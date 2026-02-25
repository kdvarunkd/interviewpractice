CREATE TABLE employees (
    emp_id     INT PRIMARY KEY,
    name       VARCHAR(50),
    manager_id INT,
    salary     INT
);

INSERT INTO employees VALUES (1, 'Varun', NULL,  90000);
INSERT INTO employees VALUES (2, 'Priya', 1,     75000);
INSERT INTO employees VALUES (3, 'Rahul', 1,     80000);
INSERT INTO employees VALUES (4, 'Sneha', 2,     60000);
INSERT INTO employees VALUES (5, 'Kumar', 2,     85000);

-- ============================================
-- CREATE AND INSERT CUSTOMERS
-- ============================================
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name        VARCHAR(50),
    city        VARCHAR(50)
);

INSERT INTO customers VALUES (1, 'Varun', 'Kerala');
INSERT INTO customers VALUES (2, 'Priya', 'Chennai');
INSERT INTO customers VALUES (3, 'Rahul', 'Mumbai');
INSERT INTO customers VALUES (4, 'Sneha', 'Delhi');

-- ============================================
-- CREATE AND INSERT ORDERS
-- ============================================
CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    product     VARCHAR(50),
    amount      INT
);

INSERT INTO orders VALUES (1, 1,  'Laptop', 50000);
INSERT INTO orders VALUES (2, 1,  'Phone',  5000);
INSERT INTO orders VALUES (3, 2,  'Tablet', 20000);
INSERT INTO orders VALUES (4, 99, 'Mouse',  500);