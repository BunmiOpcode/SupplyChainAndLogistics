
-- INVENTORY OPTIMIZATION
-- 1. Find products that are below their reorder level.

WITH BelowReorder_level AS
(
SELECT pro.product_id, pro.category, pro.product_name, pro.reorder_level, inv.quantity_in_stock FROM products pro 
join inventory inv
on pro.product_id = inv.product_id
where inv.quantity_in_stock <= pro.reorder_level
order by category
)
SELECT * FROM BelowReorder_level;

