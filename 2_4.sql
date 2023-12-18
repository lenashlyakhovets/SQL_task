-- HW_2_4

select * from store.author;
select * from store.genre;
select * from store.book;
select * from store.city;
select * from store.client;
select * from store.buy;
select * from store.buy_book;
select * from store.step;
select * from store.buy_step;
select * from store.buy_archive;

/*
Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал) в отсортированном по номеру заказа и названиям книг виде.
Пояснение:
Если в нескольких таблицах столбцы называются одинаково – необходимо явно указывать из какой таблицы берется столбец. Например, столбец amount есть и в таблице book, и в таблице buy_book. В запросе нужно указать количество заказанных книг, то есть buy_book.amount.
*/

select buy.buy_id, title, price, buy_book.amount 
from 
	store.client 
    inner join store.buy on client.client_id = buy.client_id
    inner join store.buy_book on buy.buy_id = buy_book.buy_id
	inner join store.book on buy_book.book_id = book.book_id
where name_client = 'Баранов Павел'
order by buy_id, title;

/*
Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов фигурирует каждая книга).  Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
*/

select name_author, title, count(buy_book.amount) as Количество
from 
	store.book 
    left join store.author using(author_id)
    left join store.buy_book using(book_id)
group by name_author, title
order by name_author, title;

/*
Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество. Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
*/

select name_city, count(buy_id) as Количество
from
	store.city
	right join store.client using(city_id)
	left join store.buy using(client_id)
group by name_city
order by 2 desc, name_city;

/*
Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
Пояснение:
С каждым заказом в таблице buy_step связаны 4 записи, которые фиксируют этапы  заказа.
Для каждого заказа сначала выставляется счет на оплату ( в запись с step_id со значением 1 («Оплата») в столбец date_step_beg заносится  дата выставления счета по заказу ). После того, как счет оплачен, в столбец date_step_end той же записи заносится дата оплаты заказа.
Затем в таблице  buy_step заполняется  step_id со значением 2 («Упаковка»)  для текущего заказа: после передачи заказа на упаковку заполняется поле date_step_beg, а после окончания упаковки – поле date_step_end. И так далее для оставшихся двух шагов («Транспортировка» и «Доставка»).
Для реализации запроса учитывать тот факт, что те заказы, которые не оплачены в таблице buy_step в записи с step_id со значением 1 («Оплата»)  в столбце date_step_end  имеют значение Null.
*/

select buy_id, date_step_end
from 
	store.step
    join store.buy_step using(step_id)
where date_step_end is not null and name_step = 'Оплата';

/*
Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.
*/

select buy_id, name_client, sum(buy_book.amount * price) as Стоимость
from 
	store.client 
    inner join store.buy using(client_id)
    inner join store.buy_book using(buy_id)
	inner join store.book using(book_id)
group by buy_id, name_client
order by 1;

/*
Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся. Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.
Пояснение:
Текущим  считается тот этап, для которого заполнена дата начала этапа и не заполнена дата его окончания.
*/

select buy_id, name_step
from
	store.step
	join store.buy_step using(step_id)
where date_step_beg is not null and date_step_end is null
order by 1;

/*
В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город (рассматривается только этап Транспортировка). Для тех заказов, которые прошли этап транспортировки, вывести количество дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id), а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
Пояснение:
Для вычисления поля «Опоздание» используйте функцию if(), а для вычисления разности дат – функцию DATEDIFF().
Если доставка еще не осуществлена, то поле date_step_end  для этапа Транспортировка - пусто.
*/

select
	buy_id, 
    datediff(date_step_end, date_step_beg) as Количество_дней,
	if((datediff(date_step_end, date_step_beg) - days_delivery) > 0, datediff(date_step_end, date_step_beg) - days_delivery, 0) as Опоздание  
from 
	store.city
	join store.client using(city_id)
    join store.buy using(client_id)
    join store.buy_step using(buy_id)
    join store.step using(step_id)
where step_id = 3 and date_step_beg and date_step_end is not null
order by buy_id;

/*
Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.
*/

select distinct name_client
from 
	store.author
    join store.book using(author_id)
    join store.buy_book using(book_id)
    join store.buy using(buy_id)
    join store.client using(client_id)
where name_author = 'Достоевский Ф.М.'
order by 1;

/*
Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество. Последний столбец назвать Количество.
Пояснение:
Использовать вложенный запрос для вычисления максимального значения экземпляров книг. 
*/

select name_genre, sum(buy_book.amount) as Количество
from 
	store.genre
	join store.book using(genre_id)
	join store.buy_book using(book_id)
group by name_genre
having sum(buy_book.amount) =       
	(select max(sum_amount) as max_sum_amount
	from
		(
		select genre_id, sum(buy_book.amount) as sum_amount
		from
			store.book 
			join store.buy_book using(book_id)
		group by genre_id
		) as queru_in
	);

/*
Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев, затем по возрастанию лет виде. Название столбцов: Год, Месяц, Сумма.
Пояснение:
Ежемесячная выручка рассчитывается как  сумма произведений цены книги на заказанное пользователем в этом месяце количество. 
Цена книги для текущего года хранится в таблице book, а для предыдущего в buy_archive.
*/

select 
	year(date_payment) as Год,
    monthname(date_payment) as Месяц,
    sum(price * amount) as Сумма
from store.buy_archive
group by 1, 2
union 
select
	year(date_step_end) as Год, 
    monthname(date_step_end) as Месяц,
    sum(price * buy_book.amount) as Сумма
from 
	store.book
    join store.buy_book using(book_id)
    join store.buy using(buy_id)
    join store.buy_step using(buy_id)
where date_step_end is not null and step_id = 1   
group by 1, 2
order by 2, 1;

/*
Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров и их стоимости за 2020 и 2019 год . За 2020 год проданными считать те экземпляры, которые уже оплачены. Вычисляемые столбцы назвать Количество и Сумма. Информацию отсортировать по убыванию стоимости.
Пояснение:
При вычислении Количества и Суммы для текущего года учитывать только те книги, которые уже оплачены (указана дата оплаты для шага "Оплата" в таблице buy_step).
*/

select title, sum(amount) as Количество, sum(amount * price) as Сумма
from
	(
    select title, buy_archive.amount, buy_archive.price
	from 
		store.buy_archive
		join store.book using(book_id)
	union all
	select title, buy_book.amount, price
	from 
		store.book
		join store.buy_book using(book_id)
		join store.buy using(buy_id)
		join store.buy_step using(buy_id)
		join store.step using(step_id)
	where date_step_end is not null and step_id = 1
    ) as query_in
group by title
order by Сумма desc;