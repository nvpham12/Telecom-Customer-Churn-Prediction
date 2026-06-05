-- Set the context
USE DATABASE churn_project_db;
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;

-- Create a table for raw churn data, entering the schema
CREATE OR REPLACE TABLE raw_churn (
    customer_id STRING,
    gender STRING,
    senior_citizen INT,
    partner BOOLEAN,
    dependents BOOLEAN,
    tenure INT,
    phone_service BOOLEAN,
    multiple_lines STRING,
    internet_service STRING,
    online_security STRING,
    online_backup STRING,
    device_protection STRING,
    tech_support STRING,
    streaming_tv STRING,
    streaming_movies STRING,
    contract STRING,
    paperless_billing BOOLEAN,
    payment_method STRING,
    monthly_charges FLOAT,
    total_charges STRING,
    churn BOOLEAN
);

-- Copy data from the csv file over into the newly created table
COPY INTO raw_churn
FROM @churn_stage/Telco-Customer-Churn.csv
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
);