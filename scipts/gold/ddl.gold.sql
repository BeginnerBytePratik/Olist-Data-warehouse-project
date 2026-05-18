/*
================================================================================================
DDL Script: Create Gold Layer Views
================================================================================================
Script Purpose:
    This script creates the Gold layer views for the Olist Data Warehouse project.

    The Gold layer represents the final business-ready Star Schema model
    used for analytics, reporting, and dashboarding.

Business Model:
    - Dimension Tables:
        • dim_customers
        • dim_products
        • dim_sellers
        • dim_dates

    - Fact Table:
        • fact_orders

Data Source:
    All Gold views are created from the cleaned Silver layer tables.

Usage:
    Run this script after the Silver layer load process is completed.

Example:
    EXEC silver.load_silver;
================================================================================================
*/

-- ================================================================================================
-- Create Gold Schema
-- ================================================================================================

IF NOT EXISTS (
    SELECT *
    FROM sys.schemas
    WHERE name = 'gold'
)
BEGIN
    EXEC('CREATE SCHEMA gold');
END;
GO

-- ================================================================================================
-- Create View: gold.dim_customers
-- ================================================================================================
-- Purpose:
--     Stores customer descriptive information for customer analysis.
-- ================================================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS

SELECT

    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,

    customer_id,
    customer_unique_id,

    customer_city AS city,
    customer_state AS state

FROM silver.olist_customers;

GO

-- ================================================================================================
-- Create View: gold.dim_products
-- ================================================================================================
-- Purpose:
--     Stores product descriptive information for product analysis.
-- ================================================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS

SELECT

    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,

    product_id,

    product_category_english AS product_category,

    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

FROM silver.olist_products;

GO

-- ================================================================================================
-- Create View: gold.dim_sellers
-- ================================================================================================
-- Purpose:
--     Stores seller descriptive information for seller analysis.
-- ================================================================================================

IF OBJECT_ID('gold.dim_sellers', 'V') IS NOT NULL
    DROP VIEW gold.dim_sellers;
GO

CREATE VIEW gold.dim_sellers AS

SELECT

    ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key,

    seller_id,

    seller_city,
    seller_state

FROM silver.olist_sellers;

GO

-- ================================================================================================
-- Create View: gold.dim_dates
-- ================================================================================================
-- Purpose:
--     Stores date attributes for time-based analytics and reporting.
-- ================================================================================================

IF OBJECT_ID('gold.dim_dates', 'V') IS NOT NULL
    DROP VIEW gold.dim_dates;
GO

CREATE VIEW gold.dim_dates AS

SELECT DISTINCT

    CAST(order_purchase_timestamp AS DATE) AS full_date,

    YEAR(order_purchase_timestamp) AS year,

    MONTH(order_purchase_timestamp) AS month_number,

    DATENAME(MONTH, order_purchase_timestamp) AS month_name,

    DATEPART(QUARTER, order_purchase_timestamp) AS quarter_number,

    DATENAME(WEEKDAY, order_purchase_timestamp) AS weekday_name,

    CASE
        WHEN DATENAME(WEEKDAY, order_purchase_timestamp)
             IN ('Saturday', 'Sunday')
        THEN 1
        ELSE 0
    END AS is_weekend

FROM silver.olist_orders

WHERE order_purchase_timestamp IS NOT NULL;

GO

-- ================================================================================================
-- Create View: gold.fact_orders
-- ================================================================================================
-- Purpose:
--     Central fact table containing complete order transaction information.
--
-- Business Grain:
--     One row per order item.
--
-- Business Use Cases:
--     - Revenue analysis
--     - Product performance analysis
--     - Seller performance analysis
--     - Delivery performance analysis
--     - Customer satisfaction analysis
--     - Payment analysis
-- ================================================================================================

IF OBJECT_ID('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO

CREATE VIEW gold.fact_orders AS

SELECT

    -- Order Information
    oi.order_id,
    o.customer_id,

    -- Product & Seller Information
    oi.product_id,
    oi.seller_id,

    -- Order Dates
    CAST(o.order_purchase_timestamp AS DATE) AS order_date,
    CAST(o.order_delivered_customer_date AS DATE) AS delivered_date,
    CAST(o.order_estimated_delivery_date AS DATE) AS estimated_delivery_date,

    -- Order Status
    o.order_status,

    -- Sales Metrics
    oi.price,
    oi.freight_value AS shipping_cost,
    oi.total_order_item_value,

    -- Payment Information
    op.payment_type,
    op.payment_installments,
    op.payment_value,

    -- Review Information
    rv.review_score,
    rv.review_sentiment,

    -- Delivery KPIs
    o.approval_time_hours,
    o.delivery_days,
    o.estimated_delivery_days,
    o.is_delayed

FROM silver.olist_order_items oi

LEFT JOIN silver.olist_orders o
    ON oi.order_id = o.order_id

LEFT JOIN silver.olist_order_payments op
    ON oi.order_id = op.order_id

LEFT JOIN silver.olist_order_reviews rv
    ON oi.order_id = rv.order_id;

GO
