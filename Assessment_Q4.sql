-- Q4: Estimate customer lifetime value based on tenure and confirmed inflow
-- Formula: (total_transactions / tenure_months) * 12 * 0.001

SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Months since account signup
    GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1) AS tenure_months,
    
    -- Total confirmed deposits (converted from kobo)
    ROUND(SUM(sa.confirmed_amount) / 100.0, 2) AS total_transactions,
    
    -- Estimated CLV based on formula
    ROUND((
        (SUM(sa.confirmed_amount) / 100.0) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1)
    ) * 12 * 0.001, 2) AS estimated_clv
FROM
    users_customuser u
JOIN
    savings_savingsaccount sa ON u.id = sa.owner_id
WHERE
    sa.confirmed_amount > 0
GROUP BY
    u.id, CONCAT(u.first_name, ' ', u.last_name), u.date_joined
ORDER BY
    estimated_clv DESC;
