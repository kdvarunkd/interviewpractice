--  Show customers who have placed at least one order — use EXISTS
-- Q2. Show customers who have never placed an order — use NOT EXISTS
-- Q3. Show employees who are managers — use EXISTS
-- Q4. Show employees who have no one reporting to them — use NOT EXISTS
-- Q5. Show customers who ordered a Laptop — use EXISTS

SELECT name, city
FROM customers c
WHERE EXISTS (SELECT 1
FROM orders o
WHERE c.customer_id =o.customer_id)

SELECT name, city
FROM customers c
WHERE NOT EXISTS(SELECT 1
FROM orders o
WHERE o.customer_id = c.customer_id)

SELECT name
FROM employees m
WHERE EXISTS (SELECT 1
FROM employees e
WHERE m.emp_id = e.manager_id)

SELECT name
FROM employees m
WHERE NOT EXISTS(SELECT 1
FROM employees e
WHERE e.manager_id = m.emp_id)

SELECT name
FROM customers c
WHERE EXISTS (SELECT 1
FROM orders o
WHERE c.customer_id = o.customer_id AND product ='Laptop')



-- ANY / ALL
-- Q6. Show employees who earn more than ANY employee in manager_id 2 team
-- Q7. Show employees who earn more than ALL employees in manager_id 2 team
-- Q8. Show orders where amount is greater than ANY order from customer_id 1
-- Q9. Show orders where amount is greater than ALL orders from customer_id 1
-- Q10. Show employees where salary is equal to ANY of these values → 75000, 80000, 90000

SELECT name
FROM employees e
WHERE salary > ANY(SELECT salary
FROM employees
WHERE manager_id = 2 )

SELECT name
FROM employees e
WHERE salary > ALL(SELECT salary
FROM employees
WHERE manager_id = 2)

SELECT *
FROM orders
WHERE amount > any (SELECT amount
FROM orders
WHERE customer_id = 1)
SELECT *
FROM orders
WHERE amount > ALL (
    SELECT amount
FROM orders
WHERE customer_id = 1
);
SELECT *
FROM employees
WHERE salary = any(SELECT salary
FROM employees
WHERE salary in(75000, 80000, 90000))
