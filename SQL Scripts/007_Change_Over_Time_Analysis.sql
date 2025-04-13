--------Advance Data Analytics---------------

/* Change over time*/
-- analyzing how a measure evolves over time
-- helps to track trends and identify seasonality in your data


-- sales performance over time - YEARLY
select 
	year(order_date) as order_year, 
	sum(sales_amount) as Total_sales,
	count(distinct customer_key) as Total_Customers,
	sum(quantity) as Total_Quantity_Sold
from gold.fact_sales
where order_date is not null 
group by year(order_date)
order by order_year

-- sales performance over time - YEARLY
select 
	year(order_date) as order_year,
	month(order_date) as order_month,
	sum(sales_amount) as Total_sales,
	count(distinct customer_key) as Total_Customers,
	sum(quantity) as Total_Quantity_Sold
from gold.fact_sales
group by year(order_date),month(order_date)
order by year(order_date),month(order_date)

select 
	DATETRUNC(month, order_date) as Order_Date,
	sum(sales_amount) as Total_sales,
	count(distinct customer_key) as Total_Customers,
	sum(quantity) as Total_Quantity_Sold
from gold.fact_sales
group by DATETRUNC(month, order_date) 
order by DATETRUNC(month, order_date) 

select 
	DATETRUNC(year, order_date) as Order_Date,
	sum(sales_amount) as Total_sales,
	count(distinct customer_key) as Total_Customers,
	sum(quantity) as Total_Quantity_Sold
from gold.fact_sales
group by DATETRUNC(year, order_date) 
order by DATETRUNC(year, order_date) 

select 
	FORMAT(order_date, 'yyyy-MM') as Order_Date,
	sum(sales_amount) as Total_sales,
	count(distinct customer_key) as Total_Customers,
	sum(quantity) as Total_Quantity_Sold
from gold.fact_sales
group by FORMAT(order_date, 'yyyy-MM') 
order by FORMAT(order_date, 'yyyy-MM')

