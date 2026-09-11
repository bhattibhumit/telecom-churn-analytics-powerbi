/* ============================================================
   TELECOM CHURN DATASET - SILVER STAGING PROFILING & EXPLORATION
   Table: silver.telecom_churn_raw_staging
   Purpose: Column-by-column profiling before cleaning into
            silver.telecom_churn_raw
   ============================================================ */

-- Overview
SELECT * FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS Total_rows FROM silver.telecom_churn_raw_staging;


/* ============================================================
   customer_id
   ============================================================ */

-- Total non-null values
SELECT COUNT(customer_id) AS customer_id_total_values
FROM silver.telecom_churn_raw_staging;

-- Distinct values
SELECT COUNT(DISTINCT customer_id) AS customer_id_unique_values
FROM silver.telecom_churn_raw_staging;

-- Total vs unique vs duplicate count, side by side
SELECT
    COUNT(customer_id)                                 AS customer_id_total_values,
    COUNT(DISTINCT customer_id)                         AS customer_id_unique_values,
    COUNT(customer_id) - COUNT(DISTINCT customer_id)    AS duplicate_id_count
FROM silver.telecom_churn_raw_staging;

-- Duplicate customer_id values (raw list)
SELECT customer_id, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check whether NULL customer_id appears more than once
SELECT customer_id
FROM (
    SELECT customer_id, COUNT(*) AS Count_row
    FROM silver.telecom_churn_raw_staging
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS t
WHERE customer_id IS NULL;

-- Distinct customer_id values with their length (pattern check)
SELECT customer_id, LEN(customer_id) AS id_length
FROM silver.telecom_churn_raw_staging
GROUP BY customer_id, LEN(customer_id);

-- Row count where id length > 12 (e.g. CUST-DUP003758 pattern)
SELECT COUNT(*) AS rows_length_gt_12
FROM silver.telecom_churn_raw_staging
WHERE LEN(customer_id) > 12;

-- Pattern breakdown: normal vs DUP-tagged vs unexpected
SELECT
    CASE
        WHEN customer_id LIKE 'CUST-DUP%' THEN 'DUP_pattern'
        WHEN customer_id LIKE 'CUST-%'    THEN 'Normal_pattern'
        ELSE 'Other/Unexpected'
    END AS id_pattern,
    COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY
    CASE
        WHEN customer_id LIKE 'CUST-DUP%' THEN 'DUP_pattern'
        WHEN customer_id LIKE 'CUST-%'    THEN 'Normal_pattern'
        ELSE 'Other/Unexpected'
    END;


/* ============================================================
   gender
   ============================================================ */

SELECT COUNT(gender) AS gender_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT gender) AS gender_unique_values
FROM silver.telecom_churn_raw_staging;

-- Distinct values and their counts (also surfaces NULL/blank rows)
SELECT gender, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY gender;


/* ============================================================
   age
   ============================================================ */

SELECT COUNT(age) AS age_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT age) AS age_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT age, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY age;

-- NULL age rows
SELECT age, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY age
HAVING age IS NULL;

-- Non-numeric age values (would break a straight CAST)
SELECT age, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(age AS INT) IS NULL
  AND age IS NOT NULL
  AND LTRIM(RTRIM(age)) <> ''
GROUP BY age;

-- Out-of-range age values (safe cast, avoids conversion errors on bad data)
SELECT age, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(age AS INT) > 100
   OR TRY_CAST(age AS INT) < 0
GROUP BY age;


/* ============================================================
   senior_citizen
   ============================================================ */

SELECT COUNT(senior_citizen) AS senior_citizen_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT senior_citizen) AS senior_citizen_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT senior_citizen, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY senior_citizen;

SELECT senior_citizen, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY senior_citizen
HAVING senior_citizen IS NULL;


/* ============================================================
   state
   ============================================================ */

SELECT COUNT(state) AS state_total_values
FROM silver.telecom_churn_raw_staging;

-- FIXED: was referencing senior_citizen instead of state
SELECT COUNT(DISTINCT state) AS state_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT state, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY state;

SELECT state, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY state
HAVING state IS NULL;


