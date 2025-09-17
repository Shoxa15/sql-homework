1. Distributors and sales by region (show 0 if no sales)
SELECT r.Region, d.Distributor, ISNULL(s.Sales, 0) AS Sales
FROM (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN #RegionSales s 
       ON r.Region = s.Region AND d.Distributor = s.Distributor
ORDER BY d.Distributor, r.Region;

2. Managers with at least 5 direct reports
SELECT m.name
FROM Employee m
JOIN Employee e ON m.id = e.managerId
GROUP BY m.id, m.name
HAVING COUNT(e.id) >= 5;

3. Products with ≥100 units ordered in Feb 2020
SELECT p.product_name, SUM(o.unit) AS unit
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

4. Vendor with most orders per customer
SELECT CustomerID, Vendor
FROM (
    SELECT CustomerID, Vendor,
           RANK() OVER (PARTITION BY CustomerID ORDER BY SUM([Count]) DESC) AS rnk
    FROM Orders
    GROUP BY CustomerID, Vendor
) t
WHERE rnk = 1;

5. Prime check with WHILE
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2, @isPrime BIT = 1;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0 
    BEGIN
        SET @isPrime = 0;
        BREAK;
    END
    SET @i += 1;
END

IF @isPrime = 1 
    PRINT 'This number is prime';
ELSE 
    PRINT 'This number is not prime';

6. Device signals by location
WITH DeviceStats AS (
    SELECT Device_id, Locations, COUNT(*) AS signals
    FROM Device
    GROUP BY Device_id, Locations
)
SELECT d.Device_id,
       COUNT(DISTINCT d.Locations) AS no_of_location,
       (SELECT TOP 1 Locations 
        FROM DeviceStats ds 
        WHERE ds.Device_id = d.Device_id
        ORDER BY signals DESC) AS max_signal_location,
       COUNT(*) AS no_of_signals
FROM Device d
GROUP BY d.Device_id;

7. Employees earning above department average
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
);

8. Lottery winnings calculation
WITH TicketMatch AS (
    SELECT t.TicketID, COUNT(DISTINCT t.Number) AS matched
    FROM Tickets t
    JOIN Numbers n ON t.Number = n.Number
    GROUP BY t.TicketID
)
SELECT SUM(
           CASE WHEN matched = (SELECT COUNT(*) FROM Numbers) THEN 100
                WHEN matched > 0 THEN 10
                ELSE 0 END
       ) AS TotalWinnings
FROM TicketMatch;


Даст 110.

9. Spending by platform (mobile, desktop, both)
WITH UserPlatform AS (
    SELECT User_id, Spend_date,
           SUM(CASE WHEN Platform='Mobile' THEN Amount ELSE 0 END) AS MobileSpend,
           SUM(CASE WHEN Platform='Desktop' THEN Amount ELSE 0 END) AS DesktopSpend
    FROM Spending
    GROUP BY User_id, Spend_date
)
SELECT Spend_date, 'Mobile' AS Platform,
       SUM(MobileSpend) AS Total_Amount,
       COUNT(CASE WHEN MobileSpend>0 AND DesktopSpend=0 THEN 1 END) AS Total_users
FROM UserPlatform
GROUP BY Spend_date
UNION ALL
SELECT Spend_date, 'Desktop',
       SUM(DesktopSpend),
       COUNT(CASE WHEN DesktopSpend>0 AND MobileSpend=0 THEN 1 END)
FROM UserPlatform
GROUP BY Spend_date
UNION ALL
SELECT Spend_date, 'Both',
       SUM(MobileSpend+DesktopSpend),
       COUNT(CASE WHEN MobileSpend>0 AND DesktopSpend>0 THEN 1 END)
FROM UserPlatform
GROUP BY Spend_date
ORDER BY Spend_date, Platform;

10. De-group products into unit rows
WITH RECURSIVE AS (
    SELECT Product, Quantity
    FROM Grouped
    UNION ALL
    SELECT Product, Quantity-1
    FROM RECURSIVE
    WHERE Quantity > 1
)
SELECT Product, 1 AS Quantity
FROM RECURSIVE
ORDER BY Product;
