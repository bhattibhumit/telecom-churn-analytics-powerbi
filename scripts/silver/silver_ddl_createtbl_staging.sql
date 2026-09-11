/*
=====================================================================
Table: silver.telecom_churn_raw_staging
Purpose: Temporary holding table for the Silver layer. All columns are
         kept as NVARCHAR (raw, untyped) to safely land data from
         Bronze before cleaning, type conversion, and deduplication
         are applied when loading into silver.telecom_churn_raw.
=====================================================================
*/
 
-- Drop the table first if it already exists, so this script can be re-run safely

IF OBJECT_ID('silver.telecom_churn_raw_staging','U') IS NOT NULL
    DROP TABLE silver.telecom_churn_raw_staging
GO

CREATE TABLE silver.telecom_churn_raw_staging
(
	silver_row_id           BIGINT IDENTITY(1,1) PRIMARY KEY,
    ingestion_timestamp     DATETIME2 DEFAULT GETDATE(),
    bronze_row_id           BIGINT,
    bronze_ingestion_timestamp DATETIME2,
    source_file_name        NVARCHAR(200),
    customer_id             NVARCHAR(30),
    gender                  NVARCHAR(10),
    age                     NVARCHAR(10),
    senior_citizen          NVARCHAR(5),
    state                   NVARCHAR(50),
    city_tier               NVARCHAR(10),
    tenure_months           NVARCHAR(10),
    contract_type           NVARCHAR(30),
    plan_type               NVARCHAR(20),
    data_plan               NVARCHAR(30),
    international_plan      NVARCHAR(15),
    voicemail_plan          NVARCHAR(15),
    multiple_lines          NVARCHAR(20),
    online_security         NVARCHAR(25),
    online_backup           NVARCHAR(25),
    device_protection       NVARCHAR(25),
    tech_support            NVARCHAR(25),
    streaming_tv            NVARCHAR(25),
    streaming_movies        NVARCHAR(25),
    data_usage_gb           NVARCHAR(15),
    total_day_minutes       NVARCHAR(15),
    total_eve_minutes       NVARCHAR(15),
    total_night_minutes     NVARCHAR(15),
    total_intl_minutes      NVARCHAR(15),
    total_day_calls         NVARCHAR(10),
    total_eve_calls         NVARCHAR(10),
    total_night_calls       NVARCHAR(10),
    total_intl_calls        NVARCHAR(10),
    customer_service_calls  NVARCHAR(10),
    monthly_charges         NVARCHAR(15),
    total_charges           NVARCHAR(15),
    payment_method          NVARCHAR(30),
    paperless_billing       NVARCHAR(10),
    churn                   NVARCHAR(10)
);

