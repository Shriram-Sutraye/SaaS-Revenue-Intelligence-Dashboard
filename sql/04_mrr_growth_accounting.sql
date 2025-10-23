-- ============================================================
-- QUERY 4: MRR GROWTH ACCOUNTING (Fixed Date Parsing)
-- ============================================================

WITH monthly_mrr AS (
    SELECT 
        "CustomerID",
        TO_DATE("Month" || '-01', 'YYYY-MM-DD') AS month_date,
        "MRR",
        LAG("MRR") OVER (PARTITION BY "CustomerID" ORDER BY "Month") AS prev_month_mrr,
        LAG("Month") OVER (PARTITION BY "CustomerID" ORDER BY "Month") AS prev_month
    FROM mrr_monthly_subscriptions
),

mrr_changes AS (
    SELECT 
        month_date,
        "CustomerID",
        "MRR" AS current_mrr,
        COALESCE(prev_month_mrr, 0) AS prev_month_mrr,
        
        CASE
            WHEN prev_month_mrr IS NULL THEN 'New'
            WHEN "MRR" > prev_month_mrr THEN 'Expansion'
            WHEN "MRR" < prev_month_mrr AND "MRR" > 0 THEN 'Contraction'
            WHEN prev_month_mrr = 0 AND "MRR" > 0 THEN 'Reactivation'
            ELSE 'Retained'
        END AS mrr_type,
        
        CASE
            WHEN prev_month_mrr IS NULL THEN "MRR"
            WHEN "MRR" > prev_month_mrr THEN "MRR" - prev_month_mrr
            WHEN "MRR" < prev_month_mrr THEN prev_month_mrr - "MRR"
            ELSE 0
        END AS mrr_change
        
    FROM monthly_mrr
),

churned_customers AS (
    SELECT 
        (TO_DATE("Month" || '-01', 'YYYY-MM-DD') + INTERVAL '1 month')::DATE AS churn_month,
        "CustomerID",
        "MRR" AS churned_mrr
    FROM mrr_monthly_subscriptions m1
    WHERE NOT EXISTS (
        SELECT 1 
        FROM mrr_monthly_subscriptions m2 
        WHERE m2."CustomerID" = m1."CustomerID" 
        AND TO_DATE(m2."Month" || '-01', 'YYYY-MM-DD') = TO_DATE(m1."Month" || '-01', 'YYYY-MM-DD') + INTERVAL '1 month'
    )
),

monthly_summary AS (
    SELECT 
        month_date,
        SUM(CASE WHEN mrr_type = 'New' THEN mrr_change ELSE 0 END) AS new_mrr,
        SUM(CASE WHEN mrr_type = 'Expansion' THEN mrr_change ELSE 0 END) AS expansion_mrr,
        SUM(CASE WHEN mrr_type = 'Contraction' THEN mrr_change ELSE 0 END) AS contraction_mrr,
        SUM(CASE WHEN mrr_type = 'Reactivation' THEN mrr_change ELSE 0 END) AS reactivation_mrr,
        SUM(current_mrr) AS total_mrr,
        COUNT(DISTINCT CASE WHEN mrr_type = 'New' THEN "CustomerID" END) AS new_customers,
        COUNT(DISTINCT "CustomerID") AS total_customers
    FROM mrr_changes
    GROUP BY month_date
),

churn_summary AS (
    SELECT 
        churn_month,
        SUM(churned_mrr) AS churned_mrr,
        COUNT(DISTINCT "CustomerID") AS churned_customers
    FROM churned_customers
    GROUP BY churn_month
)

SELECT 
    m.month_date,
    ROUND(m.new_mrr::NUMERIC, 2) AS new_mrr,
    ROUND(m.expansion_mrr::NUMERIC, 2) AS expansion_mrr,
    ROUND(m.reactivation_mrr::NUMERIC, 2) AS reactivation_mrr,
    ROUND(COALESCE(c.churned_mrr, 0)::NUMERIC, 2) AS churned_mrr,
    ROUND(m.contraction_mrr::NUMERIC, 2) AS contraction_mrr,
    ROUND((m.new_mrr + m.expansion_mrr + m.reactivation_mrr - COALESCE(c.churned_mrr, 0) - m.contraction_mrr)::NUMERIC, 2) AS net_mrr_growth,
    ROUND(m.total_mrr::NUMERIC, 2) AS total_mrr,
    m.new_customers,
    COALESCE(c.churned_customers, 0) AS churned_customers,
    m.total_customers,
    ROUND(((m.new_mrr + m.expansion_mrr + m.reactivation_mrr - COALESCE(c.churned_mrr, 0) - m.contraction_mrr) / 
           NULLIF(LAG(m.total_mrr) OVER (ORDER BY m.month_date), 0) * 100)::NUMERIC, 2) AS growth_rate_pct
FROM monthly_summary m
LEFT JOIN churn_summary c ON m.month_date = c.churn_month
ORDER BY m.month_date;
