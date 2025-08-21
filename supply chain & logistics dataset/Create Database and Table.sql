-- CREATE DATABASE
CREATE DATABASE supply_chain;
USE supply_chain;

-- CREATE TABLES
-- Suppliers Table
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_name VARCHAR(100),
    country VARCHAR(50),
    lead_time_days INT
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    supplier_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    reorder_level INT,
    FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id)
);

-- Inventory Table
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    warehouse VARCHAR(50),
    quantity_in_stock INT,
    last_restock_date date,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    order_date DATE,
    quantity_ordered INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Shipments Table
CREATE TABLE shipments
(
shipment_id INT PRIMARY KEY,
order_id INT,
supplier_id INT,
shipment_date date,
delivery_date date,
status varchar(50),
FOREIGN KEY(order_id) REFERENCES orders(order_id),
FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id)
);

-- CONVERT ALL DATE FIELDS TO DATE FORMAT
UPDATE shipments
SET shipment_date = STR_TO_DATE(last_restock_date, '%m/%d/%Y');

UPDATE shipments
SET delivery_date = STR_TO_DATE(last_restock_date, '%m/%d/%Y');

ALTER TABLE shipments 
MODIFY COLUMN shipment_date DATE,
MODIFY COLUMN delivery_date DATE;


