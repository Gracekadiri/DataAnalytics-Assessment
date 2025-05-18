-- Q3: Identify active savings/investment plans with no inflow in the last 365 days

WITH latest_transactions AS (
    -- Get the most recent deposit (inflow) for each plan
    SELECT
        sa.plan_id,
        MAX(sa.transaction_date) AS last_transaction_date
    FROM
        savings_savingsaccount sa
    WHERE
        sa.confirmed_amount > 0
    GROUP BY
        sa.plan_id
),
inactive_plans AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        -- Classify plan type
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        lt.last_transaction_date,
        -- Days since last inflow
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
    FROM
        plans_plan p
    LEFT JOIN
        latest_transactions lt ON p.id = lt.plan_id
    WHERE
        p.status_id = 1  -- ✅ Replace with actual "active" status_id
        AND (
            lt.last_transaction_date IS NULL
            OR DATEDIFF(CURDATE(), lt.last_transaction_date) > 365
        )
)

-- Final result: Plans with no inflow in the last year
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM
    inactive_plans
ORDER BY
    inactivity_days DESC;
