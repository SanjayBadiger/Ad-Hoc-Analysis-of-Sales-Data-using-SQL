
/* Cumulative Analysis */
-- aggregating the data progressively over the time
-- helps to understand whether our budiness is growing or declining

-- calculate the total sales per month and the running total of sales over time
with cte as (
select 
	datetrunc(month, order_date) as order_date,
	sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date) 
)
select 
	order_date,total_sales, 
	sum(total_sales) over(order by order_date) as running_total
from cte
group by order_date,total_sales
order by order_date

select 
	order_date, 
	total_sales,
	sum(total_sales) over(order by order_date) as running_total
from (
select 
	datetrunc(month, order_date) as order_date,
	sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date) 
) t

-- calculate the total sales per month and the yearwise running total of sales 
select 
	order_date,
	total_sales,
	sum(total_sales) over(partition by year(order_date) order by order_date) as running_total,
	avg(avg_sales) over(partition by year(order_date) order by order_date) as moving_avg
from (
select 
	datetrunc(month,order_date) as order_date, 
	sum(sales_amount) as total_sales,
	avg(sales_amount) as avg_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(month,order_date) 
) t
