## CREDIT CARD SPENDING ANALYTICS — INDIA (SQL)

Advanced SQL analysis of **26,051** real credit card transactions across major Indian cities, exploring spending patterns by **city, card type, expense category, gender, and time.**

## 📊 Dataset## 📑 Table of Contents
- [Dataset](#-dataset)
- [Tools Used](#️-tools-used)
- [Data Cleaning](#-data-cleaning)
- [Analysis Structure](#-analysis-structure)
- [Sample Query Results](#-sample-query-results)
- [Key Findings](#-key-findings)
- [Repo Structure](#-repo-structure)
- [How to Reproduce](#-how-to-reproduce)

## 📊 Dataset

- **Source:** [Credit Card Spending Habits in India — Kaggle](https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india)
- **Size:** 26,051 rows
- **Columns:** `id`, `City`, `txn_date`, `card_type` (Silver/Gold/Platinum/Signature), `expense_type` (Bills, Food, Fuel, Travel, Entertainment, Grocery), `Gender`, `Amount`

## 🛠️ Tools Used

- MySQL Workbench
- SQL: window functions, CTEs, subqueries, aggregations

## 🧹 Data Cleaning

- Removed the ", India" suffix from all city names
- Fixed a BOM-corrupted ID column header from the CSV import
- Converted `txn_date` from text to a proper `DATE` type
- Renamed `Card Type` → `card_type` (removed the space for SQL-safe querying)

## 🔍 Analysis Structure

The [**queries.sql**](./queries.sql) file contains 19 queries organized into three tiers:

**Basic — Aggregations & Grouping (Q1–7)**
Total spend by city, card type, and expense category; gender-wise spend; top-city contribution %.

