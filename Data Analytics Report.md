# Project Background
In this project, data analysis was performed on synthetic telecom customer data. Exploratory data analysis (EDA) was conducted in Python, while data cleaning and deep-dive analysis were executed using SQL within Snowflake via an AWS S3 data pipeline. An interactive dashboard was built in Power BI to visualize key trends, supported by a predictive churn model developed in Python.

## Table of Contents
- [Project Background](#project-background)
- [Executive Summary](#executive-summary)
- [Recommendations](#recommendations)
- [Data](#data)
- [Deep Dive](#deep-dive)
- [Predictive Validation](#predictive-validation)
- [PowerBI Dashboard](#powerbi-dashboard)
- [Appendix](#appendix)

## Business Objective:
Identify customer attributes and behaviors associated with churn to support retention strategies and improve customer experience.

## Key Business Questions
- Which customer segments are most likely to churn?
- When in the customer lifecycle does churn most frequently occur?
- Which products, services, or contract types are most strongly associated with churn?
- Which customer groups should be prioritized for retention investment?

## Architecture
- **Cloud Pipeline:** AWS S3 (Staging) → Snowflake (Transformation/SQL) → Power BI (Reporting)
- **Machine Learning:** Python (Pandas, Scitkit-Learn, XGBoost, Matplotlib/Seaborn) for EDA and predictive modeling.

---

# Executive Summary
## Insights
 **Contract Volatility:** Month-to-month contracts are the primary churn driver, with a 14x higher churn rate than 2-year contracts.

**Digital Payment Friction:** Customers using Electronic Payments have 50% higher churn rates compared to any other payment method.

**12-Month Loyalty Cliff:** The critical retention window occurs in the first 12 months, where churn probability is highest at 47%. Once customers enter their second year, the probability plummets to 28%, indicating that the first year is the most vital period for retention investment.

**Add-on Churn Correlation:** Customers without the Online Security, Tech Support, Online Backup, and Device Protection add-ons have around 2-3x the churn rate compared to those with those add ons.

**Predictive Model:** Developed a predictive model to identify 77% of churners in advance, allowing for proactive intervention.

**Paperless Billing Paradox:** Customers using Paperless Billing have a 33.6% churn rate, nearly double those who receive paper statements (16.3%). This suggests that digital-only billing may reduce a customer’s tactile connection to the service or make it easier to ignore engagement prompts.

**Price Sensitivity Threshold:** Churn rates spike to 37.4% for customers with monthly charges between $76–$100. Conversely, those paying under $25 have a very healthy churn rate of only 9%.

**Senior Risk Segment:** Senior Citizens are a high-risk demographic with a 41.7% churn rate, compared to just 23.6% for non-seniors.

## Recommendations
- **Product:**
    - Bundle Online Security, Tech Support, Device Protection, and Online Backup into higher churn plans to test whether bundled adoption reduces churn relative to standalone pricing. Do this individually for each add-on to allow for targeted A/B testing on whether these add-ons reduce churn rates.
    - Offer promotion such as device discounts or bill credits to encourage customers to lock them into longer contracts.
- **Marketing:**
    - Focus retention efforts on the 11th-month mark to push customers past the 12-month tenure cliff. 
    - Offer contract buyout programs to encourage customers to switch carriers while locking them into longer contracts.
- **Operations:**
    - Investigate the Electronic Check payment gateway for technical failure or high friction, while offering promotional bill credits or discounts to incentivize customers to use other payment methods.
    - Introduce a loyalty program specifically for Paperless Billing customers to increase engagement, as this group is currently 2x more likely to churn.
- **Pricing:** 
    - Analyze the $76–$100 price bracket for value leakage. Determine if competitors are undercutting  at this specific price point and consider offering loyalty discounts to customers approaching this billing threshold.

## Proposed Success Metrics
- Churn rate
- Early-tenure churn (first 1–3 months)
- Contract upgrade conversion rate
- LTV (Lifetime Value) Improvement
- Add-on service adoption rates
- A/B Test significance (measuring retention of bundled add-ons vs control group)

## Limitations
- Assumes the business does not have a free 1 month trial for customers, which determines imputation of missing monthly charges.
- Data does not indicate any discounts or promotions.
- Monthly charges are the most recent monthly charges and any changes are not reflected in the data.

---

# Data
- The data contains information on telecom customer churn and contains 7043 rows and 21 columns.
- Columns include customer demographics and add-on services also offered by the company.
- The data is synthetic, made and shared by IBM.
- From EDA, there are 11 nulls in the data. All of these instances are nulls for total charges from customers who hadn't reached their first billing cycle.

## Data Cleaning
To ensure data integrity, a transformation SQL script to clean the raw dataset was developed. Key operations included:
- **Standardization:** Simplified payment_method strings by removing redundancy and mapped boolean flags to readable "Yes/No" formats.
- **Financial Data Correction:** Identified 11 rows where TotalCharges contained empty strings for customers having a Tenure of 0. Implemented a COALESCE logic to impute these with values for MonthlyCharges.
- **Table Creation:** Created a new table for the cleaned data, ensuring raw data is untouched for auditing/backup purposes.

<details>
<summary><b>Cleaning Script Highlights (Click to expand)</b></summary>

```sql
CREATE
OR REPLACE TABLE cleaned_churn AS
SELECT
    customer_id,
    CASE
        senior_citizen
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE NULL -- Maps boolean flags to the more interpretable 'Yes' and 'No'
    END AS senior_citizen, 
    REPLACE(payment_method, ' (automatic)', '') AS payment_method, -- removes the phrase '(automatic)' from a certain payment method, since it's already implied by that method.
    COALESCE(
        CAST(NULLIF(TRIM(total_charges), '') AS FLOAT), -- Processes missing values that show up as empty strings before changing data type to float then imputing monthly charges
        monthly_charges
    ) AS total_charges
FROM raw_churn;
```
</details>

### Data Integrity
A technical audit revealed that for 91% of the dataset, (Tenure * Monthly Charges) does not equal Total Charges. 

Since the direction of the mismatch is split 50/50 (Positive vs. Negative), this suggests that either monthly rates fluctuate significantly over a customer's lifecycle or historical discounts/tax variations are not fully captured in the Monthly Charges snapshot.

## Deep Dive
Click to expand/collapse:
<details>
<summary><b>Contract Volatility</b></summary>

- **Insight:** Churn rates are inversely proportional to contract commitment. Month-to-month (M2M) contracts exhibit a 42.7% churn rate, while One-Year and Two-Year contracts drop to 11.3% and 2.8%, respectively. Furthermore, M2M customers make up 55% of the total customer base, creating a high-exposure risk profile for the company.
- **Significance:** The "14x" risk multiplier between M2M and Two-Year contracts indicates that the contract itself is the strongest predictor of loyalty. This suggests that the company is currently "renting" half its customer base rather than "owning" it. Converting just 10% of M2M customers to a longer-term plan would significantly stabilize long-term revenue and lower the cost of customer acquisition.
</details>

---

<details>
<summary><b>Payment Method Friction</b></summary>


- **Insight:** Customers using Electronic Checks churn at a 50% higher rate than those using any other payment method.
- **Significance:** Unlike automatic methods, Electronic Checks often require manual intervention or are subject to higher transaction failure rates. This indicates that churn in this segment may be involuntary (due to payment friction) rather than a deliberate choice to leave the service.
</details>

---

<details>
<summary><b>Retention Maturity</b></summary>


- **Insight:** Churn probability is highest in Bucket 1 (0–12 months) at 14%, but plummets to 4% in Bucket 2 (12–24 months). By the final bucket (61–72 months), churn reaches a negligible 1.3%.
- **Significance:** This suggests that the "battle" for customer loyalty is won or lost in the first year. Resources should be shifted from general branding to "Year 1 Retention" programs.
</details>

---
 
<details>
<summary><b>Add-on Impact</b></summary>


- **Insight:** Customers without Online Security or Tech Support churn at 3x the rate of those who have them.
- **Significance:** These services act as "anchors." There is a massive discrepancy in churn between customers who utilize "Stickiness Services" and those who do not. Even if offered at a discount or bundled for free, the long-term Lifetime Value (LTV) gained by keeping the customer on the platform may outweigh the cost of the add-on.
</details>

---
 
<details>
<summary><b> Billing and Payment Friction Loop</b></summary>

- **Insight:** Customers with Paperless Billing contribute to 19.9% of total company churn, while the Electronic Check payment method has a churn rate of 45.3%.
- **Significance:** This paints a picture of a digital payment ecosystem that is failing to retain customers. This suggests a high probability of involuntary churn. The lack of physical reminders (Paperless) combined with manual payment friction (Electronic Check) creates a 'forgetfulness trap' that likely accounts for the high turnover in this segment.

</details>

---

<details>
<summary><b>Demographic Vulnerability</b></summary>

- **Insight:** While Senior Citizens represent a smaller portion of the total population (~16%), they experience a disproportionately high churn rate of 41.7%, compared to 23.6% for younger demographics.
- **Significance:** This gap suggests a "Service Accessibility" issue. Because high-churn correlates with a lack of add-ons like Tech Support and Online Security, it is likely that the current onboarding process or digital interface is not effectively meeting the needs of older users. Targeted outreach or simplified support packages for this segment could recover a significant portion of this at-risk revenue.

</details>

---
 
<details>
<summary><b>Financial Pressure</b></summary>

 
- **Limited Spending Risk:** The highest Total Charge churn rate is in the $0–$250 bucket (46.4%). This aligns with the theory that customers leave early and thus before they ever accumulate significant lifetime spend.
- **Premium Penalty:**: Average monthly charges for churned customers are $74.44, compared to $61.27 for those who stay. Churn is clearly driven by higher-priced tiers.
</details>

## Predictive Validation
- A predictive model using XGBoost algorithm was developed and tuned.
- Contract type, payment method, online security, and device protection are the most statistically significant drivers of churn in the model. This aligns with findings from our analysis.
![Feature Importance Chart](<Visuals/Smote Feature Importance.png>)

<details>
<summary><b>Model Performance Details (Click to expand)</b></summary>

- The model achieved an ROC-AUC of 0.85, indicating strong predictive power. Given the business goal of preventing customer loss, the model was tuned to prioritize Recall for the Churn Class.
- **Detection Rate:** The model successfully identifies 77% of churners.
- **Accuracy vs. Insight:** While the overall accuracy is 78%, the Weighted F1-Score of 0.78 provides a more balanced view of performance given the 26% churn prevalence in the dataset.
</details>

---

# PowerBI Dashboard
## Interaction
![Churn Dashboard Interaction](<Visuals/Churn Dashboard Interaction.gif>)
- **Drill Down:** Users can click on each tenure or monthly charge bucket to drill down.
- **Dynamic Filtering:** Users can toggle between customer segments to see real-time churn impact.
- **Global Reset:** A one-click reset allows for quick pivoting between different demographic deep-dives..

## Screenshot
![Dashboard](<Visuals/Dashboard.png>)

---

# Appendix
<details>
<summary><b
>Click to see links, tools used, and data source.
</b></summary>
<br></br>

# Tools & Technologies
- **Data Warehouse:** Snowflake, AWS (S3)
- **Languages:** SQL, Python (Pandas, Scikit-Learn, XGBoost, Matplotlib/Seaborn)
- **Visualization:** Power BI, Seaborn, Matplotlib

# Links
## Datasets
- [Raw Data](./Data/Raw%20Churn.csv)
- [Cleaned Data](./Data/Cleaned%20Churn.csv)

## Data Analytics
- [EDA](EDA.ipynb)
- [SQL Queries](./SQL%20Queries)

## Churn Prediction Model
- [Data Cleaning and Churn Prediction Jupyter Notebook](./Churn%20Prediction%20Model%20Jupyter%20Notebook.ipynb)
- [Churn Prediction Model Technical Report](./Churn%20Prediction%20Model%20Technical%20Report.md)

# Data Source and License
- Dataset: Telco Customer Churn
- Authors: scottdangelo
- Source: [IBM](https://github.com/IBM/telco-customer-churn-on-icp4d)
- License: Apache License 2.0
- Reference: IBM. (2019). Telco Customer Churn for Watson Studio.
</details>