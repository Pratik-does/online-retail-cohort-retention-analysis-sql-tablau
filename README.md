# 🛒 Online Retail Customer Cohort Retention Analysis

> **End-to-end customer analytics project** — SQL data transformation · Cohort methodology · Tableau BI dashboard

---

## 📌 Project Overview

This project performs a complete **cohort-based customer retention analysis** on a real-world online retail dataset. Starting from raw transactional data, the pipeline cleans, transforms, and models customer purchase behavior across 13 monthly cohorts — ultimately surfacing actionable business intelligence through an interactive Tableau dashboard.

The goal is to answer a fundamental business question:

> *"After acquiring a customer, how long do we keep them — and when do we lose them?"*

---

## 🗂️ Repository Structure

```
online-retail-cohort-retention-analysis-sql-tablau/
│
├── data/
│   ├── processed/
│   │   └── cohort_retention_dataset_sample.csv   # Cleaned, cohort-indexed export
│   └── raw/
│       └── online_retail_sample.csv              # Raw transactional source data
│
├── sql/
│   └── cohort_retention_analysis.sql             # Full SQL transformation logic
│
├── tableau/
│   └── Cohort_Retention_Dashboard.twb            # Tableau workbook
│
├── screensots/
│   ├── Cohort_Rentention_Rate.png                # Retention heatmap (%)
│   ├── Cohort_Table.png                          # Retained customer counts
│   └── customer_retention_heatmap.png            # Combined dashboard view
│
└── README.md
```

---

## 📊 Dataset Summary

| Attribute | Value |
|---|---|
| **Source File** | Online Retail (Excel/CSV) |
| **Total Transactions** | 392,689+ |
| **Unique Customers** | 4,338 |
| **Unique Invoices** | 18,532 |
| **Countries** | 37 |
| **Analysis Period** | Dec 2010 – Dec 2011 |
| **Cohort Window** | 13 Monthly Cohorts |

The dataset contains invoice records, product details, customer IDs, quantities, unit prices, and geographic data — a standard online retail transaction history.

---

## 🛠️ Technical Stack

| Tool | Role |
|---|---|
| **SQL Server** | Data cleaning, cohort logic, retention matrix |
| **T-SQL** | ROW_NUMBER, DATEDIFF, DATEFROMPARTS, pivots |
| **Tableau Desktop** | Dashboard visualization and storytelling |
| **Excel / CSV** | Data storage, export, and BI ingestion |

---

## 🔄 Analytical Workflow

```
Raw Excel Data
     │
     ▼
Data Cleaning (remove NULLs, negatives, duplicates)
     │
     ▼
Cohort Assignment (first purchase month per customer)
     │
     ▼
Cohort Index Calculation (DATEDIFF month-over-month)
     │
     ▼
Retention Matrix (pivot: cohort × index → customer count)
     │
     ▼
Retention % Calculation (retained / cohort size)
     │
     ▼
CSV Export → Tableau Dashboard
```

---

## 🧹 Data Cleaning Steps

Before any analytical computation, the following preprocessing was applied in SQL:

- Removed records with **NULL CustomerIDs**
- Filtered out **negative or zero quantities** (cancellations / data errors)
- Filtered out **invalid unit prices** (zero or negative)
- Removed **duplicate transaction records**
- Standardized all dates to **monthly cohort periods**
- Generated a sequential **cohort index** for month-over-month tracking

---

## 🧮 SQL Methodology

The core SQL logic follows this pattern:

```sql
-- Step 1: Assign each customer their first purchase month (cohort period)
-- Step 2: For every subsequent purchase, calculate months since first purchase (cohort index)
-- Step 3: Count distinct customers per cohort_period × cohort_index combination
-- Step 4: Pivot into a retention matrix
-- Step 5: Calculate retention % = retained_customers / cohort_size

-- Key SQL features used:
--   ROW_NUMBER()        → deduplicate, identify first purchase
--   DATEDIFF()          → calculate cohort index
--   DATEFROMPARTS()     → normalize dates to month start
--   Temp tables         → stage intermediate transformations
--   PIVOT               → reshape rows into cohort matrix columns
```

> See full implementation: [`sql/cohort_retention_analysis.sql`](sql/cohort_retention_analysis.sql)

---

## 📈 Dashboard Visualizations

### 1. Cohort Retention Rate Heatmap (Orange Scale)

