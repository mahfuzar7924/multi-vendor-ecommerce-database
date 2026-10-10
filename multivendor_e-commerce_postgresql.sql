
-- TABLES  (Part B: DDL)

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS vendors;
DROP TABLE IF EXISTS subscription_plans;

-- subscription_plans table (1 plan → many vendors)
CREATE TABLE subscription_plans (
    id          INT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    price       NUMERIC(10,2) NOT NULL,
    duration    VARCHAR(50),         
    features    TEXT
);

-- Q3. vendors table (PK + FK → subscription_plans.id)
-- A vendor can subscribe to only ONE plan at a time
CREATE TABLE vendors (
    id              INT PRIMARY KEY,
    business_name   VARCHAR(150) NOT NULL,
    contact_person  VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    address         VARCHAR(255),
    plan_id         INT NOT NULL REFERENCES subscription_plans(id)   -- FK → subscription_plans.id
);

-- categories table
CREATE TABLE categories (
    id          INT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- products table (1 vendor → many products)
CREATE TABLE products (
    id              INT PRIMARY KEY,
    vendor_id       INT NOT NULL REFERENCES vendors(id),   -- FK → vendors.id
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    price           NUMERIC(10,2) NOT NULL,
    stock_quantity  INT DEFAULT 0,
    status          VARCHAR(10) DEFAULT 'active'           -- 'active' or 'inactive'
);

-- Q4. product_categories table (junction table for the M:N relationship)
CREATE TABLE product_categories (
    product_id  INT REFERENCES products(id),     -- FK → products.id
    category_id INT REFERENCES categories(id),   -- FK → categories.id
    PRIMARY KEY (product_id, category_id)
);

CREATE TABLE customers (
    id          INT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    address     VARCHAR(255)
);

-- orders table (1 customer → many orders)
CREATE TABLE orders (
    id              INT PRIMARY KEY,
    customer_id     INT NOT NULL REFERENCES customers(id), 
    order_date      DATE,
    total_amount    NUMERIC(12,2),
    status          VARCHAR(20) DEFAULT 'pending'       
);

-- One order can contain products from different vendors
CREATE TABLE order_items (
    id          INT PRIMARY KEY,
    order_id    INT NOT NULL REFERENCES orders(id),    
    product_id  INT NOT NULL REFERENCES products(id),  
    quantity    INT NOT NULL,
    unit_price  NUMERIC(10,2) NOT NULL,
    subtotal    NUMERIC(12,2)                          
);

-- payments table (1 order → 1 payment, so order_id is UNIQUE)
CREATE TABLE payments (
    id              INT PRIMARY KEY,
    order_id        INT NOT NULL UNIQUE REFERENCES orders(id),   
    method          VARCHAR(30) NOT NULL,                 
    amount          NUMERIC(12,2) NOT NULL,
    payment_date    DATE,
    status          VARCHAR(20) DEFAULT 'pending'         
);



INSERT INTO subscription_plans (id, name, price, duration, features) VALUES
(1, 'Basic',     500.00, '1 Month', 'Up to 50 products, email support'),
(2, 'Standard', 1500.00, '1 Month', 'Up to 500 products, chat support'),
(3, 'Premium',  4000.00, '1 Month', 'Unlimited products, priority support, analytics');

INSERT INTO vendors (id, business_name, contact_person, email, phone, address, plan_id) VALUES
(1, 'Walton Digital Store', 'Hasan Mahmud',  'hasan@waltondigital.com', '01711000001', 'Chittagong, Bangladesh', 3),
(2, 'Aarong Fashion Hub',   'Nusrat Jahan',  'nusrat@aarongfashion.com','01811000002', 'Dhaka, Bangladesh',      2),
(3, 'HomeNeeds BD',         'Karim Hossain', 'karim@homeneeds.com',     '01911000003', 'Sylhet, Bangladesh',     1);

INSERT INTO categories (id, name, description) VALUES
(1, 'Electronics',     'Electronic devices and gadgets'),
(2, 'Computers',       'Laptops, desktops and peripherals'),
(3, 'Mobile',          'Smartphones and tablets'),
(4, 'Accessories',     'Chargers, earbuds, mice and more'),
(5, 'Fashion',         'Clothing and traditional wear'),
(6, 'Home & Kitchen',  'Appliances and kitchen items');

INSERT INTO products (id, vendor_id, name, description, price, stock_quantity, status) VALUES
(1,  1, 'Xiaomi Redmi 12',     'Budget smartphone, 128GB',   18500.00,  50, 'active'),
(2,  1, 'Samsung A35',         'Mid-range smartphone',       32000.00,  30, 'active'),
(3,  1, 'Sony Earbuds WF',     'Wireless earbuds',            4500.00, 100, 'active'),
(4,  1, 'Logitech Mouse M185', 'Wireless mouse',               950.00, 200, 'active'),
(5,  1, 'Anker Power Bank',    '10000mAh power bank',         2800.00, 150, 'active'),
(6,  2, 'Cotton Panjabi',      'Eid collection panjabi',      2200.00,  80, 'active'),
(7,  2, 'Jamdani Saree',       'Handwoven jamdani saree',     8500.00,  25, 'active'),
(8,  3, 'Rice Cooker 1.8L',    'Automatic rice cooker',       3600.00,  40, 'active'),
(9,  3, 'Electric Kettle',     '1.7L stainless steel kettle', 1800.00,  60, 'active'),
(10, 3, 'Air Fryer 4L',        'Digital air fryer',           9500.00,   0, 'inactive');
-- Note: Product 10 is inactive with 0 stock → useful for status demo

INSERT INTO product_categories (product_id, category_id) VALUES
(1, 1), (1, 3),
(2, 1), (2, 3),
(3, 1), (3, 4),
(4, 1), (4, 2), (4, 4),
(5, 1), (5, 4),
(6, 5),
(7, 5),
(8, 6), (8, 1),
(9, 6), (9, 1),
(10, 6), (10, 1);

INSERT INTO customers (id, name, email, phone, address) VALUES
(1, 'Arif Chowdhury', 'arif@gmail.com',          '01712345001', 'Dhaka, Bangladesh'),
(2, 'Mitu Akter',     'mitu@yahoo.com',          '01812345002', 'Chittagong, Bangladesh'),
(3, 'Karim Uddin',    'karim@gmail.com',         '01912345003', 'Sylhet, Bangladesh'),
(4, 'Puja Das',       'puja@hotmail.com',        '01612345004', 'Dhaka, Bangladesh'),
(5, 'Rubel Khan',     'rubel@gmail.com',         '01512345005', 'Rajshahi, Bangladesh'),
(6, 'Old Customer',   'oldcustomer@gmail.com',   '01412345006', 'Dhaka, Bangladesh');

INSERT INTO orders (id, customer_id, order_date, total_amount, status) VALUES
(1, 1, '2024-01-05',  20400.00, 'delivered'),
(2, 2, '2024-01-12',  32000.00, 'delivered'),
(3, 3, '2024-02-03',   5400.00, 'pending'),
(4, 4, '2024-02-20',   8500.00, 'delivered'),
(5, 1, '2024-03-01',  11800.00, 'shipped'),
(6, 3, '2024-03-15',  38600.00, 'delivered'),
(7, 5, '2024-04-10',   6000.00, 'confirmed'),
(8, 2, '2024-04-22',  74000.00, 'delivered'),
(9, 4, '2024-05-07',   5450.00, 'delivered');

INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES
(1,  1, 1, 1, 18500.00, 18500.00),
(2,  1, 4, 2,   950.00,  1900.00),
(3,  2, 2, 1, 32000.00, 32000.00),
(4,  3, 8, 1,  3600.00,  3600.00),
(5,  3, 9, 1,  1800.00,  1800.00),
(6,  4, 7, 1,  8500.00,  8500.00),
(7,  5, 3, 2,  4500.00,  9000.00),
(8,  5, 5, 1,  2800.00,  2800.00),
(9,  6, 2, 1, 32000.00, 32000.00),
(10, 6, 6, 3,  2200.00,  6600.00),
(11, 7, 4, 4,   950.00,  3800.00),
(12, 7, 6, 1,  2200.00,  2200.00),
(13, 8, 1, 4, 18500.00, 74000.00),
(14, 9, 3, 1,  4500.00,  4500.00),
(15, 9, 4, 1,   950.00,   950.00);

INSERT INTO payments (id, order_id, method, amount, payment_date, status) VALUES
(1, 1, 'Card',             20400.00, '2024-01-05', 'paid'),
(2, 2, 'Bkash',            32000.00, '2024-01-12', 'paid'),
(3, 3, 'Cash on Delivery',  5400.00, '2024-02-03', 'pending'),
(4, 4, 'PayPal',            8500.00, '2024-02-20', 'paid'),
(5, 5, 'Bkash',            11800.00, '2024-03-01', 'paid'),
(6, 6, 'Card',             38600.00, '2024-03-15', 'paid'),
(7, 7, 'Cash on Delivery',  6000.00, '2024-04-10', 'pending'),
(8, 8, 'Bkash',            74000.00, '2024-04-22', 'paid'),
(9, 9, 'Card',              5450.00, '2024-05-07', 'paid');


-- ============================================================
-- PART C:
-- Q5. Insert vendor "SmartTech Ltd." under the Basic plan
-- (plan_id is found by plan name using a subquery)
INSERT INTO vendors (id, business_name, contact_person, email, phone, address, plan_id)
VALUES (
    4,
    'SmartTech Ltd.',
    'Rahim Khan',
    'rahim@smarttech.com',
    '017XXXXXXXX',
    'Dhaka, Bangladesh',
    (SELECT id FROM subscription_plans WHERE name = 'Basic')
);

-- Q6. Insert product "Laptop" (price 75000, stock 10, active) for SmartTech Ltd.
-- Step 1: add the product and link it to its vendor
INSERT INTO products (id, vendor_id, name, description, price, stock_quantity, status)
VALUES (
    11,
    (SELECT id FROM vendors WHERE business_name = 'SmartTech Ltd.'),
    'Laptop',
    'High performance laptop',
    75000.00,
    10,
    'active'
);

-- Step 2: put the product under the Electronics category (M:N junction table)
INSERT INTO product_categories (product_id, category_id)
VALUES (
    (SELECT id FROM products WHERE name = 'Laptop'),
    (SELECT id FROM categories WHERE name = 'Electronics')
);

-- Q7. Update the stock quantity of "Laptop" to 15
UPDATE products
SET stock_quantity = 15
WHERE name = 'Laptop';

-- Q8. Delete the customer whose email is "oldcustomer@gmail.com"
DELETE FROM customers
WHERE email = 'oldcustomer@gmail.com';


-- PART D:
-- Q9. Display all vendors with their subscription plan name and price
SELECT v.id, v.business_name, sp.name AS plan_name, sp.price
FROM vendors v
JOIN subscription_plans sp ON v.plan_id = sp.id
ORDER BY v.id;

-- Q10. Find all products under the "Electronics" category (name, price, stock quantity)
SELECT p.name, p.price, p.stock_quantity
FROM products p
JOIN product_categories pc ON p.id = pc.product_id
JOIN categories c ON pc.category_id = c.id
WHERE c.name = 'Electronics';

-- Q11. List all orders placed by customer "Karim Uddin" (order_id, date, total_amount, status)
SELECT o.id AS order_id, o.order_date, o.total_amount, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE c.name = 'Karim Uddin';

-- Q12. Show the payment details (method, amount, status) for order_id = 1
SELECT method, amount, status
FROM payments
WHERE order_id = 1;

-- Q13. Find the top 5 best-selling products based on total quantity sold
SELECT p.id, p.name, SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 5;
