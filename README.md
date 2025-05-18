# DataAnalytics-Assessment
This repository contains my solutions to the SQL Proficiency Assessment.

### 1. High-Value Customers with Multiple Products (`Assessment_Q1.sql`)
**Approach**
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount` using `INNER JOIN` to identify customers with both savings and investment products.
- Used conditional aggregation (`CASE`) to count funded plans:
  - `is_regular_savings = 1` for savings plans.
  - `is_a_fund = 1` for investment plans.
- Filtered deposits with `confirmed_amount > 0` to include only successful transactions.
- Converted `confirmed_amount` from kobo to Naira by dividing by 100.
- Sorted results by `total_deposits DESC` to highlight high-value customers.
  

### 2. Transaction Frequency Analysis (`Assessment_Q2.sql`)
**Approach**
- Defined a CTE (`customer_activity`) to calculate:
  - Total number of successful transactions per customer.
  - Account tenure in months using `TIMESTAMPDIFF`, with a minimum of 1 via `GREATEST(..., 1)`.
- Used a `CASE` statement to assign customers to frequency tiers (High / Medium / Low).
- Calculated average transactions per month and aggregated results by frequency category.
- Ordered output logically using `FIELD()` to reflect business priorities.


### 3. Account Inactivity Alert (`Assessment_Q3.sql`)
**Approach**
- Created a CTE `latest_transactions` to extract the most recent deposit (`MAX(transaction_date)`) per plan.
- Identified plan types using `CASE` based on `is_regular_savings` and `is_a_fund`.
- Calculated days since the last transaction using `DATEDIFF(CURDATE(), last_transaction_date)`.
- Flagged accounts as inactive if:
  - No deposits in the last 365 days, or
  - No transactions recorded (`last_transaction_date IS NULL`).


### 4. Customer Lifetime Value (CLV) Estimation (`Assessment_Q4.sql`)
**Approach**
- Calculated customer tenure in months using `TIMESTAMPDIFF(date_joined, CURDATE())`, with a minimum value of 1 month.
- Summed `confirmed_amount` (converted to Naira) as total lifetime inflows.
- Used the formula:  
  `(total_transactions / tenure_months) * 12 * 0.001`  
  where 0.1% is the assumed profit margin per transaction.
- Ensured no division by zero using `GREATEST(tenure_months, 1)`.


## Challenges & Solutions
### 1. Data Quality & Assumptions
- **Null Names**: Some user names were incomplete; full names were dynamically constructed using `CONCAT(first_name, ' ', last_name)`.
- **Ambiguous Plan Status**: Assumed `status_id = 1` indicates active plans based on context; noted this in code comments.
- **Plan Classification**: Inferred plan types using `is_regular_savings` and `is_a_fund` boolean flags.

### 2. Logical Edge Cases
- **Division by Zero**: Used `GREATEST(..., 1)` to ensure safe calculations in transaction averages and CLV where tenure might be zero.
- **Short-Term Accounts**: For accounts active less than a month, enforced a minimum tenure of 1 to avoid distorted frequency or CLV values.
- **No Transactions**: Handled customers or plans with no transactions using `LEFT JOIN` and `IS NULL` checks in relevant queries.

### 3. Performance Optimizations
- In Q3, pre-aggregated latest transaction data in a CTE instead of using repeated subqueries, significantly improving query efficiency.


## Notes & Assumptions
- **SQL Dialect**: Queries are written in **MySQL**. For PostgreSQL, adjustments such as replacing `CURDATE()` with `CURRENT_DATE` and using `DATE_TRUNC` or `EXTRACT` would be required.
- **Currency Handling**: All monetary values are stored in **kobo** and converted to **Naira** by dividing by 100.
- **Valid Transactions**: Only **successful** inflows (`confirmed_amount > 0` and `transaction_status = 'success'`) were included.
- **Focus**: The analysis includes only deposits. Withdrawals were intentionally excluded based on the assessment’s stated goal.
