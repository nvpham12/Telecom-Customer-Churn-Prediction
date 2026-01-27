# Project Background
This project demonstrates data analytics and customer churn prediction using synthetic telecom data with the XGBoost algorithm. Data visualization was completed using Seaborn and Matplotlib. An interactive dashboard was created using Tableau.

## Business Objective:
Identify customer attributes and behaviors associated with churn to support retention strategies and improve customer experience.

## Key Business Questions
- Which customer segments are most likely to churn?
- When in the customer lifecycle does churn most frequently occur?
- Which products, services, or contract types are most strongly associated with churn?
- Which customer groups should be prioritized for retention investment?

---

# Executive Summary
## Insights
- Month-to-month customers account for ~89% of churn, despite representing just over half of total customers.
- Customers in the $75–$100 monthly charge range are both the largest segment and the highest churn group.
- Churn risk is highest in the first 1–2 months of tenure, indicating early lifecycle vulnerability.
- Customers with Online Security or Tech Support have materially lower churn rates.
- Senior citizens churn at roughly twice the rate of non-seniors.

## Recommendations
- Target early-tenure customers (0–90 days) with contract-upgrade incentives (e.g., bill credits or device discounts) to shift month-to-month customers into 1-year plans and reduce early churn.
- Bundle Online Security and Tech Support into higher-churn plans, testing whether bundled adoption reduces churn relative to standalone pricing.
- Audit the electronic payment experience (error rates, failed payments, support tickets) and encourage alternative payment methods until issues are resolved.
- Introduce senior-specific retention offers, such as simplified plans or loyalty discounts, and track churn rate changes within this segment.

## Proposed Success Metrics
- Overall churn rate
- Early-tenure churn (first 1–3 months)
- Contract upgrade conversion rate
- Add-on service adoption rates

---

# Links
## Data Analytics
- [Data Analytics Jupyter Notebook](https://github.com/nvpham12/Telecom-Customer-Churn-Prediction-and-Analysis/blob/main/Data%20Analysis%20Telecom%20Customer%20Churn.ipynb)
- [Full Data Analytics Report](https://github.com/nvpham12/Telecom-Customer-Churn-Prediction-and-Analysis/blob/main/Analytics%20Report.md)
## Churn Prediction
- [Data Cleaning and Churn Prediction Jupyter Notebook](https://github.com/nvpham12/Telecom-Customer-Churn-Prediction-and-Analysis/blob/main/Churn%20Prediction%20Telecom%20Customers.ipynb)
- [Churn Prediction Model Technical Report](https://github.com/nvpham12/Telecom-Customer-Churn-Prediction/blob/main/Technical%20Report.md)
## Tableau Dashboard
- [Tableau Dashboard](https://public.tableau.com/views/TelecomCustomerChurnDashboard_17551339538610/Dashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

# Tools & Technologies
- Python (Pandas, scikit-learn, XGBoost)
- Matplotlib/Seaborn
- Tableau

---

# Approach
- Performed exploratory analysis to identify churn drivers and high-risk segments
- Built predictive models to validate churn signals and feature importance
- Delivered insights via visualizations and an interactive Tableau dashboard

## Project Limitations & Mitigations
- **Review timing:** Reviews aren’t necessarily left at the time of purchase.
  - **Mitigation:** Used review dates from verified customers as a proxy for purchase dates to compute recency.  
- **Volunteer bias:** Not all customers leave reviews; analysis reflects only engaged, reviewing customers.  
- **Frequency calculation:** Does not account for multiple quantities per purchase.  
- **Monetary value estimation:** Prices of reviewed products may not reflect actual amounts paid due to discounts or price changes.
  - **Mitigation:** Used product prices at the time of scraping as a proxy for spending.  
- **Subset of customers:** Only verified reviewers are included. Analysis focuses on this engaged subset.  
- **Missing purchase info:** Data lacks actual purchase amounts and dates.
  - **Mitigation:** Review dates and product prices serve as proxies to approximate recency, frequency, and monetary features for RFM analysis.

---

# Data
Synthetic telecom customer dataset (7,043 rows, 21 features) including demographics, services, and contract details (IBM).

## Data Source and License
- Dataset: Telco Customer Churn
- Authors: scottdangelo
- Source: [IBM](https://github.com/IBM/telco-customer-churn-on-icp4d)
- License: Apache License 2.0
