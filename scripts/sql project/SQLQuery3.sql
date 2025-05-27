-- which 5 product generate the highest revenue
select top 5
p.product_name,
sum(f.sales_amount) as revenue
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_products] p
on p.product_key = f.product_key
group by p.product_name
order by revenue desc

-- which 5 product generate the lowest revenue
select top 5
p.product_name,
sum(f.sales_amount) as revenue
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_products] p
on p.product_key = f.product_key
group by p.product_name
order by revenue 

-- which 5 subproduct generate the highest revenue
select top 5
p.subcategory,
sum(f.sales_amount) as revenue
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_products] p
on p.product_key = f.product_key
group by p.subcategory
order by revenue desc

-- which 5 product generate the highest revenue and rank them without using "top"
select *
from (select 
p.product_name,
sum(f.sales_amount) as revenue,
rank() over(order by sum(f.sales_amount) desc) as products_ranked
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_products] p
on p.product_key = f.product_key
group by p.product_name) s
where products_ranked <= 5

-- find the top 10 customers that generated highest revenue
select top 10
c.customer_key, 
c.first_name,
c.last_name, 
sum(f.sales_amount) as revenue
from dbo.[gold.fact_sales] as f
left join dbo.[gold.dim_customers] c
on c.customer_key = f.customer_key
group by
c.customer_key, 
c.first_name,
c.last_name
order by revenue desc;

-- find the top 3 customers that placed the least orders
select 
c.customer_key, 
c.first_name,
c.last_name, 
count(distinct order_number) as total_order
from dbo.[gold.fact_sales] as f
left join dbo.[gold.dim_customers] c
on c.customer_key = f.customer_key
group by
c.customer_key, 
c.first_name,
c.last_name
order by total_order;
