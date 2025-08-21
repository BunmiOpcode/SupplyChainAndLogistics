-- 5. Find the average delivery time per product and supplier.
-- average delivery time per product

select 
o.product_id, 
s.status, 
month(s.delivery_date) delivery_month, 
count(s.status) delivery_time,
AVG(DATEDIFF(s.delivery_date, o.order_date)) AS avg_delivery_time
from orders o
join shipments s
on o.order_id = s.order_id
where status ='delivered'
group by o.product_id, delivery_month
order by product_id, delivery_month;


-- average delivery time per supplier

select s.supplier_id, 
month(s.delivery_date) delivery_month, 
count(month(s.delivery_date)) delivery_times,
avg(datediff(s.delivery_date, o.order_date)) avg_delivery_time
from shipments s
join orders o
on o.order_id = s.order_id
where s.status = 'delivered'
OR s.status = 'late'
group by s.supplier_id,
month(s.delivery_date)
order by supplier_id, delivery_month;


-- Identify late deliveries and their percentage per supplier.

WITH LateDeliveryCount AS
(
select supplier_id, 
month(delivery_date) delivery_month,  
count(*) late_deliveries
from shipments
where status = 'late'
group by supplier_id, 
month(delivery_date)
), 
TotalDeliveryCount AS
(
select supplier_id, 
month(delivery_date) delivery_month, 
count(*) total_deliveries
from shipments
where status IN ('delivered', 'late')
group by supplier_id, 
month(delivery_date)
)
select l.supplier_id, 
l.delivery_month, 
(l.late_deliveries/ t.total_deliveries) * 100  percentage_late_delivery 
from LateDeliveryCount l 
join TotalDeliveryCount t
on 
l.supplier_id = t.supplier_id
and
l.delivery_month = t.delivery_month
order by 
l.supplier_id, l.delivery_month;