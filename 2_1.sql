-- HW_2_1

DROP TABLE IF EXISTS stepik.author;
DROP TABLE IF EXISTS stepik.genre;
DROP TABLE IF EXISTS stepik.book;
DROP TABLE IF EXISTS stepik.back_payment;
DROP TABLE IF EXISTS stepik.fine;
DROP TABLE IF EXISTS stepik.payment;
DROP TABLE IF EXISTS stepik.supply;
DROP TABLE IF EXISTS stepik.traffic_violation;
DROP TABLE IF EXISTS stepik.trip;

create table stepik.author 
(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);

insert into stepik.author (name_author)
values
    ('Булгаков М.А.'),
    ('Достоевский Ф.М.'),    
    ('Есенин С.А.'),
    ('Пастернак Б.Л.'),
    ('Лермонтов М.Ю.');

select * from stepik.author;

create table stepik.genre
(
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(30)
);

insert into stepik.genre (name_genre)
values
    ('Роман'),
    ('Поэзия'),
    ('Приключения');

select * from stepik.genre;

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