Displays **percentage-based retention** for each cohort across all cohort indices (months 1–13).

![Cohort Retention Rate](screensots/Cohort%20Rentention%20Rate.png)

**Key observations:**
- **Month 1** always shows 100% (acquisition baseline)
- Immediate post-acquisition drop: most cohorts fall to **15–24%** by Month 2
- The **Dec 2010 cohort** is the strongest performer — sustained 35–40% across months 3–10, peaking at **50% in Month 12**
- Retention generally **stabilizes between 15–30%** after the initial drop, a common pattern in non-subscription retail

---

### 2. Cohort Customer Count Table (Green Scale)

Displays **absolute retained customer counts** — the raw numbers behind the percentages.

![Cohort Table](screensots/Cohort%20Table.png)

**Key observations:**
- The **Dec 2010 cohort (885 customers)** is the largest acquired cohort — likely driven by holiday shopping
- Most cohorts range from **169–452 customers** at acquisition
- The **Dec 2011 cohort (41 customers)** is smallest — incomplete month at analysis cutoff
- Long-term retained groups remain in the **20–130 customer range** across most cohorts

---

### 3. Combined Dashboard View

![Customer Retention Heatmap](screensots/customer_retention_heatmap.png)

Both views side-by-side in Tableau allow analysts to cross-reference the *why* (retention %) and the *what* (customer volume) simultaneously.

---

## 💡 Key Business Insights

### 1. High Early-Stage Churn Is the Primary Risk
Over **75–85% of customers do not return** after their first purchase. This signals a need for:
- Post-purchase onboarding sequences
- First-30-day loyalty incentives
- Personalized re-engagement campaigns within the first 60 days

### 2. The December 2010 Cohort Outperforms All Others
This cohort maintains **35–50% retention through Month 12**, compared to 15–30% for other cohorts. Possible drivers:
- Holiday season purchase intent → higher brand affinity
- Larger cohort size creating a more stable long-term customer pool
- Potential promotional campaign alignment

### 3. Retention Stabilizes — Surviving Customers Are Loyal
After the initial drop, retention rates across most cohorts plateau in the **17–30% range**. Customers who return twice are likely to keep returning. This is a strong signal to invest in **second-purchase conversion** as a core growth lever.

### 4. Seasonal Patterns Affect Cohort Quality
Cohorts acquired in **Q4 (Oct–Dec)** consistently show stronger long-term retention than mid-year cohorts — suggesting seasonal buyers have higher lifetime value or that Q4 promotions attract a more engaged customer segment.

---

## 📁 Data Dictionary

| Column | Description |
|---|---|
| `CustomerID` | Unique customer identifier |
| `InvoiceDate` | Date of transaction |
| `cohort_period` | Customer's first purchase month (YYYY-MM-01) |
| `cohort_index` | Months since first purchase (1 = acquisition month) |
| `customer_count` | Number of distinct customers active in that period |
| `retention_rate` | `customer_count / cohort_size` × 100 |

---

## 🚀 How to Reproduce

**SQL Analysis:**
1. Load the raw dataset into SQL Server (or compatible RDBMS)
2. Execute `sql/cohort_retention_analysis.sql` in sequence
3. Export the resulting retention matrix to CSV

**Tableau Dashboard:**
1. Open `tableau/Cohort_Retention_Dashboard.twb`
2. Connect to `data/processed/cohort_retention_dataset_sample.csv`
3. Refresh the data source if prompted

> ⚠️ Ensure the CSV export includes column headers — Tableau field detection depends on a properly structured schema.

---

## 🔮 Future Enhancements

- [ ] Add **KPI summary cards** (avg. LTV, avg. retention duration, best/worst cohort)
- [ ] Add **country-level filter** for geographic retention segmentation
- [ ] Build **dynamic cohort selectors** in Tableau for drill-down analysis
- [ ] Expand dataset to multi-year window for trend validation
- [ ] Layer in **revenue-weighted retention** (not just customer count)
- [ ] Integrate with Python (pandas / matplotlib) for automated reporting pipeline

---

## 👤 About

Built as a portfolio project demonstrating end-to-end data analytics capability:
- Real-world transactional dataset
- Production-style SQL transformation logic
- BI dashboard storytelling
- Business insight generation — not just technical execution

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

*If you found this project helpful, consider giving it a ⭐ — it helps others discover it too.*
