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

**Intermediate — Dates & Subqueries (Q8–12)**

Highest-spend month overall and per card type; weekend vs. weekday spending; cities above the average transaction size.

**Advanced — Window Functions, CTEs & Multi-step Logic (Q13–19)**

Running cumulative totals, city spend rankings, per-transaction contribution to card-type totals, month-over-month growth, and female spend share by category.

## 📸 Sample Query Results

| Query | Preview |
|---|---|
| Top 5 cities by % contribution | [View](./screenshots/Top%205%20cities%20by%20%25%20contribution.png) |
| Total spend by card type | [View](./screenshots/Total%20spend%20by%20card%20type.png) |
| Running cumulative total by city | [View](./screenshots/Running%20cumulative%20total%20by%20city.png) |
| Month-over-month growth | [View](./screenshots/Month-over-month%20growth.png) |
| Female spend % by category | [View](./screenshots/Female%20spend%20%25%20by%20category.png) |

## 💡 Key Findings
 
- **Top-spending city:** [CITY] accounted for [X]% of total spend *(Query 5)*
- **Most-used card type by spend:** [CARD TYPE] *(Query 2)*
- **Highest-spend category:** [EXPENSE TYPE] with ₹[AMOUNT] across [N] transactions *(Query 3)*
- **Gender split:** [Male/Female] average transaction was ₹[AMOUNT] higher *(Query 4)*
- **Peak spending month:** [MONTH] *(Query 8)*
- **Weekend vs weekday:** [Weekend/Weekday] transactions were higher on average *(Query 10)*

  ## 📁 Repo Structure

```
credit-card-analytics/
├── DATA/
│   ├── credit_card_transactions_raw.csv
│   └── credit_card_transactions_clean.csv
├── screenshots/
├── queries.sql
├── Credit_Card_Analytics_Project_Documentation.pdf
└── README.md
```


## 🚀 How to Reproduce

1. Import `DATA/credit_card_transactions_clean.csv` into MySQL using the Table Data Import Wizard, as table `transactions`
2. Run the setup/cleaning block at the top of `queries.sql`
3. Run any query section independently — each is commented and numbered

---

📄 [Full Project Documentation (PDF)](./Credit_Card_Analytics_Project_Documentation.pdf) · 🔗 [More projects](https://github.com/suzain05) · 💼 [LinkedIn](https://linkedin.com/in/suzain-3090b82a7)
