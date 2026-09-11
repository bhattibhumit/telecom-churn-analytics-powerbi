/*
========================================================================================================
Stored Procedure : Load Bronze Layer (Source --> Bronze)
========================================================================================================

Script :

This Stored Procedure loads data into the 'bronze' schema from external CSV Files.
It perform the Follwoing actions :
  - Truncate the bronze table before loading data
  - Uses the 'BULK INSERT' command to load data from CSV Files to Bronze tables

Parameters : NONE (This Stored Procedure does not accept any Parameters or return any values)

USAGE Example : EXEC bronze.load_bronze;

===========================================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME, @end_time DATETIME;

    BEGIN TRY
        SET @start_time = GETDATE();

        PRINT '===========================================';
        PRINT 'Loading Telecom data into Bronze Layer';
        PRINT '===========================================';

        -------------------------------------------------
        -- 1. Truncate both tables
        -------------------------------------------------
        PRINT '>> Truncating tables...';
        TRUNCATE TABLE bronze.telecom_churn_raw;
        TRUNCATE TABLE bronze.telecom_churn_raw_staging;

        -------------------------------------------------
        -- 2. Bulk Insert into STAGING table (exact match with CSV)
        -------------------------------------------------
        PRINT '>> Bulk Inserting into staging table...';

        BULK INSERT bronze.telecom_churn_raw_staging
        FROM 'E:\Telcomm\datasets\telecom_churn_messy_1M.csv'
        WITH
        (
            FIRSTROW = 2,
            FORMAT = 'CSV',              -- ✅ proper CSV parser (handles quotes)
            FIELDQUOTE = '"',            -- tells it how fields are quoted
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK

            
            --MAXERRORS = 5000000,                    -- allow some bad rows
            --ERRORFILE = 'E:\Telcomm\datasets\bulk_insert_errors.log'   -- critical 

        );

        -------------------------------------------------
        -- 3. Insert from Staging → Final table + Metadata
        -------------------------------------------------
        PRINT '>> Inserting data into bronze.telecom_churn_raw...';

        INSERT INTO bronze.telecom_churn_raw (
            customer_id,
            gender,
            age,
            senior_citizen,
            state,
            city_tier,
            tenure_months,
            contract_type,
            plan_type,
            data_plan,
            international_plan,
            voicemail_plan,
            multiple_lines,
            online_security,
            online_backup,
            device_protection,
            tech_support,
            streaming_tv,
            streaming_movies,
            data_usage_gb,
            total_day_minutes,
            total_eve_minutes,
            total_night_minutes,
            total_intl_minutes,
            total_day_calls,
            total_eve_calls,
            total_night_calls,
            total_intl_calls,
            customer_service_calls,
            monthly_charges,
            total_charges,
            payment_method,
            paperless_billing,
            churn,
            source_file_name                  -- metadata
        )
        SELECT
            customer_id,
            gender,
            age,
            senior_citizen,
            state,
            city_tier,
            tenure_months,
            contract_type,
            plan_type,
            data_plan,
            international_plan,
            voicemail_plan,
            multiple_lines,
            online_security,
            online_backup,
            device_protection,
            tech_support,
            streaming_tv,
            streaming_movies,
            data_usage_gb,
            total_day_minutes,
            total_eve_minutes,
            total_night_minutes,
            total_intl_minutes,
            total_day_calls,
            total_eve_calls,
            total_night_calls,
            total_intl_calls,
            customer_service_calls,
            monthly_charges,
            total_charges,
            payment_method,
            paperless_billing,
            churn,
            'telecom_churn_messy_1M.csv'      -- value for source_file_name
        FROM bronze.telecom_churn_raw_staging;

        -------------------------------------------------
        SET @end_time = GETDATE();
        PRINT '>> Load completed successfully';
        PRINT '>> Load Duration : ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '-------------------------------------------';

    END TRY
    BEGIN CATCH
        PRINT '===========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT '===========================================';
    END CATCH
END
GO
