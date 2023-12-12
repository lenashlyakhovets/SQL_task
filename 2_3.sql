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
