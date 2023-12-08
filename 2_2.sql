-- HW_2_2

/*
Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.
*/

select title, genre.name_genre, price
from stepik.genre inner join stepik.book
	on stepik.genre.genre_id = stepik.book.genre_id
where amount > 8
order by price desc;

/*
Вывести все жанры, которые не представлены в книгах на складе.
*/

