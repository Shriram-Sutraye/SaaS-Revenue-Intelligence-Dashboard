WITH customer_rfm AS (
    SELECT 
        "CustomerID",
        EXTRACT(DAY FROM (CURRENT_DATE - MAX("InvoiceDate"))) AS recency_days,
        COUNT(DISTINCT "InvoiceNo") AS frequency,
        SUM("TotalRevenue") AS monetary
    FROM transactions_cleaned
    GROUP BY "CustomerID"
),

rfm_scores AS (
    SELECT 
        "CustomerID",
        recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score
    FROM customer_rfm
),

rfm_segments AS (
    SELECT 
        *,
        (recency_score + frequency_score + monetary_score) AS rfm_total_score,
        CASE 
            WHEN (recency_score + frequency_score + monetary_score) >= 13 THEN 'Champion'
            WHEN (recency_score + frequency_score + monetary_score) >= 10 THEN 'Loyal'
            WHEN (recency_score + frequency_score + monetary_score) >= 7 AND recency_score <= 2 THEN 'At Risk'
            WHEN (recency_score + frequency_score + monetary_score) >= 7 THEN 'Potential Loyalist'
            WHEN recency_score <= 2 THEN 'Lost'
            ELSE 'New/Low Value'
        END AS customer_segment
    FROM rfm_scores
)

SELECT 
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(CAST(AVG(monetary) AS NUMERIC), 2) AS avg_revenue,
    ROUND(CAST(AVG(frequency) AS NUMERIC), 2) AS avg_transactions,
    ROUND(AVG(recency_days)) AS avg_days_since_purchase
FROM rfm_segments
GROUP BY customer_segment
ORDER BY customer_count DESC;
