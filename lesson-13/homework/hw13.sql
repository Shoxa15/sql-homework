Easy Tasks

1. Вывести строку "100-Steven King" (emp_id + first_name + last_name).

SELECT 
    CAST(EMPLOYEE_ID AS VARCHAR) + '-' + FIRST_NAME + ' ' + LAST_NAME AS Result
FROM Employees
WHERE EMPLOYEE_ID = 100;


2. Заменить в номере телефона 124 на 999.

SELECT 
    EMPLOYEE_ID,
    REPLACE(PHONE_NUMBER, '124', '999') AS UpdatedPhone
FROM Employees;


3. Имена на A, J, M + длина имени, сортировка по имени.

SELECT 
    FIRST_NAME,
    LEN(FIRST_NAME) AS NameLength
FROM Employees
WHERE FIRST_NAME LIKE 'A%' OR FIRST_NAME LIKE 'J%' OR FIRST_NAME LIKE 'M%'
ORDER BY FIRST_NAME;


4. Общая зарплата по каждому менеджеру.

SELECT 
    MANAGER_ID,
    SUM(SALARY) AS TotalSalary
FROM Employees
GROUP BY MANAGER_ID;


5. Год и наибольшее значение среди Max1, Max2, Max3.

SELECT 
    Year1,
    GREATEST(Max1, Max2, Max3) AS MaxValue
FROM TestMax;


В SQL Server нет GREATEST, используем CASE:

SELECT 
    Year1,
    (SELECT MAX(v) 
     FROM (VALUES (Max1), (Max2), (Max3)) AS Value(v)) AS MaxValue
FROM TestMax;


6. Фильтруем нечетные id фильмов и описание ≠ 'boring'.

SELECT *
FROM cinema
WHERE id % 2 = 1 
  AND description <> 'boring';


7. Отсортировать по Id, но Id = 0 всегда внизу.

SELECT *
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id;


8. Первый ненулевой (не NULL) документ у человека.

SELECT 
    id,
    COALESCE(ssn, passportid, itin) AS FirstNonNull
FROM person;

Medium Tasks

9. Разделить FullName на три части.

SELECT 
    StudentID,
    PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS FirstName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS MiddleName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS LastName
FROM Students;


10. Заказы в Texas у клиентов, у которых были доставки в California.

SELECT *
FROM Orders
WHERE DeliveryState = 'TX'
  AND CustomerID IN (SELECT CustomerID 
                     FROM Orders 
                     WHERE DeliveryState = 'CA');


11. Group concat значений из DMLTable.

SELECT STRING_AGG(String, ' ') AS FullQuery
FROM DMLTable;


12. Сотрудники, чьи имена (имя+фамилия) содержат букву "a" ≥ 3 раз.

SELECT *
FROM Employees
WHERE LEN(LOWER(FIRST_NAME + LAST_NAME)) 
      - LEN(REPLACE(LOWER(FIRST_NAME + LAST_NAME), 'a', '')) >= 3;


13. Кол-во сотрудников по департаменту и % с опытом > 3 лет.

SELECT 
    DEPARTMENT_ID,
    COUNT(*) AS TotalEmployees,
    100.0 * SUM(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 ELSE 0 END) / COUNT(*) AS Percent3Years
FROM Employees
GROUP BY DEPARTMENT_ID;


14. Самый опытный и наименее опытный космонавт по JobDescription.

SELECT JobDescription, 
       MAX(SpacemanID) KEEP (DENSE_RANK FIRST ORDER BY MissionCount DESC) AS MostExperienced,
       MAX(SpacemanID) KEEP (DENSE_RANK FIRST ORDER BY MissionCount ASC)  AS LeastExperienced
FROM Personal
GROUP BY JobDescription;


В SQL Server — через подзапросы:

SELECT JobDescription,
       (SELECT TOP 1 SpacemanID 
        FROM Personal p2 
        WHERE p2.JobDescription = p1.JobDescription 
        ORDER BY MissionCount DESC) AS MostExperienced,
       (SELECT TOP 1 SpacemanID 
        FROM Personal p2 
        WHERE p2.JobDescription = p1.JobDescription 
        ORDER BY MissionCount ASC) AS LeastExperienced
FROM Personal p1
GROUP BY JobDescription;

Difficult Tasks

15. Разделить строку 'tf56sd#%OqH' на категории символов.

WITH Split AS (
    SELECT value AS ch
    FROM STRING_SPLIT('tf56sd#%OqH', '', 1)
)
SELECT 
    STRING_AGG(CASE WHEN ch LIKE '[A-Z]' THEN ch END, '') AS UpperCaseLetters,
    STRING_AGG(CASE WHEN ch LIKE '[a-z]' THEN ch END, '') AS LowerCaseLetters,
    STRING_AGG(CASE WHEN ch LIKE '[0-9]' THEN ch END, '') AS Numbers,
    STRING_AGG(CASE WHEN ch NOT LIKE '[A-Za-z0-9]' THEN ch END, '') AS Others
FROM Split;


16. Сумма текущей строки + всех предыдущих (running total).

SELECT 
    StudentID,
    FullName,
    Grade,
    SUM(Grade) OVER (ORDER BY StudentID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Students;


17. Посчитать математические выражения в таблице Equations.

UPDATE Equations
SET TotalSum = 
    (SELECT SUM(CAST(value AS INT))
     FROM STRING_SPLIT(REPLACE(REPLACE(Equation, '+', ' '), '-', ' -'), ' '));


18. Найти студентов с одинаковым днем рождения.

SELECT Birthday, STRING_AGG(StudentName, ', ') AS Students
FROM Student
GROUP BY Birthday
HAVING COUNT(*) > 1;


19. Сумма очков у каждой уникальной пары игроков.

SELECT 
    LEAST(PlayerA, PlayerB) AS Player1,
    GREATEST(PlayerA, PlayerB) AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY LEAST(PlayerA, PlayerB), GREATEST(PlayerA, PlayerB);


В SQL Server нет LEAST/GREATEST, используем CASE:

SELECT 
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
         CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END;
