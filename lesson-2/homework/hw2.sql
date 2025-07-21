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
