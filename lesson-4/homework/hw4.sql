Easy-Level Tasks 1
CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentName VARCHAR(50),
    Salary INT,
    HireDate DATE,
    Age INT,
    Email VARCHAR(100),
    Country VARCHAR(50)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentName, Salary, HireDate, Age, Email, Country)
VALUES
(1, 'Alice', 'Johnson', 'HR', 60000, '2018-05-10', 29, 'alice.johnson@example.com', 'USA'),
(2, 'Bob', 'Smith', 'IT', 75000, '2017-03-22', 35, 'bob.smith@example.com', 'USA'),
(3, 'Carol', 'Lee', 'Finance', 50000, '2019-07-01', 31, NULL, 'UK'),
(4, 'David', 'Brown', 'HR', 65000, '2020-11-15', 28, 'david.brown@example.com', 'Canada'),
(5, 'Eva', 'White', 'Marketing', 55000, '2021-01-10', 26, NULL, 'Australia');

Medium-Level Tasks 2
SELECT TOP 5 * FROM Employees;

SELECT DISTINCT Category FROM Products;

SELECT * FROM Products WHERE Price > 100;

SELECT * FROM Customers WHERE FirstName LIKE 'A%';

SELECT * FROM Products ORDER BY Price ASC;

SELECT * FROM Employees WHERE Salary >= 60000 AND DepartmentName = 'HR';

SELECT 
    EmployeeID,
    FirstName,
    LastName,
    DepartmentName,
    Salary,
    HireDate,
    Age,
    ISNULL(Email, 'noemail@example.com') AS Email,
    Country
FROM Employees;

SELECT * FROM Products WHERE Price BETWEEN 50 AND 100;

SELECT DISTINCT Category, ProductName FROM Products;

SELECT DISTINCT Category, ProductName FROM Products ORDER BY ProductName DESC;

SELECT TOP 10 * FROM Products ORDER BY Price DESC;

SELECT EmployeeID, COALESCE(FirstName, LastName) AS DisplayName FROM Employees;

SELECT DISTINCT Category, Price FROM Products;

SELECT * FROM Employees WHERE (Age BETWEEN 30 AND 40) OR DepartmentName = 'Marketing';

SELECT * FROM Employees ORDER BY Salary DESC OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT * FROM Products WHERE Price <= 1000 AND Stock > 50 ORDER BY Stock ASC;

SELECT * FROM Products WHERE ProductName LIKE '%e%';

SELECT * FROM Employees WHERE DepartmentName IN ('HR', 'IT', 'Finance');

SELECT * FROM Customers ORDER BY City ASC, PostalCode DESC;


