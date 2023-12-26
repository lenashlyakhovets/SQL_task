-- HW_3_4

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
Создать вспомогательную таблицу applicant,  куда включить id образовательной программы, id абитуриента, сумму баллов абитуриентов (столбец itog) в отсортированном сначала по id образовательной программы, а потом по убыванию суммы баллов виде (использовать запрос из предыдущего урока).
Пояснение:
Для просмотра результата выполнения запроса корректировки на этом шаге и на всех остальных,  используется запрос на выборку, который отображает все записи корректируемой таблицы:
SELECT * FROM таблица;
*/

create table enrollee.applicant as
select program_id, enrollee_id, sum(result) as itog 
from
    enrollee.enrollee
    join enrollee.program_enrollee using(enrollee_id)
    join enrollee.program using(program_id)
    join enrollee.program_subject using(program_id)
    join enrollee.subject using(subject_id)
    join enrollee.enrollee_subject using(subject_id, enrollee_id)
group by program_id, enrollee_id
order by program_id, itog desc;
select * from enrollee.applicant;

/*
Из таблицы applicant, созданной на предыдущем шаге, удалить записи, если абитуриент на выбранную образовательную программу не набрал минимального балла хотя бы по одному предмету (использовать запрос из предыдущего урока).
*/

delete from enrollee.applicant
using
    enrollee.applicant
    join enrollee.program_subject using(program_id)
    join enrollee.enrollee_subject using(subject_id, enrollee_id)    
where result < min_result;
select * from enrollee.applicant;

/*
Повысить итоговые баллы абитуриентов в таблице applicant на значения дополнительных баллов (использовать запрос из предыдущего урока).
Пояснение:
1. В запросах на обновление можно использовать несколько связанных таблиц. Например, чтобы обновить поле itog таблицы applicant для записей, относящихся к образовательной программе «Прикладная механика», используется запрос:
UPDATE 
    applicant
    INNER JOIN program ON applicant.program_id = program.program_id
SET itog = 2
WHERE name_program = "Прикладная механика";
2. В нашем случае вместо таблицы program можно использовать вложенный запрос, в котором посчитаны дополнительные баллы абитуриентов. А в качестве условия соединения таблиц после ключевого слова  ON указать, что id абитуриентов в таблице applicant и во вложенном запросе совпадают.
*/

update applicant 
	join (
		select
			enrollee_id, 
            sum(if(bonus is null, 0, bonus)) as extra_points
        from 
            enrollee.enrollee
            left join enrollee.enrollee_achievement using(enrollee_id)
            left join enrollee.achievement using(achievement_id)
        group by enrollee_id
		) as Bonus using(enrollee_id)
set itog = itog + extra_points;       
select * from enrollee.applicant;

/*
Поскольку при добавлении дополнительных баллов, абитуриенты по каждой образовательной программе могут следовать не в порядке убывания суммарных баллов, необходимо создать новую таблицу applicant_order на основе таблицы applicant. При создании таблицы данные нужно отсортировать сначала по id образовательной программы, потом по убыванию итогового балла. А таблицу applicant, которая была создана как вспомогательная, необходимо удалить.
Пояснение:
Для удаления таблицы используется SQL запрос DROP:
DROP TABLE таблица;
*/

create table enrollee.applicant_order as
select program_id, enrollee_id, itog
from enrollee.applicant
order by program_id, itog desc;
drop table applicant;
select * from enrollee.applicant_order;
select * from enrollee.applicant;

/*
Включить в таблицу applicant_order новый столбец str_id целого типа , расположить его перед первым.
Пояснение: 
Для вставки нового столбца используется SQL запросы:
ALTER TABLE таблица ADD имя_столбца тип; - вставляет столбец после последнего
ALTER TABLE таблица ADD имя_столбца тип FIRST; - вставляет столбец перед первым
ALTER TABLE таблица ADD имя_столбца тип AFTER имя_столбца_1; - вставляет столбец после укзанного столбца
Для удаления столбца используется SQL запросы:
ALTER TABLE таблица DROP COLUMN имя_столбца; - удаляет столбец с заданным именем
ALTER TABLE таблица DROP имя_столбца; - ключевое слово COLUMN не обязательно указывать
ALTER TABLE таблица DROP имя_столбца,
                    DROP имя_столбца_1; - удаляет два столбца
Для переименования столбца используется  запрос (тип данных указывать обязательно):
ALTER TABLE таблица CHANGE имя_столбца новое_имя_столбца ТИП ДАННЫХ;
Для изменения типа  столбца используется запрос (два раза указывать имя столбца обязательно): 
ALTER TABLE таблица CHANGE имя_столбца имя_столбца НОВЫЙ_ТИП_ДАННЫХ;
*/

alter table enrollee.applicant_order ADD str_id int FIRST;
select * from enrollee.applicant_order;

/*
Занести в столбец str_id таблицы applicant_order нумерацию абитуриентов, которая начинается с 1 для каждой образовательной программы.
Пояснение:
В запросе на обновление используйте вложенный запрос , в котором нумеруются записи таблицы applicant_order по образовательным программам. В качестве условия соединения таблицы и вложенного запроса после ключевого слова   указать, что id программ в таблице applicant_order и во вложенном запросе совпадают, а также id абитуриентов в таблице applicant_order и во вложенном запросе совпадают.
*/

set @row_num := 1;
set @num_pr := 0;
update applicant_order
set str_id = if(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1 and @num_pr := @num_pr + 1);
select * from enrollee.applicant_order;

/*
Создать таблицу student,  в которую включить абитуриентов, которые могут быть рекомендованы к зачислению  в соответствии с планом набора. Информацию отсортировать сначала в алфавитном порядке по названию программ, а потом по убыванию итогового балла.
Пояснение:
На каждую образовательную программу может быть зачислено только обозначенное в плане число абитуриентов (например, n). Выбираются первые n абитуриентов, набравших наибольшее количество баллов. В str_id содержится нумерация (отсортированных по сумме баллов абитуриентов), начинающаяся с 1 для каждой образовательной программы. И соответственно, если по плану нужно зачислить n абитуриентов, то выбираются все абитуриенты, порядковый номер которых в str_id меньше или равен n.
То есть в таблицу на каждую образовательную программу включить абитуриентов, значение str_id которых в таблице applicant_order меньше или равно плану.
*/

create table enrollee.student as
select name_program, name_enrollee, itog
from 
    enrollee.enrollee
    join enrollee.applicant_order using(enrollee_id)
    join enrollee.program using(program_id)
where str_id <= plan
order by name_program, itog desc;
select * from enrollee.student;