-- calculate total sales for each year 
-- and the running total and moving average of sales
select 
order_date,
total_sales,
sum(total_sales) over(order by order_Date) as running_total,
avg_price,
avg(avg_price) over(order by order_Date) as moving_average
from
(select 
year(order_date) as order_date,
sum(sales_amount) as total_sales,
avg(price) as avg_price
from dbo.[gold.fact_sales]
where order_date is not null
group by year(order_date)
)s