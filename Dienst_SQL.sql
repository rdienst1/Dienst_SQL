use sakila;

-- 1a Display the first and last names of all actors from the table actor
SELECT first_name, last_name
FROM actor;

-- 1b Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT
	first_name,
    last_name, 
    CONCAT(first_name,' ',last_name) as ActorName 
FROM actor;

-- 2a Query Joe
SELECT first_name, last_name, actor_ID
FROM actor
WHERE first_name ='JOE'

-- 2b Query Gen
;SELECT first_name, last_name
FROM actor
WHERE first_name LIKE '%GEN%'


-- 2c Query Li
;SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'


-- 2d Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
;SELECT country_id, country 
FROM country
WHERE country IN ('Afghanistan','Banglasdesh','China')

-- 3a You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
;ALTER TABLE actor
ADD COLUMN description VARBINARY(200); 

-- 3b Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column
ALTER TABLE actor
DROP COLUMN description;

-- 4a List the last names of actors, as well as how many actors have that last name
;SELECT last_name,
COUNT(actor_id)
FROM actor
GROUP BY last_name
ORDER BY last_name

-- 4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
;SELECT last_name,
COUNT(actor_id)
FROM actor
GROUP BY last_name
HAVING COUNT(actor_id) > '1'
ORDER BY last_name

;SELECT * FROM actor
ORDER BY first_name;

-- 4c The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record
;UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" and last_name = "WILLIAMS"
ORDER BY first_name

;SELECT * FROM actor
ORDER BY first_name

-- 4d Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO
;UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS"

-- 5a You cannot locate the schema of the address table. Which query would you use to re-create it?
;SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE table_name = "address";

-- 6a Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff INNER JOIN address ON address.address_id = staff.address_id;

-- 6b Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
SELECT st.staff_id, first_name, last_name,
format(sum(amount), 2) AS Total
FROM staff st INNER JOIN payment pm ON st.staff_id = pm.staff_id
WHERE payment_date BETWEEN '2005-08-01% 00:00:00' AND '2005-08-31 11:59:59'
GROUP BY 
    st.staff_id,
    first_name,
    last_name
;

-- 6c List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT * FROM staff;
SELECT fl.title,
COUNT(act.actor_id) AS NumberActors
FROM film fl INNER JOIN film_actor act ON fl.film_id = act.film_id
GROUP BY fl.title;

-- 6d How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT fl.title,
COUNT(fl.film_id) AS TotalCopies FROM
film fl INNER JOIN inventory inv ON fl.film_id = inv.film_id
WHERE fl.title = 'Hunchback Impossible'
GROUP BY fl.title;

-- 6e Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name: 
SELECT last_name, first_name,
sum(amount) AS 'Total Paid'
FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY last_name, first_name
ORDER BY last_name, first_name
;
  
-- 7a The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE (title LIKE 'k%' OR title LIKE 'q%')
AND language_id = (SELECT language_id FROM language WHERE name = 'english')
ORDER BY title
;

-- 7b Use subqueries to display all actors who appear in the film Alone Trip

SELECT first_name, last_name
FROM actor WHERE actor_id IN 
    
    (SELECT DISTINCT
        film_actor.actor_id
        FROM film_actor INNER JOIN film ON film_actor.film_id = film.film_id
        WHERE film.title = 'Alone Trip'
        );

-- 7c You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT
    cust.first_name,
    cust.last_name,
    cust.email,
    country.country
FROM
    customer cust INNER JOIN address ad ON cust.address_id = ad.address_id
    INNER JOIN city ON ad.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
    
WHERE
    country.country = 'Canada'

;

-- 7d Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films
SELECT film.title AS 'Film Title', category.name AS Category
FROM film INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family'
; 

-- 7e Display the most frequently rented movies in descending order
SELECT 
    film.title,
    COUNT(rental.inventory_id) AS 'Rent Count'
 
FROM 
    rental INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN film ON inventory.film_id = film.film_id
    
GROUP BY film.title

ORDER BY 
     COUNT(rental.inventory_id) DESC;
-- 7f Write a query to display how much business, in dollars, each store brought in

SELECT store.store_id,
format(sum(amount), 2) AS Total
FROM payment pay 
INNER JOIN staff ON pay.staff_id = staff.staff_id
INNER JOIN store ON staff.store_id = store.store_id
GROUP BY store.store_id;

SELECT SUM(amount) FROM payment;

-- 7g Write a query to display for each store its store ID, city, and country
SELECT  
    store.store_id,
    city.city,
    country.country
    
FROM
    store INNER JOIN address ON store.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id;

-- 7h List the top five genres in gross revenue in descending order. 
SELECT * FROM film_category   
 ;       
use sakila;

SELECT 
    category.name,
    format(sum(payment.amount), 2) AS Total

FROM film_category INNER JOIN category ON film_category.category_id = category.category_id
    INNER JOIN inventory ON inventory.film_id = film_category.category_id
    INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id

GROUP BY 
      category.name
      
ORDER BY
    SUM(payment.amount) DESC
    
LIMIT 5;

-- 8a In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_Genres AS     
SELECT 
    category.name,
    format(sum(amount), 2) AS Total

FROM film_category INNER JOIN category ON film_category.category_id = category.category_id
    INNER JOIN inventory ON inventory.film_id = film_category.category_id
    INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id

GROUP BY 
      category.name  
ORDER BY
    SUM(payment.amount) DESC
LIMIT 5;

-- 8b How would you display the view that you created in 8a?
SELECT * FROM top_genres;

-- 8c You find that you no longer need the view top_five_genres. Write a query to delete it
DROP VIEW top_genres;