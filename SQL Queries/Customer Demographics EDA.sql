-- Queries for Customer Demographic EDA

-- Set context for Snowflake
USE DATABASE churn_project_db;
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;


-- Find the counts and percentages of each gender
SELECT
  gender,
  COUNT(*) AS count_gender,
  COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS pct_gender -- multiplication by 100.0 to convert to percent while preventing truncation and incorrect calculations
FROM cleaned_churn
GROUP BY gender;


-- Finds the counts and percentages of those with partners
SELECT
  partner,
  COUNT(*) AS count_partner,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS pct_partner
FROM cleaned_churn
GROUP BY partner;


-- Are dependents and partners correlated?
SELECT
  partner,
  dependents,
  COUNT(*) AS count,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS pct
FROM cleaned_churn
GROUP BY partner, dependents
ORDER BY partner, dependents;
-- Not having a partner is a strong predictor of having no dependents. 
-- Having a partner is a weak predictor of having or not having dependents.


-- Find the counts and percentages of Senior Citizens
SELECT
  senior_citizen,
  COUNT(*) AS count_seniorcitizen,
  COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS pct_senior_citizen
FROM cleaned_churn
GROUP BY senior_citizen;


-- Find the churn contribution for senior citizens and non-senior citizens
SELECT 
  senior_citizen,
  churn,
  total,
  churn_contribution
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
  ROUND(total_in_segment * 100.0 / segment_size,2) AS churn_rate

FROM (
  SELECT
    senior_citizen,
    churn,
    COUNT(*) AS total_in_segment,
    SUM(COUNT(*)) OVER(PARTITION BY senior_citizen) AS segment_size
  FROM cleaned_churn
  GROUP BY senior_citizen, churn
)
WHERE churn = 'Yes'
ORDER BY churn_rate;