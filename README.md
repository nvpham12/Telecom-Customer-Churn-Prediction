# Project Background
In this project, data analysis was performed on synthetic telecom customer data. Exploratory data analysis (EDA) was conducted in Python, while data cleaning and deep-dive analysis were executed using SQL within Snowflake via an AWS S3 data pipeline. An interactive dashboard was built in Power BI to visualize key trends, supported by a predictive churn model developed in Python.

## Table of Contents
- [Project Background](#project-background)
- [Executive Summary](#executive-summary)
- [Recommendations](#recommendations)
- [PowerBI Dashboard](#powerbi-dashboard)
- [Data](#data)
- [Links](#links)
- [Tools & Technologies](#tools--technologies)
- [Data Source & License](#data-source-and-license)

## Business Objective:
Identify customer attributes and behaviors associated with churn to support retention strategies and improve customer experience.

### Key Business Questions
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
- **Contract Volatility:** Month-to-month contracts are the primary churn driver, with a 14x higher churn rate than 2-year contracts.

- **Digital Payment Friction:** Customers using Electronic Payments have 50% higher churn rates compared to any other payment method.

- **12-Month Loyalty Cliff:** The critical retention window occurs in the first 12 months, where churn probability is highest at 47%. Once customers enter their second year, the probability plummets to 28%, indicating that the first year is the most vital period for retention investment.

- **Add-on Churn Correlation:** Customers without the Online Security, Tech Support, Online Backup, and Device Protection add-ons have around 2-3x the churn rate compared to those with those add ons.

- **Predictive Model:** Developed a predictive model to identify 77% of churners in advance, allowing for proactive intervention.

- **Paperless Billing Paradox:** Customers using Paperless Billing have a 33.6% churn rate, nearly double those who receive paper statements (16.3%). This suggests that digital-only billing may reduce a customer’s tactile connection to the service or make it easier to ignore engagement prompts.

- **Price Sensitivity Threshold:** Churn rates spike to 37.4% for customers with monthly charges between $76–$100. Conversely, those paying under $25 have a very healthy churn rate of only 9%.

- **Senior Risk Segment:** Senior Citizens are a high-risk demographic with a 41.7% churn rate, compared to just 23.6% for non-seniors.

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

# PowerBI Dashboard
![Churn Dashboard Interaction](<Visuals/Churn Dashboard Interaction.gif>)
- **Drill Down:** Users can click on each tenure or monthly charge bucket to drill down.
- **Dynamic Filtering:** Users can toggle between customer segments to see real-time churn impact.
- **Global Reset:** A one-click reset allows for quick pivoting between different demographic deep-dives..

---

# Data
- The data contains information on telecom customer churn and contains 7043 rows and 21 columns.
- Columns include customer demographics and add-on services also offered by the company.
- The data is synthetic, made and shared by IBM.

---

# Links
## Datasets
- [Raw Data](./Data/Raw%20Churn.csv)
- [Cleaned Data](./Data/Cleaned%20Churn.csv)

## Data Analytics
- [Data Analytics Report](./Data%20Analytics%20Report.md)
- [EDA](./EDA.ipynb)
- [SQL Queries](./SQL%20Queries/)

## Churn Prediction Model
- [Data Cleaning and Churn Prediction Jupyter Notebook](./Churn%20Prediction%20Model%20Jupyter%20Notebook.ipynb)
- [Churn Prediction Model Technical Report](./Churn%20Prediction%20Model%20Technical%20Report.md)

---

# Tools & Technologies
- **Data Warehouse:** Snowflake, AWS (S3)
- **Languages:** SQL, Python (Pandas, Scikit-Learn, XGBoost, Matplotlib/Seaborn)
- **Visualization:** Power BI, Seaborn, Matplotlib

---

# Data Source and License
- Dataset: Telco Customer Churn
- Authors: scottdangelo
- Source: [IBM](https://github.com/IBM/telco-customer-churn-on-icp4d)
- License: Apache License 2.0
