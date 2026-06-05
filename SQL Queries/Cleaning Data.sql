-- Set Context
USE DATABASE churn_project_db;
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

/*
This query
- deduplicates with SELECT DISTINCT
- uses a CASE statement to reformat the SeniorCitizen, Partner, Dependents, PhoneService, PaperlessBilling, and Churn columns
- removes the '(automatic)' in some payment methods to reduce redundancyng values for 1st month customers with Monthly Charges)
- makes a new table with the cleaned dataset, keeping raw data untouched
- cleans TotalCharges (casting to Float, removing null values, and imputing missi
*/
CREATE
OR REPLACE TABLE cleaned_churn AS
SELECT
    DISTINCT customer_id,
    gender,
    CASE
        senior_citizen
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE NULL -- Maps boolean flags to the more interpretable 'Yes' and 'No'
    END AS senior_citizen,
    CASE
        partner
        WHEN FALSE THEN 'No'
        WHEN TRUE THEN 'Yes'
        ELSE NULL
    END AS partner,
    CASE
        dependents
        WHEN FALSE THEN 'No'
        WHEN TRUE THEN 'Yes'
        ELSE NULL
    END AS dependents,
    tenure AS tenure,
    CASE
        phone_service
        WHEN FALSE THEN 'No'
        WHEN TRUE THEN 'Yes'
        ELSE NULL
    END AS phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    CASE
        paperless_billing
        WHEN FALSE THEN 'No'
        WHEN TRUE THEN 'Yes'
        ELSE NULL
    END AS paperless_billing,
    Replace(payment_method, ' (automatic)', '') as payment_method, -- removes the phrase '(automatic)' from a certain payment method, since it's already implied by that method.
    monthly_charges,
    COALESCE(
        CAST(NULLIF(TRIM(total_charges), '') AS float),
        monthly_charges
    ) -- Processes missing values that show up as empty strings before changing data type to float then imputing monthly charges.
    AS total_charges,
    CASE
        churn
        WHEN FALSE THEN 'No'
        WHEN TRUE THEN 'Yes'
        ELSE NULL
    END AS churn
FROM
    raw_churn;