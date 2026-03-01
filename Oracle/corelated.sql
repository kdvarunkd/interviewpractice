-- Q1. Show employees who earn more than average salary of their own team (same manager_id)
-- Q2. Show each employee with their manager's name
-- Q3. Show customers who have spent more than average spending of all customers
-- Q4. Show employees who are the highest earner in their team
-- Q5. Show orders where amount is greater than average order amount of that customer
-- JOIN Subquery
-- Q6. Show each customer with their total spending — using JOIN + subquery
-- Q7. Show employees with salary above company average — using JOIN
-- Q8. Show customers with their order count and total spending
-- Q9. Show top spending customer per city
-- Q10. Show employees with salary rank in their team

SELECT name, salary
FROM employees e
where salary >(select avg(salary)
from employees m
where m.manager_id =e.manager_id)


select e.name, m.name
from employees e
    join employees m on e.manager_id=m.emp_id

select c.name
from customers c
where (select sum(amount)
from orders o
where o.customer_id = c.customer_id)> (select avg(amount)
from orders
)

select e.name, salary
from employees e
where salary =(select max(salary)
from employees e1
where e1.manager_id = e.manager_id)



select name
from customers  c


    join orders o on o.customer_id = c.customer_id
where o.amount >(select avg(amount)
from orders o1
where o1.customer_id = c.customer_id )

--Show each customer with their total spending — using JOIN + subquery
-- Q7. Show employees with salary above company average — using JOIN
-- Q8. Show customers with their order count and total spending
-- Q9. Show top spending customer per city
-- Q10. Show employees with salary rank in their team


SELECT c.customer_id, c.name, t.totalSpent
FROM customers c
JOIN (
    SELECT o.customer_id, SUM(o.amount) AS totalSpent
    FROM orders o
    GROUP BY o.customer_id
) t 
ON t.customer_id = c.customer_id;

select e.name, e.salary
from employees e
    join(select avg(salary) avgsalary
    from employees
   
    ) t on  e.salary >t.avgsalary

SELECT c.customer_id,
       c.name,
       t.totalSpent,
       t.orderCount
FROM customers c
JOIN (
    SELECT o.customer_id,
           COUNT(o.order_id) AS orderCount,
           SUM(o.amount) AS totalSpent
    FROM orders o
    GROUP BY o.customer_id
) t
ON t.customer_id = c.customer_id;

SELECT *
FROM (
    SELECT c.city,
           c.name,
           SUM(o.amount) AS totalSpent,
           RANK() OVER (PARTITION BY c.city ORDER BY SUM(o.amount) DESC) rnk
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.city, c.name
) t
WHERE rnk = 1;
SELECT e.emp_id,
       e.name,
       e.salary,
       t.rnk
FROM employees e
JOIN (
    SELECT emp_id,
           manager_id,
           salary,
           RANK() OVER (
               PARTITION BY manager_id 
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
) t
ON t.emp_id = e.emp_id;

