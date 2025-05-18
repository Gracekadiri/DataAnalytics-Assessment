-- Q2: Categorize customers based on average transactions per month
-- Frequency: High (≥10), Medium (3-9), Low (≤2)

WITH customer_activity AS (
    SELECT
        sa.owner_id,
        COUNT(*) AS total_transactions,
        -- Get active duration in months (use 1 if same month to avoid divide-by-zero)
        GREATEST(
            TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), MAX(sa.transaction_date)),
            1
        ) AS active_months
    FROM
        savings_savingsaccount sa
    WHERE
        sa.transaction_status = 'success'  -- Optional filter for valid transactions
    GROUP BY
        sa.owner_id
),
frequency_classification AS (
    SELECT
        owner_id,
        total_transactions,
        active_months,
        -- Average monthly transaction count
        ROUND(total_transactions / active_months, 2) AS avg_txn_per_month,
        -- Classify based on defined frequency ranges
        CASE
            WHEN total_transactions / active_months >= 10 THEN 'High Frequency'
            WHEN total_transactions / active_months BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        customer_activity
)

-- Final output: Frequency category, number of customers, and average monthly activity
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM
    frequency_classification
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
