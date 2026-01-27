# Project Background
This project demonstrates data analytics on churn patterns from synthetic telecom customer data. Data visualization was completed using Seaborn and Matplotlib. An interactive dashboard was built using Tableau.

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

# Tools & Technologies
- **Pandas** – data manipulation
- **Matplotlib / Seaborn** – EDA and visualizations
- **Tableau** – interactive dashboarding

---

# Links
- [Data Analytics Jupyter Notebook](https://github.com/nvpham12/Telecom-Customer-Churn-Prediction-and-Analysis/blob/main/Data%20Analysis%20Telecom%20Customer%20Churn.ipynb)
- [Tableau Dashboard](https://public.tableau.com/views/TelecomCustomerChurnDashboard_17551339538610/Dashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

# Data
- The data contains information on telecom customer churn and contains 7043 rows and 21 columns.
- Columns include customer demographics and add-on services also offered by the company.
- The data is synthetic, made and shared by IBM.

## Schema
Full schema available in appendix

## Data Source and License
- Dataset: Telco Customer Churn
- Authors: scottdangelo
- Source: [IBM](https://github.com/IBM/telco-customer-churn-on-icp4d)
- License: Apache License 2.0
- Reference: IBM. (2019). Telco Customer Churn for Watson Studio.

---

## Approach
- Cleaned and transformed synthetic churn dataset: handled missing values, changed data types, encoded categorical features, and transformed skewed distributions. 
- The data used for the analytics notebook was a previously cleaned copy. The code for data cleaning is in the Churn Prediction Model Jupyter Notebook file.
- Used Matplotlib and Seaborn to generate visualizations that show churn patterns and customer distributions.
- Interpreted the visualizations, documenting and delivering actionable insights and recommendations.
- Built a Tableau dashboard to visualize churn by tenure, contract type, and other features.

---

# Numerical Feature Distributions
## Total Charges
<img width="1000" height="600" alt="distribution_total_charges" src="https://github.com/user-attachments/assets/cad7c955-8576-4626-b838-485896e24f85" />

- The company's has a consistently decreasing number of customers as Total Charges goes up. The rate of decrease is initially rapid (at lower levels of total charges) but tapers off at higher levels of total charges.
- The majority of the company's customers are likely new customers or customers with cheaper plans, since bins with the lowest total charges have the most customers. 
---

## Monthly Charges
<img width="1000" height="600" alt="distribution_monthly_charges" src="https://github.com/user-attachments/assets/2e4eb8e3-bc02-4ca2-a4de-ed4b1ad85141" />

- The largest bin of customers have Monthly Charges of around \$20, which should represent cheap, single line plans.
- For other levels of Monthly Charges, there are distinct a bell shaped curves at around \$40-\$70 of charges then another taller bell curve from around \$70-\$120 dollars.
- These regions can represent different customer segments based on levels of Monthly Charges that can be targeted differently.
---

### \$30-\$70 Group
<img width="1000" height="600" alt="distribution_monthly_charges_30-70" src="https://github.com/user-attachments/assets/25072941-9035-4ea8-9b72-0c27f2627d58" />

- For this customer segment, the company should focus on flexibility and affordability.
- Offer personalized phone upgrades based on usage patterns.
- Highlight features these customers is missing out on like speeds or no throttling.
- Send anniversary messages or small rewards.
- Invite these customers to beta programs or exclusive events.
- Encourage these customers to refer friends/family with bonuses.
- Provide tips or tutorials to help these customers get more out of their current plan.
---

### \$60-\$120 Group
<img width="1000" height="600" alt="distribution_monthly_charges_60-120" src="https://github.com/user-attachments/assets/4e39b3a9-9e78-48cc-9986-351c3ef588b0" />

- For this customer group, the company should focus on premium features and reliability.
- Offer priority customer service or dedicated account managers.
- Provide early access to new features or services.
- Give these customers VIP status with perks like free upgrades, bundled discounts, or loyalty tiers.
- Perform regular check-ins to ensure customer satisfaction.
- Ask for feedback and make these customers feel their voices are heard.
- Monitor for any signs of dissatisfaction or lower usage. Intervene early with personalized offers or support to prevent this group especially from churning.
---

## Tenure
<img width="1000" height="600" alt="distribution_tenure" src="https://github.com/user-attachments/assets/52b3465a-ce3e-431c-9b3d-cb5433fa080e" />

- The company's largest customer counts come from their lowest tenure (newest customers) and highest tenure (the oldest customers), especially the lowest tenure group.
- The lowest tenure group has at least 50% more customers than any other group, including the group with the second most number of customers.
- Other tenure groups have roughly the same number of customers on average.
---

# Churn Proportion Analysis Across Features
## Contract Type
<img width="1000" height="600" alt="churn_by_contract" src="https://github.com/user-attachments/assets/b85eccd9-2acf-4974-bc72-2b53ba9e2373" />

- The churn rate drastically decreases between contract types.
- Customers on One-Year contract have around a quarter of the churn rate as those on Month-to-Month contracts.
- Those on Two-Year contracts in turn, have around a quarter of the churn rate as those on One-Year contracts.
- The churn rate of those on Month-to-Month contracts is around 14 times that of those on Two-Year contracts.

| Contract Type   | Churners | % of Total | Non-Churners | % of Total |
|-----------------|----------|------------|--------------|------------|
| Month-to-Month  | 1,655    | 23.50%     | 2,220        | 31.52%     |
| 1 Year          | 166      | 2.36%      | 1,307        | 18.56%     |
| 2 Year          | 48       | 0.68%      | 1,647        | 23.38%     |

- The company's overall churn rate is around 25%.
- People with Month-to-Month contracts make up a little over half of the company's total customers.
- The number of churning customers drastically decreases between contract types.

### Contract Churn Pie
<img width="1000" height="600" alt="pie_contract_churn" src="https://github.com/user-attachments/assets/30cbf485-4fc7-4737-8df8-8025fdc27862" />

- Of all churning customers, approximately 89% are on Month-to-Month contracts, 9% on 1-Year contracts, and 2% on 2-Year contracts. 
- For the company, it is of the utmost importance to get customers on 1 or 2-Year contracts. Even 1-Year contracts will drastically reduce churn rate.
---

## Internet Service
<img width="1000" height="600" alt="churn_by_internet_service" src="https://github.com/user-attachments/assets/3e5226f8-3095-432c-8659-9bd1fffd3668" />

- There are higher proportions of customers who churn when they have internet service. 
- Fiber Optic users have around double the churn ratio of DSL users, indicating potential issues with the service.
---

## Payment Method
<img width="1000" height="600" alt="churn_by_payment_method" src="https://github.com/user-attachments/assets/3fbfa14a-aaf4-44a4-9de0-cf35ce1297d2" />

- Customers who pay via electronic checks have higher proportions of churning customers than those who use other payment methods (and those other payment methods have roughly the same levels of churn). 
- This may be a sign of serious technical problems with the electronic check payment method leading to churn.
---

## Online Security Churn Proportions
<img width="1000" height="600" alt="churn_by_online_security" src="https://github.com/user-attachments/assets/27c54739-f9e5-4538-b2e1-9acd79b7d765" />

- The churn rate seems to be higher for people who have not had online security.
- Market the benefits of having online security and the strengths of the company's service.
---

## Tech Support Churn Proportions
<img width="1000" height="600" alt="churn_by_Tech_Support" src="https://github.com/user-attachments/assets/56b9eb72-be41-4c75-8acc-79b8c7bfe9f2" />

- The churn rate seems to be higher for people who have not had tech support.
- Encourage customers to use tech support as the company's tech support team may be strong and helpful to customers.
---

## Senior Citizen
<img width="1000" height="600" alt="churn_by_Senior_Citizen" src="https://github.com/user-attachments/assets/f63b1686-7d9e-4986-9748-4e53b7036a16" />

- Senior Citizens have twice the churn rate as non-senior citizens.
- Provide new or enhance existing senior discounts to prevent churn.
- Investigate if churn comes from switching plans or the consequences of aging (passing away).
---

## Dependents
<img width="1000" height="600" alt="churn_by_Dependents" src="https://github.com/user-attachments/assets/b60e163e-5448-4aab-86eb-afc4624c420f" />

- It looks like people are less likely to churn if they have dependents.
- Those with dependents may have favorable rates for each additional line. Consider reducing single line prices or providing other offers to those with single lines.
---

# Churn Counts
## Monthly Charges Churn Counts
<img width="1000" height="600" alt="counts_monthly_charges" src="https://github.com/user-attachments/assets/c402eea8-347a-40a8-9474-19abbbd9cd49" />

- The bracket with the largest number of customers is the \$75-\$100 Monthly Charges bracket. It also has the highest churn rate.
- The \$25-\$50 and \$100-\$125 brackets are roughly tied for the lowest number customers.
- Customers with \$0-\$25 Monthly Charges have the lowest churn rate, but are likely on strictly data limited plans.
---

## Tenure Churn Counts
<img width="1000" height="600" alt="counts_tenure" src="https://github.com/user-attachments/assets/893573f6-fb9c-4c94-9e70-7eaff8d56a9b" />

- Customers tend to churn more in the first couple of months. 
- The churn ratio gradually decreases at higher levels of tenure.
- The tenure groups with the largest number of customers are the groups with the lowest months and the highest months. 
---

# Tableau Dashboard Preview
<img width="1635" height="1090" alt="Dashboard" src="https://github.com/user-attachments/assets/2a765d0e-ce9c-4884-8674-cb68bf8af24e" />

---

# Appendix
## Data Schema
| Field Name         | Type     |
|--------------------|----------|
| CustomerID         | object   |
| Gender             | object   |
| SeniorCitizen      | int64    |
| Partner            | object   |
| Dependents         | object   |
| Tenure             | int64    |
| PhoneService       | object   |
| MultipleLines      | object   |
| InternetService    | object   |
| OnlineSecurity     | object   |
| OnlineBackup       | object   |
| DeviceProtection   | object   |
| TechSupport        | object   |
| StreamingTV        | object   |
| StreamingMovies    | object   |
| Contract           | object   |
| PaperlessBilling   | object   |
| PaymentMethod      | object   |
| MonthlyCharges     | float64  |
| TotalCharges       | object   |
| Churn              | object   |
