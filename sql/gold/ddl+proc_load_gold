/*
===============================================================================
DDL Script: Create Gold Dimension - Customers
===============================================================================
*/
IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
	DROP TABLE gold.dim_customers;
GO

CREATE TABLE gold.dim_customers
(
	customer_key INT IDENTITY(1,1) PRIMARY KEY,
	customer_id INT NOT NULL,
	full_name NVARCHAR(101),
	segment NVARCHAR(50),
	city NVARCHAR(50),
	state NVARCHAR(100),
	country NVARCHAR(100),
	postal_code NVARCHAR(50),
	latitude DECIMAL(18,4),
	longitude DECIMAL(18,4)
);
GO

/*
===============================================================================
Load: gold.dim_customers
===============================================================================
*/

DECLARE @start_time DATETIME, @end_time DATETIME, @rows_loaded INT;

SET @start_time = GETDATE();

PRINT '>> Truncating Table : gold.dim_customers';

TRUNCATE TABLE gold.dim_customers;

PRINT '>> Inserting Data Into : gold.dim_customers';

INSERT INTO gold.dim_customers
(
	customer_id,
	full_name,
	segment,
	city,
	state,
	country,
	postal_code,
	latitude,
	longitude
)

SELECT
	
	customer_id,
	CONCAT(COALESCE(customer_first_name, ''),' ',COALESCE(customer_last_name, '')) AS full_name,
	customer_segment,
	customer_city,
	customer_state,
	customer_country,
	customer_zipcode,
	latitude,
	longitude

FROM silver.customers;

SET @rows_loaded = @@ROWCOUNT;

SET @end_time = GETDATE();

PRINT '>> Customers Loaded Successfully';
PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond,@start_time, @end_time) as NVARCHAR(20)) + ' milliseconds'

PRINT '------------------------------------------------------------------------';

/*
===============================================================================
DDL Script: Create Gold Dimension - products
===============================================================================
*/

IF OBJECT_ID ('gold.dim_products', 'U') IS NOT NULL
	DROP TABLE gold.dim_products;
GO

CREATE TABLE gold.dim_products
(
	product_key INT IDENTITY (1,1) PRIMARY KEY,
	product_id INT NOT NULL,
	product_name NVARCHAR(255),
	category_name NVARCHAR(100),
	department_name NVARCHAR(100),
	list_price DECIMAL(18,4),
	status NVARCHAR(20)
);
GO

DECLARE @start_time DATETIME, @end_time DATETIME, @rows_loaded INT;
SET @start_time = GETDATE();

PRINT '>> Truncating Table : gold.dim_products'

TRUNCATE TABLE gold.dim_products;

PRINT '>> Inserting Data Into : gold.dim_products'

INSERT INTO gold.dim_products
(
	product_id,
	product_name,
	category_name,
	department_name,
	list_price,
	status
)

SELECT
	
	p.product_card_id,
	p.product_name,
	c.category_name,
	d.department_name,
	p.product_price,
	CASE
		WHEN p.product_status = 0 THEN 'Inactive'
		WHEN P.product_status = 1 THEN  'Active'
		ELSE 'Unknown'
	END AS product_status
FROM silver.products p
LEFT JOIN silver.categories c
ON c.category_id = p.category_id
LEFT JOIN  silver.departments d
ON d.department_id = c.department_id;

SET @rows_loaded = @@ROWCOUNT;

SET @end_time = GETDATE();

PRINT '>> Products Loaded Successfully';
PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR(20)) + ' millisconds';

PRINT '------------------------------------------------------------------------';

/*
===============================================================================
DDL Script: Create Gold Dimension - Locations
===============================================================================
*/

IF OBJECT_ID('gold.dim_order_locations', 'U') IS NOT NULL
	DROP TABLE gold.dim_order_locations
GO

