-- Create promo_code table
CREATE TABLE promo_code (
    promo_id SERIAL PRIMARY KEY,
    promo_name VARCHAR(255),
    price_deduction INT,
    description VARCHAR(255),
    duration INT
);

-- Import data from CSV file into promo_code table
COPY promo_code FROM 'C:\Task\promo_code.csv' DELIMITER ',' CSV HEADER;

-- Display all data from promo_code table
SELECT * FROM promo_code;

-- Join promo_code to sales_table
SELECT a.*, b.*
FROM sales_table a
JOIN promo_code b ON a.promo_id = b.promo_id
ORDER BY a.purchase_date ASC;

-- Show purchase date with promo discount (if available)
SELECT 
    a.purchase_date, 
    a.quantity, 
    b.price, 
    a.promo_id,
    COALESCE(c.price_deduction, 0) AS deduction
FROM sales_table a
LEFT JOIN marketplace_table b ON a.item_id = b.item_id
LEFT JOIN promo_code c ON a.promo_id = c.promo_id
ORDER BY a.purchase_date ASC;

-- Calculate total sales after applying promo
SELECT
    s.sales_id,
    s.item_id,
    s.quantity,
    s.purchase_date,
    m.price,
    m.price * s.quantity AS total_price,
    p.price_deduction,
    (m.price * s.quantity) - p.price_deduction AS sales_after_promo
FROM sales_table s
JOIN marketplace_table m ON s.item_id = m.item_id
JOIN promo_code p ON s.promo_id = p.promo_id
ORDER BY s.purchase_date ASC;

-- Calculate total price before applying promo
SELECT
    s.sales_id,
    s.item_id,
    s.quantity,
    s.purchase_date,
    m.price,
    m.price * s.quantity AS total_price
FROM sales_table s
JOIN marketplace_table m ON s.item_id = m.item_id
ORDER BY s.purchase_date ASC;
