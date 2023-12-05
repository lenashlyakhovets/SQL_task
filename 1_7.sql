-- HW_1_7

create table stepik.fine (
	fine_id int primary key auto_increment,
	name varchar(30),
    number_plate varchar(6),
    violation varchar(50),
    sum_fine decimal(8, 2),
    date_violation date,
    date_payment date
);

insert into stepik.fine (name, number_plate, violation, sum_fine, date_violation, date_payment)
values    
	('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', 500.00, '2020-01-12', '2020-01-17'),
    ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', 1000.00, '2020-01-14', '2020-02-27'),
	('Яковлев Г.Р.', 'Т330ТТ', 'Превышение скорости(от 20 до 40)', 500.00, '2020-01-23', '2020-02-23'),
	('Яковлев Г.Р.', 'М701АА', 'Превышение скорости(от 20 до 40)', null, '2020-01-12', null),
    ('Колесов С.П.', 'К892АХ', 'Превышение скорости(от 20 до 40)', null, '2020-02-01', null),
    ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', null, '2020-02-14', null),
    ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', null, '2020-02-23', null),
    ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', null, '2020-03-03', null);

select * from stepik.fine;

create table stepik.traffic_violation (
	violation_id int primary key auto_increment,
    violation varchar(50),
    sum_fine decimal(8, 2)
);

insert into stepik.traffic_violation (violation, sum_fine)
values 
	('Превышение скорости(от 20 до 40)', 500.00),
	('Превышение скорости(от 40 до 60)', 1000.00),
    ('Проезд на запрещающий сигнал', 1000.00);

select * from stepik.traffic_violation;

/*
Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. При этом суммы заносить только в пустые поля столбца  sum_fine.
Таблица traffic_violation создана и заполнена.
Важно! Сравнение значения столбца с пустым значением осуществляется с помощью оператора IS NULL.
Пояснение:
1.После ключевого слова UPDATE кроме обновляемой таблицы fine укажите таблицу traffic_violation, для того чтобы запрос видел таблицы источники.  Сначала перечисляем все источники, потом выполняем необходимые действия.
2.Обновляйте только те записи таблицы fine, у которых значение столбца violation совпадает со значением соответствующего столбца таблицы traffic_violation, а также значение столбца sum_fine пусто.
*/

update stepik.fine as f, stepik.traffic_violation as tv
set f.sum_fine = tv.sum_fine
where f.violation = tv.violation and f.sum_fine is null;
select * from stepik.fine;

/*
Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило два и более раз. При этом учитывать все нарушения, независимо от того оплачены они или нет. Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
Пояснение:
Под увеличение  штрафа в два раза подходит водитель «Абрамова К.А.», который на машине с государственным номером «О111АВ» совершил повторное нарушение «Проезд на запрещающий сигнал», а также водитель  «Баранов П.Е.», который на машине с номером «Р523ВТ» дважды совершил нарушение «Превышение скорости(от 40 до 60)».
*/

select name, number_plate, violation, count(*)
from stepik.fine
group by name, number_plate, violation 
having count(*) >= 2
order by 1, 2, 3;

/*
В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей.
Пояснение:
1.Для всех нарушений, по которым штраф еще не оплачен, (тех, у которых date_payment имеет пустое значение Null), необходимо проверить, является ли данное нарушение для водителя и машины повторным, если да –  увеличить штраф в два раза.
2.Если водитель совершил нарушение на другой машине, ему увеличивать штраф не нужно.
3.Если несколько повторных нарушений не оплачены, то штраф увеличить для всех.
Важно! Если в запросе используется несколько таблиц или запросов, включающих одинаковые поля, то применяется полное имя столбца, включающего название таблицы через символ «.». Например,  fine.name  и  query_in.name. 
*/
/*
При реализации можно использовать вложенный запрос как отдельную таблицу, записанную после ключевого слова UPDATE, при этом вложенному запросу необходимо присвоить имя, например query_in:
UPDATE fine, 
    (
     SELECT ...
    ) query_in
SET ...
WHERE указать, что совпадают нарушение, фамилия водителя и номер машины в таблицах fine и вложенном запросе query_in соответственно, а также дата оплаты в таблице fine пуста

Другим способом решения является использование двух запросов: сначала создать временную таблицу, например query_in, в которую включить информацию о тех штрафах, сумму которых нужно увеличить в два раза, а затем уже обновлять информацию в таблице fine:
CREATE TABLE query_in ...;
UPDATE fine, query_in
SET ...
WHERE ...;
После ключевого слова WHERE  указывается условие, при котором нужно обновлять данные. В нашем случае  данные обновляются, если и фамилия, и государственный номер, и нарушение совпадают в таблице fine и в результирующей таблице запроса query_in. Например, для связи по фамилии используется запись fine.name = query_in.name. Также в условии нужно учесть, что данные обновляются только для тех записей, у которых в столбце date_payment пусто.
*/

