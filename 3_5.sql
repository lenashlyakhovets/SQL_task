-- HW_3_5

create database school;
use school;
show full tables from school;


-- drop table if exists school.module;
-- drop table if exists school.lesson;
-- drop table if exists school.step;
-- drop table if exists school.keyword;
-- drop table if exists school.step_keyword;
-- drop table if exists school.student;
-- drop table if exists school.step_student;

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

select    
    if(length(concat(module_id, ' ', module_name)) > 16, concat(left(concat(module_id, ' ', module_name), 16), '...'), concat(module_id, ' ', module_name)) as Модуль,    
    if(length(concat(module_id, '.', lesson_position, ' ', lesson_name)) > 16, concat(left(concat(module_id, '.', lesson_position, ' ', lesson_name), 16), '...'), concat(module_id, '.', lesson_position, ' ', lesson_name)) as Урок,
    concat(module_id, '.', lesson_position, '.', step_position, ' ', step_name) as Шаг
from
    school.module
    join school.lesson using(module_id)
    join school.step using(lesson_id)
where step_name like '%ложен%запрос%'
order by 1, 2, 3;

/*
Заполнить таблицу step_keyword следующим образом: если ключевое слово есть в названии шага, то включить в step_keyword строку с id шага и id ключевого слова.
Пояснение:
1. Чтобы проверить, есть ли ключевое слово в заголовке шага, можно использовать функцию:
INSTR(string_1, string_2)
которая возвращает позицию первого вхождения string_2 в string_1. Если вхождения нет - результат функции 0.
2. Обратите внимание, что некоторые ключевые слова, например IN, входят в INNER и JOIN. Нужно учитывать только отдельные слова, которые разделены в названии шага либо пробелом, либо запятой, либо открывающей скобкой.
3. Это задание можно решить с помощью регулярных выражений или с помощью функции REGEXP_INSTR.
*/

insert into school.step_keyword (step_id, keyword_id)
select 
    step.step_id,
    keyword.keyword_id
from school.keyword, school.step
where step_name regexp concat('\\b', keyword_name,'\\b');
select * from school.step_keyword;

/*
Реализовать поиск по ключевым словам. Вывести шаги, с которыми связаны ключевые слова MAX и AVG одновременно. Для шагов указать id модуля, позицию урока в модуле, позицию шага в уроке через точку, после позиции шага перед заголовком - пробел. Позицию шага в уроке вывести в виде двух цифр (если позиция шага меньше 10, то перед цифрой поставить 0). Столбец назвать Шаг. Информацию отсортировать по первому столбцу в алфавитном порядке.
Пояснение:
В таблице step_keyword хранится информация о том, какие ключевые слова в каких шагах используются. При этом ключевое слово может быть связано с шагом, в названии которого этого ключевого слова нет.
*/

select
    if(step_position < 10, 
       concat(module_id, '.', lesson_position, '.', '0', step_position, ' ', step_name), 
       concat(module_id, '.', lesson_position, '.', step_position, ' ', step_name)) as Шаг    
from
    school.module
    join school.lesson using(module_id)
    join school.step using(lesson_id)
    join school.step_keyword using(step_id)
    join school.keyword using(keyword_id)
where keyword_name in ('MAX', 'AVG')
group by 1
having count(keyword_name) = 2
order by 1;

/*
Посчитать, сколько студентов относится к каждой группе. Столбцы назвать Группа, Интервал, Количество. Указать границы интервала.
Пояснение:
Если логическое выражения во всех WHEN представляет собой сравнение на равенство с некоторым значением, то оператор CASE можно записать в виде:
CASE столбец 
     WHEN значение_1 THEN выражение_1
     WHEN значение_2 THEN выражение_2
     ...
     ELSE значение_else   
END  
Это задание можно решить и другим способом (без  CASE). Для этого можно создать таблицу с интервалами и использовать ее в запросе.
*/

select 
    case
        when rate <= 10 then "I"
        when rate <= 15 then "II"
        when rate <= 27 then "III"
        else "IV"
    end as Группа,
    case
        when rate <= 10 then "от 0 до 10"
        when rate <= 15 then "от 11 до 15"
        when rate <= 27 then "от 16 до 27"
        else "больше 27"
    end as Интервал,
    count(query_in.rate) as Количество    
from
    (
    select student_name, count(step_id) as rate
    from
        school.student
        join school.step_student using(student_id)
    where result = 'correct'
    group by 1
    ) as query_in
group by 1, 2
order by 1;

/*
Исправить запрос примера так: для шагов, которые  не имеют неверных ответов,  указать 100 как процент успешных попыток, если же шаг не имеет верных ответов, указать 0. Информацию отсортировать сначала по возрастанию успешности, а затем по названию шага в алфавитном порядке.
*/

