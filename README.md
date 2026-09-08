
# Dirty Cafe Sales Analysis

An end-to-end data analysis project using Python, Pandas, Matplotlib, Seaborn, and SQL to clean, analyze, and derive business insights from a messy cafe sales dataset.

## Project Objective

The goal of this project is to transform a messy cafe sales dataset into a reliable analytical dataset and identify patterns in:

- Product performance
- Sales volume and revenue
- Customer purchasing behavior
- Payment methods
- Location performance
- Monthly sales trends
- Transaction value

## Tools & Technologies

- Python
- Pandas
- Matplotlib
- Seaborn
- SQL
- Jupyter Notebook
- GitHub

## Project Structure

```text
dirty-cafe-sales-analysis/
│
├── Task-1-Data-Cleaning/
│   ├── 01_Data_Cleaning.ipynb
│   ├── dirty_cafe_raw.csv
│   └── dirty_cafe_cleaned.csv
│
├── Task-2-EDA/
│   └── 02_Exploratory_Data_Analysis.ipynb
│
├── visualizations/
│   ├── revenue_by_item.png
│   ├── sales_distribution.png
│   ├── payment_method_transactions.png
│   ├── location_revenue.png
│   ├── quantity_by_item.png
│   ├── monthly_sales.png
│   └── quantity_vs_total_spent.png
│
└── README.md

Task 1 — Data Cleaning

The raw dataset contained missing values, inconsistent categorical data, and data quality issues.

The cleaning process included:

Standardizing column names
Cleaning categorical values
Handling missing values
Correcting data types
Validating numerical relationships
Checking for negative values
Checking for duplicate records
Verifying Total_Spent = Quantity × Price_Per_Unit

After cleaning, the dataset contained no remaining missing numerical values, negative values, or transaction-value mismatches.

Task 2 — Exploratory Data Analysis

The cleaned dataset was analyzed to understand sales performance and customer purchasing patterns.

Key Findings

Product Performance

Salad generated the highest revenue at $17,375, followed by Sandwich at $13,764. Coffee recorded the highest sales volume, with 3,551 units sold, showing that the highest-volume product is not necessarily the highest-revenue product.

Customer Purchasing Behavior

Most transactions fall within the lower spending range, indicating that customers generally make small-to-moderate purchases. Coffee's high sales volume also indicates strong demand for the product.

Operational/Data Quality

A substantial number of transactions have unknown payment methods and locations, limiting reliable analysis of customer payment preferences and location-level performance.

Sales Trends

Monthly revenue fluctuated throughout 2023, with June and October recording the strongest sales and February recording the lowest. There was no consistent upward or downward trend.

Quantity & Transaction Value

Higher quantities generally lead to higher transaction values, with larger-quantity transactions tending to generate more revenue.

Visualizations

The EDA includes visualizations covering:

Total Revenue by Item
Distribution of Transaction Values
Payment Method vs Transaction Count
Location vs Total Revenue
Total Quantity Sold by Item
Monthly Sales Performance
Quantity vs Total Spent
Project Status
 Data Cleaning
 Exploratory Data Analysis
 SQL Analysis
