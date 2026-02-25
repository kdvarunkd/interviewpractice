-- Easy
-- (1-3)
-- Q1. Find employees earning more than average salary
-- Q2. Find customers who live in same city as customer_id 1
-- Q3. Find orders
-- with amount greater than average order amount
-- Intermediate
-- (4-7)
-- Q4. Find employees earning more than Priya
-- Q5. Find customers who placed orders worth more than average order amount
-- Q6. Find employees who earn more than their department average


SELECT *
FROM employees
SELECT *
FROM customers
select *
FROM orders

SELECT
    name,
    salary
FROM employees
WHERE salary > (SELECT AVG(salary)
FROM employees)

SELECT
    name,
    city
FROM customers
WHERE city = (SELECT city
FROM customers
WHERE customer_id = 1)

SELECT
    order_id,
    product,
    amount
FROM orders
WHERE amount > (SELECT AVG(amount)
FROM orders)


SELECT
    name,
    salary
FROM employees
WHERE salary >(SELECT
    salary
FROM employees
WHERE name = 'Priya')


--  Find customers who placed orders worth more than average order amount
select c.name
from customers c
    JOIN orders o on c.customer_id = o.customer_id
WHERE c.customer_id in(select customer_id
from orders
WHERE amount > (select avg(amount)
from orders))

--Find employees who earn more than their department average

SELECT e.name, e.salary
FROM employees e
WHERE e.salary >(select avg(salary)
from employees e1
WHERE e.manager_id = e1.manager_id)

-- **Q7.** Find the most expensive order details

-- ## Advanced (8-10)
-- **Q8.** Find second highest salary

-- **Q9.** Find 3rd highest salary

-- **Q10.** Find employees earning more than manager
SELECT *
FROM orders
WHERE amount  = (SELECT MAX(amount)
FROM orders)

SELECT MAX(salary) Maxsalary
FROM employees
WHERE salary < (SELECT MAX(salary)
FROM employees)


SELECT TOP 1
    salary
FROM employees
WHERE salary < (SELECT MAX(salary)
FROM employees
WHERE salary < (SELECT MAX(salary)
FROM employees)
)

ORDER BY salary DESC

SELECT name, salary
FROM employees
WHERE salary > (SELECT salary
FROM employees e
WHERE  e.emp_id = employees.manager_id)
