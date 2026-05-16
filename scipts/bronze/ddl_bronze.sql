/*
================================================================================================
DDL Script: Create Bronze Tables
================================================================================================
Script Purpose:
This script creates tables in the 'bronze' schema, dropping existing tables if they already exist.
Run this script to re-define the DDL structure of Bronze layer tables for the
Olist E-Commerce Data Warehouse Project.
================================================================================================
*/

-- Create table: bronze.olist_products
IF OBJECT_ID('bronze.olist_products', 'U') IS NOT NULL
    DROP TABLE bronze.olist_products;
GO

CREATE TABLE bronze.olist_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(50),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
GO

-- Create table: bronze.olist_customers
IF OBJECT_ID('bronze.olist_customers', 'U') IS NOT NULL
    DROP TABLE bronze.olist_customers;
GO

CREATE TABLE bronze.olist_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(50),
    customer_state VARCHAR(50)
);
GO

-- Create table: bronze.olist_geolocation
IF OBJECT_ID('bronze.olist_geolocation', 'U') IS NOT NULL
    DROP TABLE bronze.olist_geolocation;
GO

CREATE TABLE bronze.olist_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(50),
    geolocation_state VARCHAR(50)
);
GO

-- Create table: bronze.olist_order_items
IF OBJECT_ID('bronze.olist_order_items', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_items;
GO

CREATE TABLE bronze.olist_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME2,
    price FLOAT,
    freight_value FLOAT
);
GO

-- Create table: bronze.olist_order_payments
IF OBJECT_ID('bronze.olist_order_payments', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_payments;
GO

CREATE TABLE bronze.olist_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value FLOAT
);
GO

-- Create table: bronze.olist_order_reviews
IF OBJECT_ID('bronze.olist_order_reviews', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_reviews;
GO

CREATE TABLE bronze.olist_order_reviews (
    review_id VARCHAR(MAX),
    order_id VARCHAR(MAX),
    review_score INT,
    review_comment_title VARCHAR(MAX),
    review_comment_message VARCHAR(MAX),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
GO

-- Create table: bronze.olist_orders
IF OBJECT_ID('bronze.olist_orders', 'U') IS NOT NULL
    DROP TABLE bronze.olist_orders;
GO

CREATE TABLE bronze.olist_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME2,
    order_approved_at DATETIME2,
    order_delivered_carrier_date DATETIME2,
    order_delivered_customer_date DATETIME2,
    order_estimated_delivery_date DATETIME2
);
GO

-- Create table: bronze.olist_sellers
IF OBJECT_ID('bronze.olist_sellers', 'U') IS NOT NULL
    DROP TABLE bronze.olist_sellers;
GO

CREATE TABLE bronze.olist_sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(50),
    seller_state VARCHAR(50)
);
GO

-- Create table: bronze.product_category
IF OBJECT_ID('bronze.product_category', 'U') IS NOT NULL
    DROP TABLE bronze.product_category;
GO

CREATE TABLE bronze.product_category (
    column1 VARCHAR(50),
    column2 VARCHAR(50)
);
GO
