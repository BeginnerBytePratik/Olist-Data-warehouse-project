/*
===================================================================================
Stored Procedure: Load Bronze Layer (Source > Bronze)
===================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.

    Actions Performed:
    - Truncates bronze tables before loading
    - Loads CSV data using BULK INSERT
    - Tracks load duration for each table
    - Handles errors using TRY...CATCH

Parameters:
    None

Usage Example:
    EXEC bronze.load_bronze;
===================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    DECLARE @start_time DATETIME,
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '===================================';
        PRINT 'Loading Bronze Layer';
        PRINT '===================================';

        PRINT '-----------------------------------';
        PRINT 'Loading Olist Tables';
        PRINT '-----------------------------------';

        -- OLIST CUSTOMERS
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_customers';
        TRUNCATE TABLE bronze.olist_customers;

        PRINT '>> Inserting Data Into: bronze.olist_customers';
        BULK INSERT bronze.olist_customers
        FROM 'C:\OlistDataset\olist_customers_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        -- OLIST ORDERS
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_orders';
        TRUNCATE TABLE bronze.olist_orders;

        PRINT '>> Inserting Data Into: bronze.olist_orders';
        BULK INSERT bronze.olist_orders
        FROM 'C:\OlistDataset\olist_orders_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        -- OLIST ORDER ITEMS
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_order_items';
        TRUNCATE TABLE bronze.olist_order_items;

        PRINT '>> Inserting Data Into: bronze.olist_order_items';
        BULK INSERT bronze.olist_order_items
        FROM 'C:\OlistDataset\olist_order_items_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        -- OLIST PAYMENTS
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_order_payments';
        TRUNCATE TABLE bronze.olist_order_payments;

        PRINT '>> Inserting Data Into: bronze.olist_order_payments';
        BULK INSERT bronze.olist_order_payments
        FROM 'C:\OlistDataset\olist_order_payments_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        -- OLIST REVIEWS
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_order_reviews';
        TRUNCATE TABLE bronze.olist_order_reviews;

        PRINT '>> Inserting Data Into: bronze.olist_order_reviews';
        BULK INSERT bronze.olist_order_reviews
        FROM 'C:\OlistDataset\olist_order_reviews_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            FORMAT = 'CSV',
            FIELDQUOTE = '\"',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        -- OLIST PRODUCTS
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_products';
        TRUNCATE TABLE bronze.olist_products;

        PRINT '>> Inserting Data Into: bronze.olist_products';
        BULK INSERT bronze.olist_products
        FROM 'C:\OlistDataset\olist_products_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        -- OLIST SELLERS
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_sellers';
        TRUNCATE TABLE bronze.olist_sellers;

        PRINT '>> Inserting Data Into: bronze.olist_sellers';
        BULK INSERT bronze.olist_sellers
        FROM 'C:\OlistDataset\olist_sellers_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        -- OLIST GEOLOCATION
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.olist_geolocation';
        TRUNCATE TABLE bronze.olist_geolocation;

        PRINT '>> Inserting Data Into: bronze.olist_geolocation';
        BULK INSERT bronze.olist_geolocation
        FROM 'C:\OlistDataset\olist_geolocation_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        -- PRODUCT CATEGORY TRANSLATION
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.product_category';
        TRUNCATE TABLE bronze.product_category;

        PRINT '>> Inserting Data Into: bronze.product_category';
        BULK INSERT bronze.product_category
        FROM 'C:\OlistDataset\product_category_name_translation.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
        + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
        + ' seconds';

        PRINT '-----------------------------------';


        SET @batch_end_time = GETDATE();

        PRINT '===================================';
        PRINT 'Bronze Layer Loaded Successfully';
        PRINT 'Total Load Duration: '
        + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
        + ' seconds';
        PRINT '===================================';

    END TRY

    BEGIN CATCH

        PRINT '===========================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===========================================';

    END CATCH

END;
GO
