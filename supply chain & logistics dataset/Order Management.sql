-- Order Management
-- Find the top 10 products by total sales
 SELECT 
    p.product_id,
    MONTH(o.order_date) AS order_month,
    SUM(o.quantity_ordered) AS total_quantity,
    p.unit_price,
    SUM(o.quantity_ordered * p.unit_price) total_sales
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY 
    p.product_id,
    MONTH(o.order_date),
    p.unit_price
ORDER BY 
    p.product_id,
    order_month;
    
    -- ranking
    WITH ProductRank AS
    (
     SELECT 
    p.product_id,
    MONTH(o.order_date) AS order_month,
    SUM(o.quantity_ordered) AS total_quantity,
    p.unit_price,
    SUM(o.quantity_ordered * p.unit_price) total_sales
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY 
    p.product_id,
    MONTH(o.order_date),
    p.unit_price
    )
    SELECT *,
    RANK() OVER( ORDER BY total_sales desc  ) global_rank
    FROM ProductRank
    LIMIT 10;
    
-- 9. Determine seasonal demand trends over months.
    
    WITH DemandTrend AS
    (
     SELECT 
    p.product_id,
    MONTH(o.order_date) AS order_month,
    SUM(o.quantity_ordered) AS total_quantity
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY 
    p.product_id,
    MONTH(o.order_date)
    )
    SELECT *,
    RANK() OVER( PARTITION BY order_month ORDER BY total_quantity desc  ) monthly_product_rank
    FROM DemandTrend;