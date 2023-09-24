use zomato;

-- Qus 1: What is the total amount each customer spent on Zomato?

select a.userid, sum(b.price) as Amount
from sales a
inner join product b on a.product_id =  b.product_id
group by a.userid
order by a.userid;

-- Qus 2: How many days has each customer visited zomato?

select userid, count(distinct(created_date)) as Total_Counts
from sales
group by userid;

-- Qus 3: What was the first product purchased by each customer?

select s.userid, s.product_id, s.product_name from
(select a.userid, a.created_date, a.product_id, b.product_name, dense_rank() over(partition by a.userid order by created_date) as rnk
from sales a
inner join product b on a.product_id = b.product_id)s
where rnk = 1;

-- Qus 4: What is most purchased item on menu & how many times was it purchased by all customers?

select a.product_id, b.product_name, count(a.product_id) as Total_count
from sales a
inner join product b on a.product_id = b.product_id
group by a.product_id, b.product_name
order by Total_count desc
limit 1;

-- Qus 5: Which item was most popular product for each customer?

select s.userid, s.product_name, s.Total_count from
(select a.userid, b.product_name, count(a.product_id) as Total_count, dense_rank() over(partition by userid order by count(a.product_id) desc) as rnk
from sales a
inner join product b on a.product_id = b.product_id
group by a.userid, b.product_name) s
where rnk = 1;

-- Qus 6 Which item was purchased first by the customer after they become a gold member?

select d.userid, d.product_id, d.product_name from 
(select a.*, b.product_name, row_number() over(partition by a.userid order by a.created_date) as rn
from sales a
inner join product b on a.product_id = b.product_id
inner join goldusers_signup c on a.userid = c.userid
where a.created_date >= c.gold_signup_date) d
where d.rn = 1;

-- Qus 7: Which item was purchased by the customer just before they become a gold member?

select d.userid, d.product_id, d.product_name from 
(select a.*, b.product_name, row_number() over(partition by a.userid order by a.created_date desc) as rn
from sales a
inner join product b on a.product_id = b.product_id
inner join goldusers_signup c on a.userid = c.userid
where a.created_date < c.gold_signup_date) d
where d.rn = 1;

-- Qus 8: What is the total orders and amount spent for each customer before they became a gold member?

select a.userid, count(a.product_id) as Total_orders, sum(b.price) as Amount
from sales a
inner join product b on a.product_id = b.product_id
inner join goldusers_signup c on a.userid = c.userid
where a.created_date < c.gold_signup_date
group by a.userid
order by a.userid;

/* Qus 9: If buying each product generates points for eg 5rs=2 zomato point and each product has different purchasing points for eg for p1 5rs=1 zomato point, for p2 10rs=5 zomato point and p3 5rs=1 zomato point. Calculate points collected by each customer and for which product most points have been given till now */

-- The following query is for calculating the total points earned by each user
select e.userid, sum(Total_points) as Final_points from
(select d.*, round(d.Price/d.points) as Total_points from
(select c.*, case when c.product_id = 1 then 5
				  when c.product_id = 2 then 2
                  when c.product_id = 3 then 5 end as Points
from                 
(select a.userid, a.product_id, sum(b.price) as Price
from sales a
inner join product b on a.product_id = b.product_id
group by a.userid, a.product_id) c) d) e
group by e.userid
order by e.userid;

-- The following query is to find out the product that has received the highest number of points up to this point?"
select e.product_id, sum(e.Total_points) as Final_points from
(select d.*, round(d.Price/d.points) as Total_points from
(select c.*, case when c.product_id = 1 then 5
				  when c.product_id = 2 then 2
                  when c.product_id = 3 then 5 end as Points
from                 
(select a.userid, a.product_id, sum(b.price) as Price
from sales a
inner join product b on a.product_id = b.product_id
group by a.userid, a.product_id) c) d) e
group by e.product_id
order by Final_points desc
limit 1;

-- Qus 10: In the first year of a customer joining the gold program (including the joining date), irrespective of what customer has purchased, he earn 5 zomato points for every 10rs spent. Which user earned more and what was their points earning in the first year?

-- Note for solution: 10rs = 5 zomato points means that 1 point = 2rs

select f.userid, sum(f.Points) as Total_points from
(select e.*, round(e.price/2) as Points from
(select d.userid, d.product_id, sum(d.price) as Price from
(select a.*, b.product_name, b.price, c.gold_signup_date
from sales a
inner join product b on a.product_id = b.product_id
inner join goldusers_signup c on a.userid = c.userid
where a.created_date >= c.gold_signup_date and a.created_date <= date_add(c.gold_signup_date, interval 1 year)) d
group by d.userid, d.product_id) e) f
group by f.userid
order by Total_points desc;

-- Qus 11 : Rank all transactions of each customer by the price of the product from highest to lowest.

select a.userid, a.product_id, sum(b.price) as Price, dense_rank() over(partition by a.userid order by sum(b.price) desc) as Rnk
from sales a
inner join product b on a.product_id = b.product_id
group by a.userid, a.product_id;

-- Qus 12: Rank all transactions for each customer when they are zomato gold member. When they are a non-gold member then mark their transaction as 'NA'.


select c.*, case when c.gold_signup_date is not null then dense_rank() over(partition by c.userid order by c.created_date)
				 else 'NA' end as Rnk
from
(select a.*, b.gold_signup_date
from sales a
left join goldusers_signup b on a.userid = b.userid) c;



