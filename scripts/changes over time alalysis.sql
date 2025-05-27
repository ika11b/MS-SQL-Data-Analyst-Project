-- how total_sales, total_customers and total_quantity changes over the years
select
year(order_date) order_year,
sum(sales_amount) total_sales,
count(distinct customer_key) total_customers,
sum(quantity) total_quantity
from dbo.[gold.fact_sales]
where order_date is not null
group by year(order_date)
order by year(order_date);

-- how total_sales, total_customers and total_quantity changes over the months
select
format(order_date, 'MMM') order_month,
sum(sales_amount) total_sales,
count(distinct customer_key) total_customers,
sum(quantity) total_quantity
from dbo.[gold.fact_sales]
where order_date is not null
group by format(order_date, 'MMM')
order by total_sales desc;

-- how total_sales, total_customers and total_quantity changes over the months in a single year
select
format(order_date, 'MMM') order_month,
sum(sales_amount) total_sales,
count(distinct customer_key) total_customers,
sum(quantity) total_quantity
from dbo.[gold.fact_sales]
where order_date is not null and year(order_date) = 2013
group by format(order_date, 'MMM')
order by total_sales desc;