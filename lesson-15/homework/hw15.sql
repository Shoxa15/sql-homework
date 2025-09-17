Level 1: Basic Subqueries

1. Find Employees with Minimum Salary

SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);


2. Find Products Above Average Price

SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);

Level 2: Nested Subqueries with Conditions

3. Find Employees in Sales Department

SELECT *
FROM employees
WHERE department_id = (
    SELECT id 
    FROM departments 
    WHERE department_name = 'Sales'
);


4. Find Customers with No Orders

SELECT *
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM orders
);

Level 3: Aggregation and Grouping in Subqueries

5. Find Products with Max Price in Each Category

SELECT p.*
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
);


6. Employees in Department with Highest Avg Salary

SELECT *
FROM employees
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);

Level 4: Correlated Subqueries

7. Employees Earning Above Department Average

SELECT e.*
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);


8. Students with Highest Grade per Course

SELECT s.student_id, s.name, g.course_id, g.grade
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);

Level 5: Ranking and Complex Conditions

9. Find Third-Highest Price per Category

SELECT product_name, category_id, price
FROM (
    SELECT p.*,
           DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rnk
    FROM products p
) t
WHERE rnk = 3;


10. Employees with Salary Between Company Avg and Dept Max

SELECT e.*
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees)
  AND salary < (
        SELECT MAX(salary)
        FROM employees
        WHERE department_id = e.department_id
  );
