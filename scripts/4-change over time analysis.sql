/*
Change Over Time Analysis

Purpose:
- To analyze trends and variations in sales over time.
- To identify trends, seasonality, and fluctuations in performance.
- To measure growth or decline across specific time intervals.

SQL Concepts Used:
- Date Functions: DATEPART(), DATETRUNC(), FORMAT()
- Aggregate Functions: SUM(), COUNT(), AVG()
- GROUP BY, ORDER BY
*/


-- Using DATEPART()
SELECT
    YEAR(fs.order_date) AS order_year,
    MONTH(fs.order_date) AS order_month,
    SUM(fs.sales_amount) AS total_sales,
    COUNT(DISTINCT fs.customer_key) AS total_customers,
    SUM(fs.quantity) AS total_quantity
FROM [gold.fact_sales] AS fs
WHERE fs.order_date IS NOT NULL
GROUP BY YEAR(fs.order_date), MONTH(fs.order_date)
ORDER BY YEAR(fs.order_date), MONTH(fs.order_date);

-- Using DATETRUNC()
SELECT
    DATETRUNC(month, fs.order_date) AS order_month,
    SUM(fs.sales_amount) AS total_sales,
    COUNT(DISTINCT fs.customer_key) AS total_customers,
    SUM(fs.quantity) AS total_quantity
FROM [gold.fact_sales] AS fs
WHERE fs.order_date IS NOT NULL
GROUP BY DATETRUNC(month, fs.order_date)
ORDER BY order_month;

-- Using FORMAT()
SELECT
    FORMAT(fs.order_date, 'yyyy-MMM') AS order_month,
    SUM(fs.sales_amount) AS total_sales,
    COUNT(DISTINCT fs.customer_key) AS total_customers,
    SUM(fs.quantity) AS total_quantity
FROM [gold.fact_sales] AS fs
WHERE fs.order_date IS NOT NULL
GROUP BY FORMAT(fs.order_date, 'yyyy-MMM')
ORDER BY order_month;

