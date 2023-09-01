-- Question
-- Add a new column in the customer table for Platinum Member. This can be a boolean.
-- Platinum Members are any customers who have spent over $200. 
-- Create a procedure that updates the Platinum Member column to True for any customer who has spent over $200 and False for any customer who has spent less than $200.


-- Use the payment and customer table.
SELECT customer_id, first_name, last_name, platinum_member
FROM customer;

SELECT payment_id, customer_id, amount
FROM payment;

-- Adding the new column Platinum Member in customer table
ALTER TABLE customer ADD platinum_member BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE customer DROP platinum_member;
-- This pulls all customer id's who spent over $200
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 200
ORDER BY SUM(amount) DESC;

-- joining the two tables
SELECT payment.customer_id, SUM(amount), customer.platinum_member
FROM payment
INNER JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY payment.customer_id, customer.platinum_member
HAVING SUM(amount) > 200
ORDER BY SUM(amount) DESC;

-- Create a procedure that updates the Platinum Member column to True for any customer who has spent over $200
CREATE OR REPLACE PROCEDURE update_to_platinum()
AS $$
BEGIN
UPDATE customer
SET platinum_member = TRUE
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 200
	ORDER BY SUM(amount) DESC);
END;
$$
LANGUAGE plpgsql;

CALL update_to_platinum();




