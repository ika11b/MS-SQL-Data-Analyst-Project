/*
Database Exploration

Purpose:
- Explore the structure of the database, including a list of tables and their schemas.
- Inspect column metadata for specific tables.
*/

-- 1. Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- 2. Retrieve all columns for a specific table (dim_customers)
SELECT 
    TABLE_NAME,
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'gold.dim_customers';

