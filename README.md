
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
```
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

## SQL Analysis

The cleaned café sales data was loaded into **SQL Server** using a relational database structure consisting of dimension tables for products, payment methods, and locations, along with a central transactions table.

Ten analytical SQL queries were developed to answer business-focused questions using `JOINs`, aggregations, `GROUP BY`, subqueries, CTEs, and window functions.

### Analytical Queries

| Query | Business Question | SQL Concepts Used |
|---|---|---|
| Q1 | Which products generate the most revenue? | JOIN, GROUP BY, Aggregation |
| Q2 | Which products sell the most units? | JOIN, GROUP BY, Aggregation |
| Q3 | Which location performs best? | JOIN, GROUP BY, Aggregation |
| Q4 | Which payment methods are most used? | JOIN, GROUP BY, Aggregation |
| Q5 | How does product performance vary by location? | Multiple JOINs, GROUP BY |
| Q6 | Which products generate above-average revenue? | Subquery, HAVING, Aggregation |
| Q7 | What is the top-revenue product in each location? | CTE, ROW_NUMBER(), Window Function |
| Q8 | What is the monthly revenue trend? | Date Functions, GROUP BY, Aggregation |
| Q9 | What payment methods are preferred by location? | Multiple JOINs, GROUP BY |
| Q10 | Which products have above-average transaction value? | Subquery, HAVING, Aggregation |

### SQL Techniques Demonstrated

- Relational data modeling using dimension and transaction tables
- `JOIN` operations to combine related datasets
- `GROUP BY` with `SUM()`, `COUNT()`, and `AVG()`
- `HAVING` for filtering aggregated results
- Subqueries for above-average comparisons
- CTEs for structuring complex analysis
- `ROW_NUMBER()` with `PARTITION BY` for ranking
- SQL date functions for monthly trend analysis

---

## Pandas Validation

To verify the reliability of the SQL analysis, each of the 10 SQL queries was independently reproduced using **Pandas**.

The SQL and Pandas results were compared across the relevant dimensions and metrics, including revenue, units sold, transaction counts, average transaction value, rankings, and monthly trends.

### Validation Results

| Query | Validation Metrics | Result |
|---|---|---|
| Q1 | Units Sold, Revenue | PASS |
| Q2 | Units Sold, Transactions, Average Quantity | PASS |
| Q3 | Transactions, Units, Revenue, Average Transaction Value | PASS |
| Q4 | Transactions, Units, Revenue, Average Transaction Value | PASS |
| Q5 | Units Sold, Revenue by Location and Product | PASS |
| Q6 | Above-Average Products and Revenue | PASS |
| Q7 | Top Product and Revenue by Location | PASS |
| Q8 | Monthly Transactions, Units, Revenue, Average Transaction Value | PASS |
| Q9 | Transactions, Revenue and Average Transaction Value by Location and Payment Method | PASS |
| Q10 | Transaction Count and Average Transaction Value | PASS |

### Validation Outcome

**10/10 SQL queries passed cross-validation against Pandas.**

The matching results provide confidence that the SQL queries correctly reproduce the analytical calculations performed during the Python/Pandas analysis.

### Data Quality Note

During validation, **460 transactions were found to have missing transaction dates**.

These records were excluded from the monthly revenue trend because they could not be assigned to a calendar month. The same treatment was applied consistently during validation.
