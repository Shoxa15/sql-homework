Easy Tasks

1. Numbers table 1–1000 (recursive CTE)

WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < 1000
)
SELECT n
FROM Numbers
OPTION (MAXRECURSION 1000);


2. Total sales per employee (derived table)

SELECT e.EmployeeID, e.FirstName, e.LastName, s.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) s ON e.EmployeeID = s.EmployeeID;


3. Average salary (CTE)

WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary
FROM Employees e
CROSS JOIN AvgSalary;


4. Highest sales per product (derived table)

SELECT p.ProductID, p.ProductName, t.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) t ON p.ProductID = t.ProductID;


5. Double numbers until < 1,000,000 (recursive)

WITH Doubles AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n * 2
    FROM Doubles
    WHERE n * 2 < 1000000
)
SELECT n
FROM Doubles
OPTION (MAXRECURSION 1000);


6. Employees with more than 5 sales (CTE)

WITH SalesCount AS (
    SELECT EmployeeID, COUNT(*) AS SaleCount
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
JOIN SalesCount s ON e.EmployeeID = s.EmployeeID
WHERE s.SaleCount > 5;


7. Products with total sales > 500 (CTE)

WITH ProdSales AS (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT p.ProductName, ps.TotalSales
FROM Products p
JOIN ProdSales ps ON p.ProductID = ps.ProductID
WHERE ps.TotalSales > 500;


8. Employees with salaries above average (CTE)

WITH AvgSal AS (
    SELECT AVG(Salary) AS AvgSalary FROM Employees
)
SELECT e.*
FROM Employees e, AvgSal
WHERE e.Salary > AvgSalary;

Medium Tasks

9. Top 5 employees by orders (derived table)

SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName, t.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) t ON e.EmployeeID = t.EmployeeID
ORDER BY t.OrderCount DESC;


10. Sales per product category (derived table)

SELECT p.CategoryID, SUM(s.SalesAmount) AS TotalSales
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.CategoryID;


11. Factorial of each number (recursive CTE)

WITH Factorial AS (
    SELECT Number, CAST(Number AS BIGINT) AS Fact, Number AS n
    FROM Numbers1
    UNION ALL
    SELECT f.Number, f.Fact * (f.n - 1), f.n - 1
    FROM Factorial f
    WHERE f.n > 1
)
SELECT Number, MAX(Fact) AS Factorial
FROM Factorial
GROUP BY Number;


12. Split string into characters (recursive CTE)

WITH Split AS (
    SELECT Id, String, 1 AS pos, SUBSTRING(String, 1, 1) AS ch
    FROM Example
    UNION ALL
    SELECT Id, String, pos + 1, SUBSTRING(String, pos + 1, 1)
    FROM Split
    WHERE pos < LEN(String)
)
SELECT Id, ch
FROM Split
ORDER BY Id, pos
OPTION (MAXRECURSION 1000);


13. Sales difference current vs previous month (CTE + LAG)

WITH MonthlySales AS (
    SELECT 
        YEAR(SaleDate) AS Y,
        MONTH(SaleDate) AS M,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT Y, M,
       TotalSales,
       TotalSales - LAG(TotalSales) OVER (ORDER BY Y, M) AS DiffFromPrev
FROM MonthlySales;


14. Employees with >45000 sales per quarter (derived table)

SELECT e.EmployeeID, e.FirstName, e.LastName, t.Quarter, t.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID,
           DATEPART(QUARTER, SaleDate) AS Quarter,
           SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
) t ON e.EmployeeID = t.EmployeeID
WHERE t.TotalSales > 45000;

Difficult Tasks

15. Fibonacci numbers (recursive CTE)

WITH Fibonacci AS (
    SELECT 0 AS n, 0 AS f
    UNION ALL
    SELECT 1, 1
    UNION ALL
    SELECT n + 1, f + LAG(f) OVER (ORDER BY n)
    FROM Fibonacci
)
SELECT TOP 20 * FROM Fibonacci;


В SQL Server рекурсивный Fibonacci обычно делают через UNION ALL и JOIN самого себя.

16. Strings with all same characters (FindSameCharacters)

SELECT *
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND LEN(LTRIM(REPLACE(Vals, LEFT(Vals,1), ''))) = 0;


17. Numbers sequence 1 → 12 → 123… (recursive)

DECLARE @n INT = 5;
WITH Seq AS (
    SELECT 1 AS Id, CAST('1' AS VARCHAR(50)) AS NumStr
    UNION ALL
    SELECT Id + 1, NumStr + CAST(Id + 1 AS VARCHAR(10))
    FROM Seq
    WHERE Id < @n
)
SELECT * FROM Seq;


18. Employees with most sales in last 6 months (derived table)

SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName, t.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) t ON e.EmployeeID = t.EmployeeID
ORDER BY t.TotalSales DESC;


19. Remove duplicate integers from string (RemoveDuplicateIntsFromNames)

SELECT PawanName,
       Pawan_slug_name,
       STRING_AGG(DISTINCT value, '') AS Cleaned
FROM RemoveDuplicateIntsFromNames
CROSS APPLY STRING_SPLIT(Pawan_slug_name, '')
WHERE value NOT LIKE '[0-9]' 
   OR LEN(value) > 1
GROUP BY PawanName, Pawan_slug_name;
