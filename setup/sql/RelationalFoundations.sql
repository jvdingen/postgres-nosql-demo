-- ----------------
-- 0) Start fresh
-- ----------------
-- Clean up (drop in correct order)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- ----------------
-- 1) Create tables
-- ----------------

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT UNIQUE NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    sku        TEXT UNIQUE,
    price      NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Orders stores a snapshot of unit_price to preserve the price at time of order. 
-- This is common in order systems, for example when products go on sale later.
CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    product_id   INT NOT NULL REFERENCES products(product_id),
    unit_price   NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    quantity     INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    order_date   TIMESTAMPTZ DEFAULT NOW()
);

-- ----------------
-- 2) Insert sample data (Create)
-- ----------------

-- Products
INSERT INTO products (name, sku, price) VALUES
  ('Keyboard',   'KB-100', 49.99),
  ('Mouse',      'MS-200', 24.50),
  ('Monitor',    'MN-300', 199.99),
  ('Headset',    'HS-400', 89.50),
  ('USB Cable',  'CB-500', 9.99);

-- Customers
INSERT INTO customers (name, email) VALUES
  ('Alice Johnson',  'alice@example.com'),
  ('Bob Smith',      'bob@example.com'),
  ('Charlie Green',  'charlie@example.com');

-- Orders
-- You can derive unit_price with a subselect to keep it consistent:
INSERT INTO orders (customer_id, product_id, unit_price, quantity)
VALUES
  (1, 1, (SELECT price FROM products WHERE product_id = 1), 1),  -- Alice buys Keyboard
  (1, 2, (SELECT price FROM products WHERE product_id = 2), 1),  -- Alice buys Mouse
  (2, 3, (SELECT price FROM products WHERE product_id = 3), 2),  -- Bob buys 2 Monitors
  (3, 4, (SELECT price FROM products WHERE product_id = 4), 1),  -- Charlie buys Headset
  (3, 5, (SELECT price FROM products WHERE product_id = 5), 3);  -- Charlie buys 3 USB Cables

-- ----------------
-- 3) Read queries (Selects)
-- ----------------

-- Look at our data in the tables we created
SELECT * FROM products ORDER BY product_id;
SELECT * FROM customers ORDER BY customer_id;
SELECT * FROM orders ORDER BY order_id;

-- Orders with joined customer & product information for the full picture
SELECT
  o.order_id,
  c.name     AS customer_name,
  p.name     AS product_name,
  o.quantity,
  o.unit_price,
  (o.unit_price * o.quantity) AS line_total,
  o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p  ON o.product_id  = p.product_id
ORDER BY o.order_date;

-- ----------------
-- 4) Update (Update)
-- ----------------

-- Example 1: A customer changes their email address
UPDATE customers
SET email = 'alice.johnson@example.com'
WHERE name = 'Alice Johnson';

-- Example 2: Products change price, but historical orders keep the old price snapshot
UPDATE products
SET price = 54.99
WHERE product_id = 1;  -- Keyboard price increased from 49.99 -> 54.99

INSERT INTO orders (customer_id, product_id, unit_price, quantity) VALUES
  (2, 1, (SELECT price FROM products WHERE product_id = 1), 2),  -- Bob buys 2 Keyboards

-- Show that historical orders keep the old unit_price snapshot
SELECT order_id, product_id, unit_price FROM orders WHERE product_id = 1;

-- ----------------
-- 5) Delete (Delete)
-- ----------------

-- delet product headset
DELETE FROM products
WHERE name = 'Headset';


-- Delete a single order (Charlie’s headset order)
DELETE FROM orders
WHERE order_id = (
  SELECT order_id FROM orders
  JOIN products USING (product_id)
  WHERE products.name = 'Headset'
  LIMIT 1
);

-- Delete a product that is not ordered (safe delete)
-- Attempting to delete a product that has orders will fail due to FK constraint:
-- DELETE FROM products WHERE product_id = 3;  -- if orders exist, this will error

-- ----------------
-- 6) Aggregations (Count, Sum, Group By)
-- ----------------

-- Total number of orders (rows)
SELECT COUNT(*) AS total_orders FROM orders;

-- Total revenue (sum of unit_price * quantity)
SELECT SUM(unit_price * quantity) AS total_revenue FROM orders;

-- Revenue per customer
SELECT
  c.customer_id,
  c.name,
  SUM(o.unit_price * o.quantity) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY revenue DESC;

-- Top products by revenue
SELECT
  p.product_id,
  p.name,
  SUM(o.unit_price * o.quantity) AS revenue,
  SUM(o.quantity) AS total_sold
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY revenue DESC;

-- ----------------
-- 7) Small view and index examples (optional quick demo)
-- ----------------

-- A simple view for reporting
CREATE OR REPLACE VIEW daily_sales AS
SELECT
  date_trunc('day', order_date) AS day,
  COUNT(*) AS orders_count,
  SUM(unit_price * quantity) AS revenue
FROM orders
GROUP BY 1
ORDER BY 1;

-- use the view
select * from daily_sales;

-- Index to speed up joins / lookups by product_id on orders
CREATE INDEX IF NOT EXISTS idx_orders_product_id ON orders(product_id);

-- ================================
-- End of script
-- ================================