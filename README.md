# DataAnalytics-Assessment
This repository contains my solutions to the SQL Proficiency Assessment.

## Assessment_Q1.sql – High-Value Customers with Multiple Products
**Approach:**  
Joined users, plans, and transactions. Filtered only funded savings and investment plans using `confirmed_amount > 0`. Counted distinct plan types and summed deposits.
**Challenge:**  
The name column was often NULL. I fixed this by using `CONCAT(first_name, last_name)` instead.

## Assessment_Q2.sql – Transaction Frequency Analysis
**Approach:**  
Used CTEs to count total transactions and calculate number of active months. Computed average transactions per month and categorized customers into frequency tiers.
**Challenge:**  
Had to use `GREATEST(..., 1)` to avoid divide-by-zero for customers with all transactions in one month.

## Assessment_Q3.sql – Account Inactivity Alert
**Approach:**  
Identified the last deposit (inflow) per plan using `MAX(transaction_date)`. Flagged accounts where no deposit occurred in the last 365 days. Used plan flags to classify as Savings or Investment.
**Challenge:**  
Some plans had no deposits at all. I used `LEFT JOIN` to catch those and handled NULLs in `last_transaction_date`.

## Assessment_Q4.sql – Customer Lifetime Value (CLV)
**Approach:**  
Calculated tenure in months since `date_joined`. Summed all deposits and applied the CLV formula. Rounded output values and ensured division safety.
**Challenge:**  
Made sure tenure wasn't 0 by using `GREATEST(..., 1)`, and converted all amounts from kobo to Naira.

## Notes
- All SQL queries include inline comments for clarity.
- Solutions are optimized for readability and performance.
