/*
=====================================================================
Table: silver.telecom_churn_raw
Purpose: Cleaned/standardized telecom customer dataset (Silver layer).
         Sourced from bronze.telecom_churn_raw after cleaning and
         deduplication (one row per customer_id).
=====================================================================
*/
 
-- Drop the table first if it already exists, so this script can be re-run safely

IF OBJECT_ID('silver.telecom_churn_raw','U') IS NOT NULL
    DROP TABLE silver.telecom_churn_raw
GO

CREATE TABLE silver.telecom_churn_raw (
    -- Metadata / lineage
    silver_row_id               BIGINT IDENTITY(1,1) PRIMARY KEY,
    ingestion_timestamp          DATETIME2 DEFAULT GETDATE(),
    bronze_row_id                BIGINT,
    bronze_ingestion_timestamp   DATETIME2,

    -- Identifiers
    customer_id                  NVARCHAR(30) NOT NULL,

    -- Demographics
    gender                        NVARCHAR(10),
    age                           TINYINT,
    senior_citizen                BIT,
    state                         NVARCHAR(50),
    city_tier                     NVARCHAR(10),

    -- Account / plan info
    tenure_months                 SMALLINT,
    contract_type                 NVARCHAR(30),
    plan_type                     NVARCHAR(20),
    data_plan                     NVARCHAR(30),
    international_plan            BIT,
    voicemail_plan                BIT,
    multiple_lines                NVARCHAR(20),

    -- Add-on services
    online_security               NVARCHAR(25),
    online_backup                 NVARCHAR(25),
    device_protection             NVARCHAR(25),
    tech_support                  NVARCHAR(25),
    streaming_tv                  NVARCHAR(25),
    streaming_movies              NVARCHAR(25),

    -- Usage
    data_usage_gb                 DECIMAL(10,2),
    total_day_minutes             DECIMAL(10,2),
    total_eve_minutes             DECIMAL(10,2),
    total_night_minutes           DECIMAL(10,2),
    --total_intl_minutes            DECIMAL(10,2),
    total_day_calls               SMALLINT,
    total_eve_calls               SMALLINT,
    total_night_calls             SMALLINT,
    --total_intl_calls              SMALLINT,
    customer_service_calls        TINYINT,

    -- Billing
    monthly_charges               DECIMAL(10,2),
    total_charges                 DECIMAL(12,2),
    payment_method                NVARCHAR(30),
    paperless_billing              BIT,

    
);
