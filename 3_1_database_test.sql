-- HW_3_1_database_test

create database test;
use test;
show full tables from test;

-- 1.SUBJECT--------------------------------------------------------
-- drop table if exists test.subject;

create table test.subject
(
	subject_id int primary key auto_increment,
    name_subject varchar(30)
);

insert into test.subject (name_subject)
values
	('Основы SQL'),
	('Основы баз данных'),
	('Физика');
select * from test.subject;

-- 2.STUDENT--------------------------------------------------------
-- drop table if exists test.student;

create table test.student
(
	student_id int primary key auto_increment,
    name_student varchar(50)
);

insert into test.student (name_student)
values
	('Баранов Павел'),
	('Абрамова Катя'),
	('Семенов Иван'),
    ('Яковлева Галина');
select * from test.student;

-- 3.ATTEMPT--------------------------------------------------------
-- drop table if exists test.attempt;

create table test.attempt
(
	attempt_id int primary key auto_increment,
    student_id int,
    subject_id int,
    date_attempt date,
    result int,
    foreign key (student_id) references test.student (student_id) on delete cascade,
    foreign key (subject_id) references test.subject (subject_id) on delete cascade
);

insert into test.attempt (student_id, subject_id, date_attempt, result)
values
	(1, 2, '2020-03-23', 67),
	(3, 1, '2020-03-23', 100),
	(4, 2, '2020-03-26', 0),
    (1, 1, '2020-04-15', 33),
	(3, 1, '2020-04-15', 67),
	(4, 2, '2020-04-21', 100),
	(3, 1, '2020-05-17', 33);
select * from test.attempt;

-- 4.QUESTION--------------------------------------------------------
-- drop table if exists test.question;

create table test.question
(
	question_id int primary key auto_increment,
    name_question varchar(100),
    subject_id int,    
    foreign key (subject_id) references test.subject (subject_id) on delete cascade
);

insert into test.question (name_question, subject_id)
values
	('Запрос на выборку начинается с ключевого слова:', 1),
	('Условие, по которому отбираются записи, задается после ключевого слова:', 1),
	('Для сортировки используется:', 1),
    ('Какой запрос выбирает все записи из таблицы student:', 1),
	('Для внутреннего соединения таблиц используется оператор:', 1),
	('База данных - это:', 2),
	('Отношение - это:', 2),
    ('Концептуальная модель используется для', 2),
    ('Какой тип данных не допустим в реляционной таблице?', 2);
select * from test.question;

-- 5.ANSWER--------------------------------------------------------
-- drop table if exists test.answer;

create table test.answer
(
	answer_id int primary key auto_increment,
    name_answer varchar(100),
    question_id int,
    is_correct boolean,
    foreign key (question_id) references test.question (question_id) on delete cascade
);

insert into test.answer (name_answer, question_id, is_correct)
values
	('UPDATE', 1, FALSE),
	('SELECT', 1, TRUE),
	('INSERT', 1, FALSE),
	('GROUP BY', 2, FALSE),
	('FROM', 2, FALSE),
	('WHERE', 2, TRUE),
	('SELECT', 2, FALSE),
	('SORT', 3, FALSE),
	('ORDER BY', 3, TRUE),
	('RANG BY', 3, FALSE),
	('SELECT * FROM student', 4, TRUE),
	('SELECT student', 4, FALSE),
	('INNER JOIN', 5, TRUE),
	('LEFT JOIN', 5, FALSE),
	('RIGHT JOIN', 5, FALSE),
	('CROSS JOIN', 5, FALSE),
	('совокупность данных, организованных по определенным правилам', 6, TRUE),
	('совокупность программ для хранения и обработки больших массивов информации', 6, FALSE),
	('строка', 7, FALSE),
	('столбец', 7, FALSE),
	('таблица', 7, TRUE),
	('обобщенное представление пользователей о данных', 8, TRUE),
	('описание представления данных в памяти компьютера', 8, FALSE),
	('база данных', 8, FALSE),
	('file', 9, TRUE),
	('INT', 9, FALSE),
	('VARCHAR', 9, FALSE),
	('DATE', 9, FALSE);
select * from test.answer;

-- 6.TESTING--------------------------------------------------------
-- drop table if exists test.testing;

create table test.testing
(
	testing_id int primary key auto_increment,
    attempt_id int,
    question_id int,
    answer_id int,
    foreign key (attempt_id) references test.attempt (attempt_id) on delete cascade,
    foreign key (question_id) references test.question (question_id) on delete cascade,    
    foreign key (answer_id) references test.answer (answer_id) on delete cascade
);

insert into test.testing (attempt_id, question_id, answer_id)
values
	(1, 9, 25),
	(1, 7, 19),
	(1, 6, 17),
	(2, 3, 9),
	(2, 1, 2),
	(2, 4, 11),
	(3, 6, 18),
	(3, 8, 24),
	(3, 9, 28),
	(4, 1, 2),
	(4, 5, 16),
	(4, 3, 10),
	(5, 2, 6),
	(5, 1, 2),
	(5, 4, 12),
	(6, 6, 17),
	(6, 8, 22),
	(6, 7, 21),
	(7, 1, 3),
	(7, 4, 11),
	(7, 5, 16);
select * from test.testing;