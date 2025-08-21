-- Create a dashboard-like SQL output that combines:
-- Total sales
-- Average delivery time
-- Stock levels
-- Late shipment rate

 WITH Sales AS (
    SELECT 
        SUM(o.quantity_ordered * p.unit_price) AS total_sales
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
),
Delivery AS (
    SELECT 
        AVG(DATEDIFF(s.delivery_date, o.order_date)) AS avg_delivery_time
    FROM shipments s
    JOIN orders o ON s.order_id = o.order_id
    WHERE s.status in('delivered', 'late')
),
Stock AS (
    SELECT 
        SUM(quantity_in_stock) AS total_stock
    FROM inventory
),
LateRate AS (
    SELECT 
        sum((case when status = 'late' then 1 else 0 end) * 100) / count(*)
        AS late_shipment_rate
    FROM shipments s
    JOIN orders o
    ON s.order_id = o.order_id
    WHERE status IN ('late', 'delivered')
)
SELECT 
    s.total_sales,
    d.avg_delivery_time,
    st.total_stock,
    l.late_shipment_rate
FROM Sales s, Delivery d, Stock st, LateRate l;

SELECT 
    o.customer_id, 
    SUM(o.quantity_ordered * p.unit_price) AS total_spent
FROM products p
JOIN orders o 
    ON o.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Seasonal trend of orders

select month(order_date), count(*) total_orders from orders
group by month(order_date)
order by month(order_date);

-- Stockout risk report
-- (Products that will run out soon based on average monthly sales)

WITH monthly_sales AS (
    SELECT product_id, AVG(quantity_ordered) AS avg_monthly_sales
    FROM orders
    GROUP BY product_id
)
SELECT p.product_name, i.quantity_in_stock, m.avg_monthly_sales,
       ROUND(i.quantity_in_stock / m.avg_monthly_sales, 1) AS months_left
FROM products p
JOIN inventory i ON p.product_id = i.product_id
JOIN monthly_sales m ON p.product_id = m.product_id
WHERE i.quantity_in_stock < m.avg_monthly_sales * 2
ORDER BY months_left ASC;
