/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME, @start_time DATETIME, @end_time DATETIME, @rows_loaded INT;
	BEGIN TRY

		SET @batch_start_time = GETDATE();
		PRINT '>> ==============================================================';
		PRINT '   Loading Silver Layer';
		PRINT '>> ==============================================================';
		PRINT '-----------------------------------------'
		PRINT '-- Loading silver.customers'
		PRINT '-----------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table : Silver.Customers';
		TRUNCATE TABLE silver.customers;
		PRINT '>> Inserting Data Into : Silver.Customers';

		;WITH customer_dedup AS
		(
			SELECT
				*,
				ROW_NUMBER() OVER
				(
					PARTITION BY customer_id
					ORDER BY customer_id
				) AS rn
			FROM bronze.order_fulfillment_raw
			WHERE customer_id IS NOT NULL
		)

		INSERT INTO silver.customers
		(
			customer_id,
			customer_first_name,
			customer_last_name,
			customer_email,
			customer_segment,
			customer_city,
			customer_state,
			customer_country,
			customer_street,
			customer_zipcode,
			latitude,
			longitude
		)

		SELECT
	
			customer_id,
	
			NULLIF(TRIM(customer_first_name), '') AS customer_first_name,
	
			NULLIF(TRIM(customer_last_name), '') AS customer_last_name,

			LOWER(NULLIF(TRIM(customer_email),'')) AS customer_email,

			-- Standardize customer segment values.
			CASE
				WHEN TRIM(customer_segment) IN
					('Consumer', 'Corporate', 'Home Office')
				THEN TRIM(customer_segment)
				ELSE 'Unknown'
			END AS customer_segment,

			NULLIF(TRIM(customer_city), '') AS customer_city,

			NULLIF(TRIM(customer_state), '') AS customer_state,

			NULLIF(TRIM(customer_country), '') AS customer_country,

			NULLIF(TRIM(customer_street), '') AS customer_street,

			NULLIF(TRIM(customer_zipcode), '') AS customer_zipcode,

			-- Validate geographical coordinates.
			CASE
				WHEN latitude BETWEEN -90 AND 90
				THEN latitude
				ELSE NULL
			END AS latitude,

			CASE
				WHEN longitude BETWEEN -180 AND 180
				THEN longitude
				ELSE NULL
			END AS longitude
		FROM customer_dedup
		WHERE rn = 1;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();

		PRINT '>> Customers Loaded Successfuly';
		PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ==============================================================';

		PRINT '-----------------------------------------'
		PRINT '-- Loading silver.categories'
		PRINT '-----------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table : silver.categories';
		TRUNCATE TABLE silver.categories;
		PRINT '>> Inserting Data Into : silver.categories';

		; WITH category_dedup AS
		(
			SELECT
				*,
				ROW_NUMBER() OVER
				(
					PARTITION BY category_id
					ORDER BY category_id
				) AS rn
			FROM bronze.order_fulfillment_raw
			WHERE category_id IS NOT NULL
			AND department_id IS NOT NULL
		)


		INSERT INTO silver.categories
		(
			category_id,
			category_name,
			department_id
		)

		SELECT
	
			category_id,

			NULLIF(TRIM(category_name), '') AS category_name,

			department_id

		FROM category_dedup
		WHERE rn = 1;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> Categories Loaded Successfuly'
		PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ==============================================================';

		PRINT '-----------------------------------------'
		PRINT '-- Loading silver.departments'
		PRINT '-----------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Tuncating Table : silver.departments';
		TRUNCATE TABLE silver.departments;
		PRINT '>> Inserting Data Into : silver.departments';


		INSERT INTO silver.departments
		(
			department_id,
			department_name
		)

		SELECT DISTINCT

			department_id,

			NULLIF(TRIM(department_name), '') AS department_name

		FROM bronze.order_fulfillment_raw

		WHERE department_id IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();

		PRINT '>> Departments Loaded Successfuly';
		PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ==============================================================';

		PRINT '-----------------------------------------'
		PRINT '-- Loading silver.products'
		PRINT '-----------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table : silver.products';
		TRUNCATE TABLE silver.products;
		PRINT '>> Inserting Data Into : silver.products'


		INSERT INTO silver.products
		(
			product_card_id,
			product_name,
			product_price,
			product_status,
			product_image,
			product_description,
			category_id
		)

		SELECT DISTINCT
	
			product_card_id,

			NULLIF(TRIM(product_name), '') AS product_name,

			CASE
				WHEN product_price >= 0
				THEN product_price
				ELSE NUll
			END AS product_price,

			CASE
				WHEN product_status IN (0,1)
				THEN product_status
				ELSE NULL
			END AS product_status,

			NULLIF(TRIM(product_image), '') AS product_image,

			NULLIF(TRIM(product_description), '') AS product_description,

			category_id

		FROM bronze.order_fulfillment_raw

		WHERE product_card_id IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();

		PRINT '>> Products Loaded Successfuly';
		PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ==============================================================';

		PRINT '-----------------------------------------'
		PRINT '-- Loading silver.orders'
		PRINT '-----------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table : silver.orders';
		TRUNCATE TABLE silver.orders;
		PRINT '>> Inserting Data Into : silver.orders';


		; WITH orders_dedup AS
		(
			SELECT	
				*,
				ROW_NUMBER() OVER
				(
					PARTITION BY order_id
					ORDER BY order_date DESC
				) AS rn
			FROM bronze.order_fulfillment_raw
			WHERE order_id IS NOT NULL
		)

		INSERT INTO silver.orders
		(
			order_id,
			customer_id,
			order_date,
			shipping_date,
			payment_type,
			order_status,
			delivery_status,
			shipping_mode,
			market,
			order_city,
			order_state,
			order_country,
			order_region,
			order_zipcode,
			real_shipping_days,
			scheduled_shipping_days,
			late_delivery_risk
		)

		SELECT
	
			order_id,

			customer_id,

			TRY_CONVERT(DATETIME2, order_date)  AS order_date,

			TRY_CONVERT(DATETIME2, shipping_date) AS shipping_date,

			UPPER(NULLIF(TRIM(type), '')) AS payment_type,

			UPPER(NULLIF(TRIM(order_status), '')) AS order_status,

			NULLIF(TRIM(delivery_status), '') AS delivery_status,

			NULLIF(TRIM(shipping_mode), '') AS shipping_mode,

			NULLIF(TRIM(market), '') AS market,

			NULLIF(TRIM(order_city), '') AS order_city,

			NULLIF(TRIM(order_state), '') AS order_state,

			NULLIF(TRIM(order_country), '') AS order_country,

			NULLIF(TRIM(order_region), '') AS order_region,

			NULLIF(TRIM(order_zipcode), '') AS order_zipcode,

			CASE
				WHEN  days_for_shipping_real >= 0
				THEN days_for_shipping_real
				ELSE NULL
			END AS real_shipping_days,

			CASE
				WHEN days_for_shipment_scheduled >= 0
				THEN days_for_shipment_scheduled
				ELSE NULL
			END AS scheduled_shipping_days,

			CASE
				WHEN late_delivery_risk IN (0,1)
				THEN late_delivery_risk
				ELSE NULL
			END AS late_delivery_risk

		FROM orders_dedup
		WHERE rn = 1

		SET @rows_loaded = @@ROWCOUNT;
		SET @end_time = GETDATE();

		PRINT '>> Orders Loaded Successfuly';
		PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ==============================================================';

		PRINT '-----------------------------------------'
		PRINT '-- Loading silver.order_items'
		PRINT '-----------------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table : silver.order_items';
		TRUNCATE TABLE silver.order_items;

		PRINT '>> Inserting Data Into : silver.order_items';

		INSERT INTO silver.order_items
		(
			order_item_id,
			order_id,
			product_card_id,
			quantity,
			sales,
			sales_per_customer,
			order_item_product_price,
			order_item_discount,
			order_item_discount_rate,
			order_item_total,
			order_profit_per_order,
			benefit_per_order,
			order_item_profit_ratio
		)

		SELECT
	
			order_item_id,

			order_id,

			product_card_id,

			CASE
				WHEN order_item_quantity > 0
				THEN order_item_quantity
				ELSE NULL
			END AS quantity,

			CASE
				WHEN sales >= 0
				THEN sales
				ELSE NULL
			END AS sales,

			CASE
				WHEN sales_per_customer >= 0
				THEN sales_per_customer
				ELSE NULL
			END AS sales_per_customer,

			CASE
				WHEN order_item_product_price >= 0
				THEN order_item_product_price
				ELSE NULL
			END AS order_item_product_price,

			CASE
				WHEN order_item_discount >= 0
				THEN order_item_discount
				ELSE NULL
			END AS order_item_discount,

			CASE
				WHEN order_item_discount_rate BETWEEN 0 AND 1
				THEN order_item_discount_rate
				ELSE NULL
			END AS order_item_discount_rate,

			CASE
				WHEN order_item_total >= 0
				THEN order_item_total
				ELSE NULL
			END AS order_item_total,

			order_profit_per_order,

			benefit_per_order,

			CASE
				WHEN order_item_profit_ratio BETWEEN -1 AND 1
				THEN order_item_profit_ratio
				ELSE NULL
			END AS order_item_profit_ratio

		FROM bronze.order_fulfillment_raw

		WHERE order_item_id IS NOT NULL;

		SET @rows_loaded = @@ROWCOUNT
		SET @end_time = GETDATE();
		PRINT '>> Orders Items Loaded Successfuly';
		PRINT '>> Rows Loaded : ' + CAST(@rows_loaded AS NVARCHAR(20));
		PRINT '>> Load Duration : ' + CAST(DATEDIFF(millisecond, @start_time, @end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ==============================================================';


		SET @batch_end_time = GETDATE();
		PRINT '>> ==============================================================';
		PRINT '-- Loading Silver Layer is completed';
		PRINT '   Total Load Duration: ' + CAST(DATEDIFF(millisecond, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' milliseconds';
		PRINT '>> ==============================================================';

	END TRY
	BEGIN CATCH
		PRINT '>> =============================================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message : ' + ERROR_MESSAGE();
		PRINT 'Error Message : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '>> ==============================================================';
	END CATCH
END;

