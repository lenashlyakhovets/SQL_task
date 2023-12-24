-- HW_3_3

select * from enrollee.department;
select * from enrollee.subject;
select * from enrollee.program;
select * from enrollee.enrollee;
select * from enrollee.achievement;
select * from enrollee.enrollee_achievement;
select * from enrollee.program_subject;
select * from enrollee.program_enrollee;
select * from enrollee.enrollee_subject;

/*
Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в отсортированном по фамилиям виде.
*/

select name_enrollee
from 
    enrollee.enrollee
    join enrollee.program_enrollee using(enrollee_id)
    join enrollee.program using(program_id)
where name_program = 'Мехатроника и робототехника'
order by name_enrollee;

/*
Вывести образовательные программы, на которые для поступления необходим предмет «Информатика». Программы отсортировать в обратном алфавитном порядке.
*/

select name_program
from 
    enrollee.subject
    join enrollee.program_subject using(subject_id)
    join enrollee.program using(program_id)
where name_subject = 'Информатика'
order by name_program desc;

/*
Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение баллов по предмету ЕГЭ. Вычисляемые столбцы назвать Количество, Максимум, Минимум, Среднее. Информацию отсортировать по названию предмета в алфавитном порядке, среднее значение округлить до одного знака после запятой.
*/

select 
    name_subject, 
    count(name_subject) as Количество,
    max(result) as Максимум,
    min(result) as Минимум,
    round(avg(result), 1) as Среднее
from
    enrollee.subject
    join enrollee.enrollee_subject using(subject_id)
group by name_subject
order by name_subject;

/*
Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам. Программы вывести в отсортированном по алфавиту виде.
*/
