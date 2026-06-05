# Project Background
In this project, data analysis was performed on synthetic telecom customer data. Exploratory data analysis (EDA) was conducted in Python, while data cleaning and deep-dive analysis were executed using SQL within Snowflake via an AWS S3 data pipeline. An interactive dashboard was built in Power BI to visualize key trends, supported by a predictive churn model developed in Python.

## Table of Contents
- [Project Background](#project-background)
- [Data](#data)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Churn Prediction Modeling](#churn-prediction-modeling)
- [Model Performance Evaluation](#model-performance-evaluation)
- [Conclusion](#conclusion)
- [Appendix](#appendix)

## Business Objective:
- Identify key churn drivers to support retention strategies and improve customer experience.
- Develop a model to realibly identify customers at high risk of churning in advance.

## Approach
- Cleaned & transformed synthetic churn dataset; handled missing values, changed data types, encoded categorical features, and transformed skewed distributions.
- Trained XGBoost models: baseline, hyperparameter-tuned, and SMOTE-balanced for class imbalance.
- Built a Tableau dashboard to visualize churn by tenure, contract type, and other features.

# Data
- The data contains information on telecom customer churn and contains 7043 rows and 21 columns.
- Columns include customer demographics and add-on services also offered by the company.
- The data is synthetic, made and shared by IBM.
- From EDA, there are 11 nulls in the data. All of these instances are nulls for total charges from customers who hadn't reached their first billing cycle.


## Data Cleaning
- There were missing values for monthly charges for new customers, which were imputed using their total charges.
- Data types are changed to appropriate data types for manipulation and modeling.
- Extra whitespace is removed from categorical variables.

## Exploratory Data Analysis
### Heatmap
![Heatmap](<Visuals/Heatmap.png>)

- Tenure has high 0.83 correlation with Total Charges, which is reasonable considering the longer a customer stays with the company, the larger the accumulation of their charges.
- Monthly Charges has a moderate 0.65 correlation with Total Charges. This likely means that customers have a tendency to change their plans, and by extension, their Monthly Charges rather than sticking to the same plan.

---
### Categorical Variable Counts
![Categorical Variable Counts](<Visuals/Categorical Variable Counts.png>)
- Most of the variables are imbalanced. While this is normal in the telecom industry, since most customers won't churn, this may cause some issues with model performance and results.
- The data will be modeled both before and after balancing.

---
### Numerical Variable Distributions
![Numerical Distributions](<Visuals/Numerical Distributions.png>)
- These variables do not have normal distributions.
- Tenure and Monthly Charges are multimodal, while Total Charges is right skewed. These features will require a transformation to deal with the skew before modeling.

---

# Data Preprocessing
- Total Charges is removed due to high correlation with other features.
- Some redundant features are removed because they depend on other features. For example, Multiple Lines can take on the value of 'No Service,' which implies the value for the Phone Service feature.
- Yeo-Johnson Transformation is applied to numerical features to handle skewed features.
- Categorical Variables are encoded using binary encoding and dummy variable encoding. The first column is dropped when dummy variable encoding to avoid the dummy variable trap, an issue that arises where the dummy variables are highly correlated to each other.
  
# Churn Prediction Modeling
XGBoost will be used as the model to predict customer churn. XGBoost is a gradient-boosted tree algorithm that iteratively trains weak learners to correct previous errors. It supports classification and regression tasks; here it is applied for churn classification.

The evaluation metric best suited for the situation is aucpr. This is the Area Under the Precision-Recall Curve and it was selected since the data is imbalanced and correctly predicting whether customers will churn is top priority. 

3 Models were developed using different techniques:
- Base Model: This is a baseline model without tuning or data balancing.
- Tuned Model: This model uses hyperparameter tuning to increase model performance.
- SMOTE Model: This model first applies Synthetic Minority Oversampling Technique (SMOTE), balancing the data by generating synthetic data for the minority classes. Then, hyperparameter tuning is performed.

# Model Performance Evaluation
- A classification report is generated for each model, showing model performance metrics such as Precision, Recall, Accuracy, and F1-Score.
- A confusion matrix is generated for each model to show how its predictions compare to the actual sentiment labels.
- The ROC-AUC score is computed for each model to evaluate the models' effectiveness.

## Metrics Table

| Model  | Sentiment    | Precision | Recall | F1-Score |
|--------|--------------|-----------|--------|----------|
| Base   | Won't Churn  | 0.83      | 0.88   | 0.85     |
|        | Will Churn   | 0.59      | 0.49   | 0.54     |
| Tuned  | Won't Churn  | 0.85      | 0.91   | 0.88     |
|        | Will Churn   | 0.69      | 0.54   | 0.61     |
| SMOTE  | Won't Churn  | 0.90      | 0.77   | 0.83     |
|        | Will Churn   | 0.55      | 0.77   | 0.64     |

- The Tuned Model shows modest, consistent improvements over the Base Model across all metrics.
- Compared to the Tuned Model, the SMOTE Model achieves substantially higher recall for churning customers
- The Tuned Model outperforms SMOTE in precision for churning customers and recall for non-churning customers.

---
## Accuracy, ROC-AUC, and Macro-Average Metrics Table

| Model  | Precision | Recall | F1-Score | Accuracy | ROC-AUC |
|--------|-----------|--------|----------|----------|---------|
| Base   | 0.71      | 0.69   | 0.70     | 0.78     | 0.83    |
| Tuned  | 0.77      | 0.73   | 0.74     | 0.81     | 0.86    |
| SMOTE  | 0.73      | 0.77   | 0.74     | 0.78     | 0.85    |
> Note: This table uses macro-averages for precision, recall, and f1-score.
- The Base Model is consistently outperformed by the Tuned Model.
- The Tuned Model and SMOTE Models are just as balanced.
- The Tuned Model boosts precision and accuracy with tradeoffs in recall.
- The SMOTE Model boosts recall with tradeoffs in precision and accuracy.

## Feature Importance
Feature importance is used to rank how inputs affect a model's predictions. In linear models, the most important features often have the largest weights. In tree-based or complex models, such as with the XGBoost model used in this project, importance can reflect split frequency, information gain, or influence on prediction variance.

![Feature Importance Plot](<Visuals/Smote Feature Importance.png>)
> - The most powerful predictors in the churn prediction model are the 2-Year Contracts, Electronic Check Payment Method, 1-Year Contracts, No Online Security, No Device Protection, and Tenure. 
> - This finding aligns with the identified churn drivers in our SQL queries and analyses. 


# Conclusion
For predicting customer churn, the SMOTE model should chosen despite having lower accuracy than the Base Model and Tuned Models. Because telecom data tends to be imbalanced with customer churn being the minority, models should be optimized for the highest recall, which the SMOTE Model has (up to 42% improvement from the Tuned Model).

# Appendix
<details>
<summary><b
>Click to see links, tools used, and data source.
</b></summary>
<br></br>

# Links
## Datasets
- [Raw Data](./Data/Raw%20Churn.csv)
- [Cleaned Data](./Data/Cleaned%20Churn.csv)

## Data Analytics
- [Data Analytics Report](./Data%20Analytics%20Report.md)
- [EDA](./EDA.ipynb)
- [SQL Queries](./SQL%20Queries)

## Churn Prediction Model
- [Data Cleaning and Churn Prediction Jupyter Notebook](./Churn%20Prediction%20Model%20Jupyter%20Notebook.ipynb)


# Tools & Technologies
- **Pandas** – data manipulation and cleaning
- **NumPy** - data transformation
- **Matplotlib / Seaborn** – EDA and visualizations
- **Scikit-learn** – data preprocessing and model evaluation
- **XGBoost** – tree-based classification and feature importance visualization
- **GridSearchCV** – hyperparameter tuning
- **Imbalanced-learn (imblearn)** - data balancing via SMOTE

# Data Source and License
- Dataset: Telco Customer Churn
- Authors: scottdangelo
- Source: [IBM](https://github.com/IBM/telco-customer-churn-on-icp4d)
- License: Apache License 2.0
- Reference: IBM. (2019). Telco Customer Churn for Watson Studio.