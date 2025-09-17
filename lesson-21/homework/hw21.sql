Часть 1: ProductSales
1. Пронумеровать продажи по дате (ROW_NUMBER)
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;


ROW_NUMBER назначает уникальный порядковый номер.

2. Ранжировать продукты по сумме проданного количества (DENSE_RANK)
SELECT ProductName, SUM(Quantity) AS TotalQty,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankNum
FROM ProductSales
GROUP BY ProductName;


DENSE_RANK даёт одинаковый ранг для равных значений без пропусков.

3. Топ-продажа по сумме для каждого клиента
SELECT *
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) t
WHERE rn = 1;


Используем PARTITION BY для разделения по клиентам.

4. Каждая продажа + следующая (LEAD)
SELECT SaleID, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextAmount
FROM ProductSales;

5. Каждая продажа + предыдущая (LAG)
SELECT SaleID, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevAmount
FROM ProductSales;

6. Продажи, больше предыдущей
SELECT SaleID, SaleAmount
FROM (
    SELECT SaleID, SaleAmount,
           LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
) t
WHERE SaleAmount > PrevAmount;

7. Разница с предыдущей продажей по продукту
SELECT ProductName, SaleDate, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffPrev
FROM ProductSales;

8. % изменение относительно следующей продажи
SELECT SaleID, SaleAmount,
       ( (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / SaleAmount ) AS PctChange
FROM ProductSales;

9. Отношение к предыдущей (Ratio)
SELECT ProductName, SaleDate, SaleAmount,
       SaleAmount * 1.0 / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS RatioPrev
FROM ProductSales;

10. Разница с первой продажей продукта
SELECT ProductName, SaleDate, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFirst
FROM ProductSales;

11. Продажи с постоянным ростом (каждая > предыдущей)
SELECT *
FROM (
    SELECT ProductName, SaleDate, SaleAmount,
           CASE WHEN SaleAmount > LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) 
                THEN 1 ELSE 0 END AS Growing
    FROM ProductSales
) t
WHERE Growing = 1;

12. "Closing balance" (running total)
SELECT SaleID, SaleDate, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM ProductSales;

13. Скользящее среднее за 3 продажи
SELECT SaleID, SaleDate, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM ProductSales;

14. Разница от среднего по всем продажам
SELECT SaleID, SaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;

Часть 2: Employees1
1. Сотрудники с одинаковым рангом зарплаты
SELECT EmployeeID, Name, Department, Salary,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

2. Топ-2 зарплаты по департаментам
SELECT *
FROM (
    SELECT EmployeeID, Name, Department, Salary,
           DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptRank
    FROM Employees1
) t
WHERE DeptRank <= 2;

3. Минимальная зарплата в департаменте
SELECT *
FROM (
    SELECT EmployeeID, Name, Department, Salary,
           RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS DeptRank
    FROM Employees1
) t
WHERE DeptRank = 1;

4. Накопительная сумма зарплат по департаменту
SELECT Department, Name, Salary,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM Employees1;

5. Общая сумма зарплат без GROUP BY
SELECT DISTINCT Department,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees1;

6. Средняя зарплата без GROUP BY
SELECT DISTINCT Department,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary
FROM Employees1;

7. Разница зарплаты с департаментским средним
SELECT EmployeeID, Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1;

8. Скользящее среднее зарплаты (3 сотрудника)
SELECT EmployeeID, Name, Department, Salary,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees1;

9. Сумма зарплат последних 3 нанятых сотрудников
SELECT SUM(Salary) AS Last3Sum
FROM (
    SELECT Salary
    FROM Employees1
    ORDER BY HireDate DESC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
) t;
