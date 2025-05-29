/*
Part-to-Whole Analysis

Purpose:
- To measure the contribution of individual segments (product categories)
  to the total metric (overall revenue).
- Helps identify dominant contributors and assess relative performance.

SQL Concepts Used:
- Common Table Expressions (CTEs)
- Window Functions: SUM() OVER() for total reference
- Percentage Calculation using CAST and ROUND
*/

-- Identify which product categories contribute the most to overall sales
WITH category_sales AS (
    SELECT
        dp.category,
        SUM(fs.sales_amount) AS total_sales
    FROM [gold.fact_sales] AS fs
    LEFT JOIN [gold.dim_products] AS dp
        ON dp.product_key = fs.product_key
    GROUP BY dp.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
