
//* Date range exploration *//

select min(order_date) as first_order_date, max(order_date) as last_order_date
from gold.fact_sales

-- years of sales
select DATEDIFF(year,min(order_date),max(order_date)) as years_of_sales 
from gold.fact_sales

-- youngest and oldest customer
select first_name, birthdate, DATEDIFF(year, birthdate, GETDATE()) as age
from gold.dim_customers
where birthdate = (select min(birthdate) from gold.dim_customers) or
	birthdate = (select max(birthdate) from gold.dim_customers) 
