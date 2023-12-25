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

