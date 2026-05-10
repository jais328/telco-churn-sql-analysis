# telco-churn-sql-analysis
End-to-end SQL project analyzing customer churn using PostgreSQL

# 📊 Telco Customer Churn Analysis — SQL Project

## 🔍 Project Overview
End-to-end SQL analysis of IBM Telco Customer Churn dataset
using PostgreSQL. Analyzed 7,043 customers across 21 columns
with 25 business-driven SQL queries.

---

## 📁 Dataset
- **Source:** IBM Telco Customer Churn (Kaggle)
- **Rows:** 7,043 customers
- **Columns:** 21
- **Tool:** PostgreSQL (pgAdmin)

---

## 🗂️ Project Structure

| Phase | Topic | Queries |
|---|---|---|
| Phase 1 | Data Exploration | Q1–Q5 |
| Phase 2 | Churn Analysis | Q6–Q12 |
| Phase 3 | Revenue & Risk | Q13–Q18 |
| Phase 4 | CTEs & Window Functions | Q19–Q25 |

---

## 💡 Key Business Insights

| # | Insight | Finding |
|---|---|---|
| 1 | Contract Type | Month-to-month churns 15X more than 2-year (42.71% vs 2.83%) |
| 2 | Payment Method | Electronic check = 45.29% churn vs auto-pay = 15.24% |
| 3 | New Customers | Year 1 customers churn at 47.72% — critical retention window |
| 4 | Risk Model | High-risk segment churns at 67.99% — proactive retention possible |
| 5 | Revenue Lost | $49,000/month = $593,916/year lost to churn |

---

## 🛠️ SQL Skills Used

- CTEs (WITH clause)
- Window Functions (RANK, NTILE, SUM OVER)
- PARTITION BY
- CASE WHEN (conditional aggregation)
- CROSS JOIN
- Data Cleaning (TRIM, ALTER TABLE)
- Subqueries
- ::numeric casting



---

## 📂 Files

| File | Description |
|---|---|
| `telco_churn_key_insights.sql` | All 25 queries with insights |
| `telco_churn_infographic.png` | Project summary infographic |

---

## 🚀 How to Run

1. Install PostgreSQL & pgAdmin
2. Create database `telco_project`
3. Download dataset from Kaggle
4. Run `telco_churn_key_insights.sql`

---

## 👤 Author
**Ritik Gupta**
SQL • Data Analytics • PostgreSQL
