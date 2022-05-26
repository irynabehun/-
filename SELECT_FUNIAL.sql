USE movie;

Select * from cinema;
select * from hall;
select * from user;
select * from movie;
select * from showe;
select * from booking;

-- Number of hall in All cinema
Select c.adress, c.cinema_id,  count(h.hall_id) as num_of_hall
from hall h right join cinema c
on h.cinema_id = c.cinema_id 
group by c.cinema_id;

-- Number of hall in cinema
Select c.adress, c.cinema_id,  count(h.hall_id) as num_of_hall
from hall h,  cinema c
where h.cinema_id = c.cinema_id 
AND c.cinema_id = 1;

-- All the between '09:00' and '14:00' and shows playing on 12.06
Select m.m_name, s.show_time, s.show_date, c.adress 
from showe s, movie m, hall h, cinema c
where s.movie_id = m.movie_id and s.show_time between '09:00' and '14:00' and s.show_date = '22-06-01' 
and s.hall_id = h.hall_id and h.cinema_id = c.cinema_id;

-- Show Timings for movie_name
Select m.m_name, s.show_time, s.show_date, c.adress 
from showe s, movie m, hall h, cinema c
where s.movie_id = m.movie_id and m.m_name = 'Бетмен'
and s.hall_id = h.hall_id and h.cinema_id = c.cinema_id;

-- Total seats in Cinema hall
Select hall_id, num_of_seats_pr, num_of_seats_nr,  SUM(num_of_seats_pr + num_of_seats_nr), cinema.adress
from hall, cinema 
where hall.cinema_id = cinema.cinema_id and name_of_cinema = 'Кіностудія' 
group by hall_id;

-- All English movies
Select m.m_name, s.show_time, s.show_date, c.adress 
from showe s, movie m, hall h, cinema c
where m.m_language = 'Англійська' and s.movie_id = m.movie_id 
and s.hall_id = h.hall_id and h.cinema_id = c.cinema_id;

--  Remaining seats in showes on 01-06-22 in first cinema
Select m.m_name, seats_remaining_pr, seats_remaining_nr, s.show_time,s.show_date 
from showe s, movie m, hall h, cinema c 
Where s.movie_id = m.movie_id  and h.cinema_id = c.cinema_id and s.hall_id = h.hall_id
and s.show_date = '2022-06-01' and c.cinema_id = 1
Order By s.show_time;

-- 8. Num booking made by user
select u.first_name,u.last_name,count(b.booking_id) as num_of_booking
from  user u ,booking b, showe s, hall h, cinema c
where c.cinema_id = h.cinema_id and h.hall_id=s.hall_id
and b.show_id=s.show_id and b.user_id=u.user_id 
group by u.first_name,u.last_name; 



-- 9. Які корстувачі купили квитки на фільм англвйською мовою/ ?????
select concat(first_name,' ' ,last_name) as user, booking_id
from user join booking on user.user_id = booking.user_id 
join showe on booking.show_id = showe.show_id 
join movie on showe.movie_id = movie.movie_id
where m_language like 'Англійська' 
group by user;

select language,count(booking_id) number_of_tickets_bought 
from movie JOIN (select * from booking RIGHT JOIN showe on booking.show_id = showe.show_id) p 
on movie.movie_id = p.movie_id 
where m_language like 'Англійська' ;


-- 10. Кількість вільних мість на фільм 'Бетмен' '01/06/22' в різних кінотеатрах.
select c.cinema_id, c.adress, h.hall_id, s.show_time, s.seats_remaining_pr, s.seats_remaining_nr
from movie m, showe s, hall h ,cinema c
where m.m_name='Бетмен' 
and s.show_date='22-06-01'
and s.hall_id= h.hall_id and h.cinema_id= c.cinema_id 
group by c.cinema_id;

-- 11 Розклад сеансів з ціною для звичайного та преміум квитка
Select m.m_name, seats_remaining_pr,(m.cost_nr *1.3) AS Premiun_seat_cost, seats_remaining_nr, (m.cost_nr) AS Normal_seat_cost, s.show_time,s.show_date , c.adress
from showe s, movie m, hall h, cinema c 
Where s.movie_id = m.movie_id  
and h.cinema_id = c.cinema_id and s.hall_id = h.hall_id
and s.show_time between '10:00' and '16:00'
and c.cinema_id = 1 
Order By  m.m_name;

-- 12 Сеанси фільму у віковій категорії 12+ в кінотеатрах
Select m.m_name, s.show_time, s.show_date, c.adress
from movie m join showe s on m.movie_id = s.movie_id
join hall h on s.hall_id = h.hall_id join cinema c on c.cinema_id = h.cinema_id
where m.audience = '12+' or m.audience = '0+'
and s.show_date='22-06-01';

Select m.m_name, s.show_time, s.show_date, c.adress
from movie m, showe s, hall h, cinema c
where m.movie_id = s.movie_id and s.hall_id = h.hall_id and c.cinema_id = h.cinema_id and m.audience = '12+';

-- 13 Скільки продав квитків кінотеатр
drop view most_sales_made;

create view most_sales_made as
(select c.adress as location,count(booking_id) as ticket_sales
from cinema c, showe s, booking b, hall h
where c.cinema_id = h.cinema_id and s.hall_id=h.hall_id and s.show_id=b.show_id 
group by c.adress);

create view most_sales_made as
(select c.adress as location,count(booking_id) as ticket_sales, sum(m.cost_nr) as amount
from cinema c, showe s, booking b, hall h, movie m
where c.cinema_id = h.cinema_id and s.hall_id=h.hall_id and s.show_id=b.show_id 
and s.movie_id = m.movie_id and boking_date between '2022-05-01' and '2022-06-01'
group by c.adress);

select * from  most_sales_made;

select location ,ticket_sales, amount
from most_sales_made
where ticket_sales=(select max(ticket_sales) from most_sales_made);

select location ,ticket_sales
from most_sales_made;


-- 14 Найпопулярніший кінотеатр
drop view most_popular_theatre;
create view most_popular_theatre as
(select c.adress as location ,count(b.booking_id) as no_of_bookings_received
from cinema c, showe s, booking b, hall h
where c.cinema_id = h.cinema_id and s.hall_id = h.hall_id and s.show_id = b.show_id 
and boking_date between '2022-05-01' and '2022-06-01'
group by c.adress);

select * from most_popular_theatre;

select location
from most_popular_theatre 
where no_of_bookings_received=(select max(no_of_bookings_received) from most_popular_theatre);

-- 15
drop view premium;
create view premium as (select c.adress as location, count(seat_class) as premium, sum((m.cost_nr * 1.3)) as amount  
from booking b join showe s on s.show_id = b.show_id
join movie m on s.movie_id = m.movie_id
join  hall on s.hall_id = hall.hall_id
join cinema c on hall.cinema_id = c.cinema_id
 where seat_class = 'pr' 
 and boking_date between '2022-05-01' and '2022-06-01'
 group by c.adress);
 select * from premium;
 
drop view normal;
create view normal as (select c.adress as location, count(seat_class) as normal, sum(m.cost_nr ) as amount  
from booking b join showe s on s.show_id = b.show_id
join movie m on s.movie_id = m.movie_id
join  hall on s.hall_id = hall.hall_id
join cinema c on hall.cinema_id = c.cinema_id
 where seat_class = 'nr' 
 and boking_date between '2022-05-01' and '2022-06-01'
 group by c.adress);
select * from normal;

drop view sold;
create view sold as (Select * from premium p cross join normal n);

Select * from premium p cross join normal n on p.location = n.location;
select * from sold;
 
 
