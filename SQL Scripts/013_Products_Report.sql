
/*
==================================================================================
Product Report
==================================================================================
Purpose:
	- This report consolidates key product metrics and behaviors

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range or Low-Performers
	3. Aggregate product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique) 
		- lifespan (in month)
	4. Calculate valuable KPIs:
		- recency (months since last sale)
		- average order value
		- average monthly spend
===================================================================================*/
create view gold.report_product as
with base_query as (
-- 1) Base query -- to retrieve the core columns 
select 
	p.product_key,
	p.product_name,
	p.category, 
	p.subcategory,
	p.cost,
	s.customer_key, 
	s.sales_amount,
	s.order_number, 
	s.quantity,
	s.order_date
from gold.fact_sales s
left join gold.dim_products p
	on s.product_key = p.product_key
where order_date is not null -- considers only valid order dates
),
product_aggregations as (
-----------------------------------------------------------------------------
-- 2) Product level agrregations: summarizes the key metrics at product level
-----------------------------------------------------------------------------
select 
	product_name,
	product_key,
	category, 
	subcategory, cost,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	count(distinct customer_key) as total_customers,
	max(order_date) as last_order_date,
	DATEDIFF(month, min(order_date) ,max(order_date)) as life_span_in_months,
	round(avg(cast(sales_amount as float)/nullif(quantity,0)),1) as avg_sellig_price
from base_query
group by product_name,product_key, category, subcategory,cost
)
----------------------------------------------------------------------------------
--3) Final query: combines all the products results into one output
----------------------------------------------------------------------------------
select 
	product_key,
	product_name,
	category, 
	subcategory,
	cost,
	last_order_date,
	DATEDIFF(month, last_order_date, getdate()) as recency_in_months,
	case	when total_sales > 50000 then 'High-Performer'
			when total_sales >=10000 then 'Mid-range'
			else 'Low-Performer'
	end as product_segment,
	life_span_in_months,
	total_sales,
	total_orders,
	total_quantity,
	total_customers,
	avg_sellig_price,
	-- average order revenue
	case
		when total_sales = 0 then 0
		else total_sales/total_orders 
	end as average_order_revenue,
	-- average monthly revenue
	case 
		when life_span_in_months=0 then 0
		else total_sales/life_span_in_months 
	end as average_monthly_revenue_per_product
from product_aggregations

-- report_product info
select * from gold.report_product