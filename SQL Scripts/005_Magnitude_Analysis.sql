
/* Magnitude Analysis 
--> compare the measure values by categories.
--> it helps to understand the importance of different categories*/


-- Total Customers by Country
select country, count(customer_key) as TotalCustomers
from gold.dim_customers
group by country
order by TotalCustomers DESC


-- Total customers by gender
select gender, count(customer_key) as No_of_Customers
from gold.dim_customers
group by gender
ORDER BY No_of_Customers DESC

--Total products by category
select category, COUNT(product_id) as Total_Products
from gold.dim_products
group by category
order by Total_Products DESC


-- Average cost of each category
select category, AVG(cost) as Avg_Cost 
from gold.dim_products
group by category
order by Avg_Cost DESC


-- Total Revenue generated for each category
select p.category, SUM(sales_amount) as avg_revenue
from gold.fact_sales s
left join gold.dim_products p
	on s.product_key=p.product_key
group by p.category
order by avg_revenue DESC


-- Total revenue generated by each customer
select 
	c.customer_key,c.first_name,c.last_name,
	sum(s.sales_amount) as total_revenue
from gold.fact_sales s
left join gold.dim_customers c
	on s.customer_key=c.customer_key
group by c.customer_key,c.first_name,c.last_name
order by total_revenue desc


-- distribution of sold items across the countries
select 
	c.country, sum(s.quantity) as No_Of_Items_Sold
from gold.fact_sales s
left join gold.dim_customers c
	on s.customer_key=c.customer_key
group by c.country
order by No_Of_Items_Sold desc
