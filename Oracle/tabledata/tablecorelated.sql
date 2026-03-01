-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50),
    price INT
);
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 80000),
(2, 'Phone', 'Electronics', 30000),
(3, 'Desk', 'Furniture', 15000),
(4, 'Chair', 'Furniture', 8000),
(5, 'Tablet', 'Electronics', 25000);

-- Salespeople Table
CREATE TABLE salespeople (
    sales_id INT PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50),
    manager_id INT
);
INSERT INTO salespeople VALUES
(1, 'Varun', 'South', NULL),
(2, 'Priya', 'South', 1),
(3, 'Rahul', 'North', 1),
(4, 'Sneha', 'North', 3),
(5, 'Kumar', 'South', 2),
(6, 'Arjun', 'North', 3);

-- Sales Table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sales_id INT,
    product_id INT,
    quantity INT,
    total_amount INT,
    sale_date DATE
);
INSERT INTO sales VALUES
(1, 2, 1, 2, 160000, '2024-01-15'),
(2, 2, 2, 5, 150000, '2024-02-20'),
(3, 3, 3, 3, 45000,  '2024-01-10'),
(4, 4, 4, 10, 80000, '2024-03-05'),
(5, 5, 5, 4, 100000, '2024-02-28'),
(6, 3, 1, 1, 80000,  '2024-03-15'),
(7, 2, 5, 2, 50000,  '2024-01-20'),
(8, 6, 2, 3, 90000,  '2024-03-01'),
(9, 4, 1, 1, 80000,  '2024-02-10'),
(10,5, 3, 2, 30000,  '2024-01-25');

-- Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INT
);
INSERT INTO departments VALUES
(1, 'Electronics', 500000),
(2, 'Furniture', 200000),
(3, 'Marketing', 300000);