/* ============================================================
   city_tier
   ============================================================ */

SELECT COUNT(city_tier) AS city_tier_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT city_tier) AS city_tier_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT city_tier, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY city_tier;

SELECT city_tier, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY city_tier
HAVING city_tier IS NULL;


/* ============================================================
   tenure_months
   ============================================================ */

SELECT COUNT(tenure_months) AS tenure_months_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT tenure_months) AS tenure_months_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT tenure_months, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY tenure_months;

SELECT tenure_months, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY tenure_months
HAVING tenure_months IS NULL;


/* ============================================================
   contract_type
   ============================================================ */

SELECT COUNT(contract_type) AS contract_type_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT contract_type) AS contract_type_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT contract_type, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY contract_type;

SELECT contract_type, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY contract_type
HAVING contract_type IS NULL;


/* ============================================================
   plan_type
   ============================================================ */

SELECT COUNT(plan_type) AS plan_type_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT plan_type) AS plan_type_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT plan_type, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY plan_type;

SELECT plan_type, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY plan_type
HAVING plan_type IS NULL;


/* ============================================================
   data_plan
   ============================================================ */

SELECT COUNT(data_plan) AS data_plan_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT data_plan) AS data_plan_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT data_plan, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY data_plan;

SELECT data_plan, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY data_plan
HAVING data_plan IS NULL;


/* ============================================================
   international_plan
   ============================================================ */

SELECT COUNT(international_plan) AS international_plan_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT international_plan) AS international_plan_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT international_plan, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY international_plan;

SELECT international_plan, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY international_plan
HAVING international_plan IS NULL;


/* ============================================================
   voicemail_plan
   ============================================================ */

SELECT COUNT(voicemail_plan) AS voicemail_plan_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT voicemail_plan) AS voicemail_plan_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT voicemail_plan, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY voicemail_plan;

SELECT voicemail_plan, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY voicemail_plan
HAVING voicemail_plan IS NULL;


/* ============================================================
   multiple_lines
   ============================================================ */

SELECT COUNT(multiple_lines) AS multiple_lines_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT multiple_lines) AS multiple_lines_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT multiple_lines, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY multiple_lines;

SELECT multiple_lines, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY multiple_lines
HAVING multiple_lines IS NULL;


/* ============================================================
   online_security
   ============================================================ */

SELECT COUNT(online_security) AS online_security_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT online_security) AS online_security_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT online_security, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY online_security;

SELECT online_security, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY online_security
HAVING online_security IS NULL;


/* ============================================================
   online_backup
   ============================================================ */

SELECT COUNT(online_backup) AS online_backup_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT online_backup) AS online_backup_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT online_backup, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY online_backup;

SELECT online_backup, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY online_backup
HAVING online_backup IS NULL;


/* ============================================================
   device_protection
   ============================================================ */

SELECT COUNT(device_protection) AS device_protection_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT device_protection) AS device_protection_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT device_protection, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY device_protection;

SELECT device_protection, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY device_protection
HAVING device_protection IS NULL;


/* ============================================================
   tech_support
   ============================================================ */

SELECT COUNT(tech_support) AS tech_support_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT tech_support) AS tech_support_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT tech_support, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY tech_support;

SELECT tech_support, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY tech_support
HAVING tech_support IS NULL;


/* ============================================================
   streaming_tv
   ============================================================ */

SELECT COUNT(streaming_tv) AS streaming_tv_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT streaming_tv) AS streaming_tv_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT streaming_tv, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY streaming_tv;

SELECT streaming_tv, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY streaming_tv
HAVING streaming_tv IS NULL;


/* ============================================================
   streaming_movies
   ============================================================ */

SELECT COUNT(streaming_movies) AS streaming_movies_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT streaming_movies) AS streaming_movies_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT streaming_movies, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY streaming_movies;

SELECT streaming_movies, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY streaming_movies
HAVING streaming_movies IS NULL;


/* ============================================================
   payment_method
   ============================================================ */

