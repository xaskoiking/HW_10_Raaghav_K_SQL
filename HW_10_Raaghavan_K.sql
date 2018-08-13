use sakila;
#1a. Display the first and last names of all actors from the table actor

SELECT 
    first_name, last_name
FROM
    sakila.actor;
    
#1b. Display the first and last name of each actor in a single column in upper case letters.
#Name the column Actor Name.

SELECT 
    CONCAT(first_name, ', ', last_name) AS 'Actor Name'
FROM
    sakila.actor;
    
#2a. You need to find the ID number, first name, and last name of an actor, 
# of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?

SELECT 
    first_name, last_name, actor_id
FROM
    sakila.actor
WHERE
    first_name = 'Joe';
    
#2b. Find all actors whose last name contain the letters GEN:

SELECT 
    first_name, last_name, actor_id
FROM
    sakila.actor
WHERE
    UPPER(last_name) like '%GEN%';

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:

SELECT 
    first_name, last_name
FROM
    sakila.actor
WHERE
    UPPER(last_name) LIKE '%LI%'
ORDER BY first_name , last_name;

#2d. Using IN, display the country_id and country columns of the following countries: 
# Afghanistan, Bangladesh, and China:

SELECT 
    country_id, country
FROM
    sakila.country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
    
#3a. You want to keep a description of each actor. 
#You don't think you will be performing queries on a description, 
#so create a column in the table actor named description and 
#use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_name;

SELECT 
    *
FROM
    sakila.actor;
    
#3b. Very quickly you realize that entering descriptions for each actor is too much effort.
# Delete the description column.

		ALTER TABLE actor
		drop column description;

		SELECT 
			*
		FROM
			sakila.actor;

#4a. List the last names of actors, as well as how many actors have that last name.

SELECT 
    last_name, COUNT(*) AS lastNameCount
FROM
    sakila.actor
GROUP BY 1
ORDER BY lastNameCount DESC;

#4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors

SELECT 
    last_name, COUNT(*) AS lastNameCount
FROM
    sakila.actor
GROUP BY 1
having lastNameCount > 1
ORDER BY lastNameCount DESC;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
#Write a query to fix the record.
#PRE UPDATE#
SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'GROUCHO'
	AND last_name = 'WILLIAMS';

#UPDATE#
UPDATE sakila.actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
	AND last_name = 'WILLIAMS';

#POST UPDATE#
SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'HARPO'
	AND last_name = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO, 
#change it to GROUCHO.

#PRE UPDATE#
SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'HARPO'
	AND last_name = 'WILLIAMS';

#UPDATE#
UPDATE sakila.actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO'
	AND last_name = 'WILLIAMS';

#POST UPDATE#
SELECT 
    *
FROM
    sakila.actor
WHERE
    first_name = 'GROUCHO'
	AND last_name = 'WILLIAMS';
    
#5a. You cannot locate the schema of the address table. 
#Which query would you use to re-create it?

SHOW CREATE TABLE sakila.address;

#6a. Use JOIN to display the first and last names, 
#as well as the address, of each staff member. 
#Use the tables staff and address:

SELECT 
    a.first_name, a.last_name, b.address
FROM
    sakila.staff a
        JOIN
    sakila.address b ON a.address_id = b.address_id;
    
#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
#Use tables staff and payment.

SELECT 
    a.first_name, a.last_name, sum(b.amount) as amount
FROM
    sakila.staff a
        LEFT JOIN
    sakila.payment b ON a.staff_id = b.staff_id
    where b.payment_date >= '2005-08-01'
    and b.payment_date < '2005-09-02'
group by 1,2;

#6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.

SELECT 
    a.title, COUNT(b.actor_id) AS actorsCount
FROM
    sakila.film a
        INNER JOIN
    sakila.film_actor b ON a.film_id = b.film_id
GROUP BY 1;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT 
    a.title, count(b.inventory_id) as inventoryCount
FROM
    sakila.film a
        LEFT JOIN
    sakila.inventory b ON a.film_id = b.film_id
    group by 1;
    
#6e. Using the tables payment and customer and the JOIN command, 
#list the total paid by each customer. 
#List the customers alphabetically by last name:
SELECT 
    a.first_name, a.last_name, sum(b.amount) as amountPaid
