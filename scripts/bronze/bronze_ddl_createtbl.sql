
/*
==============================================================
DDL Bronze : Create Bronze Tables
==============================================================

------------------------------------------------------------------------------------
Scripts :
  - Create the table telecom_churn_raw for row data
  - If table already exits than it drop exiting table and create new table 
-------------------------------------------------------------------------------------
*/

IF OBJECT_ID('bronze.telecom_churn_raw_staging', 'U') IS NOT NULL
    DROP TABLE bronze.telecom_churn_raw_staging;
GO

CREATE TABLE bronze.telecom_churn_raw_staging (
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
GO

IF OBJECT_ID('bronze.telecom_churn_raw', 'U') IS NOT NULL
    DROP TABLE bronze.telecom_churn_raw;
GO

CREATE TABLE bronze.telecom_churn_raw (
    -- Metadata columns
    bronze_row_id           BIGINT IDENTITY(1,1) PRIMARY KEY,
    ingestion_timestamp     DATETIME2 DEFAULT GETDATE(),
    source_file_name        NVARCHAR(200),

    -- Data columns (from CSV)
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
GO