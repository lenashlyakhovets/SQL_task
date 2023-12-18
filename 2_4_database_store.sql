-- HW_2_4_database_store

create database store;
use store;

-- 1.AUTHOR--------------------------------------------------------
-- drop table if exists store.author;

create table store.author
(
	author_id int primary key auto_increment,
    name_author varchar(50)
);

insert into store.author (name_author)
values
	('Булгаков М.А.'),
	('Достоевский Ф.М.'),
	('Есенин С.А.'),
	('Пастернак Б.Л.'),
	('Лермонтов М.Ю.');
select * from store.author;

-- 2.GENRE--------------------------------------------------------
-- drop table if exists store.genre;

create table store.genre
(
	genre_id int primary key auto_increment,
    name_genre varchar(30)
);

insert into store.genre (name_genre)
values
	('Роман'),
	('Поэзия'),
	('Приключения');
select * from store.genre;

-- 3.BOOK--------------------------------------------------------
-- drop table if exists store.book;

create table store.book
(
	book_id int primary key auto_increment,
    title varchar(50),
    author_id int not null,
    genre_id int null,
    price decimal(8, 2),
    amount int,
    foreign key (author_id) references store.author (author_id) on delete cascade,
    foreign key (genre_id) references store.genre (genre_id) on delete set null
);

insert into store.book (title, author_id, genre_id, price, amount)
values
	('Мастер и Маргарита', 1, 1, 670.99, 3),
	('Белая гвардия ', 1, 1, 540.50, 5),
	('Идиот', 2, 1, 460.00, 10),
	('Братья Карамазовы', 2, 1, 799.01, 2),
	('Игрок', 2, 1, 480.50, 10),
	('Стихотворения и поэмы', 3, 2, 650.00, 15),
	('Черный человек', 3, 2, 570.20, 6),
	('Лирика', 4, 2, 518.99, 2);
select * from store.book;

-- 4.CITY--------------------------------------------------------
-- drop table if exists store.city;

create table store.city
(
	city_id int primary key auto_increment,
    name_city varchar(30),    
    days_delivery int
);

insert into store.city (name_city, days_delivery)
values
	('Москва', 5),
	('Санкт-Петербург', 3),
	('Владивосток', 12);
select * from store.city;

-- 5.CLIENT--------------------------------------------------------
-- drop table if exists store.client;

create table store.client
(
	client_id int primary key auto_increment,
    name_client varchar(50),
    city_id int,
    email varchar(30),
    foreign key (city_id) references store.city (city_id)
);

insert into store.client (name_client, city_id, email)
values
	('Баранов Павел', 3, 'baranov@test'),
	('Абрамова Катя', 1, 'abramova@test'),
	('Семенонов Иван', 2, 'semenov@test'),
	('Яковлева Галина', 1, 'yakovleva@test');
select * from store.client;

-- 6.BUY--------------------------------------------------------
-- drop table if exists store.buy;

create table store.buy
(
	buy_id int primary key auto_increment,
    buy_description varchar(100) null,
    client_id int,    
    foreign key (client_id) references store.client (client_id)
);

insert into store.buy (buy_description, client_id)
values
	('Доставка только вечером', 1),
	(NULL, 3),
	('Упаковать каждую книгу по отдельности', 2),
	(NULL, 1);	
select * from store.buy;

-- 7.BUY_BOOK--------------------------------------------------------
-- drop table if exists store.buy_book;

create table store.buy_book
(
	buy_book_id int primary key auto_increment,
    buy_id int,
    book_id int,
    amount int,
    foreign key (buy_id) references store.buy (buy_id),
    foreign key (book_id) references store.book (book_id)
);

insert into store.buy_book (buy_id, book_id, amount)
values
	(1, 1, 1),
	(1, 7, 2),
	(1, 3, 1),
	(2, 8, 2),
	(3, 3, 2),
	(3, 2, 1),
	(3, 1, 1),
	(4, 5, 1);	
select * from store.buy_book;

-- 8.STEP--------------------------------------------------------
-- drop table if exists store.step;

create table store.step
(
	step_id int primary key auto_increment,
    name_step varchar(30)
);

insert into store.step (name_step)
values
	('Оплата'),
	('Упаковка'),
	('Транспортировка'),
	('Доставка');
select * from store.step;

-- 9.BUY_STEP--------------------------------------------------------
-- drop table if exists store.buy_step;

create table store.buy_step
(
	buy_step_id int primary key auto_increment,
    buy_id int,
    step_id int,
    date_step_beg date null,
    date_step_end date null,
    foreign key (buy_id) references store.buy (buy_id),
    foreign key (step_id) references store.step (step_id)
);

insert into store.buy_step (buy_id, step_id, date_step_beg, date_step_end)
values
	(1, 1, '2020-02-20', '2020-02-20'),
	(1, 2, '2020-02-20', '2020-02-21'),
	(1, 3, '2020-02-22', '2020-03-07'),
	(1, 4, '2020-03-08', '2020-03-08'),
	(2, 1, '2020-02-28', '2020-02-28'),
	(2, 2, '2020-02-29', '2020-03-01'),
	(2, 3, '2020-03-02', NULL),
	(2, 4, NULL, NULL),
	(3, 1, '2020-03-05', '2020-03-05'),
	(3, 2, '2020-03-05', '2020-03-06'),
	(3, 3, '2020-03-06', '2020-03-10'),
	(3, 4, '2020-03-11', NULL),
	(4, 1, '2020-03-20', NULL),
	(4, 2, NULL, NULL),
	(4, 3, NULL, NULL),
	(4, 4, NULL, NULL);	
select * from store.buy_step;

-- 10.BUY_ARCHIVE--------------------------------------------------------
-- drop table if exists store.buy_archive;

create table store.buy_archive
(
    buy_archive_id int primary key auto_increment,
    buy_id int,
    client_id int,
    book_id int,
    date_payment date,
    price decimal(8, 2),
    amount int
);

insert into buy_archive (buy_id, client_id, book_id, date_payment, price, amount)
values 
	(2, 1, 1, '2019-02-21', 670.60, 2),
	(2, 1, 3, '2019-02-21', 450.90, 1),
	(1, 2, 2, '2019-02-10', 520.30, 2),
	(1, 2, 4, '2019-02-10', 780.90, 3),
	(1, 2, 3, '2019-02-10', 450.90, 1),
	(3, 4, 4, '2019-03-05', 780.90, 4),
	(3, 4, 5, '2019-03-05', 480.90, 2),
	(4, 1, 6, '2019-03-12', 650.00, 1),
	(5, 2, 1, '2019-03-18', 670.60, 2),
	(5, 2, 4, '2019-03-18', 780.90, 1);
select * from store.buy_archive;
    