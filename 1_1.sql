-- HW_1_1

/*
Сформулируйте SQL запрос для создания таблицы book, занесите  его в окно кода (расположено ниже)
и отправьте на проверку (кнопка Отправить). Структура таблицы book:
book_id	INT PRIMARY KEY AUTO_INCREMENT
title	VARCHAR(50)
author	VARCHAR(30)
price	DECIMAL(8, 2)
amount	INT 
*/

create database stepik;
use stepik;
select * from stepik.book;

create table book (
	book_id int primary key auto_increment,
    title varchar(50),
    author varchar(30),
    price decimal(8, 2),
    amount int
);

/*
Занесите новые строки в таблицу book (текстовые значения (тип VARCHAR) заключать либо в двойные, либо в одинарные кавычки):
1	Мастер и Маргарита	Булгаков М.А.	670.99	3
2	Белая гвардия	Булгаков М.А.	540.50	5
3	Идиот	Достоевский Ф.М.	460.00	10
4	Братья Карамазовы	Достоевский Ф.М.	799.01	2
*/

insert into stepik.book (book_id, title, author, price, amount)
values 
	(1, 'Мастер и Маргарита', 'Булгаков М.А.', '670.99', '3'),
	(2, 'Белая гвардия', 'Булгаков М.А.', '540.50', '5'),
	(3, 'Идиот', 'Достоевский Ф.М.', '460.00', '10'),
	(4, 'Братья Карамазовы', 'Достоевский Ф.М.', '799.01', '2'),
    (5, 'Стихотворения и поэмы', 'Есенин С.А.', '650.0', '15');
    
-- delete from stepik.book where book_id = 1;
-- update stepik.book set price = 650.00 where book_id = 5;