SELECT COUNT(payment_method) AS payment_method_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT payment_method) AS payment_method_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT payment_method, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY payment_method;

SELECT payment_method, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY payment_method
HAVING payment_method IS NULL;


/* ============================================================
   paperless_billing
   ============================================================ */

SELECT COUNT(paperless_billing) AS paperless_billing_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT paperless_billing) AS paperless_billing_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT paperless_billing, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY paperless_billing;

SELECT paperless_billing, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY paperless_billing
HAVING paperless_billing IS NULL;


/* ============================================================
   total_day_minutes
   ============================================================ */

SELECT COUNT(total_day_minutes) AS total_day_minutes_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_day_minutes) AS total_day_minutes_unique_values
FROM silver.telecom_churn_raw_staging;

-- NULL / blank check
SELECT COUNT(*) AS total_day_minutes_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_day_minutes IS NULL OR LTRIM(RTRIM(total_day_minutes)) = '';

-- Non-numeric junk values (would break a straight CAST)
SELECT total_day_minutes, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_day_minutes AS FLOAT) IS NULL
  AND total_day_minutes IS NOT NULL
  AND LTRIM(RTRIM(total_day_minutes)) <> ''
GROUP BY total_day_minutes;

-- Range check (min / max / avg on valid numeric values)
SELECT
    MIN(TRY_CAST(total_day_minutes AS FLOAT)) AS min_val,
    MAX(TRY_CAST(total_day_minutes AS FLOAT)) AS max_val,
    AVG(TRY_CAST(total_day_minutes AS FLOAT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

-- Negative values (shouldn't exist for a minutes field)
SELECT total_day_minutes, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_day_minutes AS FLOAT) < 0
GROUP BY total_day_minutes;


/* ============================================================
   total_eve_minutes
   ============================================================ */

SELECT COUNT(total_eve_minutes) AS total_eve_minutes_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_eve_minutes) AS total_eve_minutes_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS total_eve_minutes_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_eve_minutes IS NULL OR LTRIM(RTRIM(total_eve_minutes)) = '';

SELECT total_eve_minutes, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_eve_minutes AS FLOAT) IS NULL
  AND total_eve_minutes IS NOT NULL
  AND LTRIM(RTRIM(total_eve_minutes)) <> ''
GROUP BY total_eve_minutes;

SELECT
    MIN(TRY_CAST(total_eve_minutes AS FLOAT)) AS min_val,
    MAX(TRY_CAST(total_eve_minutes AS FLOAT)) AS max_val,
    AVG(TRY_CAST(total_eve_minutes AS FLOAT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT total_eve_minutes, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_eve_minutes AS FLOAT) < 0
GROUP BY total_eve_minutes;


/* ============================================================
   total_night_minutes
   ============================================================ */

SELECT COUNT(total_night_minutes) AS total_night_minutes_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_night_minutes) AS total_night_minutes_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS total_night_minutes_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_night_minutes IS NULL OR LTRIM(RTRIM(total_night_minutes)) = '';

SELECT total_night_minutes, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_night_minutes AS FLOAT) IS NULL
  AND total_night_minutes IS NOT NULL
  AND LTRIM(RTRIM(total_night_minutes)) <> ''
GROUP BY total_night_minutes;

SELECT
    MIN(TRY_CAST(total_night_minutes AS FLOAT)) AS min_val,
    MAX(TRY_CAST(total_night_minutes AS FLOAT)) AS max_val,
    AVG(TRY_CAST(total_night_minutes AS FLOAT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT total_night_minutes, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_night_minutes AS FLOAT) < 0
GROUP BY total_night_minutes;


/* ============================================================
   total_intl_minutes
   ============================================================ */

SELECT COUNT(total_intl_minutes) AS total_intl_minutes_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_intl_minutes) AS total_intl_minutes_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS total_intl_minutes_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_intl_minutes IS NULL OR LTRIM(RTRIM(total_intl_minutes)) = '';

SELECT total_intl_minutes, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_intl_minutes AS FLOAT) IS NULL
  AND total_intl_minutes IS NOT NULL
  AND LTRIM(RTRIM(total_intl_minutes)) <> ''
