-- HW_2_5

select * from store.author;
select * from store.genre;
select * from store.book;
select * from store.city;
select * from store.client;
select * from store.buy;
select * from store.buy_book;
select * from store.step;
select * from store.buy_step;
select * from store.buy_archive;

/*
Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
*/

insert into store.client (name_client, city_id, email)
values 
	('Попов Илья',
    (
    select city_id
    from store.city
    where name_city = 'Москва'
    ),
	'popov@test');
select * from store.client;

/*
Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».
Важно! В решении нельзя использоваться VALUES и делать отбор по client_id.
*/

insert into store.buy (buy_description, client_id)
select 
    'Связаться со мной по вопросу доставки',
    (
     select client_id
     from store.client left join store.buy using(client_id)
     where name_client = 'Попов Илья'
     );
select * from store.buy;

/*
В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака «Лирика» в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.
Пояснение:
Для вставки каждой книги используйте отдельный запрос. Не забывайте между запросами ставить точку с запятой.
*/

insert into store.buy_book (buy_id, book_id, amount)
values 
    (5, 
    (
    select book_id
    from 
        store.author
        join store.book using(author_id)
    where title = 'Лирика' and name_author = 'Пастернак Б.Л.'
    ), 
     2);

insert into store.buy_book (buy_id, book_id, amount)
values     
    (5, 
    (
    select book_id
    from 
        store.author
        join store.book using(author_id)
    where title = 'Белая гвардия' and  name_author = 'Булгаков М.А.'
    ), 
     1);     
     
select * from store.buy_book;

/*
Количество тех книг на складе, которые были включены в заказ с номером 5, уменьшить на то количество, которое в заказе с номером 5  указано.
Пояснение:
Для изменения количества книг используйте запрос UPDATE.
*/

update store.book, store.buy_book
set book.amount = book.amount - buy_book.amount
where book.book_id = buy_book.book_id and buy_id = 5;
select * from store.book;

/*
Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить название книг, их автора, цену, количество заказанных книг и  стоимость. Последний столбец назвать Стоимость. Информацию в таблицу занести в отсортированном по названиям книг виде.
Пояснение:
Для создании таблицы используйте запрос CREATE.
*/

create table store.buy_pay as
select title, name_author, price, buy_book.amount, (price * buy_book.amount) as Стоимость
from
    store.author 
    left join store.book using(author_id)
    left join store.buy_book using(book_id)
where buy_id = 5
order by title;
select * from store.buy_pay;

/*
Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа, количество книг в заказе (название столбца Количество) и его общую стоимость (название столбца Итого). Для решения используйте ОДИН запрос.
*/

drop table if exists store.buy_pay;

create table store.buy_pay as
select buy_id, sum(buy_book.amount) as Количество, sum(price * buy_book.amount) as Итого
from
    store.book
    join store.buy_book using(book_id)
where buy_id = 5;
select * from store.buy_pay;

/*
В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые должен пройти этот заказ. В столбцы date_step_beg и date_step_end всех записей занести Null.
Пояснение:
Все этапы в таблицу buy_step можно вставить одним запросом, для этого используется соединение CROSS JOIN для таблиц buy и step. 
*/

insert into store.buy_step (buy_id, step_id)
select buy_id, step_id
from store.buy cross join store.step
where buy_id = 5;
select * from store.buy_step;

/*
В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5.
Правильнее было бы занести не конкретную, а текущую дату. Это можно сделать с помощью функции Now(). Но при этом в разные дни будут вставляться разная дата, и задание нельзя будет проверить, поэтому  вставим дату 12.04.2020.
Пояснение:
Для просмотра данных из таблицы buy_step выбраны не все  записи, а только те, которые относятся к заказу с номером 5.
*/

update 
    store.step
    join store.buy_step using(step_id)
set date_step_beg = '2020-04-12'
where buy_id = 5 and name_step = 'Оплата';

select * from store.buy_step
where buy_id = 5;   

/*
Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату 13.04.2020, и начать следующий этап («Упаковка»), задав в столбце date_step_beg для этого этапа ту же дату.
Реализовать два запроса для завершения этапа и начала следующего. Они должны быть записаны в общем виде, чтобы его можно было применять для любых этапов, изменив только текущий этап. Для примера пусть это будет этап «Оплата».
Пояснение:
В таблицу step все необходимые этапы занесены последовательно. Если текущий этап «Оплата», его id 1, то у следующего этапа «Упаковка» id будет на единицу больше, то есть 2. Поэтому в условии отбора запроса, который обновляет дату начала следующего этапа, можно использовать вложенный запрос, который выбирает id этапа на 1 больше, чем у текущего:
*/

update store.buy_step
       join store.step using(step_id)
   set date_step_end = if(name_step = 'Оплата', '2020-04-13', date_step_end),
       date_step_beg = if(name_step = 'Упаковка', '2020-04-13', date_step_beg)
where buy_id = 5;

select * from store.buy_step
