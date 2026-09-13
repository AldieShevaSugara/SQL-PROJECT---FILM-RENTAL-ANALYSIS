#TASK SQL

#1 All film with PG-13 film with rental rate of 2.99 or lower

	SELECT title, rating, rental_rate 
   	FROM sakila.film f
	WHERE rating = 'PG-13' 
   	AND rental_rate<=2.99

#2 All film that have deleted scenes

  	SELECT title, special_features 	
  	FROM sakila.film f
  	WHERE special_features LIKE '%deleted scenes%'

#3. All active customers

  	SELECT CONCAT(first_name,' ',last_name) 'Full name', active 
  	FROM sakila.customer
  	WHERE active = 1

#4. Names of customers who rented a movie on 26th July 2005

  	SELECT CONCAT(c.first_name,' ', c.last_name) 'Full name', DATE(r.rental_date) 
  	FROM sakila.rental r
  	JOIN sakila.customer c ON c.customer_id = r.customer_id
  	WHERE DATE(r.rental_date) = '2005-07-26';

#5. Distinct names of customers

  	SELECT distinct concat(c.first_name,' ', c.last_name) 'Full name' 
  	FROM sakila.rental r
  	JOIN sakila.customer c ON c.customer_id = r.customer_id
  	WHERE DATE(r.rental_date) = '2005-07-26';

#6. How many distinct last names we have in the data
	
  	SELECT count(distinct c.last_name) 'Distinct customer last name' 
  	FROM sakila.customer c;

#7. How many rentals we do in each day?

  	SELECT DATE(rental_date), count(*) FROM sakila.rental r
  	GROUP BY DATE(rental_date);

#8 Busiest day?

  	SELECT DATE(rental_date), count(*) AS SUM_RENTAL
  	FROM sakila.rental r
  	GROUP BY DATE (rental_date)
  	ORDER BY sum_rental DESC
  	LIMIT 1;

#9. All Sci-fi film in our catalogue

  	SELECT fc.film_id, fc.category_id, c.name, f.title 
  	FROM sakila.film_category fc
  	JOIN sakila.category c ON c.category_id = fc.category_id
  	JOIN sakila.film f ON f.film_id = fc.film_id
  	WHERE c.name='Sci-fi';

#10 Customers and how many movies they rented from us so far?

  	SELECT c.first_name, r.customer_id, count(*) 
  	FROM sakila.rental r
  	JOIN sakila.customer c ON c.customer_id = r.customer_id
  	GROUP BY customer_id

#11 Which movies should we discontinue from our catalogue (<=1 lifetime rental)

  	SELECT r.inventory_id, i.film_id, f.title, count(*) 
  	FROM sakila.rental r
  	JOIN sakila.inventory i ON i.inventory_id = r.inventory_id
  	JOIN sakila.film f ON f.film_id = i.film_id
  	GROUP BY inventory_id
  	HAVING count(*)<=1
  	ORDER BY count(*)
  
	  #OR

  	WITH low_rentals AS
  	(SELECT rental.inventory_id, count(*) 
  	FROM sakila.rental
  	GROUP BY inventory_id
  	HAVING count(*)<=1)
  
  	SELECT f.film_id, f.title, ls.inventory_id 	
  	FROM low_rentals ls
  	JOIN sakila.inventory i ON i.inventory_id = ls.inventory_id
  	join sakila.film f on f.film_id = i.film_id

#12. Which movies are not returned yet?

  	SELECT f.title, r.return_date 
  	FROM sakila.rental r
  	JOIN sakila.inventory i ON i.inventory_id = r.inventory_id
  	JOIN sakila.film f ON f.film_id = i.film_id
  	WHERE r.return_date is null

#13 How much money and rentals we make for store 1 by day?

  	SELECT DATE(rental_date) AS DATE, SUM(p.amount) AS EARNING, COUNT(r.rental_id) AS TOTAL_RENT
  	FROM sakila.rental r
  	JOIN sakila.payment p ON p.payment_id = r.rental_id
  	JOIN sakila.inventory i ON i.inventory_id = r.inventory_id
  	WHERE i.store_id = 1
  	GROUP BY DATE(rental_date)
  	ORDER BY DATE(rental_date)

#14 What are top 3 earning days so far?

  	SELECT DATE(rental_date) AS DATE, SUM(p.amount) AS EARNING, COUNT(r.rental_id) AS TOTAL_RENT 
    FROM sakila.rental r
  	JOIN sakila.payment p ON p.payment_id = r.rental_id
  	GROUP BY DATE(rental_date)
  	ORDER BY SUM(p.amount) DESC
  	LIMIT 3;
