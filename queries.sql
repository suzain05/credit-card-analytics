create database credit_card_analytics;
use credit_card_analytics;

UPDATE transactions
SET City = REPLACE(City, ', India', '');

SET SQL_SAFE_UPDATES = 0;

UPDATE transactions
SET City = REPLACE(City, ', India', '');

ALTER TABLE transactions CHANGE COLUMN `ï»¿ID` id INT;

ALTER TABLE transactions MODIFY COLUMN txn_date DATE;

SELECT * FROM transactions LIMIT 10;

## 1. Total spend by city
SELECT City, SUM(Amount) AS total_spend
FROM transactions
GROUP BY City
ORDER BY total_spend DESC;

## 2. Total spend by card type
SELECT Card_Type, SUM(Amount) AS total_spend
FROM transactions
GROUP BY Card_Type
ORDER BY total_spend DESC;

SELECT 'Card Type', count('card type') AS total_spend
FROM transactions
GROUP BY 'Card Type'
ORDER BY total_spend DESC;

## 3. Total spend by expense category
SELECT expense_type, SUM(Amount) AS total_spend, COUNT(*) AS num_transactions
FROM transactions
GROUP BY expense_type
ORDER BY total_spend DESC;

## 4. Gender-wise total spend
SELECT Gender, SUM(Amount) AS total_spend, AVG(Amount) AS avg_transaction
FROM transactions
GROUP BY Gender;

## 5. Top 5 cities with % contribution to total spend
SELECT 
    City,
    SUM(Amount) AS city_spend,
    ROUND(SUM(Amount) * 100.0 / (SELECT SUM(Amount) FROM transactions), 2) AS pct_of_total
FROM transactions
GROUP BY City
ORDER BY city_spend DESC
LIMIT 5;

## 6. City with lowest % spend on Gold card type
SELECT City, SUM(Amount) AS gold_spend
FROM transactions
WHERE Card_Type = 'Gold'
GROUP BY City
ORDER BY gold_spend ASC
LIMIT 1;

## 7. Highest and lowest expense type per city
SELECT City, expense_type, SUM(Amount) AS total_spend
FROM transactions
GROUP BY City, expense_type
ORDER BY City, total_spend DESC;

## 8. Highest spend month overall
SELECT DATE_FORMAT(txn_date, '%Y-%m') AS month, SUM(Amount) AS total_spend
FROM transactions
GROUP BY month
ORDER BY total_spend DESC
LIMIT 1;

 ## 9. Highest spend month per card type
SELECT Card_Type, month, total_spend
FROM (
    SELECT Card_Type , DATE_FORMAT(txn_date, '%Y-%m') AS month, SUM(Amount) AS total_spend,
           RANK() OVER (PARTITION BY Card_Type ORDER BY SUM(Amount) DESC) AS rnk
    FROM transactions
    GROUP BY Card_Type, month
) ranked
WHERE rnk = 1;
 
## 10. Weekend vs weekday total spend
SELECT 
    CASE WHEN DAYOFWEEK(txn_date) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    SUM(Amount) AS total_spend,
    COUNT(*) AS num_transactions
FROM transactions
GROUP BY day_type;

##11. City with highest spend-to-transaction ratio on weekends
SELECT City, SUM(Amount)/COUNT(*) AS spend_per_txn
FROM transactions
WHERE DAYOFWEEK(txn_date) IN (1,7)
GROUP BY City
ORDER BY spend_per_txn DESC
LIMIT 5;
 
## 12. Cities spending above the overall average transaction amount
SELECT City, AVG(Amount) AS avg_spend
FROM transactions
GROUP BY City
HAVING AVG(Amount) > (SELECT AVG(Amount) FROM transactions);


## 13.Running (cumulative) total spend by city, ordered by date
SELECT City, txn_date, Amount,
       SUM(Amount) OVER (PARTITION BY City ORDER BY txn_date) AS running_total
FROM transactions
ORDER BY City, txn_date;


## 14. Rank cities by total spend
SELECT City, SUM(Amount) AS total_spend,
       RANK() OVER (ORDER BY SUM(Amount) DESC) AS city_rank
FROM transactions
GROUP BY City;
 
## 15. Each transaction's % contribution to its card type's total spend
SELECT id, Card_Type, Amount,
       ROUND(Amount * 100.0 / SUM(Amount) OVER (PARTITION BY Card_Type), 4) AS pct_of_card_total
FROM transactions
ORDER BY Card_Type, pct_of_card_total DESC;

## 16. Month-over-month growth in total spend
WITH monthly AS (
    SELECT DATE_FORMAT(txn_date, '%Y-%m') AS month, SUM(Amount) AS total_spend
    FROM transactions
    GROUP BY month
)
SELECT month, total_spend,
       LAG(total_spend) OVER (ORDER BY month) AS prev_month_spend,
       ROUND((total_spend - LAG(total_spend) OVER (ORDER BY month)) * 100.0 
             / LAG(total_spend) OVER (ORDER BY month), 2) AS pct_growth
FROM monthly
ORDER BY month;


##17. Month-over-month growth per card type + expense type combo
WITH combo_monthly AS (
    SELECT Card_Type, expense_type, DATE_FORMAT(txn_date, '%Y-%m') AS month, SUM(Amount) AS total_spend
    FROM transactions
    GROUP BY Card_Type, expense_type, month
)
SELECT Card_Type, expense_type, month, total_spend,
       total_spend - LAG(total_spend) OVER (PARTITION BY Card_Type, expense_type ORDER BY month) AS growth
FROM combo_monthly
ORDER BY Card_Type, expense_type, month;

## 18. Female spend % contribution by expense category
WITH female_totals AS (
    SELECT expense_type, SUM(Amount) AS female_spend
    FROM transactions WHERE Gender = 'F'
    GROUP BY expense_type
),
category_totals AS (
    SELECT expense_type, SUM(Amount) AS total_spend
    FROM transactions
    GROUP BY expense_type
)
SELECT f.expense_type, 
       ROUND(f.female_spend * 100.0 / c.total_spend, 2) AS female_pct
FROM female_totals f
JOIN category_totals c ON f.expense_type = c.expense_type
ORDER BY female_pct DESC;

## 19. Number of days each city took to reach its 500th transaction
WITH numbered AS (
    SELECT City, txn_date,
           ROW_NUMBER() OVER (PARTITION BY City ORDER BY txn_date, id) AS txn_num
    FROM transactions
),
first_last AS (
    SELECT City, MIN(txn_date) AS first_txn_date
    FROM transactions GROUP BY City
)
SELECT n.City, DATEDIFF(n.txn_date, f.first_txn_date) AS days_to_500th
FROM numbered n
JOIN first_last f ON n.City = f.City
WHERE n.txn_num = 500;

ALTER TABLE transactions CHANGE COLUMN `Card Type` card_type VARCHAR(50);

SELECT * FROM transactions LIMIT 3;
 
SELECT * FROM credit_card_analytics.transactions;