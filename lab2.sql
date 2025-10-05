


--1.	Display the invoice number, the invoice date, the customer id, and the customer name for each order in the database.
SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice, customer
WHERE customer.cust_id = invoice.cust_id;

SELECT invoice_num, invoice_date, c.cust_id, cust_name
FROM invoice as i, customer as c
WHERE c.cust_id = i.cust_id;

-- This is EQUIJOIN and also an INNER JOIN

SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice INNER JOIN customer ON invoice.cust_id = customer.cust_id;

-- WEIRD OUTER JOIN (note the precedence afforded by the keyword RIGHT)
SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice RIGHT OUTER JOIN customer ON invoice.cust_id = customer.cust_id;

--2.	Display the invoice number, the customer id, and the customer name for each order placed on September 12th, 2007.
SELECT invoice_num, invoice_date, c.cust_id, cust_name
FROM invoice as i, customer as c
WHERE c.cust_id = i.cust_id
AND invoice_date = '12-SEP-07';
--3.	Display the invoice number, the invoice date, the product id, the number of units ordered, and the line price for each line in each order.
-- I was thinking to put the name to clarify and make finding things easier
SELECT 
    invoice.invoice_num,
    invoice.invoice_date,
    line.prod_id,
    line.line_num_ordered,
    line.line_price
FROM 
    invoice
JOIN 
    line ON invoice.invoice_num = line.invoice_num;

-- Das Way -- somehow this didnt work
SELECT invoice_num, invoice_date, line.prod_id, line_num_ordered, line_price
FROM invoice, line
WHERE invoice.invoice_num = line.invoice_num;

--4.	Display the id and the name of each customer that placed an order on September 12th, 2007, using the IN operator in your query.
SELECT cust_id, cust_name
FROM customer
WHERE cust_id IN 
(
	SELECT cust_id
	FROM invoice
	WHERE invoice_date = '12-SEP-07'
);
--5.	Display the id and the name of each customer that placed an order on September 12th, 2007, using the EXISTS operator in your query.
SELECT cust_id, cust_name
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM invoice i
    WHERE i.cust_id = c.cust_id
      AND i.invoice_date = '2007-09-12'
);

--6.	Display the id and the name of each customer that did not place an order on September 12th, 2007.   (Be careful in performing this query.)
 SELECT cust_id, cust_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM invoice i
    WHERE i.cust_id = c.cust_id
      AND i.invoice_date = '2007-09-12'
);


--7.	Display the invoice number, the invoice date, the product id, the product description, and the product type for each line in each order.
SELECT 
    invoice.invoice_num,
    invoice.invoice_date,
    product.prod_id,
    product.prod_desc,
    product.prod_type
FROM 
    invoice
JOIN 
    line ON invoice.invoice_num = line.invoice_num
JOIN 
    product ON line.prod_id = product.prod_id;

--8.	Display the same data as in question 7, but order the display by product type.  Within each type, order the display by invoice number.
SELECT 
    invoice.invoice_num,
    invoice.invoice_date,
    product.prod_id,
    product.prod_desc,
    product.prod_type
FROM 
    invoice
JOIN 
    line ON invoice.invoice_num = line.invoice_num
JOIN 
    product ON line.prod_id = product.prod_id
ORDER BY 
    product.prod_type,
    invoice.invoice_num;

--9.	Display the sales representative's id, last name, and first name of each representative who represents, at a minimum, one customer whose credit is $10,000 using a subquery.
 SELECT rep.rep_id, rep.rep_lname, rep.rep_fname
FROM rep
WHERE EXISTS (
    SELECT 1
    FROM customer
    WHERE customer.rep_id = rep.rep_id
      AND customer.cust_limit > customer.cust_balance
);

--10.	Display the same data as in the previous question without using a subquery.
SELECT DISTINCT rep.rep_id, rep.rep_lname, rep.rep_fname
FROM rep
JOIN customer ON rep.rep_id = customer.rep_id
WHERE customer.cust_limit > customer.cust_balance;

-- Das Way --
SELECT DISTINCT (r.rep_id), rep_lname, rep_fname
FROM rep AS r JOIN customer AS c ON r.rep_id = c.rep_id
WHERE cust_limit >= 10000;


