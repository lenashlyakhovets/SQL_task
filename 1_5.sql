-- HW_1_5

update stepik.book set amount = 2 where book_id = 4;
delete from stepik.book where book_id = 5;
delete from stepik.book where book_id = 6;
insert into stepik.book (book_id, title, author, price, amount)
values    
    (5, 'Стихотворения и поэмы', 'Есенин С.А.', '650.0', '15');

select * from stepik.book;

/*
Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблиц book.
*/

create table stepik.supply (
	supply_id int primary key auto_increment,
    title varchar(50),
    author varchar(30),
    price decimal(8, 2),
    amount int
);

select * from stepik.supply;

/*
Занесите в таблицу supply четыре записи, чтобы получилась следующая таблица:

supply_id	title	        author	         price	amount
        1	Лирика	        Пастернак Б.Л.	 518.99	     2
        2	Черный человек 	Есенин С.А.	     570.20	     6
        3	Белая гвардия	Булгаков М.А.	 540.50	     7
        4	Идиот	        Достоевский Ф.М. 360.80	     3
*/

insert into stepik.supply (supply_id, title, author, price, amount)
values    
    (1, 'Лирика', 'Пастернак Б.Л.', '518.99', '2'),
    (2, 'Черный человек', 'Есенин С.А.', '570.20', '6'),
    (3, 'Белая гвардия', 'Булгаков М.А.', '540.50', '7'),
    (4, 'Идиот', 'Достоевский Ф.М.', '360.80', '3');

/*
Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.
Пояснение:
Задание нужно выполнить без вложенных запросов.
*/

insert into stepik.book (title, author, price, amount)
select title, author, price, amount
from stepik.supply
where author not in ('Булгаков М.А.', 'Достоевский Ф.М.');
select * from stepik.book;

/*
Занести из таблицы supply в таблицу book только те книги, авторов которых нет в book.
*/

insert into stepik.book (title, author, price, amount)
select title, author, price, amount
from stepik.supply
where author not in (
	select author
    from stepik.book
	);

/*
Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.
*/

update stepik.book
set price = 0.9 * price
where amount between 5 and 10;

/*
В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, чтобы оно не превышало количество экземпляров книг, указанных в столбце amount. А цену тех книг, которые покупатель не заказывал, снизить на 10%.
*/

update stepik.book
set buy = if(buy > amount, amount, buy),
    price = if(buy = 0, price * 0.9, price);
select * from stepik.book;

/*
Для тех книг в таблице book , которые есть в таблице supply, не только увеличить их количество в таблице book ( увеличить их количество на значение столбца amountтаблицы supply), но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).
Пояснение:
Пересчет для книг с одинаковым названием и ценой не повлияет на результат, поэтому в запросе не обязательно рассматривать два случая: когда цена у одинаковых книг равна и когда нет.
*/

update stepik.book as b, stepik.supply as s
set b.amount = b.amount + s.amount,
    b.price = (b.price + s.price) / 2
where b.title = s.title and b.author = s.author;
select * from b;

/*
Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.
*/

delete from stepik.supply
where author in (
    select author
    from stepik.book
    group by author
    having sum(amount) > 10
    );
select * from stepik.supply;

/*
Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book. В таблицу включить столбец   amount, в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.
*/

create table stepik.ordering as
select author, title, 
    (
    select round(avg(amount)) 
    from stepik.book
    ) as amount
from stepik.book
where amount < (
    select round(avg(amount)) 
    from stepik.book
    ); 
select * from stepik.ordering;    

drop table stepik.ordering;

-- delete from stepik.book where book_id > 5;
-- delete from stepik.supply where supply_id >= 1;
-- update stepik.supply set price = 650.00 where supply_id = 5;
