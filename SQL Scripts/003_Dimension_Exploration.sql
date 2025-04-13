
//* DIMENSION EXPLORATION *//
select distinct country from gold.dim_customers

select * from gold.dim_products
select distinct category, subcategory, product_name from gold.dim_products
order by 1,2,3