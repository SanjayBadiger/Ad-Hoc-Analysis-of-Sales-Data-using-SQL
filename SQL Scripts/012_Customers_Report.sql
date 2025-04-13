
/*
==================================================================================
Customer Report
==================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages and transaction details.
	2. Segments customers into categories (VIP, Regular and New) and age groups
	3. Aggregate customer-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total products 
		- lifespan (in month)
	4. Calculate valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
===================================================================================*/
CREATE VIEW gold.report_customer AS 
with base_query as(
/*----------------------------------------------------------------------------------
-- 1) Base Query: Retriveing the core columns from the tables
----------------------------------------------------------------------------------*/
select
	s.order_number, s.product_key,
	s.order_date, s.sales_amount,
	s.quantity,
	c.customer_key, c.customer_number,
	concat(c.first_name,' ',c.last_name) as customer_name,
	datediff(year,c.birthdate, GETDATE()) as age
from gold.fact_sales s
left join gold.dim_customers c
	on s.customer_key=c.customer_key
where order_date is not null
),
customer_aggregations as(
/*----------------------------------------------------------------------------------
-- 2) Customer Aggregations: summarizes the key metrics at customer level
----------------------------------------------------------------------------------*/
select 
	customer_key, customer_number,
	customer_name, age,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	count(distinct product_key) as total_products,
	max(order_date) as last_order_date,
	DATEDIFF(month, min(order_date),max(order_date)) as lifespan_in_months
from base_query
group by customer_key, customer_number,customer_name, age
)

select 
	customer_key, customer_number,customer_name, age,
	case
		when age < 20 then 'under 20'
		when age between 20 and 29 then '20-29'
		when age between 30 and 39 then '30-39'
		when age between 40 and 49 then '40-49'
		else '50 or above'
	end as age_groups,
	case 
		when lifespan_in_months >=12 and total_sales >5000 then 'VIP'
		when lifespan_in_months >=12 and total_sales <5000 then 'Regular'
		else 'New'
	end as customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) as recency_in_months,
	-- compute average order value (AVO)
	case
		when total_orders = 0 then 0
		else total_sales/total_orders 
	end as average_order_value,
	-- average monthly spend
	case 
		when lifespan_in_months = 0 then 0
		else total_sales/lifespan_in_months
	end as average_monthly_spend
from customer_aggregations

-- report_customer info
select * from gold.report_customer

-- direct aggregations on the view created- report_customer
select 
	customer_segment,
	count(customer_number) as total_customers,
	sum(total_sales) as total_sales
from gold.report_customer
group by customer_segment
order by total_sales

