-- Membuat tabel promo_code
CREATE TABLE promo_code (
    promo_id SERIAL PRIMARY KEY,
    promo_name VARCHAR(255),
    price_deduction INT,
    description VARCHAR(255),
    duration INT
);

-- Mengimpor data dari file CSV ke dalam tabel promo_code
COPY promo_code FROM 'C:\Task\promo_code.csv' DELIMITER ',' CSV HEADER;

-- Menampilkan seluruh data dari tabel promo_code
SELECT * FROM promo_code;

-- Gabung promo_code ke sales_table
SELECT a.*, b.*
FROM sales_table a
JOIN promo_code b ON a.promo_id = b.promo_id
ORDER BY a.purchase_date ASC;


-- Tampilkan tanggal pembelian dengan potongan harga promo (jika ada)
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


-- Hitung total penjualan setelah promo
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


-- Hitung total harga sebelum promo
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
