-- 10. Logistics & Supply Chain Efficiency

-- Calculate warehouse utilization (total stock per warehouse).
select *  from inventory;

select 
warehouse_id,
month(last_restock_date) restock_month, 
sum(quantity_in_stock) total_stock
from inventory
group by warehouse_id, month(last_restock_date)
order by warehouse_id, restock_month;

-- 11. Find the best performing warehouse based on stock availability and order fulfillment speed.
-- Based on stock availability
select 
warehouse_id,
month(last_restock_date) restock_month, 
sum(quantity_in_stock) total_stock
from inventory
group by warehouse_id, month(last_restock_date)
order by warehouse_id, restock_month;

-- Based on order fulfillment speed

select 
i.warehouse_id,
month(i.last_restock_date) restock_month, 
avg(datediff(s.delivery_date, o.order_date)) avg_lead_time
from shipments s 
join orders o
on s.order_id = o.order_id
join inventory i
on o.product_id = i.product_id
where status in ('delivered', 'late')
group by i.warehouse_id, month(i.last_restock_date)
order by i.warehouse_id, restock_month;

-- ranking
WITH Stock AS
(
select 
warehouse_id,
month(last_restock_date) restock_month, 
sum(quantity_in_stock) total_stock
from inventory
group by warehouse_id, month(last_restock_date)

), FufilmentSpeed AS
(
select 
i.warehouse_id,
avg(datediff(s.delivery_date, o.order_date)) avg_lead_time
from shipments s 
join orders o
on s.order_id = o.order_id
join inventory i
on o.product_id = i.product_id
where status in ('delivered', 'late')
group by i.warehouse_id
)
select s.warehouse_id, s.restock_month, s.total_stock, avg_lead_time,
RANK() OVER(partition by s.restock_month ORDER BY s.total_stock DESC, fs.avg_lead_time ASC) performance_rank
from Stock s
join FufilmentSpeed fs
on s.warehouse_id = fs.warehouse_id
order by performance_rank;