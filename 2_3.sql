-- HW_2_3

select * from stepik.book;
select * from stepik.genre;
select * from stepik.author;
select * from stepik.supply;

DROP TABLE IF EXISTS stepik.supply;
create table stepik.supply 
(
    supply_id int primary key auto_increment,
    title varchar(50),
    author varchar(50),    
    price decimal(8,2),
    amount int    
);

insert into stepik.supply (title, author, price, amount)
values    
	('Доктор Живаго', 'Пастернак Б.Л.', 380.80, 4),
	('Черный человек', 'Есенин С.А.', 570.20, 6),
	('Белая гвардия', 'Булгаков М.А.', 540.50, 7),
	('Идиот', 'Достоевский Ф.М.', 360.80, 3),
	('Стихотворения и поэмы', 'Лермонтов М.Ю.', 255.90, 4),
	('Остров сокровищ', 'Стивенсон Р.Л.', 599.99, 5);

select * from stepik.supply;

/*
Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),  необходимо в таблице book увеличить количество на значение, указанное в поставке,  и пересчитать цену. А в таблице  supply обнулить количество этих книг. Формула для пересчета цены:
price = (p1*k1+p2*k2)/(k1+k2) 
где  p1, p2 - цена книги в таблицах book и supply;
       k1, k2 - количество книг в таблицах book и supply.
Пояснение:
Пересчитываться должна цена только одной книги Достоевского «Идиот», для этой же книги увеличится количество в таблице book и обнулится количество в таблице supply.
*/

update stepik.book
    inner join stepik.author on book.author_id = author.author_id
    inner join stepik.supply on book.title = supply.title
                         and supply.author = author.name_author
set book.amount = book.amount + supply.amount,
    supply.amount = 0,
    book.price = (book.price * book.amount + supply.price * supply.amount) / (book.amount + supply.amount)
where book.price <> supply.price;
select * from stepik.book;
select * from stepik.supply;

/*
Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы author.  Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.
*/

insert into stepik.author (name_author)
    select supply.author
    from stepik.author right join stepik.supply on supply.author = author.name_author
    where name_author is null;
select * from stepik.author;

/*
Добавить новые книги из таблицы supply в таблицу book на основе сформированного выше запроса. Затем вывести для просмотра таблицу book.
Пояснение:
Если нужно оставить какое-то поле пустым - его просто не указывают в списке полей таблицы, в которую добавляются записи.
*/

select title, author_id, price, amount
from author 
     right join supply on author.name_author = supply.author

