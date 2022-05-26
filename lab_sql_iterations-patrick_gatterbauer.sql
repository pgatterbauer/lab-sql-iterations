/**

Instructions
Write queries to answer the following questions:

**/

USE sakila;

#Write a query to find what is the total business done by each store.

SELECT 
	s.store_id,
    SUM(p.amount) as sum_amount
FROM
	staff s
JOIN
	payment p
USING
	(staff_id)
GROUP BY
	s.store_id;
    
#Convert the previous query into a stored procedure.
DELIMITER //
CREATE PROCEDURE store_revenue (in id int)
BEGIN  
	SELECT 
		s.store_id,
		SUM(p.amount) as sum_amount
	FROM
		staff s
	JOIN
		payment p
	USING
		(staff_id)
	GROUP BY
		s.store_id
	HAVING
		s.store_id = id;
END;
//
DELIMITER ;

CALL store_revenue (1);

DROP PROCEDURE store_revenue;

# Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //
CREATE PROCEDURE store_revenue_2 (in id int)
BEGIN
   SELECT 
	s.store_id, sum(p.amount) AS store_revenue
FROM
	store s
JOIN
	staff st
USING
	(store_id)
JOIN
	payment p
USING
	(staff_id)
GROUP BY
	s.store_id, st.staff_id 
HAVING
	s.store_id = id;
END;
//
DELIMITER ;

CALL store_revenue_2(1);

DROP PROCEDURE store_revenue_2;


# Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result 
# (of the total sales amount for the store). Call the stored procedure and print the results.

DELIMITER //
CREATE PROCEDURE store_revenue_3 (in id int)
BEGIN
DECLARE total_sales_value float default 0.0;
SELECT 
	sum(p.amount) into total_sales_value
FROM
	store s
JOIN
	staff st 
USING
    (store_id)
JOIN
	payment p 
USING 
	(staff_id)
GROUP BY
	s.store_id, st.staff_id
HAVING
	s.store_id = id;
SELECT id, total_sales_value;
END;
//
DELIMITER ;

CALL store_revenue_3 (1);

DROP PROCEDURE store_revenue_3;

# In the previous query, add another variable flag. If the total sales value for the store is over 30.000, 
# then label it as green_flag, otherwise label is as red_flag. 
DELIMITER //
CREATE PROCEDURE store_revenue_4 (in id int, out flag varchar(10))
BEGIN
DECLARE total_sales_value float default 0.0;
DECLARE colour VARCHAR(10) DEFAULT "";
SELECT 
	sum(p.amount) into total_sales_value
FROM
	store s
JOIN
	staff st 
USING 
	(store_id)
JOIN
	payment p 
USING
	(staff_id)
GROUP BY
	s.store_id, st.staff_id 
HAVING
	s.store_id = id;
SELECT id, total_sales_value;

IF total_sales_value > 30000 THEN
	SET colour = 'green_flag';
ELSE
	SET colour = 'red_flag';
END IF;

SELECT colour INTO flag;
END;
//
DELIMITER ;

CALL store_revenue_4(1, @flag);
SELECT @flag;

DROP PROCEDURE store_revenue_4;

# Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
DELIMITER //
CREATE PROCEDURE store_revenue_5 (in id int, out sales float4, out flag varchar(10))
BEGIN
DECLARE colour VARCHAR(10) DEFAULT "";
SELECT 
	sum(p.amount) into sales
FROM
	store s
JOIN
	staff st 
USING 
	(store_id)
JOIN
	payment p 
USING 
	(staff_id)
GROUP BY
	s.store_id, st.staff_id 
HAVING
	s.store_id = id;
    
IF sales > 30000 THEN
	SET colour = 'green_flag';
ELSE
	SET colour = 'red_flag';
END IF;

SELECT colour INTO flag;
END;
//
delimiter ;

CALL store_revenue_5(1, @sales, @flag);
SELECT @sales AS sales, @flag AS flag;

DROP PROCEDURE store_revenue_5;

