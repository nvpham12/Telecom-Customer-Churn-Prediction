-- Queries for Tenure and Senior Citizen EDA


-- Set context for Snowflake
USE DATABASE churn_project_db;
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;


-- Compute summary statistics for tenure
SELECT
  min(tenure) AS min_tenure,
  max(tenure) AS max_tenure,
  avg(tenure) AS avg_tenure,
  stddev(tenure) as stddev_tenure,
  median(tenure) as median_tenure
FROM cleaned_churn;


-- Find average tenure for churning and non-churning customers
SELECT churn, avg(tenure) as avg_tenure
FROM cleaned_churn
GROUP BY churn;


-- Find the churn contributions for each tenure bucket
-- Create a view for reuse when finding churn rates
CREATE VIEW IF NOT EXISTS tenure_buckets AS
(
  SELECT
    CASE
    WHEN tenure BETWEEN 0 AND 12 THEN '0-12'
    WHEN tenure BETWEEN 13 AND 24 THEN '13-24'
    WHEN tenure BETWEEN 25 AND 36 THEN '25-36'
    WHEN tenure BETWEEN 37 AND 48 THEN '37-48'
    WHEN tenure BETWEEN 49 AND 60 THEN '49-60'
    WHEN tenure BETWEEN 61 AND 72 THEN '61-72'
    END AS tenure_bucket,
    churn,
  FROM cleaned_churn  
); 
-- Query for churn contributions using the view
SELECT 
  tenure_bucket,
  churn,
  total,
  churn_contribution
FROM (
      SELECT 
        tenure_bucket,
        churn,
        COUNT(*) as total,
        COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS churn_contribution
      FROM tenure_buckets
      GROUP BY tenure_bucket, churn
)
WHERE churn = 'Yes'
ORDER BY churn_contribution DESC;


-- Find churn rates across tenure buckets
SELECT 
  tenure_bucket, 
  churn,
  total_in_segment,
  ROUND(total_in_segment * 100.0 / segment_size, 2) AS churn_rate
FROM (
      SELECT 
        tenure_bucket,
        churn,
        COUNT(*) as total_in_segment,
        SUM(COUNT(*)) OVER (PARTITION BY tenure_bucket) as segment_size
      FROM tenure_buckets
      GROUP BY tenure_bucket, churn
)
WHERE churn = 'Yes'
ORDER BY churn_rate DESC;


-- Compute the percentage of customers who have churned overall
SELECT overall_pct_churn
FROM
  (
    SELECT
      churn,
      COUNT(*) AS churn_counts,
      COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS overall_pct_churn
    FROM cleaned_churn
    GROUP BY churn
  )
WHERE churn = 'Yes';


-- Find the churn contribution of senior citizens and non-senior citizens
SELECT senior_citizen, churn, total, churn_contribution
FROM
  (
    SELECT
      senior_citizen,
      churn,
      COUNT(*) AS total,
      COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS churn_contribution
    FROM cleaned_churn
    GROUP BY senior_citizen, churn
  )
WHERE churn = 'Yes'
ORDER BY churn_contribution DESC;


-- Find the churn rates for senior citizens and non-senior citizens
SELECT 
  senior_citizen, 
  churn, 
  total_in_segment, 
  ROUND(total_in_segment * 100.0 / segment_size, 2) AS churn_rate
FROM
  (
    SELECT
      senior_citizen,
      churn,
      COUNT(*) AS total_in_segment,
      SUM(COUNT(*)) OVER (PARTITION BY senior_citizen) AS segment_size
    FROM cleaned_churn
    GROUP BY senior_citizen, churn
  )
WHERE churn = 'Yes'
ORDER BY churn_rate DESC;