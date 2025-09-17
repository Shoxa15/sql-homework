1. Customers who purchased in March 2024 (EXISTS)
SELECT DISTINCT s.CustomerName
FROM #Sales s
WHERE EXISTS (
    SELECT 1 
    FROM #Sales sub
    WHERE sub.CustomerName = s.CustomerName
      AND MONTH(sub.SaleDate) = 3
      AND YEAR(sub.SaleDate) = 2024
);

2. Product with highest revenue (subquery)
SELECT TOP 1 Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

3. Second highest sale amount (subquery + DISTINCT)
SELECT MAX(SaleAmount) AS SecondHighest
FROM (
    SELECT DISTINCT Quantity * Price AS SaleAmount
    FROM #Sales
) t
WHERE SaleAmount < (SELECT MAX(Quantity * Price) FROM #Sales);

4. Total quantity per month (subquery)
SELECT FORMAT(SaleDate, 'yyyy-MM') AS Month, 
       (SELECT SUM(Quantity) 
        FROM #Sales s2 
        WHERE FORMAT(s2.SaleDate,'yyyy-MM') = FORMAT(s1.SaleDate,'yyyy-MM')) AS TotalQty
FROM #Sales s1
GROUP BY FORMAT(SaleDate,'yyyy-MM');

5. Customers who bought same products as others (EXISTS)
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.CustomerName <> s2.CustomerName
      AND s1.Product = s2.Product
);

6. Fruits count (pivot)
SELECT Name,
       SUM(CASE WHEN Fruit='Apple' THEN 1 ELSE 0 END) AS Apple,
       SUM(CASE WHEN Fruit='Orange' THEN 1 ELSE 0 END) AS Orange,
       SUM(CASE WHEN Fruit='Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

7. Family older-younger pairs (recursive CTE)
WITH FamilyTree AS (
    SELECT ParentId, ChildID
    FROM Family
    UNION ALL
    SELECT f.ParentId, c.ChildID
    FROM FamilyTree f
    JOIN Family c ON f.ChildID = c.ParentId
)
SELECT * FROM FamilyTree;

8. CA → TX orders
SELECT o.*
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1 
      FROM #Orders c 
      WHERE c.CustomerID = o.CustomerID AND c.DeliveryState = 'CA'
  );

9. Insert missing resident names
UPDATE #residents
SET fullname = SUBSTRING(address, CHARINDEX('name=', address) + 5, 
               CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - CHARINDEX('name=', address) - 5)
WHERE fullname IS NULL;

10. Route Tashkent → Khorezm (recursive)
WITH Paths AS (
    SELECT DepartureCity, ArrivalCity, 
           CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(200)) AS Route,
           Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
    UNION ALL
    SELECT p.DepartureCity, r.ArrivalCity, 
           p.Route + ' - ' + r.ArrivalCity,
           p.Cost + r.Cost
    FROM Paths p
    JOIN #Routes r ON p.ArrivalCity = r.DepartureCity
)
SELECT TOP 1 Route, Cost
FROM Paths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost ASC;  -- cheapest

SELECT TOP 1 Route, Cost
FROM Paths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost DESC; -- most expensive

11. Ranking products by order of insertion
SELECT ID, Vals,
       SUM(CASE WHEN Vals='Product' THEN 1 ELSE 0 END) 
           OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS ProductGroup
FROM #RankingPuzzle;

12. Employees above avg sales in dept
SELECT EmployeeName, Department, SalesAmount
FROM #EmployeeSales e
WHERE SalesAmount > (
    SELECT AVG(SalesAmount) 
    FROM #EmployeeSales 
    WHERE Department = e.Department
      AND SalesMonth = e.SalesMonth
      AND SalesYear = e.SalesYear
);

13. Employees with highest sales per month (EXISTS)
SELECT DISTINCT e.EmployeeName, e.Department, e.SalesMonth, e.SalesYear
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales sub
    WHERE sub.SalesMonth = e.SalesMonth AND sub.SalesYear = e.SalesYear
    GROUP BY sub.SalesMonth, sub.SalesYear
    HAVING e.SalesAmount = MAX(sub.SalesAmount)
);

14. Employees with sales in every month (NOT EXISTS)
SELECT DISTINCT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth, SalesYear
    FROM #EmployeeSales
    EXCEPT
    SELECT SalesMonth, SalesYear
    FROM #EmployeeSales sub
    WHERE sub.EmployeeName = e.EmployeeName
);

15. Products above global avg price
SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

16. Products stock < max stock
SELECT Name
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

17. Products in same category as Laptop
SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name='Laptop');

18. Products price > lowest Electronics
SELECT Name
FROM Products
WHERE Price > (
    SELECT MIN(Price) FROM Products WHERE Category='Electronics'
);

19. Products price > avg of their category
SELECT Name
FROM Products p
WHERE Price > (
    SELECT AVG(Price) 
    FROM Products 
    WHERE Category = p.Category
);

20. Products ordered at least once
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

21. Products ordered > avg quantity
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (SELECT AVG(Quantity) FROM Orders);

22. Products never ordered
SELECT p.Name
FROM Products p
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.ProductID = p.ProductID);

23. Product with highest total ordered qty
SELECT TOP 1 p.Name, SUM(o.Quantity) AS TotalQty
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY TotalQty DESC;
