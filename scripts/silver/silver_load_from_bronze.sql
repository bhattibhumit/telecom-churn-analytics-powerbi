/*
=====================================================================
Load: bronze.telecom_churn_raw -> silver.telecom_churn_raw_staging
Purpose: Move raw customer records from Bronze into the Silver staging
         table as-is (no cleaning/type conversion here), carrying
         forward lineage info (bronze_row_id, bronze ingestion time,
         source file name) so records can be traced back to Bronze.
=====================================================================
*/

INSERT INTO silver.telecom_churn_raw_staging (
    bronze_row_id,
    bronze_ingestion_timestamp,
    source_file_name,
    customer_id, gender, age, senior_citizen, state, city_tier, tenure_months,
    contract_type, plan_type, data_plan, international_plan, voicemail_plan,
    multiple_lines, online_security, online_backup, device_protection,
    tech_support, streaming_tv, streaming_movies, data_usage_gb,
    total_day_minutes, total_eve_minutes, total_night_minutes, total_intl_minutes,
    total_day_calls, total_eve_calls, total_night_calls, total_intl_calls,
    customer_service_calls, monthly_charges, total_charges,
    payment_method, paperless_billing, churn
)
SELECT
    bronze_row_id,
    ingestion_timestamp,
    source_file_name,
    customer_id, gender, age, senior_citizen, state, city_tier, tenure_months,
    contract_type, plan_type, data_plan, international_plan, voicemail_plan,
    multiple_lines, online_security, online_backup, device_protection,
    tech_support, streaming_tv, streaming_movies, data_usage_gb,
    total_day_minutes, total_eve_minutes, total_night_minutes, total_intl_minutes,
    total_day_calls, total_eve_calls, total_night_calls, total_intl_calls,
    customer_service_calls, monthly_charges, total_charges,
    payment_method, paperless_billing, churn
FROM bronze.telecom_churn_raw;