
-- dim_customer = Details about the customer 

CREATE VIEW gold.dim_customer AS
SELECT
    customer_id,
    gender,
    age,
    senior_citizen,
    state,
    city_tier
FROM silver.telecom_churn_raw;
GO

-- dim_account = Details about customer accounts

CREATE VIEW gold.dim_account AS
SELECT
    customer_id,
    contract_type,
    plan_type,
    data_plan,
    payment_method,
    paperless_billing
FROM silver.telecom_churn_raw;
GO

-- dim_services = Details about Service used by customer

CREATE VIEW gold.dim_services AS
SELECT
    customer_id,
    multiple_lines, 
    online_security, 
    online_backup, 
    device_protection,
    tech_support, 
    streaming_tv, 
    streaming_movies, 
    international_plan, 
    voicemail_plan
FROM silver.telecom_churn_raw;
GO

-- fact_usage_billing = Service usage detail used by 

CREATE VIEW gold.fact_usage_billing AS
SELECT
    customer_id, 
    tenure_months, 
    data_usage_gb,
    total_day_minutes, 
    total_eve_minutes, 
    total_night_minutes,
    total_day_calls, 
    total_eve_calls, 
    total_night_calls,
    customer_service_calls, 
    monthly_charges, 
    total_charges
FROM silver.telecom_churn_raw;
GO

/*
DROP VIEW gold.dim_customer
DROP VIEW gold.dim_account
DROP VIEW gold.dim_services
DROP VIEW gold.fact_usage_billing */

--cust
WITH dup_id_cust AS
(SELECT customer_id ,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY customer_id) as rnk
FROM gold.dim_customer)

DELETE FROM gold.dim_customer
WHERE customer_id IN (
    SELECT customer_id FROM dup_id_cust WHERE rnk > 1
);

--account
WITH dup_id_acc AS
(SELECT customer_id ,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY customer_id) as rnk
FROM gold.dim_account)

DELETE FROM gold.dim_account
WHERE customer_id IN (
    SELECT customer_id FROM dup_id_acc WHERE rnk > 1
);

-- Service 
WITH dup_id_ser AS
(SELECT customer_id ,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY customer_id) as rnk
FROM gold.dim_services)

DELETE FROM gold.dim_services
WHERE customer_id IN (
    SELECT customer_id FROM dup_id_ser WHERE rnk > 1
);


SELECT customer_id,COUNT(*)
FROM gold.dim_customer
GROUP BY customer_id

