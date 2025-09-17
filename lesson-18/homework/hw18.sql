1. Temporary table MonthlySales
SELECT p.ProductID,
       SUM(s.Quantity) AS TotalQuantity,
       SUM(s.Quantity * p.Price) AS TotalRevenue
INTO #MonthlySales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE MONTH(s.SaleDate) = MONTH(GETDATE())
  AND YEAR(s.SaleDate) = YEAR(GETDATE())
GROUP BY p.ProductID;

SELECT * FROM #MonthlySales;

2. View: Product Sales Summary
CREATE VIEW vw_ProductSalesSummary AS
SELECT p.ProductID, p.ProductName, p.Category,
       ISNULL(SUM(s.Quantity),0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;

3. Scalar function: total revenue for product
CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18,2);
    SELECT @Revenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE p.ProductID = @ProductID;
    RETURN ISNULL(@Revenue,0);
END;

4. Table-valued function: sales by category
CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT p.ProductName,
           SUM(s.Quantity) AS TotalQuantity,
           SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);

5. Prime number function
CREATE FUNCTION fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    IF @Number < 2 RETURN 'No';
    DECLARE @i INT = 2;
    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0 RETURN 'No';
        SET @i += 1;
    END
    RETURN 'Yes';
END;

6. Table-valued function: numbers between two values
CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS @Result TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @Start;
    WHILE @i <= @End
    BEGIN
        INSERT INTO @Result VALUES (@i);
        SET @i += 1;
    END
    RETURN;
END;

7. Nth highest distinct salary
CREATE FUNCTION getNthHighestSalary (@N INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT MIN(salary) 
        FROM (
            SELECT DISTINCT salary,
                   DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
            FROM Employee
        ) t
        WHERE rnk = @N
    );
END;

8. Person with the most friends
SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id, accepter_id AS friend FROM RequestAccepted
    UNION ALL
    SELECT accepter_id, requester_id FROM RequestAccepted
) t
GROUP BY id
ORDER BY COUNT(*) DESC;

9. View: Customer Order Summary
CREATE VIEW vw_CustomerOrderSummary AS
SELECT c.customer_id,
       c.name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.amount) AS total_amount,
       MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

10. Fill gaps with last non-null workflow
SELECT RowNumber,
       MAX(TestCase) OVER (
           ORDER BY RowNumber
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS Workflow
FROM Gaps
ORDER BY RowNumber;
