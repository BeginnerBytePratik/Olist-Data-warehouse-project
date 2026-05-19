/*
================================================================================
Quality Checks
================================================================================
Script Purpose:
    This script performs various quality checks for data consistency,
    accuracy, and standardization across the Bronze and Silver layers
    of the Olist Data Warehouse project.

    The validation checks include:
    - NULL or duplicate primary key validation
    - Blank value detection
    - Unwanted space validation
    - Data standardization checks
    - Financial and numerical validation
    - Date and timeline consistency validation
    - Delivery SLA and derived metric validation
    - Business rule validation

Usage Notes:
    - Run these checks after loading the Silver Layer.
    - Investigate and resolve all unexpected results.
    - Expected clean datasets should return no rows for error checks.
================================================================================
*/

-- ================================================================================
-- Checking 'silver.olist_customers'
-- ================================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT
    customer_id,
    COUNT(*) AS cnt
FROM silver.olist_customers
GROUP BY customer_id
HAVING COUNT(*) > 1
    OR customer_id IS NULL;

-- Check for NULLs in customer_unique_id
-- Expectation: No Results
SELECT *
FROM silver.olist_customers
WHERE customer_unique_id IS NULL;

-- Check for Blank Values
-- Expectation: No Results
SELECT *
FROM silver.olist_customers
WHERE customer_id = ''
   OR customer_unique_id = ''
   OR customer_city = ''
   OR customer_state = '';

-- Check for Unwanted Spaces in customer_city
-- Expectation: No Results
SELECT
    customer_city
FROM silver.olist_customers
WHERE customer_city != TRIM(customer_city);

-- Check for Unwanted Spaces in customer_state
-- Expectation: No Results
SELECT
    customer_state
FROM silver.olist_customers
WHERE customer_state != TRIM(customer_state);

-- Check ZIP Code Validity
-- Expectation: No Results
SELECT *
FROM silver.olist_customers
WHERE customer_zip_code_prefix <= 0;

-- Validate State Code Length Consistency
-- Expectation: All values should have length = 2
SELECT DISTINCT
    LEN(customer_state) AS state_length
FROM silver.olist_customers;

-- Data Standardization & Consistency
SELECT DISTINCT
    customer_city
FROM silver.olist_customers
ORDER BY customer_city;

SELECT DISTINCT
    customer_state
FROM silver.olist_customers
ORDER BY customer_state;

-- ================================================================================
-- Checking 'silver.olist_products'
-- ================================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT
    product_id,
    COUNT(*) AS cnt
FROM silver.olist_products
GROUP BY product_id
HAVING COUNT(*) > 1
    OR product_id IS NULL;

-- Check for NULL Distribution Across Product Attributes
SELECT
    COUNT(*) - COUNT(product_id) AS product_id_nulls,
    COUNT(*) - COUNT(product_category_name) AS category_nulls,
    COUNT(*) - COUNT(product_name_lenght) AS name_length_nulls,
    COUNT(*) - COUNT(product_description_lenght) AS description_length_nulls,
    COUNT(*) - COUNT(product_photos_qty) AS photos_qty_nulls,
    COUNT(*) - COUNT(product_weight_g) AS weight_nulls,
    COUNT(*) - COUNT(product_length_cm) AS length_nulls,
    COUNT(*) - COUNT(product_height_cm) AS height_nulls,
    COUNT(*) - COUNT(product_width_cm) AS width_nulls
FROM silver.olist_products;

-- Check for Negative Product Dimensions or Weight
-- Expectation: No Results
SELECT *
FROM silver.olist_products
WHERE product_weight_g < 0
   OR product_length_cm < 0
   OR product_height_cm < 0
   OR product_width_cm < 0;

-- Data Standardization & Consistency
SELECT DISTINCT
    product_category_name
FROM silver.olist_products
ORDER BY product_category_name;

-- ================================================================================
-- Checking 'silver.olist_orders'
-- ================================================================================

-- Check for NULL Counts
SELECT
    COUNT(*) - COUNT(order_id) AS order_id_nulls,
    COUNT(*) - COUNT(customer_id) AS customer_id_nulls,
    COUNT(*) - COUNT(order_status) AS order_status_nulls,
    COUNT(*) - COUNT(order_purchase_timestamp) AS purchase_timestamp_nulls,
    COUNT(*) - COUNT(order_approved_at) AS approved_at_nulls,
    COUNT(*) - COUNT(order_delivered_carrier_date) AS carrier_date_nulls,
    COUNT(*) - COUNT(order_delivered_customer_date) AS delivered_date_nulls,
    COUNT(*) - COUNT(order_estimated_delivery_date) AS estimated_delivery_nulls
