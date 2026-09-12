# Telecom Customer Churn Analytics (TrueConnect)
## 📌 Project Overview

This is an end-to-end telecom customer analytics project built using SQL Server and Power BI. It follows the Medallion Architecture (Bronze → Silver → Gold layers) to clean and model a messy ~1M-row telecom dataset, then presents the results as an interactive Power BI dashboard ("TrueConnect") covering customer demographics, account & plan performance, service adoption, and usage & billing.

This repository is created for learning and portfolio purposes.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🏗️ Data Architecture

<img width="1200" height="1520" alt="trueconnect_pipeline_poster (1)" src="https://github.com/user-attachments/assets/f2beee4a-f306-4887-9e50-13e01b498f64" />

- **Bronze Layer**: telecom_churn_messy_1M.csv data loaded as-is into SQL Server, with full lineage back to the source file
- **Silver Layer**: Cleaned, standardized, and type-cast data — fixes inconsistent text values, invalid entries, currency/encoding artifacts, and duplicate customer records
- **Gold Layer**: Business-ready views (dim_customer, dim_account, dim_services, fact_usage_billing) split by subject area, ready for reporting

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 📖 Project Overview

This project demonstrates how to take a messy, real-world-style telecom dataset and turn it into a decision-ready analytics product using the Medallion Architecture (Bronze → Silver → Gold).

It covers the complete flow:
1. **Data Architecture** – Designing Bronze, Silver, and Gold layers
2. **ETL Pipelines** – Extracting, cleaning, standardizing, and de-duplicating customer data
3. **Data Modeling** – Creating subject-area Gold views (customer, account, services, usage & billing)
4. **Analytics** – Building an interactive Power BI dashboard to explore demographics, plan performance, service adoption, and usage/billing patterns

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🛠️ Tech Stack
- SQL Server
- SQL Server Management Studio (SSMS)
- Git & GitHub
- Power BI

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🚀 Project Requirements

Objective

Build a clean, analysis-ready telecom customer dataset in SQL Server and turn it into a Power BI dashboard that helps understand customer demographics, plan/account performance, service adoption, and usage & billing behavior.

Key Specifications
- Ingest the raw telecom_churn_messy_1M.csv dataset (~1M rows) into SQL Server
- Clean and resolve data quality issues (inconsistent text casing/spelling, invalid values, currency symbols/encoding artifacts, duplicate customer records)
- Model the cleaned data into subject-area Gold views for reporting
- Build an interactive Power BI dashboard on top of the Gold layer
- Document the data model and pipeline clearly
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 📊 Power BI Dashboard

| Page | What it shows | Image |
|------|----------------|-------|
| **Home** | Landing page with navigation to all report pages | <img width="1507" height="822" alt="image" src="https://github.com/user-attachments/assets/e7944d16-a9fe-45ff-a033-5535d33de5b9" /> |
| **Age Insights** | Customer age distribution, gender/senior citizen ratios, tier distribution by age | <img width="1462" height="832" alt="image" src="https://github.com/user-attachments/assets/ce85de07-12bc-4007-a75b-237c4ca45f40" /> |
| **Account & Plan Performance** | Contract type, plan type, paperless billing, monthly charges by plan | <img width="1465" height="841" alt="image" src="https://github.com/user-attachments/assets/8558d32b-0c81-4e02-9854-0011bbee3859" /> |
| **Services & Add-ons Adoption** | Streaming, security, tech support, and multiple-lines adoption rates | <img width="1472" height="835" alt="image" src="https://github.com/user-attachments/assets/d9869ffa-5077-4bcb-951d-14b61df32c51" /> |
| **Usage & Billing Analysis** | Revenue, average tenure, data usage, and service calls by age group | <img width="1481" height="807" alt="image" src="https://github.com/user-attachments/assets/f5643e16-b5f9-41b0-9ea1-51e57da5889d" /> |

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 📂 Repository Structure

```
telecom-churn-analytics-powerbi/
│
├── dataset/
│   └── source.md                  # Link to the dataset (hosted on Google Drive, too large for GitHub)
│
├── powerbi/
│   └── Telecomm_proj.pdf          # Power BI report exported as PDF
│
├── scripts/                       # SQL scripts (ETL)
│   ├── bronze/                    # Raw data loading
│   ├── silver/                    # Cleaning & transformation
│   ├── gold/                      # Gold layer views (star-schema style)
│   └── db_creation.sql            # Database/schema setup
│
└── README.md
```



