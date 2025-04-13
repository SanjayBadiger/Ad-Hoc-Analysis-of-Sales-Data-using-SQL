
/*----------- Data Segmentation ---------------------------------------*/
-- grouping of the data based on specific range
-- we create a new category and then get the data based on the new category
-- helps understand the correlation between two measures

-- segment the products into cost ranges and count how many products fall into each segment
with segments as(
select 
	product_key,
	product_name,
	cost,
	case
		when cost < 100 then 'Below 100'
		when cost between 100 and 500 then '100-500'
		when cost between 500 and 1000 then '500-1000'
		else 'Above 1000'
	end as cost_range
from gold.dim_products
)
select 
	cost_range,
	count(product_key) as count_of_products
from segments
group by cost_range
order by count_of_products desc

/* 
group customers into three categories based on their spending behavior
- VIP --> at least 12 months of history and spending more than $5000
- Regular --> at least 12 months of history but spending $5000 or less
- New --> lifespan less than 12 months
And find the total number of customers by each group
*/
with customer_spending_table as(
select 
	c.customer_key,
	min(s.order_date) as first_order_date,
	max(s.order_date) as last_order_date,
	DATEDIFF(MONTH,min(s.order_date),max(s.order_date)) as lifespan,
	sum(s.sales_amount) as total_spending
from gold.fact_sales s 
left join gold.dim_customers c
	on s.customer_key=c.customer_key
group by c.customer_key
),
intermediate_table as(
select 
	customer_key,
	total_spending,
	lifespan,
	case 
		when lifespan >=12 and total_spending >5000 then 'VIP'
		when lifespan >=12 and total_spending <5000 then 'Regular'
		else 'New'
	end as customer_category
from customer_spending_table
)
select 
	customer_category,
	count(customer_key) as customer_count
from intermediate_table
group by customer_category
order by customer_count desc;
