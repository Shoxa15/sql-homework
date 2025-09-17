Lesson 12 - SQL Homework Solutions
Задача 1: Combine Two Tables

SELECT p.firstName, p.lastName, a.city, a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId;
Пояснение: Используем LEFT JOIN, чтобы взять всех людей из Person и, если есть, их адреса. Если адреса нет – вернётся NULL.
Задача 2: Employees Earning More Than Their Managers

SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;
Пояснение: Сравниваем зарплаты сотрудников с их менеджерами. Возвращаем только тех, у кого зарплата выше.
Задача 3: Duplicate Emails

SELECT email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;
Пояснение: Группируем по email и выбираем только те, которые встречаются больше одного раза.
Задача 4: Delete Duplicate Emails

DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
);
Пояснение: Удаляем дубликаты email, оставляя только запись с минимальным id для каждого email.
Задача 5: Find Parents Who Have Only Girls

SELECT DISTINCT g.ParentName
FROM girls g
WHERE g.ParentName NOT IN (SELECT b.ParentName FROM boys b);
Пояснение: Выбираем родителей из таблицы girls, которых нет в таблице boys, то есть у них только девочки.
Задача 6: Total Sales > 50 and Least Weight (TSQL2012)

SELECT custid, SUM(totaldue) AS TotalSales, MIN(orderid) AS LeastOrderID
FROM Sales.Orders
WHERE freight > 50
GROUP BY custid;
Пояснение: Считаем общую сумму заказов с весом больше 50 для каждого клиента. Дополнительно выбираем минимальный orderid (пример на 'least weight').
Задача 7: Carts Comparison

SELECT c1.Item AS [Item Cart 1], c2.Item AS [Item Cart 2]
FROM Cart1 c1
FULL OUTER JOIN Cart2 c2 ON c1.Item = c2.Item;
Пояснение: FULL OUTER JOIN возвращает все товары из обеих корзин. Если товар есть только в одной – в другой колонке будет NULL.
Задача 8: Customers Who Never Order

SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.id IS NULL;
Пояснение: LEFT JOIN показывает всех клиентов, а условие WHERE o.id IS NULL отбирает тех, кто не сделал ни одного заказа.
Задача 9: Students and Examinations

SELECT s.student_id, s.student_name, sub.subject_name, 
       COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e 
     ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
Пояснение: CROSS JOIN формирует все комбинации студентов и предметов. LEFT JOIN соединяет с экзаменами. COUNT показывает, сколько раз студент сдавал каждый предмет.
