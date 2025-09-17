Easy Tasks

1. Разделить Name на имя и фамилию (по запятой).

SELECT 
    Id,
    LEFT(Name, CHARINDEX(',', Name) - 1) AS FirstName,
    SUBSTRING(Name, CHARINDEX(',', Name) + 1, LEN(Name)) AS Surname
FROM TestMultipleColumns;


2. Найти строки, содержащие символ %.

SELECT *
FROM TestPercent
WHERE Strs LIKE '%[%]%';


3. Разделить строку по точке (.).

SELECT 
    Id,
    PARSENAME(REPLACE(Vals, '.', '.'), 2) AS Part1,
    PARSENAME(REPLACE(Vals, '.', '.'), 1) AS Part2
FROM Splitter;


4. Заменить все цифры на X.

DECLARE @str VARCHAR(50) = '1234ABC123456XYZ1234567890ADS';

SELECT TRANSLATE(@str, '0123456789', 'XXXXXXXXXX') AS ReplacedString;


5. Найти строки, где в Vals больше 2-х точек.

SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;


6. Подсчитать количество пробелов в строке.

SELECT 
    texts,
    LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;


7. Сотрудники, которые зарабатывают больше своего менеджера.

SELECT e.Id, e.Name, e.Salary, e.ManagerId
FROM Employee e
JOIN Employee m ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;


8. Сотрудники со стажем > 10 и < 15 лет.

SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE,
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 11 AND 14;

Medium Tasks

9. Разделить строку rtcfvty34redt на числа и буквы.

DECLARE @str VARCHAR(50) = 'rtcfvty34redt';

SELECT 
    STRING_AGG(value, '') AS Letters,
    (SELECT STRING_AGG(value, '') FROM STRING_SPLIT(@str, '') WHERE value LIKE '[0-9]') AS Numbers
FROM STRING_SPLIT(@str, '')
WHERE value LIKE '[A-Za-z]';


10. Найти Id дат, где температура выше, чем вчера.

SELECT w1.Id, w1.RecordDate, w1.Temperature
FROM weather w1
JOIN weather w2 ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE w1.Temperature > w2.Temperature;


11. Первый логин каждого игрока.

SELECT player_id, MIN(event_date) AS FirstLogin
FROM Activity
GROUP BY player_id;


12. Вернуть 3-й фрукт из списка.

SELECT 
    LTRIM(RTRIM(value)) AS ThirdFruit
FROM fruits
CROSS APPLY STRING_SPLIT(fruit_list, ',')
WHERE (SELECT COUNT(*) 
       FROM STRING_SPLIT(fruit_list, ',') s2
       WHERE s2.[value] <= STRING_SPLIT.fruit_list) = 3;


Проще:

SELECT TRIM(value) AS ThirdFruit
FROM fruits
CROSS APPLY (SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) rn 
             FROM STRING_SPLIT(fruit_list, ',')) t
WHERE rn = 3;


13. Каждая буква строки в отдельной строке.

DECLARE @str VARCHAR(50) = 'sdgfhsdgfhs@121313131';

WITH Numbers AS (
    SELECT TOP (LEN(@str)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
    FROM sys.objects
)
SELECT SUBSTRING(@str, n, 1) AS Character
FROM Numbers;


14. Join таблиц p1 и p2, где p1.code = 0 → заменить на p2.code.

SELECT 
    p1.id,
    CASE WHEN p1.code = 0 THEN p2.code ELSE p1.code END AS FinalCode
FROM p1
JOIN p2 ON p1.id = p2.id;


15. Employment Stage по Hire Date.

SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsWorked,
    CASE 
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;


16. Извлечь целое число в начале строки.

SELECT 
    Id,
    LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 'X') - 1) AS StartingNumber
FROM GetIntegers
WHERE VALS IS NOT NULL;

Difficult Tasks

17. Поменять местами первые две буквы в строке (comma separated).

SELECT 
    Id,
    STUFF(Vals, 1, 1, SUBSTRING(Vals, 3, 1)) AS Swapped
FROM MultipleVals;


18. Устройство первого входа для каждого игрока.

SELECT player_id, device_id
FROM Activity a
WHERE event_date = (
    SELECT MIN(event_date) 
    FROM Activity 
    WHERE player_id = a.player_id
);


19. Процент продаж по неделям и дням.

SELECT 
    FinancialWeek,
    FinancialYear,
    Area,
    [Date],
    SUM(ISNULL(SalesLocal,0) + ISNULL(SalesRemote,0)) AS TotalSales,
    100.0 * SUM(ISNULL(SalesLocal,0) + ISNULL(SalesRemote,0)) 
         / SUM(SUM(ISNULL(SalesLocal,0) + ISNULL(SalesRemote,0))) 
           OVER (PARTITION BY FinancialWeek, FinancialYear) AS WeekPercentage
FROM WeekPercentagePuzzle
GROUP BY FinancialWeek, FinancialYear, Area, [Date]
ORDER BY FinancialWeek, [Date];
