use sakila;

#1-How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT 
    COUNT(inventory_id) AS copies
FROM
    inventory
WHERE
    film_id = (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible')
;

#2-List all films whose length is longer than the average of all the films.

SELECT 
    film_id,title
FROM
    film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            film);

#3-Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));
;

#4-Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT 
    film_id, title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id = (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'family'))
ORDER BY film_id
;



#5-Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT 
    first_name, last_name, email
FROM
    customer
WHERE
    customer_id IN (SELECT 
            A.customer_id
        FROM
            customer A
                JOIN
            address USING (address_id)
                JOIN
            city USING (city_id)
                JOIN
            country D USING (country_id)
        WHERE
            country = 'Canada')
;

#6-Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_actor
        WHERE
            actor_id = (SELECT 
                    A.actor_id
                FROM
                    actor A
                        JOIN
                    film_actor B USING (actor_id)
                GROUP BY A.actor_id
                ORDER BY COUNT(B.film_id) DESC
                LIMIT 1))
;


#7-Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            inventory A
                JOIN
            rental B USING (inventory_id)
        WHERE
            B.customer_id = (SELECT 
                    customer_id
                FROM
                    payment
                GROUP BY customer_id
                ORDER BY SUM(amount) DESC
                LIMIT 1))
;

#8-Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.

SELECT 
    customer_id AS client_id, total AS total_amount_spent
FROM
    (SELECT 
        customer_id, SUM(amount) AS total
    FROM
        payment
    GROUP BY customer_id) AS avg_total
WHERE
    total > (SELECT 
            AVG(total) AS average
        FROM
            (SELECT 
                customer_id, SUM(amount) AS total
            FROM
                payment
            GROUP BY customer_id) AS avg_total)
ORDER BY total DESC
;



