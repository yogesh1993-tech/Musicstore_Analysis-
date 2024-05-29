/* QUESTIONS Set 1 ( EASY) */

/*Q1: Who is the senior most employee based on job title?  */

select * from employee;

select first_name , last_name , title , levels from employee order by levels desc limit 1; 


 /* Q2: Which countries have the most Invoices? */
 
 select *from invoice;
 select *from invoice_line;
 
 select billing_country as country , count(*)  as invoice from invoice group by country order by invoice desc ; 
 
 /* Q3: What are top 3 values of total invoice?  */ 

select round(total) as top_value from invoice order by top_value desc limit 3;

/*Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals. */

select *from invoice; 

select billing_country, round(sum(total)) as invoice_total from invoice group by billing_country order by  invoice_total desc limit 1 ; 

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
select * from customer; 
select *from invoice; 

select customer.first_name,customer.last_name, round(sum(invoice.total)) as Total_spending from customer join invoice on customer.customer_id = invoice.customer_id group by 
customer.customer_id,customer.first_name,customer.last_name order by Total_spending desc limit 1; 


/* QUESTION Set 2 - Moderate */ 


/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */ 

select  * from genre; 
select * from playlist;
select * from invoice; 
select * from customer; 	

select customer.first_name, customer.last_name,customer.email,genre.name from customer 
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
order by customer.email; 

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select  * from genre; 
select * from playlist;
select * from invoice; 
select * from customer; 
select * from artist; 
select * from album2; 
select*from playlist_track;

select artist.name as artist_name,count(track.track_id) as Total_Track from artist 
join album2 on artist.artist_id = album2.album_id
join track on track.album_id = album2.album_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist_name
order by Total_Track DESC
LIMIT 10;   

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */ 


select  * from genre; 
select * from playlist;
select * from invoice; 
select * from customer; 
select * from artist; 
select * from album2; 
select*from playlist_track;
select * from track; 

select track.name as Track_name ,milliseconds from track where milliseconds > (select avg(milliseconds) from track) order by milliseconds desc; 


/* QUESTION  Set 3 - Advance */



/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
select  * from genre; 
select * from playlist;
select * from invoice; 
select * from customer; 
select * from artist; 
select * from album2; 
select*from playlist_track;
select * from track;

WITH most_popular_genre AS (
SELECT customer.country AS Country, COUNT(invoice_line.quantity) AS Purchases, 
genre.genre_id AS Genre_ID, genre.name AS Genre_Name, 
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS Row_No 
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
GROUP BY Country, genre. genre_id, genre. name
ORDER BY Country, Purchases DESC
)
SELECT Country, Purchases, Genre_id, Genre_Name
FROM most_popular_genre WHERE Row_No <= 1;



/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */


WITH Customter_with_country AS 
(
SELECT customer.customer_id, customer.first_name, customer.last_name, 
invoice.billing_country AS Country, ROUND(SUM(invoice.total),2) AS total_spent,
ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY SUM(invoice.total) DESC) AS Row_No 
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
GROUP BY 1,2,3,4
ORDER BY 4,5 DESC
)
SELECT customer_id, first_name, last_name, Country, total_spent 
FROM Customter_with_country 
WHERE Row_No <= 1;



