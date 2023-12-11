-- HW_2_2

select * from stepik.book;
select * from stepik.genre;
select * from stepik.author;

/*
Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.
*/

select title, genre.name_genre, price
from stepik.genre inner join stepik.book
	on stepik.genre.genre_id = stepik.book.genre_id
where amount > 8
order by price desc;

/*
Вывести все жанры, которые не представлены в книгах на складе.
*/

select name_genre
from stepik.genre left join stepik.book
	on stepik.genre.genre_id = stepik.book.genre_id
where title is null;

/*
Есть список городов, хранящийся в таблице city:
city_id	name_city
1	    Москва
2	    Санкт-Петербург
3	    Владивосток
Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. Дату проведения выставки выбрать случайным образом. Создать запрос, который выведет город, автора и дату проведения выставки. Последний столбец назвать Дата. Информацию вывести, отсортировав сначала в алфавитном порядке по названиям городов, а потом по убыванию дат проведения выставок.
*/
/*
Пояснение:
1. Для генерации случайной даты можно к первому числу года ('2020-01-01') прибавить целое случайное число в интервале от 0 до 365.
Генерации случайных чисел в интервале от 0 до 1 (не включительно) осуществляется с помощью функции RAND(). Если эту функцию умножить на 365, то она будет генерировать вещественные числа от 0 до 365 (не включительно). Осталось только отбросить дробную часть. Это можно сделать с помощью функции FLOOR(), которая возвращает наибольшее целое число, меньшее или равное указанному числовому значению. Таким образом, случайное число от 0 до 365 можно получить с помощью выражения:
FLOOR(RAND() * 365)
Важно! Даты должны быть за 2020 год, первое число года - 1 января 2020 года.
2. Для сложения  даты с числом используется функция:
DATE_ADD(дата, INTERVAL число единица_измерения),где
  единица_измерения (использовать прописные буквы) – это день (DAY), месяц(MONTH), неделя(WEEK) и пр., 
  число – целое число,
  дата – значение даты или даты и времени.
Функция к дате  прибавляет указанное число, выраженное в днях, месяцах и пр. , в зависимости от заданного интервала, и возвращает новую дату.
Например:
DATE_ADD('2020-02-02', INTERVAL 45 DAY) возвращает 18 марта 2020 года
DATE_ADD('2020-02-02', INTERVAL 6 MONTH) возвращает 2 августа 2020 года
*/

create table stepik.city 
(
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name_city VARCHAR(50)
);

insert into stepik.city (name_city)
values
    ('Москва'),
    ('Санкт-Петербург'),
    ('Владивосток');

select * from stepik.city;

select 
	name_city, 
    name_author,
    (DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY)) as Дата
from stepik.city cross join stepik.author
order by name_city, 3 desc;

/*
Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.
*/

select name_genre, title, name_author
from stepik.author
	inner join stepik.book on stepik.author.author_id = stepik.book.author_id
	inner join stepik.genre on stepik.book.genre_id = stepik.genre.genre_id
where name_genre like '%роман%'
order by title;

/*
Посчитать количество экземпляров  книг каждого автора из таблицы author.  Вывести тех авторов,  количество книг которых меньше 10, в отсортированном по возрастанию количества виде. Последний столбец назвать Количество.
Пояснение:
Чтобы в результат были включены авторы, книг которых на складе нет, необходимо в условии отбора, кроме того, что общее количество книг каждого автора меньше 10, учесть, что у автора вообще может не быть книг (то есть COUNT(title) = 0).
*/

select name_author, sum(amount) as Количество
from stepik.author
	left join stepik.book on stepik.author.author_id = stepik.book.author_id
group by name_author
having sum(amount) < 10 or count(title) = 0
order by 2;

/*
Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. Поскольку у нас в таблицах так занесены данные, что у каждого автора книги только в одном жанре,  для этого запроса внесем изменения в таблицу book. Пусть у нас  книга Есенина «Черный человек» относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям» (эти изменения в таблицы уже внесены).
*/

/*
update stepik.book
set genre_id = 3
where book_id = 2;
select * from stepik.book;

update stepik.book
set genre_id = 1
where book_id = 7;
select * from stepik.book;
*/

select name_author
from stepik.author inner join 
	(
	select author_id
	from stepik.book
	group by author_id
	having count(distinct genre_id) = 1
	) as query_in
	on stepik.author.author_id = stepik.query_in.author_id
order by name_author;

/*
Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книги), написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде. Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.
*/

/*
DROP TABLE IF EXISTS stepik.book;

create table stepik.book 
(
    book_id int primary key auto_increment,
    title varchar(50),
    author_id int not null,    
    genre_id int null,
    price decimal(8,2),
    amount int,
    foreign key (author_id) references stepik.author (author_id) ON DELETE CASCADE,
    foreign key (genre_id) references stepik.genre (genre_id) ON DELETE SET NULL
);

insert into stepik.book (book_id, title, author_id, genre_id, price, amount)
values
	(1, 'Мастер и Маргарита', 1, 1, 670.99, 3),
    (2, 'Белая гвардия', 1, 1, 540.50, 5),
    (3, 'Братья Карамазовы', 2, 1, 799.01, 3),
    (4, 'Игрок', 2, 1, 480.50, 10),
    (5, 'Стихотворения и поэмы', 3, 2, 650.00, 15),
    (6, 'Черный человек', 3, 2, 570.20, 6),
    (7, 'Лирика', 4, 2, 518.99, 10),
    (8, 'Идиот', 2, 1, 460.00, 10),
    (9, 'Герой нашего времени', 5, 3, 570.59, 2),
    (10, 'Доктор Живаго', 4, 3, 740.50, 5); 

select * from stepik.book;
*/



/*
Если в таблицах supply и book есть одинаковые книги, которые имеют равную цену, вывести их название и автора, а также посчитать общее количество экземпляров книг в таблицах supply и book, столбцы назвать Название, Автор и Количество.
*/

/*
DROP TABLE IF EXISTS stepik.book;

create table stepik.book 
(
    book_id int primary key auto_increment,
    title varchar(50),
    author_id int not null,    
    genre_id int null,
    price decimal(8,2),
    amount int,
    foreign key (author_id) references stepik.author (author_id) ON DELETE CASCADE,
    foreign key (genre_id) references stepik.genre (genre_id) ON DELETE SET NULL
);

insert into stepik.book (book_id, title, author_id, genre_id, price, amount)
values
	(1, 'Мастер и Маргарита', 1, 1, 670.99, 3),
    (2, 'Белая гвардия', 1, 1, 540.50, 5),
    (3, 'Идиот', 2, 1, 460.00, 10),
    (4, 'Братья Карамазовы', 2, 1, 799.01, 3),
    (5, 'Игрок', 2, 1, 480.50, 10),
    (6, 'Стихотворения и поэмы', 3, 2, 650.00, 15),
    (7, 'Черный человек', 3, 2, 570.20, 6),
    (8, 'Лирика', 4, 2, 518.99, 2);

select * from stepik.book;

create table stepik.supply 
(
    supply_id int primary key auto_increment,
    title varchar(50),
    author int not null,    
    price decimal(8,2),
    amount int    
);

insert into stepik.supply (supply_id, title, author, price, amount)
values
	(1, 'Доктор Живаго', 'Пастернак Б.Л.', 618.99, 3),
    (2, 'Черный человек', 'Есенин С.А.', 570.20, 6),
    (3, 'Евгений Онегин', 'Пушкин А.С.', 440.80, 5),
    (4, 'Идиот', 'Достоевский Ф.М.', 360.80, 3);

select * from stepik.supply;
*/

