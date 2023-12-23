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

select name_subject, count(distinct student_id) as Количество
from
    test.subject
    left join test.attempt using(subject_id)
group by name_subject
order by 2 desc, 1;

/*
Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы question_id и name_question.
Пояснение:
Для выбора случайных вопросов можно отсортировать вопросы в случайном порядке:
ORDER BY RAND()
*/

select question_id, name_question
from
    test.subject 
    join test.question using(subject_id)
where name_subject = 'Основы баз данных'
order by rand()
limit 3;

/*
Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17  (значение attempt_id для этой попытки равно 7). Указать, какой ответ дал студент и правильный он или нет (вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец  Результат.
Пояснение:
Для вывода результата используете функцию if()
*/

select name_question, name_answer, if(is_correct, 'Верно', 'Неверно') as Результат
from
    test.question
    join test.testing using(question_id) 
    join test.answer using(answer_id)
where testing.attempt_id = 7;

/*
Посчитать результаты тестирования. Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до двух знаков после запятой. Вывести фамилию студента, название предмета, дату и результат. Последний столбец назвать Результат. Информацию отсортировать сначала по фамилии студента, потом по убыванию даты попытки.
Пояснение:
В запрос не рекомендуется включать таблицу question, нужно связать answer непосредственно с testing. Если же в этом запросе использовать связь testing - question - answer и считать верные ответы, то получится, что считаются ВЕРНЫЕ ответы на вопросы, занесенные в таблицу question, а не верные ответы, которые дал пользователь.
*/

select name_student, name_subject, date_attempt, round(sum(is_correct / 3 * 100), 2) AS Результат
from
    test.answer
    join test.testing using(answer_id) 
    join test.attempt using(attempt_id)
    join test.student using(student_id)
    join test.subject using(subject_id)
group by name_student, name_subject, date_attempt
order by name_student, date_attempt desc;

/*
Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных ответов к общему количеству ответов, значение округлить до 2-х знаков после запятой. Также вывести название предмета, к которому относится вопрос, и общее количество ответов на этот вопрос. В результат включить название дисциплины, вопросы по ней (столбец назвать Вопрос), а также два вычисляемых столбца Всего_ответов и Успешность. Информацию отсортировать сначала по названию дисциплины, потом по убыванию успешности, а потом по тексту вопроса в алфавитном порядке.
Поскольку тексты вопросов могут быть длинными, обрезать их 30 символов и добавить многоточие "...".
Пояснение:
1. Чтобы выделить крайние левые n символов из строки используется функция LEFT(строка, n):
LEFT("abcde", 3) -> "abc"
2. Соединение строк осуществляется с помощью функции CONCAT(строка_1, строка_2):
CONCAT("ab","cd") -> "abcd"
3. Поле is_correct - имеет тип BOOLEAN. Если ответ верный (TRUE), то в нем хранится 1, если неверный (FALSE), то в нем хранится 0. Можно заметить, что суммирование этого поля (при верно установленных связях) позволит посчитать количество верных ответов.
4. Чтобы включить в запрос вопросы,  на которые все пользователи  ответили неверно, используйте операторы внешнего соединения. (Можно придумать и другой способ включения таких вопросов в результат).
*/

SELECT name_subject,
       CONCAT(LEFT(name_question, 30), '...')              AS Вопрос,
       COUNT(is_correct)                                   AS Всего_ответов, 
       ROUND(SUM(is_correct) / COUNT(is_correct) * 100, 2) AS Успешность
FROM 
    subject 
    INNER JOIN question USING(subject_id)
    INNER JOIN testing USING(question_id)
    INNER JOIN answer USING(answer_id)
GROUP BY name_subject, Вопрос
ORDER BY name_subject ASC, Успешность DESC, Вопрос ASC;


SELECT name_subject,
       CONCAT(LEFT(name_question, 30), '...') AS Вопрос,
       COUNT(testing.attempt_id) AS Всего_ответов,
       ROUND(AVG(is_correct)*100, 2) AS Успешность
  FROM question
       INNER JOIN testing USING(question_id)
       INNER JOIN answer  USING(answer_id)
       INNER JOIN subject USING(subject_id)
 GROUP BY subject.subject_id, testing.question_id
 ORDER BY 1, Успешность DESC, Вопрос;
