/*

Cumulative Analysis

Purpose:
  - To calculate running totals or moving averages for key metrics.
	- To track growth trends and long-term performance.
	- Useful for year-over-year cumulative tracking and pricing insights.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
*/

-- Calculate the total sales per month 
-- and the running total of sales + moving average price over time
SELECT
    order_year,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_year) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_year) AS moving_average_price
FROM (
    SELECT 
        DATETRUNC(MONTH, order_date) AS order_year, -- if you change month with year you will calculate sales per year
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM [gold.fact_sales]
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date) 
) AS s
ORDER BY order_year;

