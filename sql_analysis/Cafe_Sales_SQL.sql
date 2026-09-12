CREATE DATABASE cafe

USE cafe

-- Creating smaller tables from main table

-- Create Items Table

CREATE TABLE items (
    item_id INT IDENTITY(1,1) PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL UNIQUE
);

-- Create Payment Methods Table

CREATE TABLE payment_methods (
    payment_method_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_method VARCHAR(50) NOT NULL UNIQUE
);

-- Create Locations Table

CREATE TABLE locations (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    location_name VARCHAR(50) NOT NULL UNIQUE
);

-- Create Transactions Table

CREATE TABLE transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    item_id INT,
    payment_method_id INT,
    location_id INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    total_spent DECIMAL(10,2),
    transaction_date DATE,

    CONSTRAINT FK_transactions_items
        FOREIGN KEY (item_id)
        REFERENCES items(item_id),

    CONSTRAINT FK_transactions_payment_methods
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_methods(payment_method_id),

    CONSTRAINT FK_transactions_locations
        FOREIGN KEY (location_id)
        REFERENCES locations(location_id)
);

SELECT TOP 10 *
FROM dbo.cafe_sales_staging_new;

SELECT COUNT(*) AS row_count
FROM dbo.cafe_sales_staging_new;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'cafe_sales_staging_new'
ORDER BY ORDINAL_POSITION;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'cafe_sales_staging_new';

SELECT DISTINCT item
FROM dbo.cafe_sales_staging_new
ORDER BY item;

SELECT DISTINCT payment_method
FROM dbo.cafe_sales_staging_new
ORDER BY payment_method;

SELECT DISTINCT location
FROM dbo.cafe_sales_staging_new
ORDER BY location;

SELECT COUNT(*) AS total_rows
FROM dbo.cafe_sales_staging_new;

-- Populating items table

INSERT INTO dbo.items (item_name)
SELECT DISTINCT
    LTRIM(RTRIM(item))
FROM dbo.cafe_sales_staging_new
WHERE item IS NOT NULL;

SELECT *
FROM dbo.items
ORDER BY item_id;

-- Populate payment_methods

INSERT INTO dbo.payment_methods (payment_method)
SELECT DISTINCT
    LTRIM(RTRIM(payment_method))
FROM dbo.cafe_sales_staging_new
WHERE payment_method IS NOT NULL;


SELECT *
FROM dbo.payment_methods
ORDER BY payment_method_id;

-- Populate locations

INSERT INTO dbo.locations (location_name)
SELECT DISTINCT
    LTRIM(RTRIM(location))
FROM dbo.cafe_sales_staging_new
WHERE location IS NOT NULL;

SELECT *
FROM dbo.locations
ORDER BY location_id;

SELECT 'Items' AS table_name, COUNT(*) AS row_count
FROM dbo.items

UNION ALL

SELECT 'Payment Methods', COUNT(*)
FROM dbo.payment_methods

UNION ALL

SELECT 'Locations', COUNT(*)
FROM dbo.locations;

-- Populate transactions

INSERT INTO dbo.transactions (
    transaction_id,
    item_id,
    payment_method_id,
    location_id,
    quantity,
    price_per_unit,
    total_spent,
    transaction_date
)
SELECT
    s.transaction_id,
    i.item_id,
    pm.payment_method_id,
    l.location_id,
    s.quantity,
    CAST(s.price_per_unit AS DECIMAL(10,2)),
    CAST(s.total_spent AS DECIMAL(10,2)),
    s.transaction_date
FROM dbo.cafe_sales_staging_new AS s

LEFT JOIN dbo.items AS i
    ON LTRIM(RTRIM(s.item)) = i.item_name

LEFT JOIN dbo.payment_methods AS pm
    ON LTRIM(RTRIM(s.payment_method)) = pm.payment_method

LEFT JOIN dbo.locations AS l
    ON LTRIM(RTRIM(s.location)) = l.location_name;


SELECT COUNT(*) AS transaction_count
FROM dbo.transactions;

-- Checking the relational structure

SELECT TOP 20
    t.transaction_id,
    i.item_name,
    t.quantity,
    t.price_per_unit,
    t.total_spent,
    pm.payment_method,
    l.location_name,
    t.transaction_date
FROM dbo.transactions AS t

JOIN dbo.items AS i
    ON t.item_id = i.item_id

JOIN dbo.payment_methods AS pm
    ON t.payment_method_id = pm.payment_method_id

JOIN dbo.locations AS l
    ON t.location_id = l.location_id;

----------------------------------------------------ANALYTICAL QUERIES---------------------------------------------------
    
-- Query 1
-- Business Question:
-- Which products generate the most revenue?

SELECT
    i.item_name,
    SUM(t.quantity) AS total_units_sold,
    ROUND(SUM(t.total_spent), 2) AS total_revenue
FROM dbo.transactions AS t
JOIN dbo.items AS i
    ON t.item_id = i.item_id
GROUP BY
    i.item_id,
    i.item_name
ORDER BY
    total_revenue DESC;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 2
-- Business Question:
-- Which products sell the most units?

