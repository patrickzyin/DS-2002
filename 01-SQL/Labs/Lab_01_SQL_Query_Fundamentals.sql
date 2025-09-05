-- --------------------------------------------------------------------------------------
-- Course: DS2-2002 - Data Science Systems | Author: Jon Tupitza
-- Lab 1: SQL Query Fundamentals | 5 Points
-- --------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- 1). First, How Many Rows (Products) are in the Products Table?			| 0.2 pt
-- --------------------------------------------------------------------------------------
	SELECT COUNT(*) AS products
	FROM northwind.products;

-- --------------------------------------------------------------------------------------
-- 2). Fetch Each Product Name and its Quantity per Unit					| 0.2.pt
-- --------------------------------------------------------------------------------------

SELECT product_name AS name, quantity_per_unit AS unit_qty
FROM northwind.products;
-- --------------------------------------------------------------------------------------
-- 3). Fetch the Product ID and Name of Currently Available Products		| 0.2 pt
-- --------------------------------------------------------------------------------------

SELECT id AS product_id, product_name
FROM northwind.products
WHERE discontinued = 0;

-- --------------------------------------------------------------------------------------
-- 4). Fetch the Product ID, Name & List Price Costing Less Than $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------

SELECT id AS product_id, product_name, list_price
FROM northwind.products
WHERE list_price < 20
ORDER BY list_price DESC;

-- --------------------------------------------------------------------------------------
-- 5). Fetch the Product ID, Name & List Price Costing Between $15 and $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------

SELECT id AS product_id, product_name, list_price
FROM northwind.products
WHERE list_price BETWEEN 15 AND 20
ORDER BY list_price DESC;


-- Older (Equivalent) Syntax -----

SELECT id AS product_id, product_name, list_price
FROM northwind.products
WHERE list_price >= 15 AND list_price <= 20
ORDER BY list_price DESC;


-- --------------------------------------------------------------------------------------
-- 6). Fetch the Product Name & List Price of the 10 Most Expensive Products 
--     Sort the results with the most expensive Products first.				| 0.33 pt
-- --------------------------------------------------------------------------------------

SELECT product_name, list_price
FROM northwind.products
ORDER BY list_price DESC
LIMIT 10;



-- --------------------------------------------------------------------------------------
-- 7). Fetch the Name & List Price of the Most & Least Expensive Products	| 0.33 pt.
-- --------------------------------------------------------------------------------------

SELECT product_name, list_price
FROM northwind.products
WHERE list_price = (SELECT MAX(list_price) FROM northwind.products)
OR list_price = (SELECT MIN(list_price) FROM northwind.products);

-- --------------------------------------------------------------------------------------
-- 8). Fetch the Product Name & List Price Costing Above Average List Price
--     Sort the results with the most expensive Products first.				| 0.33 pt.
-- --------------------------------------------------------------------------------------

-- average list price is approximately 15.85

SELECT product_name, list_price
FROM northwind.products
WHERE list_price > (SELECT AVG(list_price) FROM northwind.products)
ORDER BY list_price DESC;

-- --------------------------------------------------------------------------------------
-- 9). Fetch & Label the Count of Current and Discontinued Products using
-- 	   the "CASE... WHEN" syntax to create a column named "availablity"
--     that contains the values "discontinued" and "current". 				| 0.33 pt
-- --------------------------------------------------------------------------------------
UPDATE northwind.products SET discontinued = 1 WHERE id IN (95, 96, 97);

-- TODO: Insert query here.

SELECT 
CASE
	WHEN discontinued = 1 THEN 'discontinued'
    ELSE 'current'
END AS availability,
COUNT(*) AS count
FROM northwind.products
GROUP BY 
CASE 
	WHEN discontinued = 1 THEN 'discontinued'
	ELSE 'current'
END;	



UPDATE northwind.products SET discontinued = 0 WHERE id in (95, 96, 97);

-- --------------------------------------------------------------------------------------
-- 10). Fetch Product Name, Reorder Level, Target Level and "Reorder Threshold"
-- 	    Where Reorder Level is Less Than or Equal to 20% of Target Level	| 0.33 pt.
-- --------------------------------------------------------------------------------------
SELECT product_name, reorder_level, target_level, ROUND(target_level/5) AS reorder_threshold
FROM northwind.products
WHERE reorder_level <= ROUND(target_level/5);

-- --------------------------------------------------------------------------------------
-- 11). Fetch the Number of Products per Category Priced Less Than $20.00	| 0.33 pt
-- --------------------------------------------------------------------------------------

SELECT COUNT(*) AS product_count, category
FROM northwind.products
WHERE list_price <= 20
GROUP BY category;


-- --------------------------------------------------------------------------------------
-- 12). Fetch the Number of Products per Category With Less Than 5 Units In Stock	| 0.5 pt
-- --------------------------------------------------------------------------------------
SELECT category, COUNT(*) as units_in_stock
FROM northwind.products
GROUP BY category
HAVING units_in_stock < 5;


-- --------------------------------------------------------------------------------------
-- 13). Fetch Products along with their Supplier Company & Address Info		| 0.5 pt
-- --------------------------------------------------------------------------------------

SELECT p.product_name,
	p.category AS product_category,
    p.list_price AS product_list_price,
    s.company AS supplier_company,
    s.address AS supplier_address,
    s.city AS supplier_city,
    s.state_province AS supplier_state_province,
    s.zip_postal_code AS supplier_zip_postal_code
FROM northwind.products p 
INNER JOIN northwind.suppliers s
ON p.supplier_ids = s.id;
    

-- --------------------------------------------------------------------------------------
-- 14). Fetch the Customer ID and Full Name for All Customers along with
-- 		the Order ID and Order Date for Any Orders they may have			| 0.5 pt
-- --------------------------------------------------------------------------------------

SELECT c.id AS customer_id,
	CONCAT(c.first_name, " ", c.last_name) AS customer_full_name,
    o.id AS order_id,
    o.order_date
FROM northwind.customers c
LEFT JOIN northwind.orders AS o
ON c.id = o.customer_id
ORDER BY customer_id;
	

-- --------------------------------------------------------------------------------------
-- 15). Fetch the Order ID and Order Date for All Orders along with
--   	the Customer ID and Full Name for Any Associated Customers			| 0.5 pt
-- --------------------------------------------------------------------------------------

SELECT o.id AS order_id,
       o.order_date,
       c.id AS customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name
FROM northwind.orders AS o
LEFT JOIN northwind.customers AS c
    ON o.customer_id = c.id
ORDER BY o.id;


