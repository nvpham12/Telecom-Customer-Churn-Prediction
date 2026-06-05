-- Queries for Billing/Revenue EDA


-- Set context for Snowflake
USE DATABASE churn_project_db;
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;


-- Find the summary statistics for monthly charges
SELECT
  min(monthly_charges) as min_monthly_charges,
  max(monthly_charges) as max_monthly_charges,
  avg(monthly_charges) as avg_monthly_charges,
  stddev(monthly_charges) as std_dev_monthly_charges
FROM cleaned_churn;


-- Find the summary statistics for total charges
SELECT
  min(total_charges) as min_total_charges,
  max(total_charges) as max_total_charges,
  avg(total_charges) as avg_total_charges,
  stddev(total_charges) as std_dev_total_charges
FROM cleaned_churn;


-- Find the average monthly charges by contract types
SELECT contract, avg(monthly_charges) AS avg_monthly_charges
FROM cleaned_churn
GROUP BY contract
ORDER BY avg_monthly_charges;


-- Find the average monthly charges by churn status
SELECT churn, avg(monthly_charges) AS avg_monthly_charges
FROM cleaned_churn
GROUP BY churn
ORDER BY avg_monthly_charges;


-- Find the most popular payment method and determine if it correlates with churn
-- Write 2 queries. The first query finds the most popular payment method
SELECT
  payment_method,
  COUNT(*) AS counts,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentages
FROM cleaned_churn
GROUP BY payment_method
ORDER BY counts DESC;


-- Determine if payment methods correlate with churn.
-- Use a second query to compute churn rates for each payment method, then compare.
SELECT 
  payment_method,
  churn,
  total_in_segment, 
  ROUND(total_in_segment * 100.0 / segment_size, 2) AS churn_rate
FROM(
      SELECT
        payment_method,
        churn,
        COUNT(*) AS total_in_segment,
        SUM(COUNT(*)) OVER (PARTITION BY payment_method) AS segment_size
      FROM cleaned_churn
      GROUP BY payment_method, churn
)
where churn = 'Yes'
Order by churn_rate;


-- Are there customers where total_charges seems inconsistent with tenure × monthly_charges?
SELECT
  COUNT(*) AS total_counts,
  SUM(
    CASE
      WHEN ABS(total_charges - (tenure * monthly_charges)) <= 0.01 THEN 1
      ELSE 0
      END)  -- 0.01 is used to exclude tiny differences from any rounding
    AS charge_matches,
  SUM(
    CASE
      WHEN ABS(total_charges - (tenure * monthly_charges)) > 0.01 THEN 1
      ELSE 0
      END)
    AS charge_mismatches
FROM cleaned_churn;


-- Compute (tenure * monthly charges) and compare to each customers' total charges, calculating differences between them.
-- Create a view storing the results for later use
CREATE VIEW IF NOT EXISTS charge_reconciliation
AS (
  SELECT
    customer_id,
    tenure,
    monthly_charges,
    total_charges,
    tenure * monthly_charges AS estimated_charges,
    ABS(total_charges - (tenure * monthly_charges)) AS abs_differences, -- absolute value is used to include positive and negative differences
    CASE
      WHEN total_charges - (tenure * monthly_charges) > 0 THEN 'Positive'
      WHEN total_charges - (tenure * monthly_charges) = 0 THEN 'No Difference'
      ELSE 'Negative'
      END AS difference_direction
  FROM cleaned_churn
  WHERE
    ABS(total_charges - (tenure * monthly_charges))
      > 0.01  -- 0.01 is used to exclude tiny differences from any rounding
    AND total_charges IS NOT NULL
  ORDER BY abs_differences DESC
);
-- Query the view
SELECT
  customer_id,
  tenure,
  monthly_charges,
  total_charges,
  estimated_charges,
  abs_differences,
  difference_direction
FROM charge_reconciliation;
/*
- Total charges don't add up to (tenure * monthly charges)
- Possible explanations for mismatches: discounts, partial billing due to start times, rounding at the source, taxes, changed monthly charges.
*/


-- Find the percentages of difference directions
SELECT
  difference_direction,
  COUNT(*) AS counts,
  COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS percentages
FROM charge_reconciliation
GROUP BY difference_direction;


-- Find churn contribution across monthly charge buckets
-- Create a view for reuse when computing churn rates
CREATE VIEW IF NOT EXISTS monthly_charge_buckets AS 
(
  SELECT
    CASE
      WHEN monthly_charges BETWEEN 0 AND 25 THEN '0-25'
      WHEN monthly_charges BETWEEN 26 AND 50 THEN '26-50'
      WHEN monthly_charges BETWEEN 51 AND 75 THEN '51-75'
      WHEN monthly_charges BETWEEN 76 AND 100 THEN '76-100'
      ELSE 'Other'
      END AS monthly_charge_bucket,
  churn
  FROM cleaned_churn
);


-- Query for churn contributions using the view
SELECT 
  monthly_charge_bucket, 
  churn,
  total, 
  churn_contribution
