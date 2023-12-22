-- HW_3_1

select * from test.answer;
select * from test.attempt;
select * from test.question;
select * from test.student;
select * from test.subject;
select * from test.testing;

/*
Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. Информацию вывести по убыванию результатов тестирования.
*/

select name_student, date_attempt, result
from
    test.subject
    join test.attempt using(subject_id)
    join test.student using (student_id)
where name_subject = 'Основы баз данных'
order by result desc;

/*
Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой. Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.  В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов.
Пояснение:
Чтобы вывести дисциплину, тестирование по которой никто не проходил, использовать оператор внешнего соединения.
*/

select name_subject, count(student_id) as Количество, round(avg(result), 2) as Среднее
from
    test.subject 
    left join test.attempt using(subject_id)
group by name_subject
order by 3 desc;

/*
Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента.
Максимальный результат не обязательно будет 100%, поэтому явно это значение в запросе не задавать.
Пояснение:
Для получения максимального результата используйте вложенный запрос. 
*/

select name_student, result
from
    test.student
    left join test.attempt using(student_id)
where result = (
        select max(result)
        from test.attempt
    )
order by name_student;

/*
Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой. В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы. Студентов, сделавших одну попытку по дисциплине, не учитывать.
Пояснение:
Дату первой и последней попытки получить как минимальное и максимальное значение даты с помощью групповых функций, для вычисления разницы между датами использовать функцию DATEDIFF(). 
*/

select 
    name_student, 
    name_subject,
    datediff(max(date_attempt), min(date_attempt)) as Интервал  
from 
    test.student
    join test.attempt using(student_id) 
    join test.subject using(subject_id)
group by name_student, name_subject
having count(date_attempt) > 1
order by 3;

/*
Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). Вывести дисциплину и количество уникальных студентов (столбец назвать Количество), которые по ней проходили тестирование . Информацию отсортировать сначала по убыванию количества, а потом по названию дисциплины. В результат включить и дисциплины, тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0.
Пояснение:
Если один и тот же студент тестировался несколько раз по одной и той же дисциплине, то студента учитывать один раз.
Чтобы вывести дисциплину, по которой никто не проходил тестирование, используйте внешнее соединение таблиц.
*/
