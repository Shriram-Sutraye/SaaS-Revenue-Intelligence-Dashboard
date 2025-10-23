-- ============================================================
-- QUERY 2: CHURN RISK SCORING (Correct Support Tickets Columns)
-- ============================================================

WITH customer_mrr_trend AS (
    SELECT 
        "CustomerID",
        "Month",
        "MRR",
        LAG("MRR", 1) OVER (PARTITION BY "CustomerID" ORDER BY "Month") AS prev_month_mrr,
        LAG("MRR", 2) OVER (PARTITION BY "CustomerID" ORDER BY "Month") AS two_months_ago_mrr,
        ROW_NUMBER() OVER (PARTITION BY "CustomerID" ORDER BY "Month" DESC) AS month_rank
    FROM mrr_monthly_subscriptions
),

current_mrr AS (
    SELECT 
        "CustomerID",
        "MRR" AS current_mrr,
        prev_month_mrr,
        two_months_ago_mrr,
        CASE 
            WHEN prev_month_mrr > 0 THEN 
                ROUND((("MRR" - prev_month_mrr) / prev_month_mrr * 100)::NUMERIC, 2)
            ELSE 0
        END AS mrr_change_pct
    FROM customer_mrr_trend
    WHERE month_rank = 1
),

customer_activity AS (
    SELECT 
        "CustomerID",
        MAX("InvoiceDate") AS last_transaction_date,
        EXTRACT(DAY FROM (CURRENT_DATE - MAX("InvoiceDate"))) AS days_since_last_purchase
    FROM transactions_cleaned
    GROUP BY "CustomerID"
),

support_activity AS (
    SELECT 
        "CustomerID",
        COUNT(*) AS ticket_count,
        SUM(CASE WHEN "Sentiment" = 'Negative' THEN 1 ELSE 0 END) AS negative_sentiment_tickets
    FROM support_tickets
    GROUP BY "CustomerID"
),

churn_risk_scores AS (
    SELECT 
        m."CustomerID",
        m.current_mrr,
        m.mrr_change_pct,
        a.days_since_last_purchase,
        COALESCE(s.ticket_count, 0) AS ticket_count,
        COALESCE(s.negative_sentiment_tickets, 0) AS negative_sentiment_tickets,
        (
            CASE 
                WHEN m.mrr_change_pct < -50 THEN 40
                WHEN m.mrr_change_pct < -25 THEN 30
                WHEN m.mrr_change_pct < 0 THEN 20
                ELSE 0
            END +
            CASE 
                WHEN a.days_since_last_purchase > 180 THEN 30
                WHEN a.days_since_last_purchase > 90 THEN 20
                WHEN a.days_since_last_purchase > 60 THEN 10
                ELSE 0
            END +
            CASE 
                WHEN COALESCE(s.negative_sentiment_tickets, 0) >= 3 THEN 30
                WHEN COALESCE(s.ticket_count, 0) >= 5 THEN 20
                WHEN COALESCE(s.ticket_count, 0) >= 3 THEN 10
                ELSE 0
            END
        ) AS churn_risk_score
    FROM current_mrr m
    JOIN customer_activity a ON m."CustomerID" = a."CustomerID"
    LEFT JOIN support_activity s ON m."CustomerID" = s."CustomerID"
)

SELECT 
    "CustomerID",
    current_mrr,
    mrr_change_pct,
    days_since_last_purchase,
    ticket_count,
    negative_sentiment_tickets,
    churn_risk_score,
    CASE 
        WHEN churn_risk_score >= 70 THEN 'Critical - Immediate Action'
        WHEN churn_risk_score >= 50 THEN 'High Risk'
        WHEN churn_risk_score >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM churn_risk_scores
WHERE current_mrr > 0
ORDER BY churn_risk_score DESC, current_mrr DESC
LIMIT 100;