FROM
    sakila.customer a
        INNER JOIN
    sakila.payment b ON a.customer_id = b.customer_id
    group by 1,2
    order by 2;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q 
#have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the 
#letters K and Q whose language is English.
SELECT 
    title
FROM
    sakila.film
WHERE
    title LIKE 'Q%'
        OR title LIKE 'R%'
        AND language_id = (SELECT 
            language_id
        FROM
            sakila.language
        WHERE
            name = 'English');

#7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
    b.first_name, b.last_name
FROM
    sakila.film_actor a,
    sakila.actor b
WHERE
    a.actor_id = b.actor_id
        AND a.film_id = (SELECT 
            film_id
        FROM
            sakila.film
        WHERE
            title = 'Alone Trip');


#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.

SELECT 
    a.first_name, 
    a.last_name, 
    a.email, 
    d.country
FROM
    sakila.customer a
        JOIN
    sakila.address b 
    ON a.address_id = b.address_id
		LEFT JOIN
	sakila.city c
    ON b.city_id = c.city_id
		LEFT JOIN
	sakila.country d
    on c.country_id = d.country_id
    WHERE d.country = 'Canada';
  
#7d. Sales have been lagging among young families, 
#and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.


SELECT 
    a.title, c.name
FROM
    sakila.film a
        JOIN
    sakila.film_category b ON a.film_id = b.film_id
        JOIN
    sakila.category c ON c.category_id = b.category_id
        AND c.name = 'family';
        
#7e. Display the most frequently rented movies in descending order.

SELECT 
    a.title, 
    a.film_id, 
    count(distinct c.rental_id) as frequency_Count
FROM
    sakila.film a,
    sakila.inventory b,
    sakila.rental c
WHERE
    a.film_id = b.film_id
    and b.inventory_id = c.inventory_id
    group by 1,2
    order by frequency_Count desc;

#7f. Write a query to display how much business, in dollars, each store brought in.

SELECT 
    a.store_id,
    sum(d.amount) as totalAmount
FROM
    sakila.store a,
    sakila.inventory b,
    sakila.rental c,
    sakila.payment d
WHERE
    a.store_id = b.store_id
    and b.inventory_id = c.inventory_id
    and c.rental_id = d.rental_id
    group by 1;
    
#7g. Write a query to display for each store its store ID, city, and country.

SELECT 
    a.store_id, 
    c.city,
    d.country
FROM
    sakila.store a
        JOIN
    sakila.address b 
    ON a.address_id = b.address_id
		LEFT JOIN
	sakila.city c
    ON b.city_id = c.city_id
		LEFT JOIN
	sakila.country d
    on c.country_id = d.country_id;

#7h. List the top five genres in gross revenue in descending order.
# (Hint: you may need to use the following tables: 
#category, film_category, inventory, payment, and rental.)

SELECT
    c.name, sum(f.amount)
FROM
    sakila.film a,
    sakila.film_category b,
    sakila.category c,
    sakila.inventory d,
    sakila.rental e,
    sakila.payment f
WHERE
    a.film_id = b.film_id
   and  c.category_id = b.category_id
   and  a.film_id = d.film_id
   and  d.inventory_id = e.inventory_id
   and  e.rental_id = f.rental_id
   group by 1
   order by sum(f.amount) desc
   limit 5;
   
#8a. In your new role as an executive, 
#you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. 
#If you haven't solved 7h, you can substitute another query to create a view.

create view sakila.top5Genres as
SELECT
    c.name, sum(f.amount)
FROM
    sakila.film a,
    sakila.film_category b,
    sakila.category c,
    sakila.inventory d,
    sakila.rental e,
    sakila.payment f
WHERE
    a.film_id = b.film_id
   and  c.category_id = b.category_id
   and  a.film_id = d.film_id
   and  d.inventory_id = e.inventory_id
   and  e.rental_id = f.rental_id
   group by 1
   order by sum(f.amount) desc
   limit 5;
  
#8b. How would you display the view that you created in 8a?
SELECT * FROM sakila.top5genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view sakila.top5genres;
