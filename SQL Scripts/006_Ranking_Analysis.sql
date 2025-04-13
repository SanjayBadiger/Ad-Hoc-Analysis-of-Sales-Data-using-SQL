
-- Ranking Analysis (order the values of dimensions by measure) --
------------ Top N and Bottom N performers ------------------

-- Rank countries by Total Sales 
select 
	c.country, 
	sum(f.sales_amount) as Total_Sales,
	DENSE_RANK() over (ORDER BY sum(f.sales_amount) desc) as Ranking
from gold.fact_sales f
left join gold.dim_customers c
	on f.customer_key=c.customer_key
group by c.country
ORDER BY Ranking

-- Top 5 products by quantity
with cte as (
select 
	s.product_key, p.product_name,
	sum(s.quantity) as Total_Qty, DENSE_RANK() OVER(Order by sum(s.quantity) desc) as Ranking
from gold.fact_sales s
left join gold.dim_products p
	on s.product_key = p.product_key
group by s.product_key,p.product_name
)
select * 
from cte
where Ranking<=5


-- Top 5 products by revenue
with cte as (
select 
	p.subcategory, sum(s.sales_amount) as Total_sales, 
	DENSE_RANK() OVER(Order by sum(s.sales_amount) DESC) as ranking
from gold.fact_sales s
left join gold.dim_products p
	on s.product_key=p.product_key
group by p.subcategory
)
select * from cte 
where ranking<=5


--5 worst performing products by revenue
with cte as (
select 
	p.subcategory, sum(s.sales_amount) as Total_sales, 
	DENSE_RANK() OVER(Order by sum(s.sales_amount)) as ranking
from gold.fact_sales s
left join gold.dim_products p
	on s.product_key=p.product_key
group by p.subcategory
)
select * from cte 
where ranking<=5

-- top 10 customers who generated the highest revenue
with cte as(
select 
	c.customer_id, c.first_name,c.last_name,
	sum(s.sales_amount) as Total_sales,
	DENSE_RANK() OVER(ORDER BY sum(s.sales_amount) desc) as ranking
from gold.fact_sales s
left join gold.dim_customers c
	on s.customer_key=c.customer_key
group by c.customer_id, c.first_name,c.last_name
)
select * from cte
where ranking <=10
order by ranking

-- 3 customers with the fewest orders
with cte as(
select 
	c.customer_id, c.first_name,c.last_name,
	count(distinct order_number) as Total_Orders,
	DENSE_RANK() OVER (ORDER BY sum(s.quantity) asc) as ranks
from gold.fact_sales s
left join gold.dim_customers c
	on s.customer_key=c.customer_key
group by c.customer_id, c.first_name,c.last_name
)
select * from cte
where ranks<=3
ORDER BY Total_Orders asc
