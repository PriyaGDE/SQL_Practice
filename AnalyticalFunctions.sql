--Practiced analytical functions queries in local database
--RANK--rank number not sequential as dense rank
select staff_id, sum(amount),
Rank() over (order by sum(amount) desc) as Total_sales
from payment
group by staff_id;

--denserank-rank number is sequential
select staff_id, sum(amount),
dense_Rank() over (order by sum(amount) desc) as Total_sales
from payment
group by staff_id;

--partition by rating
select staff_id, amount,
rank() over (partition by staff_id order by amount desc) as Partition_rating
from payment
group by staff_id,amount;

--windows function-sum() over for total payment over year
select year,sum(total_sales) over (order by year) as Yearly_Data
from
(select extract(year from payment_date) as Year,
 sum(amount) as Total_sales
from payment
group by year)
as total_sales;

--adding row number
select
row_number() over (order by length desc) as Row_No, film_id,title,rating
from film;

--ntile-divides result into equal-sized groups here 3
select staff_id, amount,
ntile(3) over (partition by staff_id order by amount desc) as Partition_rating
from payment
group by staff_id,amount;