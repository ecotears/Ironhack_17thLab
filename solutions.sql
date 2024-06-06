-- Pregunta 01
select title, inv_count
from film a
left join 
(select count(inventory_id) as inv_count, film_id
from inventory
group by film_id) b
on a.film_id = b.film_id
where title = 'HUNCHBACK IMPOSSIBLE';

-- Pregunta 02
select title
from film
where length > 
(select avg(length)
from film);

-- Pregunta 03
select distinct b.actor_id, b.first_name, b.last_name
from film_actor a inner join actor b
on a.actor_id = b.actor_id
inner join (select * from film where title = 'Alone Trip') c
on a.film_id = c.film_id;

-- Pregunta 04
select title
from film a
inner join
(select film_id
from film_category a
inner join category b
on a.category_id = b.category_id
where name = 'Family') b
on a.film_id = b.film_id;

-- Pregunta 05

select first_name, last_name, email
from
(select first_name, last_name, email, country
from customer a
inner join address b
on a.address_id = b.address_id
inner join city c
on b.city_id = c.city_id
inner join country d
on c.country_id = d.country_id) temp
where country = 'Canada';

-- Pregunta 06

select title
from film a 
inner join film_actor b
on a.film_id = b.film_id
where actor_id =
(select actor_id 
from 
(select actor_id, rank() over (order by count(a.film_id) DESC) rk
from film_actor a
group by actor_id
limit 1) temp);

-- Pregunta 07
select a.customer_id, title
from payment a
inner join rental b
on a.rental_id = b.rental_id
inner join inventory c
on b.inventory_id = c.inventory_id
inner join film d
on d.film_id = c.film_id

where a.customer_id = 
(select customer_id
from
(select sum(amount), customer_id
from payment
group by customer_id
order by sum(amount) desc 
limit 1) temp);

-- Pregunta 08
select customer_id, sum(amount)
from payment
where customer_id in
(select customer_id 
from 
(SELECT distinct
    customer_id, 
    AVG(amount) OVER () AS all_avg_amount,
    avg(amount) over (partition by customer_id) as customer_avg_amount
FROM payment) temp
where customer_avg_amount > all_avg_amount)
group by customer_id



