# Olist E-Commerce Data Warehouse & Analytics Project

Welcome to the **Olist E-Commerce Data Warehouse & Analytics Project** repository! 🚀
This project demonstrates a complete end-to-end data warehousing and analytics solution using the Olist Brazilian E-Commerce Dataset. The project focuses on building a modern data warehouse using SQL Server and generating business insights through Power BI dashboards.

Designed as a portfolio project, it showcases practical skills in data engineering, ETL pipelines, data modeling, SQL analytics, and business intelligence.

---

## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture using **Bronze**, **Silver**, and **Gold** layers:

![Data Architecture](document/data_flow_olist.png)

1. **Bronze Layer**: Stores raw data directly imported from CSV files into SQL Server without transformations.
2. **Silver Layer**: Includes data cleaning, standardization, normalization, and transformation processes.
3. **Gold Layer**: Contains business-ready fact and dimension tables modeled using a star schema for reporting and analytics.

---

## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a modern data warehouse using Medallion Architecture with Bronze, Silver, and Gold layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from raw CSV files into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based analysis and Power BI dashboards for actionable insights.

🎯 This repository is an excellent resource for professionals and students looking to showcase expertise in:

* SQL Development
* Data Engineering
* ETL Pipelines
* Data Warehousing
* Data Modeling
* Data Analytics
* Business Intelligence
* Power BI Dashboarding

---

## 🛠️ Important Links & Tools

Everything used in this project is free.

* **Datasets:** Olist Brazilian E-Commerce Dataset
* **SQL Server Express:** Lightweight SQL Server database engine
* **SQL Server Management Studio (SSMS):** Database management and development tool
* **Power BI:** Business intelligence and dashboarding platform
* **GitHub:** Version control and project hosting
* **DrawIO:** Used for architecture diagrams and data models

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective

Develop a modern data warehouse using SQL Server to consolidate e-commerce data, enabling analytical reporting and business decision-making.

#### Specifications

* **Data Sources:** Import multiple CSV files from the Olist E-Commerce Dataset.
* **Data Quality:** Clean and standardize raw data before analytics.
* **Integration:** Combine all datasets into a centralized analytical model.
* **Data Modeling:** Create fact and dimension tables for reporting.
* **Documentation:** Maintain proper documentation for architecture and transformations.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective

Develop analytics and dashboards to generate insights into:

* Customer Behavior
* Product Performance
* Sales Trends
* Seller Performance
* Delivery Performance
* Customer Satisfaction

These insights help stakeholders make data-driven business decisions.

---

## 📂 Repository Structure

```text
olist-data-warehouse-project/
│
├── datasets/                          # Raw CSV datasets
│
├── docs/                              # Documentation and architecture diagrams
│   ├── data_architecture.drawio
│   ├── data_models.drawio
│   ├── data_flow.drawio
│   ├── data_catalog.md
│   └── naming_conventions.md
│
├── scripts/                           # SQL scripts for ETL and transformations
│   ├── bronze/                        # Raw data ingestion scripts
│   ├── silver/                        # Cleaning and transformation scripts
│   └── gold/                          # Star schema and analytics models
│
├── dashboards/                        # Power BI dashboard files and screenshots
│
├── images/                            # Project screenshots and architecture images
│
├── README.md
├── LICENSE
├── .gitignore
└── requirements.txt
```

---

## 🧱 Data Warehouse Layers

### Bronze Layer

Raw ingestion layer that stores source data exactly as received.

Example Tables:

```sql
bronze.olist_orders
bronze.olist_order_items
bronze.olist_customers
bronze.olist_products
```

---

### Silver Layer

Transformation layer responsible for:

* Data cleaning
* Standardization
* Handling missing values
* Removing duplicates
* Data validation

---

### Gold Layer

Business-ready analytical layer designed using star schema.

Example Tables:

