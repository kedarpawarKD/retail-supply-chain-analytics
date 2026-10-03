/*
===============================================================================
View Name : gold.vw_dashboard
Purpose   : Business-ready reporting view for Excel & Power BI dashboards
===============================================================================
*/

IF OBJECT_ID ('gold.vw_dashboard', 'V') IS NOT NULL
	DROP VIEW gold.vw_dashboard;
GO

CREATE OR ALTER VIEW gold.vw_dashboard
AS

SELECT

    /*===================================================
        ORDER INFORMATION
    ===================================================*/

    f.order_item_id,
    f.order_id,

    d1.calendar_date AS order_date,
    d1.day_name AS order_day,
    d1.month_name AS order_month,
    d1.month_number,
    d1.quarter_number,
    d1.year_number,

    d2.calendar_date AS shipping_date,

    f.payment_type,
    f.shipping_mode,
    f.order_status,
    f.delivery_status,

    /*===================================================
        CUSTOMER
    =====================================================*/

    c.customer_id,
    c.full_name,
    c.segment,

    c.city AS customer_city,

    CASE c.state
        WHEN 'AL' THEN 'Alabama'
        WHEN 'AR' THEN 'Arkansas'
        WHEN 'AZ' THEN 'Arizona'
        WHEN 'CA' THEN 'California'
        WHEN 'CO' THEN 'Colorado'
        WHEN 'CT' THEN 'Connecticut'
        WHEN 'DC' THEN 'District of Columbia'
        WHEN 'DE' THEN 'Delaware'
        WHEN 'FL' THEN 'Florida'
        WHEN 'GA' THEN 'Georgia'
        WHEN 'HI' THEN 'Hawaii'
        WHEN 'IA' THEN 'Iowa'
        WHEN 'ID' THEN 'Idaho'
        WHEN 'IL' THEN 'Illinois'
        WHEN 'IN' THEN 'Indiana'
        WHEN 'KS' THEN 'Kansas'
        WHEN 'KY' THEN 'Kentucky'
        WHEN 'LA' THEN 'Louisiana'
        WHEN 'MA' THEN 'Massachusetts'
        WHEN 'MD' THEN 'Maryland'
        WHEN 'MI' THEN 'Michigan'
        WHEN 'MN' THEN 'Minnesota'
        WHEN 'MO' THEN 'Missouri'
        WHEN 'MT' THEN 'Montana'
        WHEN 'NC' THEN 'North Carolina'
        WHEN 'ND' THEN 'North Dakota'
        WHEN 'NJ' THEN 'New Jersey'
        WHEN 'NM' THEN 'New Mexico'
        WHEN 'NV' THEN 'Nevada'
        WHEN 'NY' THEN 'New York'
        WHEN 'OH' THEN 'Ohio'
        WHEN 'OK' THEN 'Oklahoma'
        WHEN 'OR' THEN 'Oregon'
        WHEN 'PA' THEN 'Pennsylvania'
        WHEN 'PR' THEN 'Puerto Rico'
        WHEN 'RI' THEN 'Rhode Island'
        WHEN 'SC' THEN 'South Carolina'
        WHEN 'TN' THEN 'Tennessee'
        WHEN 'TX' THEN 'Texas'
        WHEN 'UT' THEN 'Utah'
        WHEN 'VA' THEN 'Virginia'
        WHEN 'WA' THEN 'Washington'
        WHEN 'WI' THEN 'Wisconsin'
        WHEN 'WV' THEN 'West Virginia'
        ELSE c.state
    END AS customer_state,

    c.country AS customer_country,
    c.postal_code AS customer_postal_code,

    /*===================================================
        PRODUCT
    =====================================================*/

    p.product_id,
    p.product_name,
    p.category_name,
    p.department_name,
    p.status AS product_status,

    /*===================================================
        ORDER LOCATION
    =====================================================*/

    l.market,
    l.region,
    l.country AS order_country,
    l.state AS order_state,
    l.city AS order_city,
    l.postal_code AS order_postal_code,

    /*===================================================
        SALES METRICS
    =====================================================*/

    f.quantity,
    f.sales,
    f.list_price,
    f.product_cost,
    f.discount_amount,
    f.discount_percent,
    f.net_sales,
    f.profit,
    f.profit_margin,

    /*===================================================
        SHIPPING METRICS
    =====================================================*/

    f.actual_shipping_days,
    f.scheduled_shipping_days,
    f.shipping_delay_days,
    f.late_delivery_risk

FROM gold.fact_order_items f

INNER JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key

INNER JOIN gold.dim_products p
    ON f.product_key = p.product_key

INNER JOIN gold.dim_order_locations l
    ON f.location_key = l.location_key

INNER JOIN gold.dim_date d1
    ON f.order_date_key = d1.date_key

INNER JOIN gold.dim_date d2
    ON f.shipping_date_key = d2.date_key;
GO
