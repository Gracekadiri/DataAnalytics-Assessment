# DataAnalytics-Assessment

This repository contains my solutions to the SQL Proficiency Assessment.

## Assessment_Q1.sql – High-Value Customers with Multiple Products
**Approach**
- Performed `INNER JOIN` across `users_customuser`, `plans_plan`, and `savings_savingsaccount` to identify users linked to both plan types.
- Counted **funded savings plans** (`is_regular_savings = 1`) and **funded investment plans** (`is_a_fund = 1`) using conditional aggregation.
- Ensured only actual deposits were considered by filtering `confirmed_amount > 0`.
- Converted transaction values from **kobo to Naira** by dividing by 100.
- Constructed the customer’s name from `first_name` and `last_name` using `CONCAT`.
- Sorted the results by `total_deposits DESC` to prioritize high-value customers.



## Assessment_Q2.sql – Transaction Frequency Analysis
**Approach**
- Created a CTE (`customer_activity`) to calculate:
  - The total number of transactions per customer.
  - Active tenure in months using `TIMESTAMPDIFF` between the earliest and latest transaction date.
  - Used `GREATEST(..., 1)` to ensure a minimum of one month to avoid divide-by-zero.
- In a second CTE, classified customers into three frequency categories:
  - High (≥10 transactions/month)
  - Medium (3–9)
  - Low (≤2)
- Aggregated customers by frequency category and calculated their average transaction rate.
- Ordered categories using `FIELD()` to ensure the specified priority order.



## Assessment_Q3.sql – Account Inactivity Alert
**Approach**
- Built a CTE (`latest_transactions`) to extract the last inflow (`MAX(transaction_date)`) for each plan from `savings_savingsaccount`, filtered on `confirmed_amount > 0`.
- Used `LEFT JOIN` to include plans with no inflows at all.
- In the main query:
  - Classified each plan as `Savings` or `Investment` using `CASE` on `is_regular_savings` and `is_a_fund`.
  - Calculated `inactivity_days` using `DATEDIFF(CURDATE(), last_transaction_date)`.
  - Flagged plans with either no transactions (`last_transaction_date IS NULL`) or no activity in the past 365 days.



## Assessment_Q4.sql – Customer Lifetime Value (CLV) Estimation
**Approach**
- Calculated customer tenure in months since `date_joined` using `TIMESTAMPDIFF`, with `GREATEST(..., 1)` to avoid zero-tenure edge cases.
  - Summed `confirmed_amount` values (in Naira) to compute total inflows.
  - Applied the simplified CLV formula:
CLV = (total_transactions / tenure_months) * 12 * 0.001
where `0.001` represents a 0.1% profit margin per transaction.
- Rounded and ordered results by `estimated_clv DESC`.



## Challenges & Solutions
### 1. Data Quality & Assumptions
- **Missing Full Names**: The `name` field was often NULL. I generated full names dynamically using `CONCAT(first_name, ' ', last_name)`.
- **Plan Classification**: Savings and investments were determined using boolean flags: `is_regular_savings = 1` and `is_a_fund = 1`.

### 2. Logical Edge Cases
- **Zero-Month Tenure**: To avoid divide-by-zero issues for customers with transactions within a single month, I used `GREATEST(..., 1)` to enforce a minimum tenure of one month.
- **Plans with No Transactions**: Used `LEFT JOIN` and checked for `NULL` in transaction dates to handle completely inactive accounts.
- **Short-Term Customers**: Ensured fair calculation of averages by treating all customers as having at least one month of activity.

### 3. Performance Considerations
- **Efficient Aggregation**: In Q3, I used a CTE to pre-calculate latest transaction dates, which improved clarity and reduced repeated aggregation.
- **Minimal Joins**: Queries were written with only necessary joins to maintain performance.


## Notes
- **SQL Dialect**: All queries are written for **MySQL**. To adapt for PostgreSQL:
- Replace `CURDATE()` with `CURRENT_DATE`
- Use `AGE()` or `DATE_TRUNC()` for time calculations
- **Currency Handling**: All money values are stored in **kobo**. Divided by 100 to display results in **Naira**.
- **Transaction Validity**: Only **confirmed inflows** (`confirmed_amount > 0`) were considered. No withdrawals or failed transactions were included.
- **Scope**: This assessment focused only on **inflows (deposits)**, as per the instructions. Withdrawals and balance history were out of scope.

