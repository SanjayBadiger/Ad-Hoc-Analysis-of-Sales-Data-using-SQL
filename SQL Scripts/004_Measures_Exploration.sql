
/* Measures Exploration */
select * from gold.fact_sales

-- find the total sales
select sum(total_sales) as total_sales
from (select sales_amount*quantity as total_sales from gold.fact_sales) as fact_sales

-- how many items are sold
select sum(quantity) as total_qty
from gold.fact_sales

-- average selling price
select AVG(price) as avg_price from gold.fact_sales

-- total number of orders
select count(order_number) as total_orders from gold.fact_sales
select count(distinct order_number) as distinct_orders from gold.fact_sales

--total number of products sold
select count(product_key) as total_products_ordered from gold.fact_sales

--number of products are there for selling
select count(product_key) as total_products_available from gold.dim_products

--total number of customers ordered
select count(distinct customer_key) as total_products_ordered from gold.fact_sales

--number of customers 
select count(customer_id) as total_customers from gold.dim_customers

/* Generating the report */
select 'TotalSales' as MeasureName, sum(total_sales) as MeasureValue
from (select sales_amount*quantity as total_sales from gold.fact_sales) as fact_sales
UNION ALL
select 'TotalQuantity',sum(quantity) from gold.fact_sales
UNION ALL
select 'Average Price',AVG(price) as avg_price from gold.fact_sales
UNION ALL 
select 'Total Number of Orders',count(order_number) as total_orders from gold.fact_sales
UNION ALL
select 'Total Number of Products',count(product_key) as total_products_available from gold.dim_products
UNION ALL 
select 'Total Number of Customers',count(customer_id) as total_customers from gold.dim_customers
