Easy
--1-task
CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Али', 6500.00);
INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
(2, 'Мария', 5200.00),
(3, 'Бахтиёр', 4800.00);
UPDATE Employees
SET Salary = 7000.00
WHERE EmpID = 1;
DELETE FROM Employees
WHERE EmpID = 2;
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);
ALTER TABLE Employees
ADD Department VARCHAR(50);
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
DELETE FROM Employees;
--------------------------------------------------------
--11-task:
CREATE TABLE #TempDepartments (
    DepartmentName VARCHAR(50)
);
INSERT INTO #TempDepartments (DepartmentName)
VALUES 
('Финансы'),
('Маркетинг'),
('Кадры'),
('Продажи'),
('ИТ');
INSERT INTO Departments (DepartmentName)
SELECT DepartmentName FROM #TempDepartments;
DROP TABLE #TempDepartments;
--------------------------------------------------------
--12-task:
UPDATE Employees
SET Department = 'Руководство'
WHERE Salary > 5000;
--------------------------------------------------------
--13-task:
DELETE FROM Employees;
--------------------------------------------------------
--14-task:
ALTER TABLE Employees
DROP COLUMN Department;
--------------------------------------------------------
--15-task:
EXEC sp_rename 'Employees', 'StaffMembers';
--------------------------------------------------------
--16-task:
DROP TABLE Departments;
--------------------------------------------------------
------------------------------------------------------------
--task-17:
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2) CHECK (Price > 0),
    Description VARCHAR(255) 
    );
------------------------------------------------------------
--task-18: 
ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;
------------------------------------------------------------
--task-19:
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';
------------------------------------------------------------
--task-20:
INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description)
VALUES 
(1, 'Ноутбук', 'Электроника', 1500.00, 'Мощный игровой ноутбук'),
(2, 'Смартфон', 'Электроника', 800.00, 'Флагманский смартфон'),
(3, 'Стул', 'Мебель', 120.00, 'Офисный эргономичный стул'),
(4, 'Чайник', 'Бытовая техника', 45.50, 'Электрический чайник'),
(5, 'Книга', 'Канцелярия', 18.75, 'Бестселлер художественной литературы');
------------------------------------------------------------
--task-21:
SELECT * INTO Products_Backup
FROM Products;
------------------------------------------------------------
--task-22:
EXEC sp_rename 'Products', 'Inventory';
------------------------------------------------------------
--task-23:
ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;
------------------------------------------------------------
--task-24:
CREATE TABLE Inventory_New (
    ProductCode INT IDENTITY(1000, 5) PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    ProductCategory VARCHAR(50),
    Price FLOAT,
    Description VARCHAR(255),
    StockQuantity INT
);
--task-25:
INSERT INTO Inventory_New (ProductID, ProductName, ProductCategory, Price, Description, StockQuantity)
SELECT ProductID, ProductName, ProductCategory, Price, Description, StockQuantity
FROM Inventory;
DROP TABLE Inventory;
EXEC sp_rename 'Inventory_New', 'Inventory';
