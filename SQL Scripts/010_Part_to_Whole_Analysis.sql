
-------- Part to whole analysis --------------------------
/* analyze how an individual part is performing compared to the overall, allowing us 
to understand which category has the greates impact on the business */
with category_total_sales as(
select 
	p.category,
	sum(s.sales_amount) as total_sales
from gold.fact_sales s
left join gold.dim_products p
	on s.product_key=p.product_key
group by p.category
)
select 
	category, total_sales,
	sum(total_sales) over () as overall_sales,
	concat(round((cast(total_sales as float) / sum(total_sales) over ())*100,2),'%') as pct_sales
from category_total_sales
order by pct_sales desc

