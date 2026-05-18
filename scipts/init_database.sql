/*
================================================================================================
Create Database and Schemas
================================================================================================
Script Purpose:
    This script creates the Olist Data Warehouse database and required schemas.

    The warehouse follows the Medallion Architecture:

        - Bronze Layer:
            Raw source data ingestion layer

        - Silver Layer:
            Cleaned and transformed data layer

        - Gold Layer:
            Business-ready analytical layer

Schemas Created:
    - bronze
    - silver
    - gold

WARNING:
    Running this script will DROP the existing database if it already exists.

    ALL DATA WILL BE PERMANENTLY DELETED.

    Execute carefully and ensure proper backups exist before running.
================================================================================================
*/

USE master;
GO

-- ================================================================================================
-- Drop Existing Database
-- ================================================================================================

IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'Olist_DataWarehouse'
)

BEGIN

    ALTER DATABASE Olist_DataWarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE Olist_DataWarehouse;

END;
GO

-- ================================================================================================
-- Create Database
-- ================================================================================================

CREATE DATABASE Olist_DataWarehouse;
GO

USE Olist_DataWarehouse;
GO

-- ================================================================================================
-- Create Bronze Schema
-- ================================================================================================
-- Purpose:
--     Stores raw source data without transformations.
-- ================================================================================================

CREATE SCHEMA bronze;
GO

-- ================================================================================================
-- Create Silver Schema
-- ================================================================================================
-- Purpose:
--     Stores cleaned, validated, and transformed data.
-- ================================================================================================

CREATE SCHEMA silver;
GO

-- ================================================================================================
-- Create Gold Schema
-- ================================================================================================
-- Purpose:
--     Stores business-ready analytical views and star schema models.
-- ================================================================================================

CREATE SCHEMA gold;
GO
