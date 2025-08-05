-- EASY-LEVEL TASKS
-- 1. Using Products table, find the total number of products available in each category.
SELECT
    Category,
    COUNT(ProductID) AS TotalProducts
FROM Products
GROUP BY Category;

-- 2. Using Products table, get the average price of products in the 'Electronics' category.
SELECT
    AVG(Price) AS AveragePrice
FROM Products
WHERE Category = 'Electronics';

-- 3. Using Customers table, list all customers from cities that start with 'L'.
SELECT
    FirstName,
    LastName,
    City
FROM Customers
WHERE City LIKE 'L%';

-- 4. Using Products table, get all product names that end with 'er'.
SELECT
    ProductName
FROM Products
WHERE ProductName LIKE '%er';

-- 5. Using Customers table, list all customers from countries ending in 'A'.
SELECT
    FirstName,
    LastName,
    Country
FROM Customers
WHERE Country LIKE '%a';

-- 6. Using Products table, show the highest price among all products.
SELECT
    MAX(Price) AS HighestPrice
FROM Products;

-- 7. Using Products table, label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.
SELECT
    ProductName,
    StockQuantity,
    CASE
        WHEN StockQuantity < 30 THEN 'Low Stock'
        ELSE 'Sufficient'
    END AS StockStatus
FROM Products;

-- 8. Using Customers table, find the total number of customers in each country.
SELECT
    Country,
    COUNT(CustomerID) AS TotalCustomers
FROM Customers
GROUP BY Country;

-- 9. Using Orders table, find the minimum and maximum quantity ordered.
SELECT
    MIN(Quantity) AS MinimumQuantity,
    MAX(Quantity) AS MaximumQuantity
FROM Orders;

-- MEDIUM-LEVEL TASKS
-- 10. Using Orders and Invoices tables, list customer IDs who placed orders in 2023 January to find those who did not have invoices.
SELECT DISTINCT
    Orders.CustomerID
FROM Orders AS o
LEFT JOIN Invoices AS i
    ON o.CustomerID = i.CustomerID
    AND YEAR(i.InvoiceDate) = 2023
    AND MONTH(i.InvoiceDate) = 1
WHERE
    YEAR(o.OrderDate) = 2023
    AND MONTH(o.OrderDate) = 1
    AND i.InvoiceID IS NULL;

-- 11. Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted including duplicates.
SELECT ProductName FROM Products
UNION ALL
SELECT ProductName FROM Products_Discounted;

-- 12. Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted without duplicates.
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 13. Using Orders table, find the average order amount by year.
SELECT
    YEAR(OrderDate) AS OrderYear,
    AVG(TotalAmount) AS AverageOrderAmount
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

-- 14. Using Products table, group products based on price: 'Low' (<100), 'Mid' (100-500), 'High' (>500). Return productname and pricegroup.
SELECT
    ProductName,
    Price,
    CASE
        WHEN Price < 100 THEN 'Low'
        WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
        ELSE 'High'
    END AS PriceGroup
FROM Products;

-- 15. Using City_Population table, use Pivot to show values of Year column in seperate columns ([2012], [2013]) and copy results to a new Population_Each_Year table.
SELECT
    district_name,
    [2012],
    [2013]
INTO Population_Each_Year
FROM (
    SELECT district_name, year, population
    FROM city_population
) AS SourceTable
PIVOT (
    MAX(population)
    FOR year IN ([2012], [2013])
) AS PivotTable;

-- 16. Using Sales table, find total sales per product Id.
SELECT
    ProductID,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

-- 17. Using Products table, use wildcard to find products that contain 'oo' in the name. Return productname.
SELECT
    ProductName
FROM Products
WHERE ProductName LIKE '%oo%';

-- 18. Using City_Population table, use Pivot to show values of City column in seperate columns (Bektemir, Chilonzor, Yakkasaroy)  and copy results to a new Population_Each_City table.
SELECT
    year,
    [Bektemir],
    [Chilonzor],
    [Yakkasaroy]
INTO Population_Each_City
FROM (
    SELECT district_name, year, population
    FROM city_population
) AS SourceTable
PIVOT (
    MAX(population)
    FOR district_name IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS PivotTable;

-- HARD-LEVEL TASKS
-- 19. Using Invoices table, show top 3 customers with the highest total invoice amount. Return CustomerID and Totalspent.
SELECT TOP 3
    CustomerID,
    SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

-- 20. Transform Population_Each_Year table to its original format (City_Population).
-- First, recreate the table from the Medium-Level task 15 if it doesn't exist.
-- The original table `City_Population` does not have a `district_id`.
-- The unpivot operation will lose the `district_id` column.
-- Assuming the user wants to unpivot the data back to a similar structure.
SELECT
    district_name,
    [year],
    population
FROM Population_Each_Year
UNPIVOT (
    population FOR [year] IN ([2012], [2013])
) AS UnpivotTable;

-- 21. Using Products and Sales tables, list product names and the number of times each has been sold. (Research for Joins)
SELECT
    p.ProductName,
    COUNT(s.ProductID) AS TimesSold
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductID = s.ProductID
GROUP BY
    p.ProductName
ORDER BY
    TimesSold DESC;

-- 22. Transform Population_Each_City table to its original format (City_Population).
-- First, recreate the table from the Medium-Level task 18 if it doesn't exist.
-- The original table `City_Population` does not have a `district_id`.
-- The unpivot operation will lose the `district_id` column.
-- Assuming the user wants to unpivot the data back to a similar structure.
SELECT
    year,
    district_name,
    population
FROM Population_Each_City
UNPIVOT (
    population FOR district_name IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS UnpivotTable;
