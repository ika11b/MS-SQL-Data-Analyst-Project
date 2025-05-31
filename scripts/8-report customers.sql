/*
Customer Report 
View: gold.report_customers

Purpose:
- Consolidates key metrics and behaviors for each customer.

Highlights:
1. Joins sales and customer data to build a unified view.
2. Segments customers by age group and behavior (VIP, Regular, New).
3. Aggregates customer metrics:
   - Total orders, sales, quantity, products
   - Lifespan (months active)
4. Calculates KPIs:
   - Recency (months since last order)
   - Average order value (AOV)
   - Average monthly spend

SQL Concepts Used:
- Common Table Expressions (CTEs)
- Aggregates: COUNT(), SUM(), MAX(), DATEDIFF()
- CASE
*/


-- Create View: gold.report_customers
IF OBJECT_ID('[gold.report_customers]', 'V') IS NOT NULL
    DROP VIEW [gold.report_customers];
GO

CREATE VIEW [gold.report_customers] AS

WITH base_query AS (
    ---------------------------------------------------------------------------
    -- 1) Base Query: Retrieve core columns from sales and customer tables
    ---------------------------------------------------------------------------
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(year, c.birthdate, GETDATE()) AS age
    FROM [gold.fact_sales] AS f
    LEFT JOIN [gold.dim_customers] AS c
        ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),

customer_aggregation AS (
    ---------------------------------------------------------------------------
    -- 2) Aggregate customer-level metrics
    ---------------------------------------------------------------------------
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        age
)

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    -- Age segmentation
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    -- Behavioral segmentation
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    last_order_date,
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan

FROM customer_aggregation;

