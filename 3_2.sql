-- HW_3_2

select * from test.answer;
select * from test.attempt;
select * from test.question;
select * from test.student;
select * from test.subject;
select * from test.testing;

/*
В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных». Установить текущую дату в качестве даты выполнения попытки.
Пояснение:
Для того, чтобы вставить текущую дату используйте функцию NOW().
*/

insert into test.attempt (student_id, subject_id, date_attempt)
select     
    (
        select student_id
        from test.student
        where name_student = 'Баранов Павел'
    ), 
    (
        select subject_id
        from test.subject
        where name_subject = 'Основы баз данных'
    ), 
    now();

select * from test.attempt;

/*
Случайным образом выбрать три вопроса (запрос) по дисциплине, тестирование по которой собирается проходить студент, занесенный в таблицу attempt последним, и добавить их в таблицу testing. id последней попытки получить как максимальное значение id из таблицы attempt.
*/

insert into test.testing (attempt_id, question_id)
select attempt_id, question_id
from
    test.question
    join test.attempt using(subject_id)
    where attempt_id = (
        select max(attempt_id)
        from test.attempt
        )
order by rand()
limit 3;
select * from test.testing;

/*
Студент прошел тестирование (то есть все его ответы занесены в таблицу testing), далее необходимо вычислить результат(запрос) и занести его в таблицу attempt для соответствующей попытки.  Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до целого.
Будем считать, что мы знаем id попытки,  для которой вычисляется результат, в нашем случае это 8. В таблицу testing занесены следующие ответы пользователя:
+------------+------------+-------------+-----------+
| testing_id | attempt_id | question_id | answer_id |
+------------+------------+-------------+-----------+
| 22         | 8          | 7           | 19        |
| 23         | 8          | 6           | 17        |
| 24         | 8          | 8           | 22        |
+------------+------------+-------------+-----------+
Пояснение:
Используйте вложенный запрос для вычисления результатов всех попыток по таблице testing, а в таблице attempt обновляйте только запись с id равным 8.
*/

update 
    test.attempt,
    (
        select round(sum(is_correct / 3 * 100)) as query_result
        from 
            test.testing
            join test.answer using(answer_id)
            join test.attempt using(attempt_id)
        where attempt_id = 8
    ) as query_in
set attempt.result = query_in.query_result
where attempt_id = 8;
    
select * from test.attempt;

/*
Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года. Также удалить и все соответствующие этим попыткам вопросы из таблицы testing.
*/

delete from test.attempt
where date_attempt < '2020-05-01';
select * from test.attempt;
select * from test.testing;