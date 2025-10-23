-- ============================================================
-- QUERY 3: COHORT RETENTION ANALYSIS
-- Purpose: Track month-over-month retention rates by customer cohort
-- ============================================================

WITH customer_cohorts AS (
    -- Assign each customer to their first purchase month (cohort)
    SELECT 
        "CustomerID",
        DATE_TRUNC('month', MIN("InvoiceDate"))::DATE AS cohort_month
    FROM transactions_cleaned
    GROUP BY "CustomerID"
),

customer_monthly_activity AS (
    -- Track which months each customer was active
    SELECT DISTINCT
        "CustomerID",
        DATE_TRUNC('month', "InvoiceDate")::DATE AS activity_month
    FROM transactions_cleaned
),

cohort_size AS (
    -- Count how many customers in each cohort
    SELECT 
        cohort_month,
        COUNT(DISTINCT "CustomerID") AS cohort_customers
    FROM customer_cohorts
    GROUP BY cohort_month
),

retention_data AS (
    SELECT 
        c.cohort_month,
        a.activity_month,
        -- Calculate months since cohort start
        EXTRACT(YEAR FROM AGE(a.activity_month, c.cohort_month)) * 12 +
        EXTRACT(MONTH FROM AGE(a.activity_month, c.cohort_month)) AS months_since_cohort,
        COUNT(DISTINCT c."CustomerID") AS active_customers
    FROM customer_cohorts c
    JOIN customer_monthly_activity a ON c."CustomerID" = a."CustomerID"
    GROUP BY c.cohort_month, a.activity_month
)

-- Final output: Retention rates by cohort and month
SELECT 
    r.cohort_month,
    r.months_since_cohort,
    cs.cohort_customers AS cohort_size,
    r.active_customers,
    ROUND((r.active_customers::NUMERIC / cs.cohort_customers * 100), 2) AS retention_rate_pct
FROM retention_data r
JOIN cohort_size cs ON r.cohort_month = cs.cohort_month
WHERE r.months_since_cohort <= 12  -- First 12 months only
ORDER BY r.cohort_month, r.months_since_cohort;