CREATE TABLE gold.dim_order_locations
(	
	location_key INT IDENTITY(1,1) PRIMARY KEY,
	market NVARCHAR(100),
	region NVARCHAR(100),
	country NVARCHAR(100),
	state NVARCHAR(100),
	city NVARCHAR(100),
	postal_code NVARCHAR(50)
);
GO

/*
===============================================================================
Load: gold.dim_order_locations
===============================================================================
*/

DECLARE @start_time DATETIME, @end_time DATETIME, @rows_loaded INT;

SET @start_time = GETDATE();

PRINT '>> Truncating Table : gold.dim_order_locations';

TRUNCATE TABLE gold.dim_order_locations;

PRINT '>> Inserting Data Into : gold.dim_order_locations';

INSERT INTO gold.dim_order_locations
(

	market,
	region,
	country,
	state,
	city,
	postal_code
)

SELECT DISTINCT
	market,

    order_region AS region,

    order_country AS country,

    order_state AS state,

    order_city AS city,

    order_zipcode AS zipcode

FROM silver.orders

SET @rows_loaded = @@ROWCOUNT;

SET @end_time = GETDATE();

PRINT '>> Order Locations Loaded Successfully';
PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR(20)) + ' milliseconds';

PRINT '------------------------------------------------------------------------';

/*
===============================================================================
DDL Script: Create Gold Dimension - Date
===============================================================================
*/

IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL
	DROP TABLE gold.dim_date;
GO

CREATE TABLE gold.dim_date
(
	date_key INT PRIMARY KEY,
	calendar_date DATE NOT NULL,
	day_number TINYINT,
	day_name NVARCHAR(20),
	week_number TINYINT,
	month_number TINYINT,
	month_name NVARCHAR(20),
	quarter_number TINYINT,
	year_number SMALLINT,
	is_weekend BIT
);
GO

/*
===============================================================================
Load: gold.dim_date
===============================================================================
*/

DECLARE
	@start_time DATETIME,
	@end_time DATETIME,
	@rows_loaded INT,

	@start_date DATE,
	@end_date DATE

SET @start_time = GETDATE();

PRINT '>> Truncating Table : gold.dim_date';

TRUNCATE TABLE gold.dim_date;

PRINT '>> Determining Date Range';

SELECT
	@start_date = MIN(order_date),
	@end_date = MAX(shipping_date)
FROM silver.orders;

PRINT '>> Inserting Data Into : gold.dim_date';

; WITH date_series AS
(
	SELECT @start_date AS calendar_date

	UNION ALL

	SELECT DATEADD(DAY, 1, calendar_date)
	FROM date_series
	WHERE calendar_date < @end_date
)

INSERT INTO gold.dim_date
(
	date_key,
	calendar_date,
	day_number,
	day_name,
	week_number,
	month_number,
	month_name,
	quarter_number,
	year_number,
	is_weekend
)

SELECT
	
	CAST(CONVERT(CHAR(8), calendar_date, 112) AS INT),

	calendar_date,

	DAY(calendar_date),

	DATENAME(WEEKDAY, calendar_date),

	DATEPART(WEEK, calendar_date),

	MONTH(calendar_date),

	DATENAME(MONTH, calendar_date),

	DATEPART(QUARTER, calendar_date),

	YEAR(calendar_date),

	CASE
		WHEN DATENAME(WEEKDAY, calendar_date) IN ('saturday', 'sunday')
		THEN 1
		ELSE 0
	END

FROM date_series
OPTION (MAXRECURSION 0);

SET @rows_loaded = @@ROWCOUNT;

SET @end_time = GETDATE();

PRINT '>> Date Dimension Loaded Successfully';
PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
PRINT '>> Load Duration : ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR(20))
	+ ' milliseconds';
PRINT '------------------------------------------------------------------------'
/*
===============================================================================
DDL Script: Create Gold Fact Table - Order Items
===============================================================================
*/

IF OBJECT_ID('gold.fact_order_items', 'U') IS NOT NULL
	DROP TABLE gold.fact_order_items;
GO

