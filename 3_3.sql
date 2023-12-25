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

select name_program
from
    enrollee.program
    join enrollee.program_subject using(program_id)    
group by name_program
having min(min_result) >= 40
order by name_program;

/*
Вывести образовательные программы, которые имеют самый большой план набора,  вместе с этой величиной.
*/

select name_program, plan
from enrollee.program
where plan = (
    select max(plan)
    from enrollee.program
    );
    
/*
Посчитать, сколько дополнительных баллов получит каждый абитуриент. Столбец с дополнительными баллами назвать Бонус. Информацию вывести в отсортированном по фамилиям виде.
Пояснение:
Чтобы включить в результирующую таблицу всех абитуриентов, а не только тех, у кого есть дополнительные баллы, используйте оператор внешнего соединения.
После использования оператора внешнего соединения, у тех абитуриентов, у которых нет дополнительных баллов, в столбец «Бонус» будет занесено значение Null (на Stepik отображается None). Включите в запрос функцию if(), которая будет сравнивать сумму баллов с Null и,  если сравнение верно, то заносить 0, в противном случае – сумму баллов.
*/

select name_enrollee, sum(if(bonus is null, 0, bonus)) as Бонус
from 
    enrollee.enrollee
    left join enrollee.enrollee_achievement using(enrollee_id)
    left join enrollee.achievement using(achievement_id)
group by name_enrollee
order by name_enrollee;

/*
Выведите сколько человек подало заявление на каждую образовательную программу и конкурс на нее (число поданных заявлений деленное на количество мест по плану), округленный до 2-х знаков после запятой. В запросе вывести название факультета, к которому относится образовательная программа, название образовательной программы, план набора абитуриентов на образовательную программу (plan), количество поданных заявлений (Количество) и Конкурс. Информацию отсортировать в порядке убывания конкурса.
Пояснение:
После GROUP BY задаются ВСЕ столбцы, указанные после SELECT,  к которым не применяются групповые функции или выражения с групповыми функциями. В этом запросе это name_department, name_program и plan.
*/

select
    name_department,
    name_program,
    plan,
    count(name_program) as Количество,
    round(count(name_program) / plan, 2) as Конкурс
from 
    enrollee.department
    join enrollee.program using(department_id)
    join enrollee.program_enrollee using(program_id)
group by name_program, name_department, name_program, plan -- или program_id вместо всех столбцов
order by Конкурс desc;

/*   
Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика» в отсортированном по названию программ виде.
Пояснение:
Сначала отберите все  программы, для которых определены Математика или Информатика, а потом, сгруппировав результат, отберите те программы, у которых количество отобранных дисциплин ровно две.
*/

select name_program
from 
    enrollee.subject
    join enrollee.program_subject using(subject_id)
    join enrollee.program using(program_id)
where name_subject in ('Математика', 'Информатика')
group by name_program
having count(name_subject) = 2
order by name_program;

/*
Посчитать количество баллов каждого абитуриента на каждую образовательную программу, на которую он подал заявление, по результатам ЕГЭ. В результат включить название образовательной программы, фамилию и имя абитуриента, а также столбец с суммой баллов, который назвать itog. Информацию вывести в отсортированном сначала по образовательной программе, а потом по убыванию суммы баллов виде.
Пояснение:
При описании соединения таблиц можно использовать схему enrollee →program_enrollee→program →program_subject →subject →enrollee_subject. Следующей для соединения идет таблица enrollee , но она уже в списке есть. Поэтому для последнего соединения subject →enrollee_subject нужно использовать дополнительное условие связи между enrollee_subject и enrollee:
subject.subject_id = enrollee_subject.subject_id 
and enrollee_subject.enrollee_id = enrollee.enrollee_id
Важно! Можно использовать и другие способы соединения таблиц.
Подробное объяснение, зачем нужно дополнительное условие для соединения предложила Lidiya Ribakova:
Если не использовать это условие, "не сходятся данные, например, по Степанова Дарья и Семенов Иван, так как они сдали 4 ЕГЭ, а для поступления нужны только 3 предмета, то есть надо из 4 суммировать только 3. И вот как раз в таблице program_subject хранятся предметы, которые нужны на определенное направление".
Объяснение:
"Если мы джойним enrollee_subject только по subject_id , то мы подсоединяем результаты всех людей, у которых они есть по этому предмету."
*/

select name_program, name_enrollee, sum(result) as itog 
from
    enrollee.enrollee
    join enrollee.program_enrollee using(enrollee_id)
    join enrollee.program using(program_id)
    join enrollee.program_subject using(program_id)
    join enrollee.subject using(subject_id)
    join enrollee.enrollee_subject using(subject_id, enrollee_id)
group by name_program, name_enrollee
order by name_program, itog desc;
 
-- natural join делает присоединение по всем столбцам с одинаковым именем, поэтому последний join присоединяется по enrollee_id и subject_id автоматом

select name_program, name_enrollee, sum(result) as itog
from 
	enrollee.program_enrollee
	natural join enrollee.program
	natural join enrollee.program_subject
	natural join enrollee.enrollee
	natural join enrollee.enrollee_subject
group by name_enrollee, name_program
order by name_program, itog desc;

/*
Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную программу, но не могут быть зачислены на нее. Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ, необходимым для поступления на эту образовательную программу, меньше минимального балла. Информацию вывести в отсортированном сначала по программам, а потом по фамилиям абитуриентов виде.
Например, Баранов Павел по «Физике» набрал 41 балл, а  для образовательной программы «Прикладная механика» минимальный балл по этому предмету определен в 45 баллов. Следовательно, абитуриент на данную программу не может поступить.
Для этого задания в базу данных добавлена строка:
INSERT INTO enrollee.enrollee_subject (enrollee_id, subject_id, result) VALUES (2, 3, 41);
Добавлен человек, который сдавал Физику, но не подал документы ни на одну образовательную программу, где этот предмет нужен.
*/

select name_program, name_enrollee
from
    enrollee.enrollee
    join enrollee.program_enrollee using(enrollee_id)
    join enrollee.program using(program_id)
    join enrollee.program_subject using(program_id)
    join enrollee.subject using(subject_id)
    join enrollee.enrollee_subject using(subject_id, enrollee_id)
where result < min_result
order by name_enrollee, name_program;