update stepik.fine,
	(
    select name, number_plate, violation, count(*)
	from stepik.fine
	group by name, number_plate, violation 
	having count(*) >= 2
    ) as query_in
set sum_fine = if(date_payment is null, sum_fine * 2, sum_fine)
where stepik.fine.name = query_in.name;
select * from stepik.fine;

/*
Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты:
payment_id	name			number_plate	violation							date_violation	date_payment
1			Яковлев Г.Р.	М701АА			Превышение скорости(от 20 до 40)	2020-01-12		2020-01-22
2			Баранов П.Е.	Р523ВТ			Превышение скорости(от 40 до 60)	2020-02-14		2020-03-06
3			Яковлев Г.Р.	Т330ТТ			Проезд на запрещающий сигнал		2020-03-03		2020-03-23
Необходимо:
в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.
Пояснение к заданию:
1. Для уменьшения суммы штрафа в два раза в зависимости от условия можно  использовать функцию if().  Синтаксис раздела SET при использовании функции if() следующий:
SET столбец = IF(условие, выражение_1, выражение_2)
Выполняется этот оператор так:
сначала вычисляется условие;
если условие ИСТИНА, то вычисляется выражение_1, в противном случае (если условие ЛОЖНО) вычисляется выражение_2;
в столбец заносится результат выполнения функции (либо значение выражения_1, либо значение выражения_2 в зависимости от условия).
Например, чтобы обнулить штрафы, меньшие или равные 500 рублей, а остальные оставить без изменения, используется запрос:
UPDATE fine
SET sum_fine = IF(sum_fine <= 500, 0, sum_fine)
2. Количество дней между датой нарушения и датой оплаты считается по формуле:
количество_дней = дата_оплаты - дата_нарушения 
*/

create table stepik.payment (
	payment_id int primary key auto_increment,
	name varchar(30),
    number_plate varchar(6),
    violation varchar(50),
    date_violation date,
    date_payment date
);

insert into stepik.payment (name, number_plate, violation, date_violation, date_payment)
values    
	('Яковлев Г.Р.', 'М701АА', 'Превышение скорости(от 20 до 40)', '2020-01-12', '2020-01-22'),
    ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', '2020-02-14', '2020-03-06'),
	('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', '2020-03-03', '2020-03-23');

select * from stepik.payment;
--------------------------------------------------------------
update 
	stepik.fine as f, 
    stepik.payment as p
set 
	f.date_payment = p.date_payment,
    f.sum_fine = if((datediff(f.date_payment, f.date_violation)) <= 20, f.sum_fine / 2, f.sum_fine) 
where f.violation = p.violation and f.date_payment is null and f.number_plate = p.number_plate;
select * from stepik.fine;

/*
Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
Пояснение:
Для неоплаченных штрафов столбец date_payment имеет пустое значение.
Важно. На этом шаге необходимо создать таблицу на основе запроса! Не нужно одним запросом создавать таблицу, а вторым в нее добавлять строки.
*/

create table stepik.back_payment as
select name, number_plate, violation, sum_fine, date_violation
from stepik.fine
where date_payment is null;
    
select * from stepik.back_payment;

/*
Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. 
*/

delete from fine
where date_violation < '2020-02-01';

