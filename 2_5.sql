-- HW_2_5

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
Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
*/

insert into store.client (name_client, city_id, email)
values 
	('Попов Илья',
    (
    select city_id
    from store.city
    where name_city = 'Москва'
    ),
	'popov@test');
select * from store.client;

/*
Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».
Важно! В решении нельзя использоваться VALUES и делать отбор по client_id.
*/

insert into store.buy (buy_description, client_id)
select 
    'Связаться со мной по вопросу доставки',
    (
     select client_id
     from store.client left join store.buy using(client_id)
     where name_client = 'Попов Илья'
     );
select * from store.buy;
