-- # 3️⃣ SELECT Subquery — 10 Questions

-- ## Easy (1-3)
-- **Q1.** Show each employee with company average salary

-- **Q2.** Show each order with average order amount

-- **Q3.** Show each customer with total number of customers

-- ## Intermediate (4-7)
-- **Q4.** Show each employee with their salary difference from average

-- **Q5.** Show each order with difference from average amount

-- **Q6.** Show each customer with their total spending and company total spending

-- **Q7.** Show each employee with their manager's salary

-- ## Advanced (8-10)
-- **Q8.** Show each employee with:
-- - their salary
-- - company average
-- - difference from average
-- - highest salary in company

-- **Q9.** Show each customer with:
-- - their total spending
-- - city total spending
-- - percentage of city spending

-- **Q10.** Show each order with:
-- - amount
-- - average amount

SELECT
    e.name ,
    (SELECT
        AVG(salary)
    FROM employees e1
     ) companyAverage
FROM employees e

SELECT
    *,
    (SELECT AVG(amount)
    FROM orders)  avgAmount
FROM orders o

SELECT
    *, (SELECT COUNT(*)
    FROM customers) totalCustomers
FROM customers
--  Show each employee with their salary difference from average


SELECT e.name, e.salary
, e.salary-(SELECT AVG(salary)
    FROM employees )
 diffSalary
FROM employees e


SELECT order_id, product, amount
, amount-(SELECT AVG(amount)
    FROM orders ) difAmount

FROM orders o

-- Show each customer with their total spending and company total spending

SELECT
    custTotal.name, totalSpent, (
    SELECT SUM(amount)
    FROM orders       
) companyTotalSpent
FROM (
    SELECT c.name, SUM(o.amount) totalSpent
    FROM customers c
        JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.name) custTotal

--  Show each employee with their manager's salary

SELECT e.name,
    (SELECT salary
    FROM employees m
    WHERE m.emp_id = e.manager_id) managerSal
FROM employees e


-- ## Advanced (8-10)
-- **Q8.** Show each employee with:
-- - their salary
-- - company average
-- - difference from average
-- - highest salary in company

SELECT e.name,
    e.salary,
    (SELECT AVG(salary)
    FROM employees) compAvg,
    (SELECT MAX(salary)
    FROM employees) topSalary,
    e.salary-(SELECT AVG(salary)
    FROM employees) salaryDiff
FROM employees e

-- **Q9.** Show each customer with:
-- -- - their total spending
-- -- - city total spending
-- -- - percentage of city spending


SELECT 
    custCal.name,
    custCal.city,
    custCal.totalAmount,
    cityTotal.cityTotal,
    ROUND((custCal.totalAmount * 100.0 / cityTotal.cityTotal), 2) percentage
FROM (
   
    SELECT c.name, c.city, SUM(o.amount) totalAmount
    FROM customers c
        JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.name, c.city, c.customer_id
) custCal
JOIN (
    
    SELECT c.city, SUM(o.amount) cityTotal
    FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.city
) cityTotal ON custCal.city = cityTotal.city

SELECT
    order_id,
    product,
    amount,
    (SELECT AVG(amount)
    FROM orders) avgAmount,
    CASE 
        WHEN amount > (SELECT AVG(amount)
    FROM orders) THEN 'Above Average'
        WHEN amount < (SELECT AVG(amount)
    FROM orders) THEN 'Below Average'
        ELSE 'Equal to Average'
    END AS status
FROM orders