```sql
gold.fact_orders
gold.dim_customers
gold.dim_products
gold.dim_sellers
```

---

## 📊 Power BI Dashboards

The dashboards provide insights into:

* Revenue Trends
* Sales Performance
* Customer Analytics
* Product Category Performance
* Seller Contribution
* Delivery Delays
* Review Score Analysis

---

## 🧠 SQL Concepts Used

* Joins
* CTEs
* Window Functions
* Aggregate Functions
* Views
* Data Cleaning
* Data Modeling
* Fact & Dimension Tables
* Star Schema Design

Window Functions Used:

* ROW_NUMBER()
* RANK()
* DENSE_RANK()
* LAG()
* LEAD()
* SUM() OVER()

---

## 📸 Project Screenshots

### Data Architecture

*Add architecture image here*

### SQL Server Warehouse

*Add SSMS screenshots here*

### Power BI Dashboard

*Add dashboard screenshots here*

---

## 🚀 Future Improvements

* Real-time ETL pipelines
* Azure cloud deployment
* Predictive analytics
* Customer segmentation using RFM analysis
* Machine learning integration
* Automated data quality monitoring

---
📊 Power BI Analytics Solution

The Gold Layer was connected to Power BI to develop an interactive business intelligence solution for stakeholders. The dashboards were designed to provide insights into revenue performance, customer behavior, product profitability, and delivery operations.

Dashboard Features
Interactive slicers and filters
KPI scorecards
Drill-through analysis
Time intelligence calculations
Dynamic measures using DAX
Trend analysis
Cross-filtering and interactive reporting
DAX Measures Implemented
Revenue
Net Profit
Profit Margin %
Total Orders
Total Customers
Delayed Orders
Delay Rate %
Average Review Score
Average Revenue per Customer
Monthly Revenue
Previous Month Revenue
Monthly Orders
Monthly Delayed Orders
📈 Dashboard Pages
1. Executive Overview

Provides a high-level summary of business performance and operational health.

Key KPIs
Total Revenue
Total Orders
Net Profit
Delay Rate %
Insights
Revenue trends over time
State-wise sales performance
Product category contribution
Monthly performance tracking
2. Customer Analysis

Focuses on customer behavior, purchasing patterns, and customer satisfaction.

Key Metrics
Total Customers
Revenue per Customer
Average Review Score
Payment Method Distribution
Insights
Customer geographic distribution
Revenue contribution by customer segment
Payment behavior analysis
Customer satisfaction trends
3. Product Performance Analysis

Evaluates product category performance and profitability.

Key Metrics
Revenue by Category
Profit Margin %
Orders by Category
Delayed Orders by Category
Features
Product Drillthrough Page
Dynamic KPI Analysis
Monthly Performance Tracking
Insights
Best-performing product categories
Category profitability analysis
Product sales trends
Product-level operational performance
4. Logistics & Delivery Analysis

Analyzes shipping performance and operational efficiency.

Key Metrics
Average Shipping Cost
Average Product Weight
Delay Rate %
Profit Margin %
Insights
Relationship between product weight and shipping cost
Delivery delay patterns
Product weight category analysis
Logistics impact on profitability
📸 Dashboard Screenshots
Executive Overview

Customer Analysis

Product Performance Analysis

Logistics & Delivery Analysis

Then add this section near the end, before Future Improvements:

📌 Key Business Insights
Revenue Performance
Generated over R$16M in total revenue.
Revenue trends revealed seasonal fluctuations and growth opportunities.
Customer Insights
Credit cards were the dominant payment method.
Customer review scores remained largely positive.
Product Insights
Product categories contributed differently to revenue and profitability.
Certain categories generated high revenue but lower margins.
Logistics Insights
Heavier products incurred higher shipping costs.
Delay rates increased for heavier product categories.
Logistics performance directly impacted profitability.

## 🛡️ License

This project is licensed under the MIT License. You are free to use, modify, and share this project with proper attribution.
