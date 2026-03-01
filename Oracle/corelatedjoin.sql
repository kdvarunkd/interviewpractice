

-- **Q1.** Show each salesperson with their name and total sales amount — where their total sales is above 100000

select
    sp.name,
    (select sum(sa.total_amount)
    from sales sa
    where sa.sales_id = sp.sales_id ) total_saleamount

from salespeople sp

WHERE (
    select sum(total_amount)
from sales sa
WHERE  sa.sales_id = sp.sales_id
) > 100000

-- **Q2.** Show products that have been sold at least once
select pt.product_id, pt.name
from products pt
where exists(select 1
from sales sa
where sa.product_id = pt.product_id)

-- **Q3.** Show salespeople who have never made a sale

SELECT sp.name
FROM salespeople sp
WHERE NOT EXISTS (
    SELECT 1
FROM sales sa
WHERE sa.sales_id = sp.sales_id
);



-- **Q4.** Show each salesperson who made more sales than the average number of sales across all salespeople
select sp.name
from salespeople sp
where (select count(*)
from sales sa
where sa.sales_id = sp.sales_id) >(
    select avg(t.totalCount)
from


    ( select count(*) totalCount
    from sales
    GROUP BY sale_id
) t

)

-- **Q5.** Show products where price is higher than average price in their category

SELECT sp.name
FROM salespeople sp
WHERE (SELECT COUNT(*)
FROM sales sa
WHERE sa.sales_id = sp.sales_id) > (
    SELECT AVG(t.totalCount)
FROM (
        SELECT COUNT(*) totalCount
    FROM sales
    GROUP BY sales_id
    ) t
)


-- **Q6.** Show salespeople who earned more than their region's average total sales

select sp.name
from salespeople sp
where (select sum(sa.total_amount)
from sales sa
where sa.sales_id = sp.sales_id) > (select avg(t.totalAmount)
from (select sum(sa1.total_amount) totalAmount
    from salespeople sp1
        JOIN sales sa1 on sa1.sales_id =sp1.sales_id
    WHERE sp1.region = sp.region
    GROUP by sp1.sales_id)t )


-- **Advanced**



-- **Q10.** Show salespeople whose latest sale date is more recent than the average sale date of their region



-- **Q7.** Show each product with its name — only if it was sold in January 2024

select pd.name
from products pd
where exists (select 1
from sales sa
where sa.product_id = pd.product_id AND MONTH(sale_date)= 1 AND YEAR(sale_date) =2024)

-- **Q8.** Show salespeople who made their highest single sale above 100000

SELECT sp.name
FROM salespeople sp
WHERE (SELECT MAX(total_amount)
FROM sales s
WHERE s.sales_id = sp.sales_id) > 100000

-- *Q10.** Show salespeople whose latest sale date is more recent than the average sale date of their region


-- 

select *
from salespeople
select *
from sales
select *
from products

-- **Q1.** Show each salesperson with their total sales amount using JOIN

-- **Q2.** Show each product with total quantity sold using JOIN

-- **Q3.** Show salespeople who have made at least one sale — using JOIN subquery



-- **Q5.** Show each salesperson with their manager's name and total sales

-- **Intermediate**

-- **Q6.** Show top selling salesperson per region using JOIN + RANK

-- **Q7.** Show each product with total revenue and rank by revenue

-- **Q8.** Show salespeople with sales count, total amount and average amount per sale

-- **Advanced**

-- **Q9.** Show each salesperson with their total sales, region total and percentage contribution

-- **Q10.** Show top 2 salespeople per region by total amount with their rank
-- salespeople → sales_id, name, region, manager_id
-- sales       → sale_id, sales_id, product_id, quantity, total_amount, sale_date
-- products    → product_id, name, category, price
-- departments → dept_id, dept_name, budget


select sp.name, t.totalSales
from salespeople sp
    join (select sa.sales_id, sum(sa.total_amount) totalSales
    from sales sa
    group by sa.sales_id) t on t.sales_id =  sp.sales_id

select pd.name, t.totalquantity
from products pd
    left JOIN(select product_id , sum(quantity) totalquantity
    from sales
    group by product_id) t on  t.product_id = pd.product_id

-- **Q3.** Show salespeople who have made at least one sale — using JOIN subquery

select sp.name
from salespeople sp
    JOIN sales sa on sa.sales_id = sp.sales_id

-- **Q4.** Show each region with total sales amount using JOIN

select region, sum(t.total_amount)  totalregion
from(
    select sp1.region, s.total_amount
    from salespeople sp1
        JOIN sales s on s.sales_id = sp1.sales_id
) t
group by region

-- **Q5.** Show each salesperson with their manager's name and total sales
select sp.name, mgr.name, sp.manager_id, totalAmount as total
from salespeople sp
    left join(select sales_id, sum(total_amount) totalAmount
    from sales
    group by sales_id

) t on  sp.sales_id = t.sales_id
    left join salespeople mgr
    ON mgr.sales_id = sp.manager_id


-- **Q6.** Show top selling salesperson per region using JOIN + RANK


select *
from(
    select
        sp.name,
        sp.region,
        t1.total,
        rank() over (partition by sp.region ORDER BY t1.total desc ) rk

    from salespeople sp

        join
        (select sales_id, sum(total_amount) total
        FROM sales
        group by sales_id) t1 on sp.sales_id = t1.sales_id
) x
where rk = 1


--  **Q7.** Show each product with total revenue and rank by revenue

select *
from
    (
    select pdt.name, t.totalRev,
        rank() over(order by t.totalRev desc) rk




    FROM products pdt
        join(



select product_id, sum(total_amount) totalRev
        from sales
        GROUP BY product_id
) t on t.product_id = pdt.product_id

) x


select pdt.name, t.totalRev,
    rank() over(ORDER BY t.totalRev desc) rk
from products pdt

    JOIn(
    select product_id, sum(total_amount)totalRev
    from sales
    GROUP BY product_id
) t
    on t.product_id = pdt.product_id


-- **Q8.** Show salespeople with sales count, total amount and average amount per sale


select sp.name, t.totalCount totalcnt,
    t.totalAmount totalAmount,
    t.avgAmount avgAmt
from salespeople sp


    join(
        select
        sales_id, count(*) totalCount,
        sum(total_amount) totalAmount,
        avg(total_amount) avgAmount
    from sales
    group by sales_id
    ) t on t.sales_id = sp.sales_id


SELECT
    sp.name,
    sp.region,
    SUM(s.total_amount) AS salesperson_total,

    SUM(SUM(s.total_amount)) OVER(PARTITION BY sp.region) AS region_total,

    ROUND(
        (SUM(s.total_amount) * 100.0) /
        SUM(SUM(s.total_amount)) OVER(PARTITION BY sp.region),
        2
    ) AS percentage_contribution

FROM sales s
    JOIN salespeople sp
    ON s.sales_id = sp.sales_id

GROUP BY sp.name, sp.region;