CREATE TABLE gold.fact_order_items
(
	order_item_key INT IDENTITY(1,1) PRIMARY KEY,
	order_item_id INT NOT NULL,
	order_id INT NOT NULL,
	customer_key INT NOT NULL,
	product_key INT NOT NUll,
	location_key INT NOT NULL,
	order_date_key INT NOT NULL,
	shipping_date_key INT NOT NULL,
	payment_type NVARCHAR(50),
	shipping_mode NVARCHAR(50),
	order_status NVARCHAR(50),
	delivery_status NVARCHAR(50),
	quantity INT,
	sales DECIMAL(18,4),
	list_price DECIMAL(18,4),
	product_cost DECIMAL(18,4),
	discount_amount DECIMAL(18,4),
	discount_percent DECIMAL(18,4),
	net_sales DECIMAL(18,4),
	profit DECIMAL(18,4),
	profit_margin DECIMAL(18,4),
	actual_shipping_days INT,
	scheduled_shipping_days INT,
	shipping_delay_days INT,
	late_delivery_risk BIT
);
GO

/*
===============================================================================
Load: gold.fact_order_items
===============================================================================
*/
DECLARE 
	@start_time DATETIME,
	@end_time DATETIME,
	@rows_loaded INT;

SET @start_time = GETDATE();

PRINT '>> Truncating Table : gold.fact_order_items';

TRUNCATE TABLE gold.fact_order_items;

PRINT '>> Inserting Data Into : gold.fact_order_items';

INSERT INTO gold.fact_order_items
(
	order_item_id,
	order_id,

	customer_key,
	product_key,
	location_key,

	order_date_key,
	shipping_date_key,

	payment_type,
	shipping_mode,

	order_status,
	delivery_status,

	quantity,

	sales,

	list_price,
	product_cost,

	discount_amount,
	discount_percent,

	net_sales,

	profit,

	profit_margin,

	actual_shipping_days,
	scheduled_shipping_days,
	shipping_delay_days,

	late_delivery_risk
)

SELECT
	
	oi.order_item_id,
	oi.order_id,
	dc.customer_key,
	dp.product_key,
	dl.location_key,
	dd_order.date_key,
	dd_ship.date_key,
	o.payment_type,
	o.shipping_mode,
	o.order_status,
	o.delivery_status,
	oi.quantity,
	oi.sales,
	oi.order_item_product_price,
	oi.order_item_total - oi.order_profit_per_order AS product_cost,
	oi.order_item_discount,
	oi.order_item_discount_rate,
	oi.order_item_total,
	oi.order_profit_per_order,
	oi.order_item_profit_ratio,
	o.real_shipping_days,
	o.scheduled_shipping_days,
	o.real_shipping_days - o.scheduled_shipping_days,
	o.late_delivery_risk

FROM silver.order_items oi
INNER JOIN silver.orders o
	ON oi.order_id = o.order_id
INNER JOIN gold.dim_customers dc
	ON o.customer_id = dc.customer_id
INNER JOIN gold.dim_products dp
	ON oi.product_card_id = dp.product_id
INNER JOIN gold.dim_order_locations dl
	ON o.market = dl.market
	AND o.order_region = dl.region
	AND o.order_country = dl.country
	AND o.order_state = dl.state
	AND o.order_city = dl.city
	AND ISNULL(o.order_zipcode, '') = ISNULL(dl.postal_code, '')
INNER JOIN gold.dim_date dd_order
	ON CAST(CONVERT(CHAR(8), o.order_date, 112) AS INT) = dd_order.date_key
INNER JOIN gold.dim_date dd_ship
	ON CAST(CONVERT(CHAR(8), o.shipping_date, 112) AS INT) = dd_ship.date_key;

SET @rows_loaded = @@ROWCOUNT;

SET @end_time = GETDATE();

PRINT '>> Fact Order Items Loaded Successfuly';
PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
PRINT '>> Load Duration : '
		+ CAST(DATEDIFF(MILLISECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' milliseconds';





