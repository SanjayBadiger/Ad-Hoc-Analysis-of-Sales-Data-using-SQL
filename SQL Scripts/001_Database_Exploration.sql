//* DATABASE EXPLORATION *//

-- exploring all objects in the database
select * from INFORMATION_SCHEMA.TABLES

-- exploring all columns in the database
select * from INFORMATION_SCHEMA.COLUMNS

-- exploring all columns of a specific table
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='dim_customers'

-- exploring all columns of a products table
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='dim_products'

-- exploring all columns of a sales table
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='fact_sales'