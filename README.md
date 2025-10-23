# SaaS Revenue Intelligence Dashboard

**End-to-end data analytics project transforming retail transactions into SaaS subscription revenue insights using Python, PostgreSQL, and Power BI**

![Project Status](https://img.shields.io/badge/Status-Production-success)
![Python](https://img.shields.io/badge/Python-3.11-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)
![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-yellow)

---

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Business Problem](#business-problem)
- [Tech Stack](#tech-stack)
- [Project Architecture](#project-architecture)
- [Key Features](#key-features)
- [Dataset](#dataset)
- [Installation & Setup](#installation--setup)
- [Project Structure](#project-structure)
- [Data Pipeline](#data-pipeline)
- [SQL Analytics](#sql-analytics)
- [Power BI Dashboards](#power-bi-dashboards)
- [Key Insights](#key-insights)
- [Future Enhancements](#future-enhancements)
- [Author](#author)

---

## 🎯 Project Overview

This project demonstrates a complete data analytics workflow by transforming the **UCI Online Retail dataset** (541K+ e-commerce transactions) into a **SaaS subscription revenue model** with actionable business intelligence.

### What I Built
- **Python ETL Pipeline**: Cleaned 541K transactions → 407K clean records (75% retention)
- **PostgreSQL Analytics**: 5 advanced SQL views with window functions, CTEs, complex joins
- **Power BI Dashboards**: 7 interactive dashboards analyzing MRR, churn, cohorts, support
- **Synthetic Data Generation**: 13,854 support tickets + 9,481 usage logs correlated with revenue patterns

### Business Impact
- Identified **$785K annual revenue loss** from 37.7% Month 1 churn
- Flagged **$2.1M at-risk revenue** from 847 high-risk customers (19% of base)
- Discovered **Champions make 1.5x more purchases** in first 30 days (activation insight)
- Found **Hibernating segment generates 53% of support tickets** despite being 25% of customers

### Real-World Application
Simulates how SaaS companies like Salesforce, HubSpot, and Stripe analyze subscription revenue to drive retention and growth strategies.

---

## 💼 Business Problem

SaaS companies face critical revenue and retention challenges:

| **Problem** | **Solution Implemented** | **Result** |
|---|---|---|
| Revenue Attribution | MRR Growth Accounting (New, Expansion, Contraction, Churn) | Identified 0.97 churn-to-acquisition ratio |
| Customer Health | Churn Risk Scoring (0-100 predictive model) | Found 847 high-risk customers |
| Segmentation | RFM Analysis (8 customer personas) | Champions = 45% of revenue |
| Support Allocation | Ticket analysis by segment + sentiment | Prioritized Hibernating segment (78% negative) |
| Engagement | Usage pattern correlation with revenue | Power Users = 591% Champions |

---

## 🛠️ Tech Stack

| **Category** | **Technology** | **Purpose** |
|---|---|---|
| **Language** | Python 3.11 | Data cleaning, transformation, synthetic data generation |
| **Libraries** | pandas, numpy, matplotlib, seaborn, Faker | Data manipulation, visualization, synthetic data |
| **Database** | PostgreSQL 16 | Data warehouse, advanced SQL analytics |
| **Containerization** | Podman 5.6.2 | Rootless container deployment |
| **Visualization** | Power BI Desktop | Interactive dashboards, DAX measures |
| **Version Control** | Git/GitHub | Code management & collaboration |
| **IDE** | Jupyter Lab | Python development, EDA |

---

## 🏗️ Project Architecture

```
┌──────────────────────────────────────────────────────┐
│        UCI ONLINE RETAIL DATASET (CSV)               │
│           541,909 transactions                        │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────┐
│           PYTHON ETL PIPELINE                        │
│  ┌────────────────────────────────────────────────┐  │
│  │ 1. Data Cleaning                               │  │
│  │    • Remove 135K duplicates, nulls, outliers   │  │
│  │    • 406,829 clean transactions (75%)          │  │
│  │                                                 │  │
│  │ 2. SaaS Transformation                         │  │
│  │    • Transactions → Monthly subscriptions      │  │
│  │    • Calculate MRR per customer                │  │
│  │                                                 │  │
│  │ 3. Customer Analytics                          │  │
│  │    • RFM scoring (Recency, Frequency, Monetary)│  │
│  │    • 8-tier segmentation                       │  │
│  │    • Churn risk scoring (0-100)                │  │
│  │                                                 │  │
│  │ 4. Synthetic Data Generation                   │  │
│  │    • 13,854 support tickets                    │  │
│  │    • 9,481 usage logs                          │  │
│  │    • Correlated with purchase behavior         │  │
│  └────────────────────────────────────────────────┘  │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────┐
│         POSTGRESQL DATABASE (Podman)                 │
│  ┌────────────────────────────────────────────────┐  │
│  │ Tables (5):                                    │  │
│  │  • transactions (cleaned data)                 │  │
│  │  • mrr_subscriptions (monthly revenue)         │  │
│  │  • customer_analysis (RFM + churn)             │  │
│  │  • supporttickets (13,854 records)             │  │
│  │  • usagelogs (9,481 records)                   │  │
│  │                                                 │  │
│  │ SQL Views (5):                                 │  │
│  │  • 01_rfm_customer_segmentation.sql            │  │
│  │  • 02_churn_risk_scoring.sql                   │  │
│  │  • 03_cohort_retention_analysis.sql            │  │
│  │  • 04_mrr_growth_accounting.sql                │  │
│  │  • 05_customer_lifetime_value.sql              │  │
│  └────────────────────────────────────────────────┘  │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
┌──────────────────────────────────────────────────────┐
│            POWER BI DASHBOARDS                       │
│  • Business Overview (KPIs, MRR trends)              │
│  • MRR Growth (New, Expansion, Churn, Contraction)   │
│  • Customer Segmentation (RFM matrix, value tiers)   │
│  • Churn Risk & Intervention (Top at-risk customers) │
│  • Cohort & Retention (Month-over-month retention)   │
│  • Customer Support (Ticket volume by segment)       │
└──────────────────────────────────────────────────────┘
```

---

## ⭐ Key Features

### 1. MRR Growth Accounting
Decomposes monthly revenue changes into actionable components:
- **New MRR**: Revenue from first-time customers  
- **Expansion MRR**: Upgrades from existing customers (32% of growth)  
- **Contraction MRR**: Downgrades from existing customers  
- **Churn MRR**: Lost revenue from canceled subscriptions  
- **Net New MRR**: (New + Expansion) - (Contraction + Churn)

**Business Impact**: Identified 0.97 churn-to-acquisition ratio → "leaky bucket" problem

### 2. Customer Segmentation (RFM)
8-tier classification based on Recency, Frequency, Monetary scores:

| **Segment** | **Description** | **Revenue %** |
|---|---|---|
| **Champions** | High R, F, M scores | 45% |
| **Loyal Customers** | High frequency, moderate recency | 22% |
| **Promising** | Recent customers with growth potential | 8% |
| **New Customers** | First-time buyers | 5% |
| **Need Attention** | Declining engagement | 7% |
| **At Risk** | Low recent activity | 6% |
| **Lost** | No purchases in 6+ months | 4% |
| **Others** | Mid-tier customers | 3% |

### 3. Churn Risk Prediction
Predictive model scoring customers 0-100 using weighted algorithm:

```
Churn Risk = (Recency_Score × 0.4) +  
             (Frequency_Score × 0.3) +  
             (Monetary_Score × 0.2) +  
             (Engagement_Score × 0.1)
```

**Risk Categories**:
- 0-30: Low Risk (healthy engagement)
- 31-60: Medium Risk (monitor closely)
- 61-100: High Risk (immediate intervention)

**Business Impact**: 847 customers flagged → $12K monthly churn risk

### 4. Cohort Retention Analysis
Tracks customer retention month-over-month by acquisition cohort:
- **Average Retention**: 68% MoM
- **Best Cohort**: January 2011 (85% 12-month retention)
- **Month 1 Churn**: 37.7% (critical intervention point)

### 5. Customer Lifetime Value (CLV)
Projected revenue per customer:
```
CLV = Average MRR × (1 / Churn Rate) × Gross Margin
```

**Insight**: Loyal customers have 2.3x higher CLV ($3,245 vs $1,412)

---

## 📊 Dataset

**Source**: [UCI Machine Learning Repository - Online Retail Dataset](https://archive.ics.uci.edu/ml/datasets/Online+Retail)

| **Attribute** | **Details** |
|---|---|
| **Creator** | Daqing Chen, London South Bank University |
| **License** | Creative Commons Attribution 4.0 (CC BY 4.0) |
| **DOI** | [10.24432/C5BW33](https://doi.org/10.24432/C5BW33) |
| **Period** | December 2010 - December 2011 (12 months) |
| **Original Rows** | 541,909 transactions |
| **Columns** | 8 (InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country) |
| **Geography** | Primarily UK-based e-commerce (38 countries) |

**After Cleaning**:
- **Rows**: 406,829 transactions (75% retention)
- **Customers**: 4,372 unique
- **Products**: 3,684 unique SKUs
- **Revenue**: $9.7M total

---

## 🚀 Installation & Setup

### Prerequisites
```bash
Python 3.11+
PostgreSQL 16
Podman (or Docker)
Power BI Desktop
Git
```

### Step 1: Clone Repository
```bash
git clone https://github.com/Shriram-Sutraye/SaaS-Revenue-Intelligence-Dashboard.git
cd SaaS-Revenue-Intelligence-Dashboard
```

### Step 2: Setup Python Environment
```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install pandas numpy matplotlib seaborn faker psycopg2-binary jupyter
```

### Step 3: Run Jupyter Notebook
```bash
cd python_notebook
jupyter notebook SaaS_Revenue_Analytics.ipynb
```
**Run all cells** to:
- Clean data (remove duplicates, nulls, outliers)
- Generate SaaS transformations (MRR, subscriptions)
- Create synthetic data (support tickets, usage logs)
- Export to CSV

### Step 4: Setup PostgreSQL (Podman)
```bash
# Create volume for data persistence
podman volume create saas_revenue_data

# Run PostgreSQL container
podman run -d \
  --name saas_postgres \
  -e POSTGRES_PASSWORD=yourpassword \
  -e POSTGRES_DB=saas_analytics \
  -p 5432:5432 \
  -v saas_revenue_data:/var/lib/postgresql/data \
  postgres:16-alpine

# Verify container is running
podman ps
```

### Step 5: Load Data to PostgreSQL
```bash
# Connect to PostgreSQL
psql -h localhost -U postgres -d saas_analytics

# Create tables and load CSV data (paths from notebook exports)
\copy transactions FROM '/path/to/saas_cleaned_transactions.csv' DELIMITER ',' CSV HEADER;
\copy mrr_subscriptions FROM '/path/to/saas_mrr_subscriptions.csv' DELIMITER ',' CSV HEADER;
\copy customer_analysis FROM '/path/to/saas_customer_analysis.csv' DELIMITER ',' CSV HEADER;
\copy supporttickets FROM '/path/to/saas_support_tickets.csv' DELIMITER ',' CSV HEADER;
\copy usagelogs FROM '/path/to/saas_usage_logs.csv' DELIMITER ',' CSV HEADER;

# Create SQL analytical views
\i sql/01_rfm_customer_segmentation.sql
\i sql/02_churn_risk_scoring.sql
\i sql/03_cohort_retention_analysis.sql
\i sql/04_mrr_growth_accounting.sql
\i sql/05_customer_lifetime_value.sql
```

### Step 6: Open Power BI Dashboards
1. Open **Power BI Desktop**
2. **File → Import → Navigate** to `dashboards/` folder screenshots
3. To connect to live data:
   - Server: `localhost:5432`
   - Database: `saas_analytics`
   - Username: `postgres`
   - Password: `yourpassword`
4. Refresh data

---

## 📁 Project Structure

```
SaaS-Revenue-Intelligence-Dashboard/
│
├── dashboards/                        # Power BI dashboard screenshots
│   ├── Business_overview.png
│   ├── MRRGrowth.png
│   ├── Customer_segmentation_and_value.png
│   ├── Churn_risk_and_intervention.png
│   ├── Cohort_and_Retention.png
│   ├── Customer_support_overview.png
│   └── Churn_risk_and_cva.png
│
├── data/                              # Sample datasets
│   └── sample/
│       ├── rfm_customer_segments.csv
│       └── transactions_cleaned.csv
│
├── python_notebook/                   # Data processing notebook
│   └── SaaS_Revenue_Analytics.ipynb
│
├── sql/                               # SQL analytical views
│   ├── 01_rfm_customer_segmentation.sql
│   ├── 02_churn_risk_scoring.sql
│   ├── 03_cohort_retention_analysis.sql
│   ├── 04_mrr_growth_accounting.sql
│   └── 05_customer_lifetime_value.sql
│
├── .gitignore
└── README.md
```

---

## 🔄 Data Pipeline

### Phase 1: Data Cleaning & EDA
**Input**: 541,909 raw transactions  
**Actions**:
- Removed 135,037 duplicate transactions
- Handled 135,080 missing CustomerIDs (guest checkouts)
- Filtered negative quantities (returns/cancellations)
- Removed zero/negative prices
- Created `Revenue` column (Quantity × UnitPrice)

**Output**: 406,829 clean transactions, 4,372 customers (75% retention)

### Phase 2: SaaS Transformation
**Actions**:
- Converted one-time purchases → monthly subscriptions
- Calculated Monthly Recurring Revenue (MRR) per customer
- Generated subscription start dates (first purchase)
- Applied tiered pricing: Basic ($29), Standard ($79), Premium ($149)

**Output**: 13,054 monthly subscription records

### Phase 3: Customer Analytics
**RFM Scoring**:
- **Recency** (0-5): Days since last purchase
- **Frequency** (0-5): Number of purchases
- **Monetary** (0-5): Total revenue contribution

**Segmentation**: 8 customer personas (Champions, Loyal, At Risk, Lost, etc.)

**Churn Risk Scoring**:
```python
Churn Risk = (Recency × 0.4) + (Frequency × 0.3) + (Monetary × 0.2) + (Engagement × 0.1)
```

**Output**: 4,372 customers with RFM scores + churn risk (0-100)

### Phase 4: Synthetic Data Generation
**Support Tickets** (13,854 records):
- Correlated with revenue trends (declining revenue → more tickets)
- Sentiment analysis: Positive / Neutral / Negative
- Ticket types: Technical Issue, Billing, Feature Request, etc.

**Usage Logs** (9,481 records):
- Correlated with purchase frequency (active buyers → active users)
- Event types: Login, Dashboard View, Report Generated, etc.
- Session durations by customer segment

**Output**: Behavioral datasets for multi-dimensional analysis

### Phase 5: SQL Analytics Layer
Created 5 materialized views for dashboard consumption:
1. **MRR Growth Accounting**: New, Expansion, Contraction, Churn
2. **Customer Churn Risk**: Top 100 at-risk customers
3. **Cohort Retention Analysis**: Month-over-month retention rates
4. **Customer Lifetime Value**: Projected revenue per customer
5. **Support by Segment**: Ticket volume + sentiment by RFM segment

---

## 📈 SQL Analytics

### View 1: RFM Customer Segmentation
**Purpose**: Classify customers into 8 actionable segments

**Key SQL Techniques**:
- `NTILE()` window function for scoring (1-5 scale)
- Complex `CASE` statements for segmentation logic
- Date arithmetic with `DATEDIFF()`, `AGE()`

**Sample Output**:
| CustomerID | Recency | Frequency | Monetary | Segment | Revenue |
|---|---|---|---|---|---|
| 14911 | 5 | 5 | 5 | Champions | $77,183 |
| 12748 | 4 | 5 | 5 | Loyal Customers | $33,661 |

---

### View 2: Churn Risk Scoring
**Purpose**: Identify top 100 at-risk customers using predictive model

**Key SQL Techniques**:
- Multi-table `JOIN` (MRR + Transactions + Support)
- Weighted risk algorithm using `CASE WHEN`
- `EXTRACT()` for date math (days since last purchase)

**Sample Output**:
| CustomerID | CurrentMRR | RiskScore | RiskCategory | DaysSinceLastPurchase |
|---|---|---|---|---|
| 17420 | $945 | 87 | Critical | 247 |
| 16029 | $623 | 78 | High | 189 |

**Business Impact**: 847 customers scored 60+ → $2.1M at-risk MRR

---

### View 3: Cohort Retention Analysis
**Purpose**: Track month-over-month retention by signup cohort

**Key SQL Techniques**:
- `DATE_TRUNC()` for cohort grouping
- `LAG()` window function for sequential comparison
- Self-join for retention calculation

**Sample Output**:
| CohortMonth | MonthsSinceCohort | ActiveCustomers | RetentionRate |
|---|---|---|---|
| 2010-12 | 1 | 623 | 62.3% |
| 2010-12 | 6 | 421 | 42.1% |
| 2010-12 | 12 | 298 | 29.8% |

**Business Impact**: 37.7% Month 1 churn → $785K annual loss

---

### View 4: MRR Growth Accounting
**Purpose**: Decompose MRR changes into New, Expansion, Churn, Contraction

**Key SQL Techniques**:
- `LAG()` for month-over-month comparison
- CTEs for step-by-step logic
- `COALESCE()` for NULL handling

**Sample Output**:
| Month | NewMRR | ExpansionMRR | ContractionMRR | ChurnMRR | NetGrowth |
|---|---|---|---|---|---|
| 2011-06 | $45K | $12K | $3K | $38K | $16K |
| 2011-12 | $38K | $9K | $5K | $42K | $0K |

**Business Impact**: 0.97 churn-to-acquisition ratio → leaky bucket

---

### View 5: Customer Lifetime Value
**Purpose**: Calculate actual + projected CLV for each customer

**Key SQL Techniques**:
- Multiple CTEs for phased calculation
- `NULLIF()` to prevent division by zero
- Tiered classification (VIP, High, Medium, Low)

**Sample Output**:
| CustomerID | ActualCLV | PredictedAnnualValue | ValueTier | Status |
|---|---|---|---|---|
| 14911 | $77,183 | $92,620 | VIP | Active |
| 12748 | $33,661 | $40,393 | High Value | At Risk |

**Business Impact**: Top 10% VIP tier = 65% of total revenue

---

## 📊 Power BI Dashboards

### Dashboard 1: Business Overview
**KPIs**:
- Total MRR: $1.2M
- Total Customers: 4,372
- ARPU (Average Revenue Per User): $274
- MoM Growth Rate: +3.2%

**Visuals**:
- MRR trend line (13 months)
- Customer growth (new vs churned)
- Revenue by country (map)
- Top 10 customers (table)

---

### Dashboard 2: MRR Growth Accounting
**Visuals**:
- MRR components stacked area chart (New, Expansion, Churn, Contraction)
- Waterfall chart showing monthly changes
- KPI cards for each component
- Acquisition vs Churn trend line

**Key Insight**: Churn MRR ($3.84M) nearly matches New MRR ($3.96M) → 0.97 ratio

---

### Dashboard 3: Customer Segmentation & Value
**Visuals**:
- RFM donut chart (8 segments)
- Revenue bar chart by segment
- CLV histogram (Low/Medium/High/VIP)
- Segment performance table with recommendations

**Key Insight**: Champions (15% of customers) = 45% of revenue

---

### Dashboard 4: Churn Risk & Intervention
**Visuals**:
- Top 20 at-risk customers (bar chart)
- Risk score distribution (histogram)
- Churn risk by segment (heatmap)
- Intervention priority matrix

**Key Insight**: 847 customers scored 60+ → immediate action needed

---

### Dashboard 5: Cohort & Retention
**Visuals**:
- Retention curve (line chart)
- Month 1 churn donut (37.7% vs 62.3%)
- Cohort heatmap (signup month × retention %)
- Lifetime histogram

**Key Insight**: Jan 2011 cohort has 85% 12-month retention (best performing)

---

### Dashboard 6: Customer Support Overview
**Visuals**:
- Ticket volume by segment (bar chart)
- Sentiment analysis (pie chart)
- Tickets vs Revenue scatter plot
- Priority breakdown (donut chart)

**Key Insight**: Hibernating segment (25% of customers) = 53% of tickets (78% negative sentiment)

---

## 💡 Key Insights

### 1. Month 1 Churn Crisis
- **Finding**: 37.7% of customers churn after first month
- **Impact**: 1,634 lost customers × $2,198 avg value = **$785K annual loss**
- **Root Cause**: 62% never make a 2nd purchase (no activation program)
- **Solution**: Implement "First 30 Days" program with 2nd purchase incentives

### 2. Champion Creation Pattern
- **Finding**: Champions make **1.5x more purchases** in first 30 days vs non-Champions
- **Metric**: 1.8 purchases vs 1.2 (early repeat behavior = predictor)
- **Solution**: Flag customers without 2nd purchase in 14 days for proactive intervention

### 3. Revenue Concentration Risk
- **Finding**: Top 3 segments = **83.4% of revenue** (Champions, Loyal, Promising)
- **Risk**: Hibernating segment (25% of customers) = only 5.4% of revenue
- **Solution**: Win-back campaigns targeting "At Risk" and "Hibernating" → 20% conversion = $104K ARR

### 4. Usage-Loyalty Correlation
- **Finding**: 591% of Champions are "Power Users" (heavy engagement)
- **Finding**: 0% of At Risk/Hibernating are Power Users
- **Solution**: Gamify product engagement (badges, milestones) to move users from Light → Moderate tier

### 5. Support-Segment Problem
- **Finding**: Hibernating segment generates **53% of all support tickets**
- **Sentiment**: 78% negative (vs 45% for Champions)
- **Resolution Time**: Champions get **2.3x faster** resolution
- **Solution**: Dedicate CSM to Hibernating segment + prioritize tickets

---

## 🔮 Future Enhancements

### Phase 6: Machine Learning
- [ ] Churn prediction model (Random Forest / XGBoost)
- [ ] Customer segmentation using K-means clustering
- [ ] Revenue forecasting (ARIMA / Prophet)
- [ ] Anomaly detection for unusual MRR movements

### Phase 7: Real-Time Analytics
- [ ] Streaming data pipeline (Apache Kafka)
- [ ] Real-time dashboard updates
- [ ] Alert system for high-risk customer events
- [ ] Automated email campaigns based on churn risk

### Phase 8: Advanced Features
- [ ] Cohort analysis by acquisition channel (organic, paid, referral)
- [ ] Product usage analytics (feature-level tracking)
- [ ] A/B testing framework for retention strategies
- [ ] Integration with CRM systems (Salesforce, HubSpot)

---

## 👤 Author

**Shriram Sutraye**

- **GitHub**: [@Shriram-Sutraye](https://github.com/Shriram-Sutraye)
- **LinkedIn**: [Connect with me](https://linkedin.com/in/yourprofile)
- **Email**: your.email@example.com
- **Portfolio**: [yourportfolio.com](https://yourportfolio.com)

---

## 📜 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgments

- **Dataset**: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Online+Retail) - Daqing Chen
- **Inspiration**: Stripe Revenue Recognition, ChartMogul MRR Analytics
- **Tools**: PostgreSQL Community, Power BI Community, Podman Project

---

## 📚 References

1. UCI Online Retail Dataset: https://archive.ics.uci.edu/ml/datasets/Online+Retail
2. SaaS Metrics Guide: https://www.saastr.com/saas-metrics-guide/
3. Cohort Analysis: https://www.forbes.com/cohort-analysis-explained/
4. Churn Prediction: https://towardsdatascience.com/churn-prediction-in-saas

---

**⭐ Star this repo if you found it helpful!**

**🔗 Connect with me on [LinkedIn](https://linkedin.com/in/yourprofile) to discuss data analytics, SQL, and business intelligence!**
