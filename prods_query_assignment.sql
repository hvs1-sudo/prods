

	SELECT rep_id FROM rep

-- 1.	Display the ids and names for all customers.
	SELECT cust_id, cust_name FROM customer;

-- 2.	Display all the data in the sales representative table.
	SELECT * FROM rep;

	SELECT * FROM customer LIMIT 5;

-- 3.	Display the names of all customers whose credit limits are $10,000 or more.

SELECT cust_name FROM customer
WHERE cust_limit >= 10000;

-- 4.	Display the invoice number for all orders placed by the customer whose id is 1619 on September 13, 2007.  Please note: A date in a condition should be in the form ’13-SEP-07’.
SELECT invoice_num FROM invoice
WHERE cust_id = '1619' AND invoice_date = '13-SEP-07';
-- 5.	Display the id and the name for all customers whose sales representative has an id of either 237 or 268.
SELECT cust_id, cust_name
FROM customer
WHERE rep_id IN ('237', '268');
-- 6.	Display the id and description for all products whose type is not AP.
SELECT prod_id, prod_desc
FROM product
WHERE prod_type != 'AP';
-- 7.	Display the id, the description, and the number of items for each product that has between 12 and 30 items. Perform this query two different ways.
SELECT prod_id, prod_desc, prod_quantity
FROM product
WHERE prod_quantity BETWEEN 12 AND 30;
-- 8.	Display the id, the description, and the total value (product quantity * product price) of each product whose product type is HW.  Assign the column name TOTAL_VALUE to this calculation.
SELECT prod_id, prod_desc, 
       prod_quantity * prod_price AS TOTAL_VALUE
FROM product
WHERE prod_type = 'HW';
-- 9.	Display the id, the description, and the total value (product quantity * product price) of each product whose total value is greater than or equal to $4,000.  Assign the column name TOTAL_VALUE to the calculation.
SELECT prod_id, prod_desc, 
       prod_quantity * prod_price AS TOTAL_VALUE
FROM product
WHERE prod_quantity * prod_price >= 4000;
-- 10.	Display the id and the description for each product whose type is either SG or AP using the IN operator.
SELECT prod_id, prod_desc
FROM product
WHERE prod_type IN ('SG', 'AP');
-- 11.	Determine the id and the name of each customer whose name starts with the letter “S”.
SELECT cust_id, cust_name FROM customer
WHERE cust_name LIKE 'S%';
-- 12.	Display all the data in the products table.  Order the display by the product description.
SELECT * FROM product
ORDER BY prod_desc DESC;
-- 13.	Display all the data in the products table.  Order the display by product type.  Within each product type, order the display by product id.
SELECT * FROM product
ORDER BY prod_type, prod_id;
-- 14.	Determine the number of customers whose balances are less than their credit limits.
SELECT COUNT(*) FROM customer
WHERE cust_balance < cust_limit;
-- 15.	Display the total of the balances of all customers who are represented by sales representative 237 and whose balances are less than their credit limits.
SELECT SUM(cust_balance) AS total_balance
FROM customer
WHERE rep_id = '237'
  AND cust_balance < cust_limit;

-- 16.	Display the id, the description, and the total value of each product whose number of items is greater than the average number of items for all products. You may want to use a subquery.
SELECT prod_id, prod_desc, (prod_quantity * prod_price) AS TOTAL_VALUE FROM product
WHERE prod_quantity > (SELECT AVG(prod_quantity) FROM product);
-- 17.	Display the balance of the customer whose balance is the smallest.
SELECT cust_balance
FROM customer
WHERE cust_balance = (
    SELECT MIN(cust_balance)
    FROM customer
);

-- 18.	Display the id, the name, and the balance of the customer with the largest balance. 
SELECT cust_id, cust_name, cust_balance FROM customer
WHERE cust_balance = (SELECT MAX(cust_balance) FROM customer);
-- 19.	Display the sales representative’s id and the sum of the balances of all customers represented by each of these sales representatives. Group and order the display by the sales representative ids.
SELECT rep_id, SUM(cust_balance) FROM customer
GROUP BY rep_id
ORDER BY rep_id;
-- 20.	Display the sales representative’s id and the sum of the balances of all customers represented by each of these sales representatives, but limit the result to those sales representatives whose sum is more than $12,000.
SELECT rep_id, SUM(cust_balance) FROM customer
GROUP BY rep_id
HAVING SUM(cust_balance) > 12000
ORDER BY rep_id;
-- 21.	Display the ids of all products whose description is not known.
SELECT prod_id FROM product
WHERE prod_desc IS NULL;