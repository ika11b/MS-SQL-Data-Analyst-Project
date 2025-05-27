-- find total customers by countries
SELECT country, count(customer_id) as total_customers
FROM [data_analytics].[dbo].[gold.dim_customers]
group by country
order by total_customers desc;

-- find total customers by gender
SELECT gender, count(customer_id) as total_customers
FROM [data_analytics].[dbo].[gold.dim_customers]
group by gender
order by total_customers desc;

-- find total products by category
SELECT category, count(product_key) as total_products
FROM [data_analytics].[dbo].[gold.dim_products]
group by category
order by total_products desc;

-- find the avarage cost for each category
SELECT category, avg(cost) as avg_cost
FROM [data_analytics].[dbo].[gold.dim_products]
group by category
order by avg_cost desc;

-- find the total revenue for each category
select
p.category, 
sum(f.sales_amount) as revenue
from dbo.[gold.fact_sales] as f
left join dbo.[gold.dim_products] p
on p.product_key = f.product_key
group by p.category
order by revenue desc;

-- find the total revenue for each customer
select
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

--find the distribution of items in countries
select
c.country,
sum(f.quantity) as total_sold_items
from dbo.[gold.fact_sales] as f
left join dbo.[gold.dim_customers] c
on c.customer_key = f.customer_key
group by
c.country
order by total_sold_items desc