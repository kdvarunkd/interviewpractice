-- 🎯 IN Subquery — 10 Questions
-- Q1. Show customers who have placed at least one order
-- Q2. Show customers who have never placed an order
-- Q3. Show orders placed by customers from Kerala
-- Q4. Show employees who are managers (someone reports to them)
-- Q5. Show employees who are not managers
-- Q6. Show customers who ordered a Laptop
-- Q7. Show employees who earn more than all employees in manager_id 2 team
-- Q8. Show orders where customer is from Kerala or Chennai
-- Q9. Show customers who have ordered more than once
-- Q10. Show employees whose salary is in the top 3 salaries

SELECT name, city
FROM customers
WHERE customer_id IN(SELECT customer_id
FROM orders)

SELECT name, city
FROM customers
WHERE customer_id NOT IN(SELECT customer_id
FROM orders)

SELECT product, amount
FROM orders
WHERE customer_id IN(SELECT customer_id
FROM customers
WHERE city ='Kerala')

SELECT name
FROM employees
WHERE emp_id IN(SELECT manager_id
FROM employees)

SELECT name
FROM employees
WHERE emp_id NOT IN (SELECT manager_id
FROM employees
WHERE manager_id IS  NOT NULL)

SELECT name
FROM customers
WHERE customer_id IN(SELECT customer_id
FROM orders
WHERE product ='Laptop')

SELECT name FROM employees
WHERE salary >(SELECT MAX(salary) FROM employees
WHERE manager_id = 2)

SELECT order_id, product, amount FROM orders
WHERE customer_id IN(SELECT customer_id FROM customers
                     WHERE city = 'Kerala' OR city = 'Chennai')

SELECT * FROM
(SELECT c.name,COUNT(o.customer_id) totalCount FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.name
HAVING COUNT(o.customer_id) > 1
) t


SELECT  name FROM customers 
WHERE customer_id IN( SELECT customer_id FROM orders
GROUP BY customer_id
HAVING(count(*)> 1))

