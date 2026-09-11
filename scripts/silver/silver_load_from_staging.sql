
--TRUNCATE TABLE silver.telecom_churn_raw

INSERT INTO silver.telecom_churn_raw
(
    bronze_row_id,
    bronze_ingestion_timestamp,
 
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
    total_day_calls,
    total_eve_calls,
    total_night_calls,
    customer_service_calls,
    monthly_charges,
    total_charges,
    payment_method,
    paperless_billing
)
SELECT 
    bronze_row_id,
    bronze_ingestion_timestamp,
 
    -- customer_id
    CASE 
        WHEN customer_id LIKE 'CUST-DUP%' THEN REPLACE(customer_id, 'DUP', '')
        ELSE customer_id
    END AS customer_id,
 
    -- gender (only Male / Female survive into Silver -- see WHERE clause below,
    -- which drops any row whose raw gender value isn't recognized)
    CASE
        WHEN LOWER(TRIM(gender)) = 'female' THEN 'Female'
        WHEN LOWER(TRIM(gender)) = 'f'      THEN 'Female'
        WHEN LOWER(TRIM(gender)) = 'male'   THEN 'Male'
        WHEN LOWER(TRIM(gender)) = 'm'      THEN 'Male'
        ELSE 'Unknown'
    END AS gender,
 
    -- age
    CASE
        WHEN TRY_CAST(TRIM(age) AS INT) BETWEEN 1 AND 100 
            THEN TRY_CAST(TRIM(age) AS INT)
        ELSE 0
    END AS age,
 
    -- senior_citizen (normalized the same way as the other boolean columns,
    -- instead of a direct BIT cast which silently nulls out text like 'Yes'/'No')
    CASE 
        WHEN LOWER(TRIM(senior_citizen)) IN ('true', 'yes', '1', 'y') THEN 1
        WHEN LOWER(TRIM(senior_citizen)) IN ('false', 'no', '0', 'n') THEN 0
        ELSE NULL
    END AS senior_citizen,
 
    -- state
    CASE 
        WHEN state IS NULL OR TRIM(state) IN ('', '-', 'null', 'N/A', 'NA', 'Unknown') 
            THEN 'Unknown'
        WHEN LOWER(TRIM(state)) IN ('maharashtra', 'maharastra', 'maharashra') 
            THEN 'Maharashtra'
        WHEN LOWER(TRIM(state)) IN ('west bengal', 'westbengal') 
            THEN 'West Bengal'
        WHEN LOWER(TRIM(state)) IN ('tamil nadu', 'tamilnadu') 
            THEN 'Tamil Nadu'
        WHEN LOWER(TRIM(state)) IN ('gujarat', 'gujrat') 
            THEN 'Gujarat'
        WHEN LOWER(TRIM(state)) IN ('karnataka', 'karnatka') 
            THEN 'Karnataka'
        WHEN LOWER(TRIM(state)) IN ('uttar pradesh', 'up') 
            THEN 'Uttar Pradesh'
        WHEN LOWER(TRIM(state)) IN ('madhya pradesh') 
            THEN 'Madhya Pradesh'
        WHEN LOWER(TRIM(state)) IN ('andhra pradesh') 
            THEN 'Andhra Pradesh'
        WHEN LOWER(TRIM(state)) = 'delhi' THEN 'Delhi'
        WHEN LOWER(TRIM(state)) = 'kerala' THEN 'Kerala'
        WHEN LOWER(TRIM(state)) = 'punjab' THEN 'Punjab'
        WHEN LOWER(TRIM(state)) = 'haryana' THEN 'Haryana'
        WHEN LOWER(TRIM(state)) = 'rajasthan' THEN 'Rajasthan'
        WHEN LOWER(TRIM(state)) = 'telangana' THEN 'Telangana'
        WHEN LOWER(TRIM(state)) = 'bihar' THEN 'Bihar'
        ELSE TRIM(state)
    END AS state,
 
    -- city_tier
    CASE
        WHEN city_tier IS NULL OR TRIM(city_tier) IN ('', '-', 'null') THEN 'Unknown'
        ELSE TRIM(city_tier)
    END AS city_tier,
 
    -- tenure_months (kept as NULL when invalid, rather than dropping the row later)
    TRY_CAST(TRIM(tenure_months) AS INT) AS tenure_months,
 
    -- contract_type
    CASE 
        WHEN contract_type IS NULL OR TRIM(contract_type) = '' THEN 'Unknown'
        WHEN LOWER(REPLACE(TRIM(contract_type), ' ', '')) IN ('month-to-month', 'monthtomonth') 
            THEN 'Month-to-Month'
        WHEN LOWER(REPLACE(TRIM(contract_type), ' ', '')) IN ('oneyear', 'one-year') 
            THEN 'One Year'
        WHEN LOWER(REPLACE(TRIM(contract_type), ' ', '')) IN ('twoyear', 'two-year') 
            THEN 'Two Year'
        ELSE TRIM(contract_type)
    END AS contract_type,
 
    -- plan_type (added the literal 'null' string catch, matching data_plan's fix)
    CASE 
        WHEN plan_type IS NULL OR TRIM(plan_type) = '' OR TRIM(plan_type) = '-' 
            OR LOWER(TRIM(plan_type)) = 'null' THEN 'Unknown'
        WHEN LOWER(TRIM(plan_type)) = 'postpaid' THEN 'Postpaid'
        WHEN LOWER(TRIM(plan_type)) = 'prepaid'  THEN 'Prepaid'
        ELSE TRIM(plan_type)
    END AS plan_type,
 
    -- data_plan
    CASE 
        WHEN LOWER(TRIM(data_plan)) IN ('na', 'n/a', '') OR data_plan IS NULL 
            OR TRIM(data_plan) = '-' OR LOWER(TRIM(data_plan)) = 'null' THEN 'Unknown'
        ELSE TRIM(data_plan)
    END AS data_plan,
 
    -- international_plan (BIT)
    CASE 
        WHEN LOWER(TRIM(international_plan)) IN ('true', 'yes', '1', 'y') THEN 1
        WHEN LOWER(TRIM(international_plan)) IN ('false', 'no', '0', 'n') THEN 0
        ELSE NULL
    END AS international_plan,
 
    -- voicemail_plan (BIT)
    CASE 
        WHEN LOWER(TRIM(voicemail_plan)) IN ('true', 'yes', '1', 'y') THEN 1
        WHEN LOWER(TRIM(voicemail_plan)) IN ('false', 'no', '0', 'n') THEN 0
        ELSE NULL
    END AS voicemail_plan,
 
    -- multiple_lines
    TRIM(multiple_lines) AS multiple_lines,
 
    -- Add-on services: left as trimmed raw values, NULLs preserved on purpose.
    -- Do NOT coalesce to 'Unknown' here -- these NULLs are meaningful when
    -- data_plan = 'No' (service not applicable) and that distinction needs to
    -- survive into Gold/Power BI, where it gets labeled 'No Data Plan'.
    TRIM(online_security)    AS online_security,
    TRIM(online_backup)      AS online_backup,
    TRIM(device_protection)  AS device_protection,
    TRIM(tech_support)       AS tech_support,
    TRIM(streaming_tv)       AS streaming_tv,
    TRIM(streaming_movies)   AS streaming_movies,
 
    -- Usage
    COALESCE(TRY_CAST(TRIM(data_usage_gb) AS DECIMAL(10,2)), 0) AS data_usage_gb,
    COALESCE(TRY_CAST(TRIM(total_day_minutes) AS DECIMAL(10,2)), 0) AS total_day_minutes,
    COALESCE(TRY_CAST(TRIM(total_eve_minutes) AS DECIMAL(10,2)), 0) AS total_eve_minutes,
    COALESCE(TRY_CAST(TRIM(total_night_minutes) AS DECIMAL(10,2)), 0) AS total_night_minutes,
 
    COALESCE(TRY_CAST(TRIM(total_day_calls) AS SMALLINT), 0) AS total_day_calls,
    COALESCE(TRY_CAST(TRIM(total_eve_calls) AS SMALLINT), 0) AS total_eve_calls,
    COALESCE(TRY_CAST(TRIM(total_night_calls) AS SMALLINT), 0) AS total_night_calls,
 
    COALESCE(TRY_CAST(TRIM(customer_service_calls) AS TINYINT), 0) AS customer_service_calls,
 
    -- monthly_charges (remove currency symbols / encoding artifacts)
    COALESCE(
        TRY_CAST(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                TRIM(monthly_charges), 'Γé¼', ''), 'Γé╣', ''), '€', ''), '₹', ''), ',', ''), ' ', '')
        AS DECIMAL(10,2)), 0) AS monthly_charges,
 
    -- total_charges (remove currency symbols / encoding artifacts)
    COALESCE(
        TRY_CAST(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                TRIM(total_charges), 'Γé¼', ''), 'Γé╣', ''), '€', ''), '₹', ''), ',', ''), ' ', '')
        AS DECIMAL(10,2)), 0) AS total_charges,
 
    -- payment_method
    CASE 
        WHEN payment_method IS NULL OR TRIM(payment_method) IN ('', '-', 'null', 'N/A', 'NA', 'Unknown') 
            THEN 'Unknown'
        WHEN LOWER(REPLACE(TRIM(payment_method), ' ', '')) IN ('netbanking') 
            THEN 'Net Banking'
        WHEN LOWER(REPLACE(TRIM(payment_method), ' ', '')) IN ('cash/cheque', 'cashcheque') 
            THEN 'Cash / Cheque'
        WHEN LOWER(REPLACE(TRIM(payment_method), ' ', '')) IN ('debitcard') 
            THEN 'Debit Card'
        WHEN LOWER(REPLACE(TRIM(payment_method), ' ', '')) IN ('creditcard') 
            THEN 'Credit Card'
        WHEN LOWER(TRIM(payment_method)) = 'upi' 
            THEN 'UPI'
        ELSE TRIM(payment_method)
    END AS payment_method,
 
    -- paperless_billing (BIT)
    CASE 
        WHEN LOWER(TRIM(paperless_billing)) IN ('true', 'yes', '1', 'y') THEN 1
        WHEN LOWER(TRIM(paperless_billing)) IN ('false', 'no', '0', 'n') THEN 0
        ELSE NULL
    END AS paperless_billing
 
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(TRIM(tenure_months) AS INT) > 0

--SELECT * FROM silver.telecom_churn_raw;

-- cleanup 

/* WITH cleanup_customer_id AS (
    SELECT
        silver_row_id,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY silver_row_id
        ) AS rn
    FROM silver.telecom_churn_raw
)
DELETE FROM silver.telecom_churn_raw
WHERE silver_row_id IN (
    SELECT silver_row_id FROM cleanup_customer_id WHERE rn > 1
); */

--SELECT COUNT(*) FROM silver.telecom_churn_raw;

/* SELECT data_plan
FROM silver.telecom_churn_raw

SELECT data_plan,COUNT(*)
FROM silver.telecom_churn_raw
GROUP BY data_plan

SELECT gender,COUNT(*)
FROM silver.telecom_churn_raw
GROUP BY gender */