-- 11. Display the id and the name of each customer with a current order for a Blender.
SELECT c.cust_id, c.cust_name, p.prod_desc
FROM customer AS c
JOIN invoice AS i ON c.cust_id = i.cust_id
JOIN line AS l ON i.invoice_num = l.invoice_num
JOIN product AS p ON l.prod_id = p.prod_id
WHERE p.prod_desc = 'Blender';

-- 12. Display the invoice number and the invoice date for each customer order placed by Charles Appliance and Sport.
SELECT invoice.invoice_num, invoice.invoice_date
FROM invoice
JOIN customer ON invoice.cust_id = customer.cust_id
WHERE customer.cust_name = 'Charles Appliance and Sport';

--13.	Display the invoice number and the invoice date for each invoice that contains an Electric Range.
SELECT invoice.invoice_num, invoice_date
FROM invoice, product, line
WHERE invoice.invoice_num = line.invoice_num
AND line.prod_id = product.prod_id
AND prod_desc = 'Electric Range';

--14.	Display the invoice number and the invoice date for each invoice that was either placed by Charles Appliance and Sport or whose invoice contains an Electric Range.  Use a set operation to perform this query.
SELECT invoice.invoice_num, invoice.invoice_date
FROM invoice
JOIN customer ON invoice.cust_id = customer.cust_id
WHERE customer.cust_name = 'Charles Appliance and Sport'

UNION

SELECT invoice.invoice_num, invoice.invoice_date
FROM invoice
JOIN line ON invoice.invoice_num = line.invoice_num
JOIN product ON line.prod_id = product.prod_id
WHERE product.prod_desc = 'Electric Range';

--15.	Display the invoice number and the invoice date for each invoice that was placed by Charles Appliance and Sport and whose invoice contains an Electric Range.  Use a set operation to perform this query.
-- Invoices placed by Charles Appliance and Sport
SELECT invoice.invoice_num, invoice.invoice_date
FROM invoice
JOIN customer ON invoice.cust_id = customer.cust_id
WHERE customer.cust_name = 'Charles Appliance and Sport'

INTERSECT

-- Invoices that contain an Electric Range
SELECT invoice.invoice_num, invoice.invoice_date
FROM invoice
JOIN line ON invoice.invoice_num = line.invoice_num
JOIN product ON line.prod_id = product.prod_id
WHERE product.prod_desc = 'Electric Range';

--16.	Display the invoice number and the invoice date for each invoice that was placed by Charles Appliance and Sport and whose invoice does not contain an Electric Range.  Use a set operation to perform this query.
-- Invoices placed by Charles Appliance and Sport
SELECT invoice.invoice_num, invoice.invoice_date
FROM invoice
JOIN customer ON invoice.cust_id = customer.cust_id
WHERE customer.cust_name = 'Charles Appliance and Sport'

EXCEPT

-- Invoices that contain an Electric Range
SELECT invoice.invoice_num, invoice.invoice_date
FROM invoice
JOIN line ON invoice.invoice_num = line.invoice_num
JOIN product ON line.prod_id = product.prod_id
WHERE product.prod_desc = 'Electric Range';

--17.	Display the product id, the product description, the product price, and the product type for each product whose product price is greater than the price of every part in product type SG.  Be sure to correctly choose either the ALL or the ANY operator in your query.
SELECT prod_id, prod_desc, prod_price, prod_type
FROM product
WHERE prod_price > ALL (
    SELECT prod_price
    FROM product
    WHERE prod_type = 'SG'
);

--18.	Display the same attributes as in the previous question.  However, use the other of the two operators: ALL or ANY.  This version of the SQL statement provides the answer to a question.  What is that question?  Add your answer as a comment to your list file.

SELECT prod_id, prod_desc, prod_price, prod_type
FROM product
WHERE prod_price > ANY (
    SELECT prod_price
    FROM product
    WHERE prod_type = 'SG'
);

--19.	Display the id, the description, the quantity, the invoice number, and the number of units ordered for each product.  Make sure to include all products in your output.  The order number and the number of ordered units must remain blank for any product that is not contained in an invoice.  Order your display by product number.
SELECT 
    product.prod_id,
    product.prod_desc,
    product.prod_quantity,
    invoice.invoice_num,
    line.line_num_ordered
FROM product
LEFT JOIN line ON product.prod_id = line.prod_id
LEFT JOIN invoice ON line.invoice_num = invoice.invoice_num
ORDER BY product.prod_id;
