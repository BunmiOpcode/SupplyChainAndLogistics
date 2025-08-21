-- Supplier Performance

-- 4. Calculate average lead time per supplier and Rank suppliers by on-time delivery performance..

select * from shipments where status = 'delivered' ;

WITH SupplierLeadTime AS 
(
SELECT
p.supplier_id,
avg(datediff(s.delivery_date, o.order_date) )AS avg_lead_time
FROM products p 
JOIN shipments s 
	ON p.supplier_id = s.supplier_id
JOIN orders o
    ON s.order_id = o.order_id
    WHERE s.status = 'delivered'
    OR s.status = 'late'
GROUP BY
p.supplier_id
ORDER BY 
p.supplier_id
)
SELECT 
    supplier_id,
    avg_lead_time,
    RANK() OVER (ORDER BY avg_lead_time ASC) AS global_rank
FROM SupplierLeadTime
ORDER BY global_rank;

-- delivery times per product
select * from shipments where status ='delivered';

select 
o.product_id, 
s.status, 
month(s.delivery_date) delivery_month, 
count(s.status) delivery_time
from orders o
join shipments s
on o.order_id = s.order_id
where status ='delivered'
group by o.product_id, delivery_month
order by product_id, delivery_month;