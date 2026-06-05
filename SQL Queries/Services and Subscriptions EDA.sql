-- Queries for Add-ons, Services, and Subscriptions EDA


-- Set context for Snowflake
USE DATABASE churn_project_db;
USE SCHEMA PUBLIC;
USE WAREHOUSE COMPUTE_WH;


-- Find the % of customers who have phone service. Then, of those customers, find how many have multiple lines.
-- Use 2 queries. First query to find the percentage with phone service: 
SELECT
  phone_service,
  COUNT(*) AS counts,
  COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS pct
FROM cleaned_churn
GROUP BY phone_service;


-- Sencond query to find how many have multiple lines:
SELECT
  multiple_lines,
  COUNT(*) AS counts,
  COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS pct
FROM cleaned_churn
WHERE phone_service = 'Yes'
GROUP BY multiple_lines;


-- Find the distribution of internet service types
SELECT
  internet_service,
  COUNT(*) AS counts,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () as pct
FROM cleaned_churn
GROUP BY internet_service;


-- Of those who have internet service, find the percentage that have each addon (online_security, online_backup, device_protection, tech_support, streaming_tv, streaming_movies)
SELECT
  add_on,
  counts,
  counts * 100.0 / total AS percentage,

FROM
  (
    SELECT
      COUNT(*) AS total,
      count_if(online_security = 'Yes') AS online_security,
      count_if(online_backup = 'Yes') AS online_backup,
      count_if(device_protection = 'Yes') AS device_protection,
      count_if(tech_support = 'Yes') AS tech_support,
      count_if(streaming_tv = 'Yes') AS streaming_tv,
      count_if(streaming_movies = 'Yes') AS streaming_movies
    FROM cleaned_churn
    WHERE internet_service != 'No'
  )
    UNPIVOT(counts FOR add_on IN
    (online_security, 
    online_backup, 
    device_protection, 
    tech_support,
    streaming_tv, 
    streaming_movies))
ORDER BY percentage DESC;


-- What combination of add-ons is most common?
SELECT
  concat(
    CASE WHEN internet_service IN ('DSL', 'Fiber optic') THEN internet_service ELSE 'None' END,
    ' | ',
    CASE WHEN online_security = 'Yes' Then 'online_security' Else 'None' End,
    ' | ',
    CASE WHEN online_backup = 'Yes' Then 'online_backup' Else 'None' End,
    ' | ',
    CASE WHEN device_protection = 'Yes' Then 'device_protection' Else 'None' End,
    ' | ',
    CASE WHEN tech_support = 'Yes' Then 'tech_support' Else 'None' End,
    ' | ',
    CASE WHEN streaming_tv = 'Yes' Then 'streaming_tv' Else 'None' End,
    ' | ',
    CASE WHEN streaming_movies = 'Yes' Then 'streaming_movies' Else 'None' End) AS add_on_combination,
  COUNT(*) AS counts,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentages
FROM cleaned_churn
GROUP BY add_on_combination
ORDER BY percentages DESC;


-- What is the churn proportion by internet service type?
SELECT 
  internet_service, 
  churn, 
  total,
  churn_contribution
FROM
  (
    SELECT
      internet_service,
      churn,
      COUNT(*) AS total,
      COUNT(*) * 100.0 / sum(COUNT(*)) OVER () AS churn_contribution
    FROM cleaned_churn
    GROUP BY internet_service, churn
  )
WHERE churn = 'Yes'
ORDER BY churn_contribution DESC;


-- What is the churn rate by internet service type?
SELECT 
  internet_service,
  churn,
  total_in_segment,
  ROUND(total_in_segment * 100.0 / segment_size, 2) AS churn_rate
FROM
  (
    SELECT
      internet_service,
      churn,
      COUNT(*) AS total_in_segment,
      sum(COUNT(*)) OVER (PARTITION BY internet_service) AS segment_size
    FROM cleaned_churn
    GROUP BY internet_service, churn
  )
WHERE churn = 'Yes'
ORDER BY churn_rate DESC;


-- What is the churn rate for each add-on service?
SELECT
  add_on,
  count_if(has_addon = 'Yes' AND churn = 'Yes')
    * 100.0
    / NULLIF(count_if(has_addon = 'Yes'), 0) AS churn_rate_with,
  count_if(has_addon = 'No' AND churn = 'Yes')
    * 100.0
    / NULLIF(count_if(has_addon = 'No'), 0) AS churn_rate_without
FROM
  (
    SELECT
      churn,
      add_on,
      has_addon
    FROM
      cleaned_churn
        UNPIVOT(
          has_addon
            FOR
              add_on IN (
                online_security,
                online_backup,
                device_protection,
                tech_support,
                streaming_tv,
                streaming_movies))
    WHERE internet_service != 'No'
  )
GROUP BY add_on
ORDER BY churn_rate_without DESC;