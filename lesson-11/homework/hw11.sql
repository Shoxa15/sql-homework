# Lesson 11 Homework Tasks


## 🟢 Easy-Level Tasks (7)

1. **Return**: `OrderID`, `CustomerName`, `OrderDate`  
   **Task**: Show all orders placed after 2022 along with the names of the customers who placed them.  
   **Tables Used**: `Orders`, `Customers`
SELECT
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderDate
FROM Orders AS o
JOIN Customers AS c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) > 2022;

  
2. **Return**: `EmployeeName`, `DepartmentName`  
   **Task**: Display the names of employees who work in either the Sales or Marketing department.  
   **Tables Used**: `Employees`, `Departments`

  SELECT
    e.Name AS EmployeeName,
    d.DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing');

3. **Return**: `DepartmentName`,  `MaxSalary`  
   **Task**: Show the highest salary for each department.  
   **Tables Used**: `Departments`, `Employees`

  SELECT
    d.DepartmentName,
    MAX(e.Salary) AS MaxSalary
FROM Departments AS d
JOIN Employees AS e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

4. **Return**: `CustomerName`, `OrderID`, `OrderDate`  
   **Task**: List all customers from the USA who placed orders in the year 2023.  
   **Tables Used**: `Customers`, `Orders`
SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderID,
    o.OrderDate
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND YEAR(o.OrderDate) = 2023;

  
5. **Return**: `CustomerName`, `TotalOrders`  
   **Task**: Show how many orders each customer has placed.  
   **Tables Used**: `Orders` , `Customers`
SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

6. **Return**: `ProductName`, `SupplierName`  
   **Task**: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.  
   **Tables Used**: `Products`, `Suppliers`

SELECT
    p.ProductName,
    s.SupplierName
FROM Products AS p
JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies', 'Clothing Mart');

7. **Return**: `CustomerName`, `MostRecentOrderDate`  
   **Task**: For each customer, show their most recent order. Include customers who haven't placed any orders.  
   **Tables Used**: `Customers`, `Orders`
SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers AS c
LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

  
---

## 🟠 Medium-Level Tasks (6)

8. **Return**: `CustomerName`,  `OrderTotal`  
   **Task**: Show the customers who have placed an order where the total amount is greater than 500.  
   **Tables Used**: `Orders`, `Customers`
SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.TotalAmount AS OrderTotal
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > 500;
  
9. **Return**: `ProductName`, `SaleDate`, `SaleAmount`  
   **Task**: List product sales where the sale was made in 2022 or the sale amount exceeded 400.  
   **Tables Used**: `Products`, `Sales`
SELECT
    p.ProductName,
    s.SaleDate,
    s.SaleAmount
FROM Products AS p
JOIN Sales AS s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2022 OR s.SaleAmount > 400;

  
10. **Return**: `ProductName`, `TotalSalesAmount`  
    **Task**: Display each product along with the total amount it has been sold for.  
    **Tables Used**: `Sales`, `Products`
SELECT
    p.ProductName,
    COALESCE(SUM(s.SaleAmount), 0) AS TotalSalesAmount
FROM Products AS p
LEFT JOIN Sales AS s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;

  
11. **Return**: `EmployeeName`, `DepartmentName`, `Salary`  
    **Task**: Show the employees who work in the HR department and earn a salary greater than 60000.  
    **Tables Used**: `Employees`, `Departments`
SELECT
    e.Name AS EmployeeName,
    d.DepartmentName,
    e.Salary
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Human Resources' AND e.Salary > 60000;

  
12. **Return**: `ProductName`, `SaleDate`, `StockQuantity`  
    **Task**: List the products that were sold in 2023 and had more than 100 units in stock at the time.  
    **Tables Used**: `Products`, `Sales`
SELECT
    p.ProductName,
    s.SaleDate,
    p.StockQuantity
FROM Products AS p
JOIN Sales AS s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2023 AND p.StockQuantity > 100;

  
13. **Return**: `EmployeeName`, `DepartmentName`, `HireDate`  
    **Task**: Show employees who either work in the Sales department or were hired after 2020.  
    **Tables Used**: `Employees`, `Departments`
SELECT
    e.Name AS EmployeeName,
    d.DepartmentName,
    e.HireDate
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' OR YEAR(e.HireDate) > 2020;

  
---

## 🔴 Hard-Level Tasks (7)

14. **Return**: `CustomerName`, `OrderID`, `Address`, `OrderDate`  
    **Task**: List all orders made by customers in the USA whose address starts with 4 digits.  
    **Tables Used**: `Customers`, `Orders`
SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderID,
    c.Address,
    o.OrderDate
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';
  

15. **Return**: `ProductName`, `Category`, `SaleAmount`  
    **Task**: Display product sales for items in the Electronics category or where the sale amount exceeded 350.  
    **Tables Used**: `Products`, `Sales`
SELECT
    p.ProductName,
    cat.CategoryName AS Category,
    s.SaleAmount
FROM Sales AS s
JOIN Products AS p ON s.ProductID = p.ProductID
JOIN Categories AS cat ON p.Category = cat.CategoryID
WHERE cat.CategoryName = 'Electronics' OR s.SaleAmount > 350;

  
16. **Return**: `CategoryName`, `ProductCount`  
    **Task**: Show the number of products available in each category.  
    **Tables Used**: `Products`, `Categories`
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM Categories AS c
LEFT JOIN Products AS p ON c.CategoryID = p.Category
GROUP BY c.CategoryName;

  
17. **Return**: `CustomerName`, `City`, `OrderID`, `Amount`  
    **Task**: List orders where the customer is from Los Angeles and the order amount is greater than 300.  
    **Tables Used**: `Customers`, `Orders`

  SELECT
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.City,
    o.OrderID,
    o.TotalAmount AS Amount
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE c.City = 'Los Angeles' AND o.TotalAmount > 300;

  
18. **Return**: `EmployeeName`, `DepartmentName`  
    **Task**: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.  
    **Tables Used**: `Employees`, `Departments`

SELECT
    e.Name AS EmployeeName,
    d.DepartmentName
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE
    d.DepartmentName IN ('Human Resources', 'Finance')
    OR (
        LEN(e.Name) - LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(e.Name), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', ''))
    ) >= 4;

  
19. **Return**: `EmployeeName`, `DepartmentName`, `Salary`  
    **Task**: Show employees who are in the Sales or Marketing department and have a salary above 60000.  
    **Tables Used**: `Employees`, `Departments`

  SELECT
    e.Name AS EmployeeName,
    d.DepartmentName,
    e.Salary
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing') AND e.Salary > 60000;
  
