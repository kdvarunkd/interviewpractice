-- # 2️⃣ FROM Subquery — 10 Questions

-- ## Easy (1-3)
-- **Q1.** Show customer names with total spending using FROM subquery

-- **Q2.** Show employees with their salary rank using FROM subquery

-- **Q3.** Show average salary per manager using FROM subquery

-- ## Intermediate (4-7)
-- **Q4.** Find customers whose total spending is above 20000 using FROM subquery

-- **Q5.** Show top 3 customers by spending using FROM subquery

-- **Q6.** Find managers with more than 1 employee using FROM subquery

-- **Q7.** Show each city with total revenue using FROM subquery

-- ## Advanced (8-10)
-- **Q8.** Find customers spending above city average using FROM subquery

-- **Q9.** Show employee name, salary and salary rank using FROM subquery

-- **Q10.** Find the top spending customer per city using FROM subquery


SELECT
    *
FROM(
    SELECT c.name, SUM(o.amount) totalSpent
    FROM customers c
        JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.name
) t


SELECT
    *
FROM (
    SELECT
        name,
        salary,
        RANK() OVER(ORDER BY salary DESC) rankEmp

    FROM employees  
) t

-- Show average salary per manager using FROM subquery

SELECT
    *
FROM(
    SELECT
        manager_id ,
        AVG(salary) avgSlary
    FROM employees
    GROUP BY manager_id
) t

-- Find customers whose total spending is above 20000 using FROM subquery
SELECT
    *
FROM
    (
SELECT
        c.name,
        SUM(o.amount) totalSpent
    FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.name
    HAVING SUM(o.amount) > 20000

) t

--Show top 3 customers by spending using FROM subquery
SELECT TOP 3
    *
FROM
    (SELECT
        c.name,
        SUM(o.amount) totalSpent
    FROM customers c
        JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.name
) t
ORDER BY t.totalSpent DESC

-- Find managers with more than 1 employee using FROM subquery

SELECT *
FROM (
    SELECT m.name , COUNT(e.emp_id) empCount
    FROM employees e
        JOIN employees m ON m.emp_id = e.manager_id
    GROUP BY m.name
    HAVING COUNT(*) > 1
) t

SELECT *
FROM
    (
    SELECT c.city, SUM(o.amount) totalAmount
    FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.city
) t


-- Q8.** Find customers spending above city average using FROM subquery

SELECT *
FROM (
    SELECT 
        c.name,
        c.city,
        SUM(o.amount) AS totalSpent
    FROM customers c
    JOIN orders o 
        ON o.customer_id = c.customer_id
    GROUP BY c.name, c.city
) custTotals

JOIN (
    SELECT 
        city,
        AVG(cityTotal) AS cityAvg
    FROM (
        SELECT 
            c1.customer_id,
            c1.city,
            SUM(o.amount) AS cityTotal
        FROM customers c1
        JOIN orders o 
            ON o.customer_id = c1.customer_id
        GROUP BY c1.customer_id, c1.city
    ) cityData
    GROUP BY city
) cityAvgData

ON custTotals.city = cityAvgData.city

WHERE custTotals.totalSpent > cityAvgData.cityAvg;

-- Show employee name, salary and salary rank using FROM subquery

SELECT *
FROM (
    SELECT name,salary,
    DENSE_RANK() over(ORDER BY salary DESC) rankEmp

    FROM employees
) t


-- Find the top spending customer per city using FROM subquery

SELECT * FROM (
    SELECT
        c.name,
        c.city,
        SUM(o.amount) totalSpent,
        RANK() OVER(PARTITION BY c.city
                    ORDER BY SUM(o.amount) DESC) cityRank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.name, c.city
) t
WHERE cityRank = 1