/*
Ranking Analysis

Purpose:
- To rank products, customers, and other entities based on key performance metrics.
- To identify top and bottom performers for business insights.

SQL Concepts Used:
- Window Functions: RANK(), DENSE_RANK(), ROW_NUMBER()
- Aggregate Functions: SUM(), COUNT()
- Clauses: GROUP BY, ORDER BY, TOP, JOIN
*/


-- 1. Top 5 products by revenue (simple ranking)
SELECT TOP 5
    dp.product_name,
    SUM(fs.sales_amount) AS total_revenue
FROM [gold.fact_sales] fs
LEFT JOIN [gold.dim_products] dp
    ON dp.product_key = fs.product_key
GROUP BY dp.product_name
ORDER BY total_revenue DESC;

-- 2. Top 5 products by revenue (using RANK window function)
SELECT *
FROM (
    SELECT
        dp.product_name,
        SUM(fs.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS rank_products
    FROM [gold.fact_sales] fs
    LEFT JOIN [gold.dim_products] dp
        ON dp.product_key = fs.product_key
    GROUP BY dp.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- 3. Bottom 5 products by revenue (lowest performers)
SELECT TOP 5
    dp.product_name,
    SUM(fs.sales_amount) AS total_revenue
FROM [gold.fact_sales] fs
LEFT JOIN [gold.dim_products] dp
    ON dp.product_key = fs.product_key
GROUP BY dp.product_name
ORDER BY total_revenue ASC;

-- 4. Top 10 customers by revenue
SELECT TOP 10
    dc.customer_key,
    dc.first_name,
    dc.last_name,
    SUM(fs.sales_amount) AS total_revenue
FROM [gold.fact_sales] fs
LEFT JOIN [gold.dim_customers] dc
    ON dc.customer_key = fs.customer_key
GROUP BY 
    dc.customer_key,
    dc.first_name,
    dc.last_name
ORDER BY total_revenue DESC;

-- 5. Bottom 3 customers by number of orders placed
SELECT TOP 3
    dc.customer_key,
    dc.first_name,
    dc.last_name,
    COUNT(DISTINCT fs.order_number) AS total_orders
FROM [gold.fact_sales] fs
LEFT JOIN [gold.dim_customers] dc
    ON dc.customer_key = fs.customer_key
GROUP BY 
    dc.customer_key,
    dc.first_name,
    dc.last_name
ORDER BY total_orders ASC;