GROUP BY total_intl_minutes;

SELECT
    MIN(TRY_CAST(total_intl_minutes AS FLOAT)) AS min_val,
    MAX(TRY_CAST(total_intl_minutes AS FLOAT)) AS max_val,
    AVG(TRY_CAST(total_intl_minutes AS FLOAT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT total_intl_minutes, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_intl_minutes AS FLOAT) < 0
GROUP BY total_intl_minutes;


/* ============================================================
   total_day_calls
   ============================================================ */

SELECT COUNT(total_day_calls) AS total_day_calls_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_day_calls) AS total_day_calls_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS total_day_calls_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_day_calls IS NULL OR LTRIM(RTRIM(total_day_calls)) = '';

SELECT total_day_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_day_calls AS INT) IS NULL
  AND total_day_calls IS NOT NULL
  AND LTRIM(RTRIM(total_day_calls)) <> ''
GROUP BY total_day_calls;

SELECT
    MIN(TRY_CAST(total_day_calls AS INT)) AS min_val,
    MAX(TRY_CAST(total_day_calls AS INT)) AS max_val,
    AVG(TRY_CAST(total_day_calls AS INT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT total_day_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_day_calls AS INT) < 0
GROUP BY total_day_calls;


/* ============================================================
   total_eve_calls
   ============================================================ */

SELECT COUNT(total_eve_calls) AS total_eve_calls_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_eve_calls) AS total_eve_calls_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS total_eve_calls_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_eve_calls IS NULL OR LTRIM(RTRIM(total_eve_calls)) = '';

SELECT total_eve_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_eve_calls AS INT) IS NULL
  AND total_eve_calls IS NOT NULL
  AND LTRIM(RTRIM(total_eve_calls)) <> ''
GROUP BY total_eve_calls;

SELECT
    MIN(TRY_CAST(total_eve_calls AS INT)) AS min_val,
    MAX(TRY_CAST(total_eve_calls AS INT)) AS max_val,
    AVG(TRY_CAST(total_eve_calls AS INT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT total_eve_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_eve_calls AS INT) < 0
GROUP BY total_eve_calls;


/* ============================================================
   total_night_calls
   ============================================================ */

SELECT COUNT(total_night_calls) AS total_night_calls_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_night_calls) AS total_night_calls_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS total_night_calls_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_night_calls IS NULL OR LTRIM(RTRIM(total_night_calls)) = '';

SELECT total_night_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_night_calls AS INT) IS NULL
  AND total_night_calls IS NOT NULL
  AND LTRIM(RTRIM(total_night_calls)) <> ''
GROUP BY total_night_calls;

SELECT
    MIN(TRY_CAST(total_night_calls AS INT)) AS min_val,
    MAX(TRY_CAST(total_night_calls AS INT)) AS max_val,
    AVG(TRY_CAST(total_night_calls AS INT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT total_night_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_night_calls AS INT) < 0
GROUP BY total_night_calls;


/* ============================================================
   total_intl_calls
   ============================================================ */

SELECT COUNT(total_intl_calls) AS total_intl_calls_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_intl_calls) AS total_intl_calls_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS total_intl_calls_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_intl_calls IS NULL OR LTRIM(RTRIM(total_intl_calls)) = '';

SELECT total_intl_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_intl_calls AS INT) IS NULL
  AND total_intl_calls IS NOT NULL
  AND LTRIM(RTRIM(total_intl_calls)) <> ''
GROUP BY total_intl_calls;

SELECT
    MIN(TRY_CAST(total_intl_calls AS INT)) AS min_val,
    MAX(TRY_CAST(total_intl_calls AS INT)) AS max_val,
    AVG(TRY_CAST(total_intl_calls AS INT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT total_intl_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_intl_calls AS INT) < 0
GROUP BY total_intl_calls;


/* ============================================================
   customer_service_calls
   ============================================================ */

SELECT COUNT(customer_service_calls) AS customer_service_calls_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT customer_service_calls) AS customer_service_calls_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS customer_service_calls_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE customer_service_calls IS NULL OR LTRIM(RTRIM(customer_service_calls)) = '';

