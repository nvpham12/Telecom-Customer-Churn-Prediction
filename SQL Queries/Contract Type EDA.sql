-- Queries for contract Type EDA


-- Set context for Snowflake
USE DATABASE churn_project_db;
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;


-- What is the breakdown of customers by contract type (Month-to-month, One year, Two year)?
SELECT contract, COUNT(*), COUNT(*) * 100.0 / sum(COUNT(*)) over() AS percentage
FROM cleaned_churn
GROUP BY contract
ORDER BY percentage DESC;


-- Find churn contribution across contract types
SELECT contract, churn, total, churn_contribution
FROM
  (
    SELECT
      contract,
      churn,
      COUNT(*) AS total,
      COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS churn_contribution
    FROM cleaned_churn
    GROUP BY contract, churn
  )
WHERE churn = 'Yes'
ORDER BY churn_contribution DESC;


-- Find churn rate across contract types
SELECT 
    contract, 
    churn, 
    total_in_segment,
    ROUND(total_in_segment * 100.0 / segment_size, 2) AS churn_rate
FROM (
    SELECT 
        contract, 
        churn, 
        COUNT(*) AS total_in_segment,
        SUM(COUNT(*)) OVER (PARTITION BY contract) AS segment_size
    FROM cleaned_churn
    GROUP BY contract, churn
)
WHERE churn = 'Yes'
ORDER BY churn_rate DESC;


-- What is the average tenure by contract type?
SELECT contract, avg(tenure) AS avg_tenure
FROM cleaned_churn
GROUP BY contract
ORDER BY avg(tenure) DESC;