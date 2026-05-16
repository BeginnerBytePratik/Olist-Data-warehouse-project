/*
================================================================================================
DDL Script: Create Silver Tables
================================================================================================
Script Purpose:
This script creates cleaned and standardized tables in the 'silver' schema,
dropping existing tables if they already exist.

The Silver Layer contains:
- Cleaned data
- Standardized structures
- Analytics-ready derived columns
================================================================================================
*/
CREATE SCHEMA silver;
GO
-- Create table: silver.olist_products
IF OBJECT_ID('silver.olist_products', 'U') IS NOT NULL
    DROP TABLE silver.olist_products;
GO

CREATE TABLE silver.olist_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(50),

    /* Added translated category name for easier Power BI reporting */
    product_category_english VARCHAR(50),

    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
GO

-- Create table: silver.olist_customers
IF OBJECT_ID('silver.olist_customers', 'U') IS NOT NULL
    DROP TABLE silver.olist_customers;
GO

CREATE TABLE silver.olist_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(50),
    customer_state VARCHAR(50)
);
GO

-- Create table: silver.olist_order_items
IF OBJECT_ID('silver.olist_order_items', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_items;
GO

CREATE TABLE silver.olist_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME2,
    price FLOAT,
    freight_value FLOAT,

    /* Added total item value including shipping cost */
    total_order_item_value FLOAT
);
GO

-- Create table: silver.olist_order_payments
IF OBJECT_ID('silver.olist_order_payments', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_payments;
GO

CREATE TABLE silver.olist_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value FLOAT,

    /* Added flag to identify installment-based payments */
    is_installment_payment BIT
);
GO

-- Create table: silver.olist_order_reviews
IF OBJECT_ID('silver.olist_order_reviews', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_reviews;
GO

CREATE TABLE silver.olist_order_reviews (
    review_id VARCHAR(MAX),
    order_id VARCHAR(MAX),
    review_score INT,
    review_comment_title VARCHAR(MAX),
    review_comment_message VARCHAR(MAX),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,

    /* Added sentiment category based on review score */
    review_sentiment VARCHAR(20)
);
GO

-- Create table: silver.olist_orders
IF OBJECT_ID('silver.olist_orders', 'U') IS NOT NULL
    DROP TABLE silver.olist_orders;
GO

CREATE TABLE silver.olist_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME2,
    order_approved_at DATETIME2,
    order_delivered_carrier_date DATETIME2,
    order_delivered_customer_date DATETIME2,
    order_estimated_delivery_date DATETIME2,

    /* Added actual delivery duration in days */
    delivery_days INT,

    /* Added expected delivery duration in days */
    estimated_delivery_days INT,

    /* Added approval processing time in hours */
    approval_time_hours INT,

    /* Added delayed order indicator */
    is_delayed BIT
);
GO

-- Create table: silver.olist_sellers
IF OBJECT_ID('silver.olist_sellers', 'U') IS NOT NULL
    DROP TABLE silver.olist_sellers;
GO

CREATE TABLE silver.olist_sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(50),
    seller_state VARCHAR(50)
);
GO

-- Create table: silver.product_category
IF OBJECT_ID('silver.product_category', 'U') IS NOT NULL
    DROP TABLE silver.product_category;
GO

CREATE TABLE silver.product_category (

    /* Original Portuguese category name */
    product_category_name VARCHAR(50),

    /* English translated category name */
    product_category_english VARCHAR(50)

);
GO
