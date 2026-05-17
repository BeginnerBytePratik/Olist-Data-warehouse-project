/*
==================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
==================================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load)
    process to populate the silver schema tables from the bronze schema.

Actions Performed:
    - Truncates Silver tables
    - Inserts transformed and cleansed data from Bronze into Silver tables
    - Applies business logic and derived columns
    - Removes duplicates where required

Parameters:
    None

Usage Example:
    EXEC silver.load_silver;
==================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    DECLARE @start_time DATETIME,
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        /*================================================
                    LOADING CUSTOMER TABLE
        =================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading silver.olist_customers';
        PRINT '------------------------------------------------';

        TRUNCATE TABLE silver.olist_customers;

        INSERT INTO silver.olist_customers (

            customer_id,
            customer_unique_id,
            customer_zip_code_prefix,
            customer_city,
            customer_state
        )

        SELECT

            LTRIM(RTRIM(customer_id)) AS customer_id,
            LTRIM(RTRIM(customer_unique_id)) AS customer_unique_id,
            customer_zip_code_prefix,
            LTRIM(RTRIM(customer_city)) AS customer_city,
            UPPER(LTRIM(RTRIM(customer_state))) AS customer_state

        FROM bronze.olist_customers

        WHERE customer_id IS NOT NULL;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -----------------------';


        /*================================================
                    LOADING PRODUCT TABLE
        =================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading silver.olist_products';
        PRINT '------------------------------------------------';

        TRUNCATE TABLE silver.olist_products;

        INSERT INTO silver.olist_products (

            product_id,
            product_category_name,
            product_category_english,
            product_name_lenght,
            product_description_lenght,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm
        )

        SELECT

            LTRIM(RTRIM(p.product_id)) AS product_id,

            ISNULL(
                LTRIM(RTRIM(p.product_category_name)),
                'unknown'
            ) AS product_category_name,

            ISNULL(
                LTRIM(RTRIM(pc.column2)),
                'unknown'
            ) AS product_category_english,

            p.product_name_lenght,
            p.product_description_lenght,
            p.product_photos_qty,
            p.product_weight_g,
            p.product_length_cm,
            p.product_height_cm,
            p.product_width_cm

        FROM bronze.[ olist_products] p

        LEFT JOIN bronze.product_category pc
            ON p.product_category_name = pc.column1

        WHERE p.product_id IS NOT NULL;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -----------------------';


        /*================================================
                    LOADING ORDERS TABLE
        =================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading silver.olist_orders';
        PRINT '------------------------------------------------';

        TRUNCATE TABLE silver.olist_orders;

        INSERT INTO silver.olist_orders (

            order_id,
            customer_id,
            order_status,
            order_purchase_timestamp,
            order_approved_at,
            order_delivered_carrier_date,
            order_delivered_customer_date,
            order_estimated_delivery_date,
            approval_time_hours,
            delivery_days,
            estimated_delivery_days,
            is_delayed
        )

        SELECT

            LTRIM(RTRIM(order_id)) AS order_id,

            LTRIM(RTRIM(customer_id)) AS customer_id,

            LTRIM(RTRIM(order_status)) AS order_status,

            order_purchase_timestamp,
            order_approved_at,
            order_delivered_carrier_date,
            order_delivered_customer_date,
            order_estimated_delivery_date,

            DATEDIFF(
                HOUR,
                order_purchase_timestamp,
                order_approved_at
            ) AS approval_time_hours,

            DATEDIFF(
                DAY,
                order_purchase_timestamp,
                order_delivered_customer_date
            ) AS delivery_days,

            DATEDIFF(
                DAY,
                order_purchase_timestamp,
                order_estimated_delivery_date
            ) AS estimated_delivery_days,

            CASE
                WHEN order_delivered_customer_date IS NULL THEN NULL
                WHEN order_delivered_customer_date
                     > order_estimated_delivery_date
                     THEN 1
                ELSE 0
            END AS is_delayed

        FROM bronze.olist_orders

        WHERE order_id IS NOT NULL;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -----------------------';


        /*================================================
                LOADING ORDER ITEMS TABLE
        =================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading silver.olist_order_items';
        PRINT '------------------------------------------------';

        TRUNCATE TABLE silver.olist_order_items;

        INSERT INTO silver.olist_order_items (

            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date,
            price,
            freight_value,
            total_order_item_value
        )

        SELECT

            LTRIM(RTRIM(order_id)) AS order_id,

            order_item_id,

            LTRIM(RTRIM(product_id)) AS product_id,

            LTRIM(RTRIM(seller_id)) AS seller_id,

            CAST(shipping_limit_date AS DATE)
                AS shipping_limit_date,

            CAST(price AS DECIMAL(10,2)) AS price,

            CAST(freight_value AS DECIMAL(10,2))
                AS freight_value,

            CAST(
                price + freight_value
                AS DECIMAL(10,2)
            ) AS total_order_item_value

        FROM bronze.olist_order_items

        WHERE order_id IS NOT NULL;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -----------------------';


        /*================================================
                LOADING ORDER PAYMENTS TABLE
        =================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading silver.olist_order_payments';
        PRINT '------------------------------------------------';

        TRUNCATE TABLE silver.olist_order_payments;

        INSERT INTO silver.olist_order_payments (

            order_id,
            payment_sequential,
            payment_type,
            payment_installments,
            payment_value,
            is_installment_payment
        )

        SELECT

            LTRIM(RTRIM(order_id)) AS order_id,

            payment_sequential,

            LTRIM(RTRIM(payment_type)) AS payment_type,

            payment_installments,

            CAST(payment_value AS DECIMAL(10,2))
                AS payment_value,

            CASE
                WHEN payment_installments > 1 THEN 1
                ELSE 0
            END AS is_installment_payment

        FROM bronze.olist_order_payments

        WHERE order_id IS NOT NULL;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -----------------------';


        /*================================================
                LOADING ORDER REVIEWS TABLE
        =================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading silver.olist_order_reviews';
        PRINT '------------------------------------------------';

        TRUNCATE TABLE silver.olist_order_reviews;

        INSERT INTO silver.olist_order_reviews (

            review_id,
            order_id,
            review_score,
            review_comment_title,
            review_comment_message,
            review_creation_date,
            review_answer_timestamp,
            review_sentiment
        )

        SELECT

            LTRIM(RTRIM(review_id)) AS review_id,

            LTRIM(RTRIM(order_id)) AS order_id,

            review_score,

            LTRIM(RTRIM(review_comment_title))
                AS review_comment_title,

            LTRIM(RTRIM(review_comment_message))
                AS review_comment_message,

            CAST(review_creation_date AS DATE)
                AS review_creation_date,

            review_answer_timestamp,

            CASE
                WHEN review_score >= 4 THEN 'Positive'
                WHEN review_score = 3 THEN 'Neutral'
                ELSE 'Negative'
            END AS review_sentiment

        FROM (

            SELECT *,
                   ROW_NUMBER() OVER (
                       PARTITION BY review_id
                       ORDER BY review_creation_date
                   ) AS row_num

            FROM bronze.olist_order_reviews

            WHERE review_id IS NOT NULL

        ) t

        WHERE row_num = 1;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -----------------------';


        /*================================================
                    LOADING SELLERS TABLE
        =================================================*/

        SET @start_time = GETDATE();

        PRINT '------------------------------------------------';
        PRINT 'Loading silver.olist_sellers';
        PRINT '------------------------------------------------';

        TRUNCATE TABLE silver.olist_sellers;

        INSERT INTO silver.olist_sellers (

            seller_id,
            seller_zip_code_prefix,
            seller_city,
            seller_state
        )

        SELECT

            LTRIM(RTRIM(seller_id)) AS seller_id,

            seller_zip_code_prefix,

            CASE
                WHEN seller_city LIKE '%[0-9]%'
                    THEN 'unknown'
                ELSE LTRIM(RTRIM(seller_city))
            END AS seller_city,

            UPPER(LTRIM(RTRIM(seller_state)))
                AS seller_state

        FROM bronze.olist_sellers

        WHERE seller_id IS NOT NULL;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -----------------------';


        /*================================================
                    FINAL BATCH SUMMARY
        =================================================*/

        SET @batch_end_time = GETDATE();

        PRINT '================================================';
        PRINT 'Silver Layer Load Completed';
        PRINT 'Total Batch Duration: '
            + CAST(DATEDIFF(
                    SECOND,
                    @batch_start_time,
                    @batch_end_time
                ) AS NVARCHAR)
            + ' seconds';
        PRINT '================================================';

    END TRY

    BEGIN CATCH

        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING SILVER LOAD';
        PRINT '------------------------------------------------';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number : '
            + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State  : '
            + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '================================================';

    END CATCH

END;
GO

EXEC silver.load_silver;
GO
