-- ROW_NUMBER() — 5 Questions
-- Q1. Give row number to all employees ordered by salary highest to lowest
-- Q2. Give row number to each customer's orders ordered by amount highest to lowest
-- Q3. Show only the 3rd highest paid employee using ROW_NUMBER
-- Q4. Show first order placed by each customer using ROW_NUMBER — use subquery!
-- Q5. Paginate employees — show only rows 3 to 5 using ROW_NUMBER — use subquery!


select
    name, salary ,
    row_number() over(ORDER BY salary DESC) rk
from employees

SELECT c.name, o.amount,
    ROW_NUMBER() OVER(
           PARTITION BY c.customer_id
           ORDER BY o.amount DESC
       ) rk
FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id;


SELECT *
FROM(
    SELECT c.name, o.order_id,
        o.product, o.amount,
        ROW_NUMBER() OVER(
               PARTITION BY c.customer_id
               ORDER BY o.order_id ASC) rk
    FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
) t
WHERE rk = 1



--  Paginate employees — show only rows 3 to 5 using ROW_NUMBER — use subquery!
select *
from
    (select name ,
        ROW_NUMBER() over(order by name asc) rk

    from employees) t

where t.rk >=3 and t.rk<= 5


--  RANK() — 5 Questions
-- Q1. Rank all employees by salary highest to lowest
-- Q2. Rank employees within each team — PARTITION BY manager_id
-- Q3. Find all employees with rank 1 in their team — use subquery!
-- Q4. Find employees who are NOT rank 1 in their team — use subquery!
-- Q5. Show customers ranked by total spending — use subquery with JOIN!

select name, salary ,
    rank() over(order by salary DESC) rk


from employees


select name,
    RANK() over(PARTITION BY manager_id  ORDER BY salary desc)
from employees

SELECT *
FROM (
    SELECT name,
        manager_id,
        salary,
        RANK() OVER (
               PARTITION BY manager_id
               ORDER BY salary DESC
           ) AS rk
    FROM employees
) t
WHERE t.rk = 1;

SELECT *
FROM (
    SELECT name,
        manager_id,
        salary,
        RANK() OVER (
               PARTITION BY manager_id
               ORDER BY salary DESC
           ) AS rk
    FROM employees
) t
WHERE t.rk <> 1;


-- Q5. Show customers ranked by total spending — use subquery with JOIN!
select *
from(

    select c.customer_id, c.name, sum(o.amount) totalSpent,
        rank() over( ORDER BY sum(o.amount) DESC) rk


    from customers c
        LEFT join orders o on o.customer_id = c.customer_id
    GROUP BY c.customer_id ,c.name
) t


--  DENSE_RANK() — 5 Questions
-- Q1. Show each employee with DENSE_RANK by salary
-- Q2. Show RANK and DENSE_RANK together — see the difference!
-- Q3. Find employees in top 2 salary levels using DENSE_RANK — use subquery!
-- Q4. Show DENSE_RANK of each product by total revenue — use subquery with JOIN!
-- Q5. Find the 2nd highest salary level employees using DENSE_RANK — use subquery!


select name, salary,
    DENSE_RANK() over(ORDER BY salary desc) rk
from employees
select name, salary,
    DENSE_RANK() over(ORDER BY salary desc) denserk
, rank() over(ORDER BY salary desc) rk
from employees

SELECT *
FROM(
    SELECT name, salary,
        DENSE_RANK() OVER(ORDER BY salary DESC) rk
    FROM employees) t
WHERE rk <= 2
SELECT *
FROM(
    SELECT p.product_id, p.name,
        SUM(s.total_amount) totalAmount,
        DENSE_RANK() OVER(
               ORDER BY SUM(s.total_amount) DESC) rk
    FROM products p
        JOIN sales s ON s.product_id = p.product_id
    GROUP BY p.product_id, p.name) t
ORDER BY rk


select *
from(
    select name, salary,
        DENSE_RANK() over(order by salary DESC ) rk



    from employees
) t

where t.rk = 2

--  NTILE() — 5 Questions
-- Q1. Divide all employees into 4 salary buckets
-- Q2. Find employees in top 25% salary bucket — use subquery!
-- Q3. Divide customers into 3 groups by total spending — High, Medium, Low — use JOIN + subquery!
-- Q4. Divide orders into 2 buckets — above and below median — use subquery!
-- Q5. Show each employee with their salary bucket and bucket name — use CASE WHEN + NTILE!


select name, salary  

, NTILE(4) over(ORDER BY salary desc) gp

from employees

SELECT *
FROM (
    SELECT name,
           salary,
           NTILE(4) OVER (ORDER BY salary DESC) AS bucket
    FROM employees
) t
WHERE t.bucket = 1;

SELECT 
    customer_id,
    name,
    total_spent,
    CASE 
        WHEN bucket = 1 THEN 'High'
        WHEN bucket = 2 THEN 'Medium'
        WHEN bucket = 3 THEN 'Low'
    END AS spending_group
FROM (
    SELECT 
        c.customer_id,
        c.name,
        COALESCE(SUM(o.amount),0) AS total_spent,
        NTILE(3) OVER (ORDER BY SUM(o.amount) DESC) AS bucket
    FROM customers c
    LEFT JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.name
) t;


SELECT 
    order_id,
    amount,
    CASE 
        WHEN bucket = 1 THEN 'Above Median'
        ELSE 'Below Median'
    END AS order_group
FROM (
    SELECT 
        order_id,
        amount,
        NTILE(2) OVER (ORDER BY amount DESC) AS bucket
    FROM orders
) t;


SELECT 
    name,
    salary,
    bucket,
    CASE 
        WHEN bucket = 1 THEN 'Top 25%'
        WHEN bucket = 2 THEN 'Upper Middle'
        WHEN bucket = 3 THEN 'Lower Middle'
        WHEN bucket = 4 THEN 'Bottom 25%'
    END AS bucket_name
FROM (
    SELECT 
        name,
        salary,
        NTILE(4) OVER (ORDER BY salary DESC) AS bucket
    FROM employees
) t;