FROM
  (
    SELECT
      monthly_charge_bucket,
      churn,
      COUNT(*) AS total,
      COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS churn_contribution
    FROM monthly_charge_buckets
    GROUP BY monthly_charge_bucket, churn
  )
WHERE churn = 'Yes'
ORDER BY monthly_charge_bucket;


-- Find churn rates across monthly charge buckets
SELECT
  monthly_charge_bucket,
  churn,
  total_in_segment,
  ROUND(total_in_segment * 100.0 / segment_size, 2) AS churn_rate
FROM
(
  SELECT 
    monthly_charge_bucket,
    churn, 
    count(*) as total_in_segment,
    SUM(COUNT(*)) OVER (PARTITION BY monthly_charge_bucket) as segment_size
  FROM monthly_charge_buckets
  GROUP BY monthly_charge_bucket, churn
)
WHERE churn = 'Yes'
ORDER BY monthly_charge_bucket
;


-- Find churn contribution across total charge buckets
-- Create a view for reuse when computing churn rates
CREATE VIEW IF NOT EXISTS total_charge_buckets 
AS (
    SELECT
      CASE
        WHEN total_charges BETWEEN 0 AND 250 THEN '0-250'
        WHEN total_charges BETWEEN 251 AND 500 THEN '251-500'
        WHEN total_charges BETWEEN 501 AND 750 THEN '501-750'
        WHEN total_charges BETWEEN 751 AND 1000 THEN '751-1000'
        WHEN total_charges BETWEEN 1001 AND 1250 THEN '1001-1250'
        WHEN total_charges BETWEEN 1251 AND 1500 THEN '1251-1500'
        WHEN total_charges BETWEEN 1501 AND 1750 THEN '1501-1750'
        WHEN total_charges BETWEEN 1751 AND 2000 THEN '1751-2000'
        ELSE 'Other'
        END AS total_charge_bucket,
        CASE
        WHEN total_charges BETWEEN 0 AND 250 THEN 1
        WHEN total_charges BETWEEN 251 AND 500 THEN 2
        WHEN total_charges BETWEEN 501 AND 750 THEN 3
        WHEN total_charges BETWEEN 751 AND 1000 THEN 4
        WHEN total_charges BETWEEN 1001 AND 1250 THEN 5
        WHEN total_charges BETWEEN 1251 AND 1500 THEN 6
        WHEN total_charges BETWEEN 1501 AND 1750 THEN 7
        WHEN total_charges BETWEEN 1751 AND 2000 THEN 8
        ELSE 9
        END AS bucket_order, -- create a bucket ordering to avoid alphabetical sorting
      churn
    FROM cleaned_churn
);
-- Query for churn contributions using the view
SELECT 
  total_charge_bucket, 
  churn, 
  total, 
  churn_contribution
FROM
  (
    SELECT
      total_charge_bucket,
      bucket_order,
      churn,
      COUNT(*) AS total,
      COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS churn_contribution
    FROM total_charge_buckets
    GROUP BY total_charge_bucket, bucket_order, churn
  )
WHERE churn = 'Yes'
ORDER BY bucket_order;

-- Find the churn rates across total charge buckets
SELECT 
  total_charge_bucket, 
  churn, 
  total_in_segment, 
  ROUND(total_in_segment * 100.0 / segment_size) AS churn_rate
FROM
  (
    SELECT
      total_charge_bucket,
      bucket_order,
      churn,
      COUNT(*) AS total_in_segment,
      SUM(COUNT(*)) OVER (PARTITION BY total_charge_bucket) AS segment_size
    FROM total_charge_buckets
    GROUP BY total_charge_bucket, bucket_order, churn
  )
WHERE churn = 'Yes'
ORDER BY bucket_order;

-- What is the churn contribution for paperless_billing?
SELECT 
  paperless_billing, 
  churn, 
  total,
  churn_contribution
FROM
  (
    SELECT
      paperless_billing,
      churn,
      COUNT(*) AS total,
      COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS churn_contribution
    FROM cleaned_churn
    GROUP BY paperless_billing, churn
  )
WHERE churn = 'Yes';

-- What is the churn rate for paperless_billing?
SELECT 
  paperless_billing, 
  churn, 
  total_in_segment,
  ROUND(total_in_segment * 100.0 / segment_size, 2) AS churn_rate
FROM
  (
    SELECT
      paperless_billing,
      churn,
      COUNT(*) AS total_in_segment,
      SUM(COUNT(*)) OVER (PARTITION BY paperless_billing) AS segment_size
    FROM cleaned_churn
    GROUP BY paperless_billing, churn
  )
WHERE churn = 'Yes';

-- Who are the "high-value churners"; churned customers with monthly_charges above the average?
SELECT 
  customer_id, 
  monthly_charges
FROM
  (
    SELECT
      customer_id,
      monthly_charges,
      avg(monthly_charges) OVER () AS threshold
    FROM cleaned_churn
  )
WHERE monthly_charges > threshold;