/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates all tables in the 'silver' schema.

Notes:
    - Existing tables are dropped before creation.
    - Primary Keys are defined.
    - Foreign Keys will be added after successful ETL validation.
===============================================================================
*/

----------------------------------------------------------------
-- Create Schema
----------------------------------------------------------------

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'silver'
)
BEGIN
    EXEC ('CREATE SCHEMA silver');
END
GO

----------------------------------------------------------------
-- Drop Existing Tables
----------------------------------------------------------------

DROP TABLE IF EXISTS silver.order_items;
DROP TABLE IF EXISTS silver.orders;
DROP TABLE IF EXISTS silver.products;
DROP TABLE IF EXISTS silver.categories;
DROP TABLE IF EXISTS silver.departments;
DROP TABLE IF EXISTS silver.customers;
GO

----------------------------------------------------------------
-- Customers
----------------------------------------------------------------

CREATE TABLE silver.customers
(
    customer_id INT PRIMARY KEY,
    customer_first_name NVARCHAR(50),
    customer_last_name NVARCHAR(50),
    customer_email NVARCHAR(100),
    customer_segment NVARCHAR(50),
    customer_city NVARCHAR(100),
    customer_state NVARCHAR(100),
    customer_country NVARCHAR(100),
    customer_street NVARCHAR(255),
    customer_zipcode NVARCHAR(50),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7)
);
GO

----------------------------------------------------------------
-- Departments
----------------------------------------------------------------

CREATE TABLE silver.departments
(
    department_id INT PRIMARY KEY,
    department_name NVARCHAR(100)
);
GO

----------------------------------------------------------------
-- Categories
----------------------------------------------------------------

CREATE TABLE silver.categories
(
    category_id INT PRIMARY KEY,
    category_name NVARCHAR(100),
    department_id INT
);
GO

----------------------------------------------------------------
-- Products
----------------------------------------------------------------

CREATE TABLE silver.products
(
    product_card_id INT PRIMARY KEY,
    product_name NVARCHAR(255),
    product_price DECIMAL(18,4),
    product_status INT,
    product_image NVARCHAR(255),
    product_description NVARCHAR(500),
    category_id INT
);
GO

----------------------------------------------------------------
-- Orders
----------------------------------------------------------------

CREATE TABLE silver.orders
(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME2,
    shipping_date DATETIME2,
    payment_type NVARCHAR(50),
    order_status NVARCHAR(50),
    delivery_status NVARCHAR(50),
    shipping_mode NVARCHAR(50),
    market NVARCHAR(100),
    order_city NVARCHAR(100),
    order_state NVARCHAR(100),
    order_country NVARCHAR(100),
    order_region NVARCHAR(100),
    order_zipcode NVARCHAR(50),
    real_shipping_days INT,
    scheduled_shipping_days INT,
    late_delivery_risk BIT
);
GO

----------------------------------------------------------------
-- Order Items
----------------------------------------------------------------

CREATE TABLE silver.order_items
(
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_card_id INT,
    quantity INT,
    sales DECIMAL(18,4),
    sales_per_customer DECIMAL(18,4),
    order_item_product_price DECIMAL(18,4),
    order_item_discount DECIMAL(18,4),
    order_item_discount_rate DECIMAL(18,4),
    order_item_total DECIMAL(18,4),
    order_profit_per_order DECIMAL(18,4),
    benefit_per_order DECIMAL(18,4),
    order_item_profit_ratio DECIMAL(18,4)
);
GO