FROM silver.olist_orders;

-- Check for Duplicate order_id
-- Expectation: No Results
SELECT
    order_id,
    COUNT(*) AS cnt
FROM silver.olist_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check Invalid Order Timeline
-- Expectation: No Results
SELECT *
FROM silver.olist_orders
WHERE order_approved_at < order_purchase_timestamp
   OR order_delivered_customer_date < order_purchase_timestamp;

-- Check for Delayed Orders Logic
-- Expectation: is_delayed should match delivery comparison
SELECT *
FROM silver.olist_orders
WHERE (
        order_delivered_customer_date > order_estimated_delivery_date
        AND is_delayed = 0
      )
   OR (
        order_delivered_customer_date <= order_estimated_delivery_date
        AND is_delayed = 1
      );

-- Validate approval_time_hours
-- Expectation: No Negative Values
SELECT *
FROM silver.olist_orders
WHERE approval_time_hours < 0;

-- Validate delivery_days
-- Expectation: No Negative Values
SELECT *
FROM silver.olist_orders
WHERE delivery_days < 0;

-- Validate estimated_delivery_days
-- Expectation: No Negative Values
SELECT *
FROM silver.olist_orders
WHERE estimated_delivery_days < 0;

-- Data Standardization & Consistency
SELECT DISTINCT
    order_status
FROM silver.olist_orders
ORDER BY order_status;

-- ================================================================================
-- Checking 'silver.olist_order_items'
-- ================================================================================

-- Check NULL Values
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS order_item_id_nulls,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS shipping_limit_date_nulls,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS freight_value_nulls
FROM silver.olist_order_items;

-- Check Duplicate Order Items
-- Expectation: No Results
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM silver.olist_order_items
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;

-- Check for Negative Monetary Values
-- Expectation: No Results
SELECT *
FROM silver.olist_order_items
WHERE price < 0
   OR freight_value < 0;

-- Check for Zero Price Orders
SELECT *
FROM silver.olist_order_items
WHERE price = 0;

-- ================================================================================
-- Checking 'silver.olist_order_payments'
-- ================================================================================

-- Check NULL Values
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS payment_sequential_nulls,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS payment_type_nulls,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS payment_installments_nulls,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS payment_value_nulls
FROM silver.olist_order_payments;

-- Check Duplicate Payments
-- Expectation: No Results
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM silver.olist_order_payments
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;

-- Validate Payment Types
SELECT DISTINCT
    payment_type
FROM silver.olist_order_payments
ORDER BY payment_type;

-- Check for Negative Payment Values
-- Expectation: No Results
SELECT *
FROM silver.olist_order_payments
WHERE payment_value < 0;

-- Validate Installment Values
-- Expectation: No Results
SELECT *
FROM silver.olist_order_payments
WHERE payment_installments <= 0;

-- Analyze Undefined Payment Types
SELECT COUNT(*) AS not_defined_count
FROM silver.olist_order_payments
WHERE payment_type = 'not_defined';

-- ================================================================================
-- Checking 'silver.olist_order_reviews'
-- ================================================================================

-- Check NULL Values
SELECT
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS review_id_nulls,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS review_score_nulls,
    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS review_title_nulls,
    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS review_message_nulls,
    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS review_creation_nulls,
    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS review_answer_nulls
FROM silver.olist_order_reviews;

-- Check Duplicate Reviews
-- Expectation: No Results
SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM silver.olist_order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

-- Validate Review Score Range
SELECT DISTINCT
    review_score
FROM silver.olist_order_reviews
ORDER BY review_score;

-- Check Empty Review Messages
SELECT *
FROM silver.olist_order_reviews
WHERE review_comment_message = '';

-- Check Review Timeline Consistency
-- Expectation: No Results
SELECT *
FROM silver.olist_order_reviews
WHERE review_answer_timestamp < review_creation_date;

-- ================================================================================
-- Checking 'silver.olist_sellers'
-- ================================================================================

-- Check NULL Values
SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_nulls,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM silver.olist_sellers;

-- Check Duplicate seller_id
-- Expectation: No Results
SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM silver.olist_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT *
FROM silver.olist_sellers
WHERE seller_city != TRIM(seller_city)
   OR seller_state != TRIM(seller_state);

-- Data Standardization & Consistency
SELECT DISTINCT
    seller_city
FROM silver.olist_sellers
ORDER BY seller_city;

SELECT DISTINCT
    seller_state
FROM silver.olist_sellers
ORDER BY seller_state;
