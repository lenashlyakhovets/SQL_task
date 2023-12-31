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

insert into stepik.book (title, author_id, price, amount)
    select title, author_id, price, amount
    from stepik.supply 
         left join stepik.author on author.name_author = supply.author
    where amount <> 0;         
select * from stepik.book;

/*
Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», а для книги «Остров сокровищ» Стивенсона - «Приключения». (Использовать два запроса).
*/

update stepik.book
set genre_id = 
    (
    select genre_id
    from stepik.genre
    where name_genre = 'Поэзия'
    )
where author_id = 
    (
    select author_id
    from stepik.author
    where name_author like '%Лермонтов М.Ю.%'
    );

update stepik.book
set genre_id = 
    (
    select genre_id
    from stepik.genre
    where name_genre = 'Приключения'
    )
where author_id = 
    (
    select author_id
    from stepik.author
    where name_author like '%Стивенсон Р.Л.%'
    );
    
select * from stepik.book;

/*
Удалить всех авторов и все их книги, общее количество книг которых меньше 20.
Пояснение:
Для подсчета количества книг каждого автора используйте вложенный запрос. 
*/

delete from stepik.author
where stepik.author.author_id in (
    select author_id
    from stepik.book
    group by author_id
    having sum(amount) < 20
    );
select * from stepik.author;
select * from stepik.book;

/*
Задание
Удалить все жанры, к которым относится меньше 4-х наименований книг. В таблице book для этих жанров установить значение Null.
Пояснение:
В запросе считать все уникальные книги. Например, книги "Стихотворения и поэмы" написаны разными авторами и имеют разный book_id, то есть это разные книги.
Для отбора жанров, к которым относится меньше 4-х книг,  использовать вложенный запрос.
*/

delete from stepik.genre 
where genre_id in (
    select genre_id
    from stepik.book
    group by genre_id
    having count(genre_id) < 4
    );
select * from stepik.genre;
select * from stepik.book;

/*
Удалить всех авторов, которые пишут в жанре "Поэзия". Из таблицы book удалить все книги этих авторов. В запросе для отбора авторов использовать полное название жанра, а не его id.
*/

delete from stepik.author
using stepik.author 
    inner join stepik.book on author.author_id = book.author_id
    inner join stepik.genre on book.genre_id = genre.genre_id
where name_genre like '%Поэзия%';
select * from stepik.author;
select * from stepik.book;

