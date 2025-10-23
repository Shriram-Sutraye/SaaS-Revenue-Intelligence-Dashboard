-- ============================================================
-- QUERY 5: CUSTOMER LIFETIME VALUE (CLV)
-- Purpose: Calculate total revenue, lifespan, and projected CLV per customer
-- ============================================================

WITH customer_transactions AS (
    -- Get all transaction data per customer
    SELECT 
        "CustomerID",
        MIN("InvoiceDate") AS first_purchase_date,
        MAX("InvoiceDate") AS last_purchase_date,
        COUNT(DISTINCT "InvoiceNo") AS total_transactions,
        COUNT(DISTINCT DATE_TRUNC('month', "InvoiceDate")) AS active_months,
        SUM("TotalRevenue") AS total_revenue,
        AVG("TotalRevenue") AS avg_transaction_value
    FROM transactions_cleaned
    GROUP BY "CustomerID"
),

customer_lifespan AS (
    SELECT 
        "CustomerID",
        first_purchase_date,
        last_purchase_date,
        total_transactions,
        active_months,
        total_revenue,
        avg_transaction_value,
        
        -- Calculate customer lifespan in days
        EXTRACT(DAY FROM (last_purchase_date - first_purchase_date)) AS lifespan_days,
        
        -- Calculate average order frequency (days between orders)
        CASE 
            WHEN total_transactions > 1 
            THEN EXTRACT(DAY FROM (last_purchase_date - first_purchase_date)) / (total_transactions - 1)
            ELSE NULL
        END AS avg_days_between_orders,
        
        -- Monthly revenue rate
        CASE 
            WHEN active_months > 0 
            THEN total_revenue / active_months
            ELSE total_revenue
        END AS avg_monthly_revenue
        
    FROM customer_transactions
),

customer_segments_data AS (
    -- Join with RFM segments
    SELECT 
        cl.*,
        COALESCE(rfm."Segment", 'Unknown') AS rfm_segment
    FROM customer_lifespan cl
    LEFT JOIN rfm_customer_segments rfm ON cl."CustomerID" = rfm."CustomerID"
),

clv_calculations AS (
    SELECT 
        "CustomerID",
        first_purchase_date,
        last_purchase_date,
        total_transactions,
        active_months,
        lifespan_days,
        ROUND(avg_transaction_value::NUMERIC, 2) AS avg_transaction_value,
        ROUND(avg_days_between_orders::NUMERIC, 1) AS avg_days_between_orders,
        ROUND(avg_monthly_revenue::NUMERIC, 2) AS avg_monthly_revenue,
        ROUND(total_revenue::NUMERIC, 2) AS actual_clv,
        rfm_segment,
        
        -- Predicted CLV (simple model: assume customer continues at current rate for 12 more months)
        ROUND((avg_monthly_revenue * 12)::NUMERIC, 2) AS predicted_annual_value,
        
        -- CLV category
        CASE 
            WHEN total_revenue >= 10000 THEN 'VIP (>$10K)'
            WHEN total_revenue >= 5000 THEN 'High Value ($5K-$10K)'
            WHEN total_revenue >= 1000 THEN 'Medium Value ($1K-$5K)'
            ELSE 'Low Value (<$1K)'
        END AS clv_tier,
        
        -- Customer status
        CASE 
            WHEN EXTRACT(DAY FROM (CURRENT_DATE - last_purchase_date)) > 180 THEN 'Churned'
            WHEN EXTRACT(DAY FROM (CURRENT_DATE - last_purchase_date)) > 90 THEN 'At Risk'
            ELSE 'Active'
        END AS customer_status
        
    FROM customer_segments_data
)

-- Final output: Customer CLV ranked by value
SELECT 
    "CustomerID",
    first_purchase_date,
    last_purchase_date,
    lifespan_days,
    total_transactions,
    active_months,
    avg_transaction_value,
    avg_days_between_orders,
    avg_monthly_revenue,
    actual_clv,
    predicted_annual_value,
    clv_tier,
    rfm_segment,
    customer_status
FROM clv_calculations
WHERE actual_clv > 0
ORDER BY actual_clv DESC
LIMIT 100;  -- Top 100 highest value customers
