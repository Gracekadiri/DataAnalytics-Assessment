-- Q1: Identify users with at least one funded savings plan AND one funded investment plan
-- Includes total confirmed deposits (inflow only), sorted by highest deposits

SELECT
    u.id AS owner_id,
    -- Construct full name from first and last
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Count unique savings plans (where is_regular_savings = 1)
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    
    -- Count unique investment plans (where is_a_fund = 1)
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    
    -- Total confirmed deposits, converted from kobo to Naira
    ROUND(SUM(sa.confirmed_amount) / 100.0, 2) AS total_deposits
FROM
    users_customuser u
JOIN
    plans_plan p ON u.id = p.owner_id
JOIN
    savings_savingsaccount sa ON p.id = sa.plan_id
WHERE
    sa.confirmed_amount > 0  -- Ensure deposit was made
GROUP BY
    u.id, CONCAT(u.first_name, ' ', u.last_name)
HAVING
    -- Only include users with both plan types
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) >= 1
ORDER BY
    total_deposits DESC;
