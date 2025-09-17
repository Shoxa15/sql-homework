1. Running Total per Customer
SELECT customer_id, customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS RunningTotal
FROM sales_data;


Кумулятивная сумма заказов по каждому клиенту.

2. Orders per Product Category
SELECT product_category, COUNT(*) AS OrderCount
FROM sales_data
GROUP BY product_category;

3. Max Total Amount per Category
SELECT product_category, MAX(total_amount) AS MaxAmount
FROM sales_data
GROUP BY product_category;

4. Min Price per Category
SELECT product_category, MIN(unit_price) AS MinPrice
FROM sales_data
GROUP BY product_category;

5. Moving Average of 3 Days
SELECT order_date, total_amount,
       AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM sales_data;

6. Total Sales per Region
SELECT region, SUM(total_amount) AS TotalSales
FROM sales_data
GROUP BY region;

7. Rank Customers by Spending
SELECT customer_id, customer_name,
       SUM(total_amount) AS TotalSpending,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS RankBySpending
FROM sales_data
GROUP BY customer_id, customer_name;

8. Difference with Previous Sale per Customer
SELECT customer_id, order_date, total_amount,
       total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS DiffPrev
FROM sales_data;

9. Top 3 Expensive Products per Category
SELECT product_category, product_name, unit_price
FROM (
    SELECT product_category, product_name, unit_price,
           DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS rnk
    FROM sales_data
) t
WHERE rnk <= 3;

10. Cumulative Sum per Region by Date
SELECT region, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS CumulativeSales
FROM sales_data;

Medium
11. Cumulative Revenue per Category
SELECT product_category, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date) AS CumulativeRevenue
FROM sales_data;

12. Sum of Previous Values (OneColumn)
SELECT Value,
       SUM(Value) OVER (ORDER BY (SELECT NULL) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [Sum of Previous]
FROM OneColumn;

13. Customers with Purchases in >1 Category
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

14. Customers Above-Average in Region
SELECT customer_id, customer_name, region, SUM(total_amount) AS TotalSpending
FROM sales_data
GROUP BY customer_id, customer_name, region
HAVING SUM(total_amount) > (
    SELECT AVG(total_amount) FROM sales_data s2 WHERE s2.region = sales_data.region
);

15. Rank Customers Within Region
SELECT region, customer_id, customer_name,
       SUM(total_amount) AS TotalSpending,
       RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS RankInRegion
FROM sales_data
GROUP BY region, customer_id, customer_name;

16. Running Total per Customer
SELECT customer_id, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;

17. Monthly Growth Rate
WITH monthly_sales AS (
    SELECT FORMAT(order_date, 'yyyy-MM') AS Month,
           SUM(total_amount) AS Revenue
    FROM sales_data
    GROUP BY FORMAT(order_date, 'yyyy-MM')
)
SELECT Month, Revenue,
       (Revenue - LAG(Revenue) OVER (ORDER BY Month)) * 100.0 / LAG(Revenue) OVER (ORDER BY Month) AS GrowthRate
FROM monthly_sales;

18. Customers Whose Current Order > Previous
SELECT customer_id, customer_name, order_date, total_amount
FROM (
    SELECT customer_id, customer_name, order_date, total_amount,
           LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS PrevAmount
    FROM sales_data
) t
WHERE total_amount > PrevAmount;

Hard
19. Products Above Average Price
SELECT DISTINCT product_name, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

20. Group Totals at First Row (MyData)
SELECT Id, Grp, Val1, Val2,
       CASE WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1
            THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp) ELSE NULL END AS Tot
FROM MyData;

21. Aggregate Cost & Quantity by ID (TheSumPuzzle)
SELECT ID, SUM(Cost) AS Cost, SUM(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

22. Find Gaps in Seats
SELECT s1.SeatNumber + 1 AS GapStart,
       s2.SeatNumber - 1 AS GapEnd
FROM Seats s1
JOIN Seats s2 ON s2.SeatNumber = (
    SELECT MIN(s3.SeatNumber)
    FROM Seats s3
    WHERE s3.SeatNumber > s1.SeatNumber
)
WHERE s1.SeatNumber + 1 <> s2.SeatNumber;
