-- HW_3_5

create database school;
use school;
show full tables from school;


drop table if exists school.module;
drop table if exists school.lesson;
drop table if exists school.step;
drop table if exists school.keyword;
drop table if exists school.step_keyword;
drop table if exists school.student;
drop table if exists school.step_student;

select * from school.module;
select * from school.lesson;
select * from school.step;
select * from school.keyword;
select * from school.step_keyword;
select * from school.student;
select * from school.step_student;

/*
Отобрать все шаги, в которых рассматриваются вложенные запросы (то есть в названии шага упоминаются вложенные запросы). Указать к какому уроку и модулю они относятся. Для этого вывести 3 поля:
в поле Модуль указать номер модуля и его название через пробел;
в поле Урок указать номер модуля, порядковый номер урока (lesson_position) через точку и название урока через пробел;
в поле Шаг указать номер модуля, порядковый номер урока (lesson_position) через точку, порядковый номер шага (step_position) через точку и название шага через пробел.
Длину полей Модуль и Урок ограничить 19 символами, при этом слишком длинные надписи обозначить многоточием в конце (16 символов - это номер модуля или урока, пробел и  название Урока или Модуля к ним присоединить "..."). Информацию отсортировать по возрастанию номеров модулей, порядковых номеров уроков и порядковых номеров шагов.
*/

