
/*
===============================================================================
DDL Script: Create Bronze Table
===============================================================================
Script Purpose:
    This script creates table in the 'bronze' schema, dropping existing table 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Table
===============================================================================
*/

IF OBJECT_ID('bronze.order_fulfillment_raw', 'U') IS NOT NULL
    DROP TABLE bronze.order_fulfillment_raw;
GO

CREATE TABLE bronze.order_fulfillment_raw
(
   type NVARCHAR(50),
   days_for_shipping_real INT,
   days_for_shipment_scheduled INT,
   benefit_per_order DECIMAL(18,4),
   sales_per_customer DECIMAL(18,4),
   delivery_status NVARCHAR(50),
   late_delivery_risk INT,
   category_id INT,
   category_name NVARCHAR(50),
   customer_city NVARCHAR(50),
   customer_country NVARCHAR(50),
   customer_email NVARCHAR(255),
   customer_first_name NVARCHAR(50),
   customer_id INT,
   customer_last_name NVARCHAR(50),
   customer_password NVARCHAR(100),
   customer_segment NVARCHAR(50),
   customer_state NVARCHAR(50),
   customer_street NVARCHAR(255),
   customer_zipcode NVARCHAR(50),
   department_id INT,
   department_name NVARCHAR(50),
   latitude DECIMAL(18,8),
   longitude DECIMAL(18,8),
   market NVARCHAR(50),
   order_city NVARCHAR(100),
   order_country NVARCHAR(100),
   order_customer_id INT,
   order_date NVARCHAR(50),
   order_id INT,
   order_item_cardprod_id INT,
   order_item_discount DECIMAL(18,4),
   order_item_discount_rate DECIMAL(18,4),
   order_item_id INT,
   order_item_product_price DECIMAL(18,4),
   order_item_profit_ratio DECIMAL(18,4),
   order_item_quantity SMALLINT,
   sales DECIMAL(18,4),
   order_item_total DECIMAL(18,4),
   order_profit_per_order DECIMAL(18,4),
   order_region NVARCHAR(100),
   order_state NVARCHAR(100),
   order_status NVARCHAR(50),
   order_zipcode NVARCHAR(50),
   product_card_id INT,
   product_category_id INT,
   product_description NVARCHAR(500),
   product_image NVARCHAR(255),
   product_name NVARCHAR(255),
   product_price DECIMAL(18,4),
   product_status INT,
   shipping_date NVARCHAR(50),
   shipping_mode NVARCHAR(50)
);
GO