SELECT
    i.item_name,
    SUM(t.quantity) AS total_units_sold,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(AVG(t.quantity), 2) AS avg_quantity_per_transaction
FROM dbo.transactions AS t
JOIN dbo.items AS i
    ON t.item_id = i.item_id
GROUP BY
    i.item_id,
    i.item_name
ORDER BY
    total_units_sold DESC;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 3
-- Business Question:
-- Which location generates the most revenue?

SELECT
    l.location_name,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.quantity) AS total_units_sold,
    ROUND(SUM(t.total_spent), 2) AS total_revenue,
    ROUND(AVG(t.total_spent), 2) AS avg_transaction_value
FROM dbo.transactions AS t
JOIN dbo.locations AS l
    ON t.location_id = l.location_id
GROUP BY
    l.location_id,
    l.location_name
ORDER BY
    total_revenue DESC;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 4
-- Business Question:
-- Which payment methods are most frequently used?

SELECT
    pm.payment_method,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.quantity) AS total_units_sold,
    ROUND(SUM(t.total_spent), 2) AS total_revenue,
    ROUND(AVG(t.total_spent), 2) AS avg_transaction_value
FROM dbo.transactions AS t
JOIN dbo.payment_methods AS pm
    ON t.payment_method_id = pm.payment_method_id
GROUP BY
    pm.payment_method_id,
    pm.payment_method
ORDER BY
    transaction_count DESC;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 5
-- Business Question:
-- Which products perform best at each location?

SELECT
    l.location_name,
    i.item_name,
    SUM(t.quantity) AS units_sold,
    ROUND(SUM(t.total_spent), 2) AS revenue
FROM dbo.transactions AS t

JOIN dbo.items AS i
    ON t.item_id = i.item_id

JOIN dbo.locations AS l
    ON t.location_id = l.location_id

GROUP BY
    l.location_id,
    l.location_name,
    i.item_id,
    i.item_name

ORDER BY
    l.location_name,
    revenue DESC;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 6
-- Business Question:
-- Which products generate above-average revenue?

SELECT
    i.item_name,
    ROUND(SUM(t.total_spent), 2) AS total_revenue
FROM dbo.transactions AS t

JOIN dbo.items AS i
    ON t.item_id = i.item_id

GROUP BY
    i.item_id,
    i.item_name

HAVING
    SUM(t.total_spent) >
    (
        SELECT AVG(product_revenue)
        FROM
        (
            SELECT
                item_id,
                SUM(total_spent) AS product_revenue
            FROM dbo.transactions
            GROUP BY item_id
        ) AS product_summary
    )

ORDER BY
    total_revenue DESC;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 7
-- Business Question:
-- What is the highest-revenue product in each location?

WITH ProductLocationRevenue AS
(
    SELECT
        l.location_name,
        i.item_name,
        SUM(t.total_spent) AS revenue
    FROM dbo.transactions AS t

    JOIN dbo.items AS i
        ON t.item_id = i.item_id

    JOIN dbo.locations AS l
        ON t.location_id = l.location_id

    GROUP BY
        l.location_id,
        l.location_name,
        i.item_id,
        i.item_name
),

RankedProducts AS
(
    SELECT
        location_name,
        item_name,
        revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY location_name
            ORDER BY revenue DESC
        ) AS product_rank
    FROM ProductLocationRevenue
)

SELECT
    location_name,
    item_name,
    ROUND(revenue, 2) AS revenue
FROM RankedProducts
WHERE product_rank = 1
ORDER BY location_name;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 8
-- Business Question:
-- How does revenue change month over month?

SELECT
    YEAR(transaction_date) AS sales_year,
    MONTH(transaction_date) AS sales_month,
    DATENAME(MONTH, transaction_date) AS month_name,
    COUNT(transaction_id) AS transaction_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_spent), 2) AS total_revenue,
    ROUND(AVG(total_spent), 2) AS avg_transaction_value
FROM dbo.transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date),
    DATENAME(MONTH, transaction_date)
ORDER BY
    sales_year,
    sales_month;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 9
-- Business Question:
-- Does payment preference differ by location?

SELECT
    l.location_name,
    pm.payment_method,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(SUM(t.total_spent), 2) AS total_revenue,
    ROUND(AVG(t.total_spent), 2) AS avg_transaction_value
FROM dbo.transactions AS t

JOIN dbo.locations AS l
    ON t.location_id = l.location_id

JOIN dbo.payment_methods AS pm
    ON t.payment_method_id = pm.payment_method_id

GROUP BY
    l.location_id,
    l.location_name,
    pm.payment_method_id,
    pm.payment_method

ORDER BY
    l.location_name,
    transaction_count DESC;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Query 10
-- Business Question:
-- Which products have an above-average transaction value?

SELECT
    i.item_name,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(AVG(t.total_spent), 2) AS avg_product_transaction
FROM dbo.transactions AS t

JOIN dbo.items AS i
    ON t.item_id = i.item_id

GROUP BY
    i.item_id,
    i.item_name

HAVING
    AVG(t.total_spent) >
    (
        SELECT AVG(total_spent)
        FROM dbo.transactions
    )

ORDER BY
    avg_product_transaction DESC;


