-- 2. Calculate stock coverage: how many days current stock will last based on average daily sales.
-- A. average daily sales

WITH MonthlyTotals AS
(
    SELECT 
        YEAR(order_date) AS sales_year,
        MONTH(order_date) AS sales_month,
        ROUND(SUM(quantity_ordered * pro.unit_price)) AS total_sales,
        COUNT(DISTINCT order_date) AS sale_days
    FROM orders ord
    JOIN products pro
        ON pro.product_id = ord.product_id
    GROUP BY 
        YEAR(order_date),
        MONTH(order_date)
)
SELECT 
    sales_year,
    sales_month,
    total_sales,
    sale_days,
    ROUND(total_sales / sale_days, 2) AS avg_daily_sales
FROM MonthlyTotals
ORDER BY sales_year, sales_month;

-- B. how many days current stock will last based on average daily sales

WITH MonthlyTotals AS
(
    SELECT 
        MONTH(ord.order_date) AS sales_month,
        ROUND(SUM(ord.quantity_ordered * pro.unit_price)) AS total_sales,
        COUNT(DISTINCT ord.order_date) AS sale_days
    FROM orders ord
    JOIN products pro
        ON pro.product_id = ord.product_id
    GROUP BY 
        MONTH(ord.order_date)
),
StockHistory AS
(
    SELECT 
        MONTH(inv.last_restock_date) AS stock_month,
        SUM(inv.quantity_in_stock) AS total_stock
    FROM inventory inv
    GROUP BY 
        MONTH(inv.last_restock_date)
)
SELECT
    mt.sales_month,
    mt.total_sales,
    mt.sale_days,
    ROUND(mt.total_sales / mt.sale_days, 2) AS avg_daily_sales,
    sh.total_stock,
    ROUND(sh.total_stock / (mt.total_sales / mt.sale_days)) AS days_stock_will_last
FROM MonthlyTotals mt
JOIN StockHistory sh
    ON mt.sales_month = sh.stock_month
ORDER BY mt.sales_month;

-- 3. Identify fast-moving vs slow-moving products.
 -- to do this, calculate te total unit of each product sold per month

SELECT p.product_id, p.product_name, MONTH(o.order_date) sales_month, sum(o.quantity_ordered) total_quantity_sold
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name, sales_month
ORDER BY sales_month, total_quantity_sold DESC;