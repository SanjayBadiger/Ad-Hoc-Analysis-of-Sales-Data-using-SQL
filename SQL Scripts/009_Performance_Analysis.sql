
/* Performance Analysis */
-- it's a process of comparing the current value to a target value
-- helps us to measure the success and compare performance

/* analyze the yearly performance of products by comparing each product's sales
to both its average sales performance and the previous year's sales*/
with yearly_sales as(
select
	year(s.order_date) as order_year, p.product_id,p.product_name, 
	sum(s.sales_amount) as current_sales
from gold.fact_sales s
left join gold.dim_products p
	on p.product_key=s.product_key
where order_date is not null
group by year(s.order_date),p.product_id,p.product_name
)
select 
	order_year, 
	product_id, 
	product_name,
	current_sales,
	avg(current_sales) over(partition by product_name) as avg_sales,
	current_sales - avg(current_sales) over(partition by product_name) as diff_avg,
	case 
		when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'Above Avg'
		when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'Below Avg'
		else 'Avg'
	end as avg_change,
	lag(current_sales) over (partition by product_name order by order_year) as previous_year_sales,
	current_sales-lag(current_sales) over (partition by product_name order by order_year) as diff_py,
	case 
		when current_sales-lag(current_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
		when current_sales-lag(current_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
		else 'no change'
	end as py_change
from yearly_sales
order by product_name, order_year

