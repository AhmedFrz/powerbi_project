CREATE TABLE aisles (
    aisle_id INT PRIMARY KEY,
    aisle VARCHAR
);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department VARCHAR
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR,
    aisle_id INT REFERENCES aisles(aisle_id),
    department_id INT REFERENCES departments(department_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    eval_set VARCHAR, -- prior, train, test
    order_number INT,
    order_dow INT, -- day of week
    order_hour_of_day INT,
    days_since_prior_order FLOAT
);

CREATE TABLE order_products_prior (
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE order_products_train (
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


SELECT * FROM orders LIMIT 10



-- INSPECTING THE DATA -- 

-- inspect the structure of the aisles table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'aisles';

-- inspect the structure of the Departments table
select column_name, data_type
from information_schema.columns
where table_schema = 'public'
and table_name = 'departments';

-- 1. TABLE LIST WITH ROW COUNTS - shows number of rows in each table
SELECT 
  relname AS table_name,
  n_live_tup AS row_count
FROM pg_stat_user_tables
ORDER BY row_count DESC;

-- 2. Columns info per table - 
SELECT 
  table_name, 
  column_name, 
  data_type
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 3. SAMPLE DATA FROM EACH TABLE
-- Returns 5 sample rows to preview structure
SELECT * FROM aisles LIMIT 5;
SELECT * FROM departments LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_products_prior LIMIT 5;
SELECT * FROM order_products_train LIMIT 5;




-- 4. Top 10 Most Ordered Products
SELECT 
  p.product_name, 
  COUNT(*) AS total_orders
FROM order_products_prior opp
JOIN products p ON p.product_id = opp.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC
LIMIT 10;



-- 5. Order Frequency by Hour of Day
-- When customers usually place orders (by hour).

SELECT 
  order_hour_of_day, 
  COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day;


-- 6. Average Basket Size
-- Average number of items per order.

SELECT 
  AVG(product_count) AS avg_basket_size
FROM (
  SELECT order_id, COUNT(*) AS product_count
  FROM order_products_prior
  GROUP BY order_id
) sub;




-- 7. Reorder Ratio
-- What % of products are reorders (not first-time).
SELECT 
  ROUND(SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END)::numeric / COUNT(*), 3) AS reorder_ratio
FROM order_products_prior;