SELECT customer_service_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(customer_service_calls AS INT) IS NULL
  AND customer_service_calls IS NOT NULL
  AND LTRIM(RTRIM(customer_service_calls)) <> ''
GROUP BY customer_service_calls;

SELECT
    MIN(TRY_CAST(customer_service_calls AS INT)) AS min_val,
    MAX(TRY_CAST(customer_service_calls AS INT)) AS max_val,
    AVG(TRY_CAST(customer_service_calls AS INT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT customer_service_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(customer_service_calls AS INT) < 0
GROUP BY customer_service_calls;

-- Distribution of call counts (low cardinality, useful to see full spread)
SELECT customer_service_calls, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
GROUP BY customer_service_calls
ORDER BY TRY_CAST(customer_service_calls AS INT);


/* ============================================================
   monthly_charges
   ============================================================ */

SELECT COUNT(monthly_charges) AS monthly_charges_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT monthly_charges) AS monthly_charges_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS monthly_charges_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE monthly_charges IS NULL OR LTRIM(RTRIM(monthly_charges)) = '';

SELECT monthly_charges, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(monthly_charges AS FLOAT) IS NULL
  AND monthly_charges IS NOT NULL
  AND LTRIM(RTRIM(monthly_charges)) <> ''
GROUP BY monthly_charges;

SELECT
    MIN(TRY_CAST(monthly_charges AS FLOAT)) AS min_val,
    MAX(TRY_CAST(monthly_charges AS FLOAT)) AS max_val,
    AVG(TRY_CAST(monthly_charges AS FLOAT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT monthly_charges, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(monthly_charges AS FLOAT) < 0
GROUP BY monthly_charges;


/* ============================================================
   total_charges
   ============================================================ */

SELECT COUNT(total_charges) AS total_charges_total_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(DISTINCT total_charges) AS total_charges_unique_values
FROM silver.telecom_churn_raw_staging;

SELECT COUNT(*) AS total_charges_null_or_blank
FROM silver.telecom_churn_raw_staging
WHERE total_charges IS NULL OR LTRIM(RTRIM(total_charges)) = '';

SELECT total_charges, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_charges AS FLOAT) IS NULL
  AND total_charges IS NOT NULL
  AND LTRIM(RTRIM(total_charges)) <> ''
GROUP BY total_charges;

SELECT
    MIN(TRY_CAST(total_charges AS FLOAT)) AS min_val,
    MAX(TRY_CAST(total_charges AS FLOAT)) AS max_val,
    AVG(TRY_CAST(total_charges AS FLOAT)) AS avg_val
FROM silver.telecom_churn_raw_staging;

SELECT total_charges, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE TRY_CAST(total_charges AS FLOAT) < 0
GROUP BY total_charges;

-- Cross-check: blank total_charges often correlates with 0 tenure (classic pattern in this dataset)
SELECT tenure_months, total_charges, COUNT(*) AS Count_row
FROM silver.telecom_churn_raw_staging
WHERE total_charges IS NULL OR LTRIM(RTRIM(total_charges)) = ''
GROUP BY tenure_months, total_charges;

-- churn

SELECT churn , COUNT(*)
FROM silver.telecom_churn_raw_staging
GROUP BY churn


SELECT customer_id, COUNT(*) AS row_count, COUNT(DISTINCT CONCAT_WS('|',
    gender, age, senior_citizen, state, city_tier, tenure_months,
    contract_type, plan_type, data_plan, international_plan, voicemail_plan,
    multiple_lines, online_security, online_backup, device_protection,
    tech_support, streaming_tv, streaming_movies, data_usage_gb,
    total_day_minutes, total_eve_minutes, total_night_minutes, total_intl_minutes,
    total_day_calls, total_eve_calls, total_night_calls, total_intl_calls,
    customer_service_calls, monthly_charges, total_charges,
    payment_method, paperless_billing, churn
)) AS distinct_data_versions
FROM silver.telecom_churn_raw_staging
GROUP BY customer_id
HAVING COUNT(*) > 1;


SELECT * FROM silver.telecom_churn_raw_staging