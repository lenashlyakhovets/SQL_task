-- HW_3_3_database_enrollee

create database enrollee;
use enrollee;
show full tables from enrollee;

-- 1.DEPARTMENT--------------------------------------------------------
-- drop table if exists enrollee.department;

create table enrollee.department
(
	department_id int primary key auto_increment,
    name_department varchar(30)
);

insert into enrollee.department (name_department)
values
	('Инженерная школа'),
	('Школа естественных наук');
select * from enrollee.department;

-- 2.SUBJECT--------------------------------------------------------
-- drop table if exists enrollee.subject;

create table enrollee.subject
(
	subject_id int primary key auto_increment,
    name_subject varchar(30)
);

insert into enrollee.subject (name_subject)
values
	('Русский язык'),
	('Математика'),
    ('Физика'),
    ('Информатика');
select * from enrollee.subject;

-- 3.PROGRAM--------------------------------------------------------
-- drop table if exists enrollee.program;

create table enrollee.program
(
	program_id int primary key auto_increment,
    name_program varchar(50),
    department_id int,
    plan int,
    foreign key (department_id) references enrollee.department (department_id) on delete cascade
);

insert into enrollee.program (name_program, department_id, plan)
values
	('Прикладная математика и информатика', 2, 2),
	('Математика и компьютерные науки', 2, 1),
	('Прикладная механика', 1, 2),
	('Мехатроника и робототехника', 1, 3);
select * from enrollee.program;

-- 4.ENROLLEE--------------------------------------------------------
-- drop table if exists enrollee.enrollee;

create table enrollee.enrollee
(
	enrollee_id int primary key auto_increment,
    name_enrollee varchar(50)
);

insert into enrollee.enrollee (name_enrollee)
values
	('Баранов Павел'),
    ('Абрамова Катя'),
    ('Семенов Иван'),
    ('Яковлева Галина'),
    ('Попов Илья'),
    ('Степанова Дарья');
select * from enrollee.enrollee;

-- 5.ACHIEVEMENT--------------------------------------------------------
-- drop table if exists enrollee.achievement;

create table enrollee.achievement
(
	achievement_id int primary key auto_increment,
    name_achievement varchar(30),
    bonus int
);

insert into enrollee.achievement (name_achievement, bonus)
values
	('Золотая медаль', 5),
    ('Серебряная медаль', 3),
    ('Золотой значок ГТО', 3),
    ('Серебряный значок ГТО', 1);
select * from enrollee.achievement;

-- 6.ENROLLEE_ACHIEVEMENT--------------------------------------------------------
-- drop table if exists enrollee.enrollee_achievement;

create table enrollee.enrollee_achievement
(
	enrollee_achiev_id int primary key auto_increment,
    enrollee_id int,
    achievement_id int,
    foreign key (enrollee_id) references enrollee.enrollee (enrollee_id) on delete cascade,
    foreign key (achievement_id) references enrollee.achievement (achievement_id) on delete cascade
);

insert into enrollee.enrollee_achievement (enrollee_id, achievement_id)
values
	(1, 2),
    (1, 3),
    (3, 1),
    (4, 4),
    (5, 1),
    (5, 3);
select * from enrollee.enrollee_achievement;

-- 7.PROGRAM_SUBJECT--------------------------------------------------------
-- drop table if exists enrollee.program_subject;

create table enrollee.program_subject
(
	program_subject_id int primary key auto_increment,
    program_id int,
    subject_id int,
    min_result int,
    foreign key (program_id) references enrollee.program (program_id) on delete cascade,
    foreign key (subject_id) references enrollee.subject (subject_id) on delete cascade
);

insert into enrollee.program_subject (program_id, subject_id, min_result)
values
	(1, 1, 40),
    (1, 2, 50),
    (1, 4, 60),
    (2, 1, 30),
    (2, 2, 50),
    (2, 4, 60),
    (3, 1, 30),
    (3, 2, 45),
    (3, 3, 45),
    (4, 1, 40),
    (4, 2, 45),
    (4, 3, 45);
select * from enrollee.program_subject;

-- 8.PROGRAM_ENROLLEE--------------------------------------------------------
-- drop table if exists enrollee.program_enrollee;

create table enrollee.program_enrollee
(
	program_enrollee_id int primary key auto_increment,
    program_id int,
    enrollee_id int,
    foreign key (program_id) references enrollee.program (program_id) on delete cascade,
    foreign key (enrollee_id) references enrollee.enrollee (enrollee_id) on delete cascade
);

insert into enrollee.program_enrollee (program_id, enrollee_id)
values
	(3, 1),
    (4, 1),
    (1, 1),
    (2, 2),
    (1, 2),
    (1, 3),
    (2, 3),
    (4, 3),
    (3, 4),
    (3, 5),
    (4, 5),
    (2, 6),
    (3, 6),
    (4, 6);
select * from enrollee.program_enrollee;

-- 9.ENROLLEE_SUBJECT--------------------------------------------------------
-- drop table if exists enrollee.enrollee_subject;

create table enrollee.enrollee_subject
(
	enrollee_subject_id int primary key auto_increment,
    enrollee_id int,
    subject_id int,
    result int,
    foreign key (enrollee_id) references enrollee.enrollee (enrollee_id) on delete cascade,
    foreign key (subject_id) references enrollee.subject (subject_id) on delete cascade
);

insert into enrollee.enrollee_subject (enrollee_id, subject_id, result)
values
	(1, 1, 68),
    (1, 2, 70),
    (1, 3, 41),
    (1, 4, 75),
    (2, 1, 75),
    (2, 2, 70),
    (2, 4, 81),
    (3, 1, 85),
    (3, 2, 67),
    (3, 3, 90),
    (3, 4, 78),
    (4, 1, 82),
    (4, 2, 86),
    (4, 3, 70),
    (5, 1, 65),
    (5, 2, 67),
    (5, 3, 60),
    (6, 1, 90),
    (6, 2, 92),
    (6, 3, 88),
    (6, 4, 94);
select * from enrollee.enrollee_subject;