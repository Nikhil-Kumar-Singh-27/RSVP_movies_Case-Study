USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT  table_name,
	    table_rows
FROM  information_schema.tables
WHERE  table_schema = 'imdb' ;





-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS ID_nulls,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           end) AS title_nulls,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           end) AS year_nulls,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           end) AS date_published_nulls,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           end) AS duration_nulls,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           end) AS country_nulls,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           end) AS worlwide_gross_income_nulls,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           end) AS languages_nulls,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           end) AS production_company_nulls
FROM   movie; 


-- 'COUNTRY', 'WORLDWIDE GROSS INCOME', 'LANGUAGES', 'PRODUCTION COMPANY' COLUMNS ARE HAVING NULL VALUES IN MOVIE TABLE.


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- TOTAL NUMBER OF MOVIES RELEASED EACH YEAR.

SELECT  year,
		COUNT(id) AS number_of_movies
FROM  movie
GROUP BY year ;



-- TOTAL NUMBER OF MOVIES RELEASED EACH MONTH.

SELECT  MONTH(date_published) AS month_num, 
		COUNT(id) AS number_of_movies
FROM  movie
GROUP BY  month_num 
ORDER BY  month_num ;

/* WE CAN GET IN WHICH MONTH HIGHEST NUMBER OF MOVIES IS PRODUCED BY ORDER IT WITH COUNT(ID) IN DESCENDING BUT I HAVE NOT DONE IT BECAUSE THE 
OUTPUT FORMAT IS GIVEN LIKE THIS.*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(id) AS Number_of_movies,
	   year
FROM  movie
WHERE  country = 'USA'  OR  country = 'India'
GROUP BY  country 
HAVING YEAR = 2019 ;

-- USA & INDIA PRODUCED 1007 MOVIES IN YEAR 2019.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre ;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       COUNT(movie_id) AS Number_of_movies
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY number_of_movies DESC
LIMIT  1; 

-- GENRE 'DRAMA' WITH '4285' NUMBER OF MOVIES PRODUCED IS HIGHEST.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre
     AS (SELECT movie_id,
                COUNT(genre) AS No_of_genre
         FROM   genre
         GROUP  BY movie_id
         HAVING No_of_genre = 1)

SELECT COUNT(movie_id) AS 'No of movies with one genre'
FROM   one_genre ; 

-- THERE ARE TOTAL '3289' NO OF MOVIES WHICH BELONGS TO ONLY ONE GENRE.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       ROUND(AVG(duration), 2) AS avg_duration
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY avg_duration DESC ; 

-- ACTION GENRE MOVIES HAVE LONGER AVERAGE DURATION AS COMPARED TO OTHER'S GENRE.


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_info
     AS (SELECT genre,
                COUNT(movie_id)                        AS movie_count,
                RANK()
                  OVER( ORDER BY COUNT(movie_id) DESC ) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_info
WHERE  genre = 'Thriller'; 

-- MOVIE COUNT OF THRILLER IS '1484' & IS RANKED '3rd' BASED ON MOVIE COUNT.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating)    AS min_avg_rating,
       MAX(avg_rating)    AS max_avg_rating,
       MIN(total_votes)   AS min_total_votes,
       MAX(total_votes)   AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM   ratings; 



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_rating
     AS (SELECT title,
                avg_rating,
                RANK()
                  OVER( ORDER BY avg_rating DESC ) AS movie_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id)
SELECT *
FROM   movie_rating
WHERE  movie_rank <= 10; 


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   ratings
GROUP BY  median_rating
ORDER BY  median_rating; 

-- WE CAN ORDER IT BY 'MOVIE COUNT' TO GET HIGHEST MEDIAN RATING.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_rank
     AS (SELECT production_company,
                COUNT(id)                    AS movie_count,
                RANK()
                  OVER( ORDER BY COUNT(id) DESC ) AS prod_company_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_rank
WHERE  prod_company_rank = 1; 

-- DREAM WARRIOR PICTURES & NATIONAL THEATRE LIVE ARE BOTH RANKED AS TOP PRODUCTION HOUSE.


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       COUNT(id) AS movie_count
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  Month(date_published) = 3
       AND year = 2017
       AND country = 'USA'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

-- DRAMA GENRE HAS THE MOST NUMBER OF MOVIES RELEASED IN 'MARCH 2017' IN 'USA' HAVING 'TOTAL VOTES MORE THAN 1000'.


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  title REGEXP '^The'
       AND avg_rating > 8
ORDER  BY avg_rating DESC; 

-- 'THE BRIGHTON MIRACLE' WHOSE GENRE IS 'DRAMA' HAS THE HIGHEST AVERAGE RATING '9.5' AMONG ALL THE MOVIES STARTING WITH THE WORD 'THE'. 


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
       COUNT(id) AS movie_count
FROM   ratings AS r
       INNER JOIN movie AS m
               ON r.movie_id = m.id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND median_rating = 8
GROUP  BY median_rating; 

-- TOTAL '361' MOVIES WERE RELEASED BETWEEN '1 APRIL 2018' AND '1 APRIL 2019' WITH MEDIAN RATING OF '8'.


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT languages,
       total_votes
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  languages IN ( 'German', 'Italian' )
GROUP  BY languages
ORDER  BY total_votes DESC; 

-- Answer is Yes

-- 'GERMAN' MOVIES GETS MORE VOTES THAN 'ITALIAN' MOVIES.


/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 

-- EXCEPT 'NAME' COLUMN ALL COLUMNS ARE HAVING NULL VALUES.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre
AS
  (
             SELECT     genre,
                        COUNT(g.movie_id) AS movie_count
             FROM       genre             AS g
             INNER JOIN ratings           AS r
             ON         g.movie_id = r.movie_id
             WHERE      avg_rating > 8
             GROUP BY   genre
             ORDER BY   movie_count DESC
             LIMIT      3 ) ,
  top_directors
AS
  (
             SELECT     name                                         AS director_name,
                        COUNT(g.movie_id)                            AS movie_count,
                        RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS director_rank
             FROM       names                                        AS n
             INNER JOIN director_mapping                             AS dm
             ON         n.id = dm.name_id
             INNER JOIN genre AS g
             ON         dm.movie_id = g.movie_id
             INNER JOIN ratings AS r
             ON         r.movie_id = g.movie_id,
                        top_3_genre
             WHERE      avg_rating > 8
             AND        g.genre IN (top_3_genre.genre)
             GROUP BY   director_name )
  SELECT director_name,
         movie_count,
         director_rank
  FROM   top_directors
  WHERE  director_rank <= 3 ;
  
-- HERE I HAVE NOT USED THE 'LIMIT' CLAUSE AS IT WILL ONLY GIVE A SPECIFIC NUMBER OF OUTPUT IRRESPECTIVE OF MOVIE COUNT.


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name             AS actor_name,
       COUNT(rm.movie_id) AS movie_count
FROM   names AS n
       INNER JOIN role_mapping AS rm
               ON n.id = rm.name_id
       INNER JOIN ratings AS r
               ON rm.movie_id = r.movie_id
WHERE  median_rating >= 8
       AND category = 'actor'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 

-- 'MAMMOOTTY' & 'MOHANLAL' ARE THE TOP TWO ACTOR's w.r.t. 'MOVIE COUNT' WHOSE MOVIE's HAVE A MEDIAN RATING GREATER THAN OR EQUAL TO 8.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           SUM(total_votes)                            AS vote_count,
           RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM       movie                                       AS m
INNER JOIN ratings                                     AS r
ON         m.id = r.movie_id
GROUP BY   production_company 
LIMIT 3 ;

-- 'MARVEL STUDIOS', 'TWENTIETH CENTURY FOX' & 'WARNER BROS.' ARE TOP 3 PRODUCTION HOUSES BASED ON NUMBER OF VOTES RECEIVED BY THERE MOVIE's.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     name                                                                                                       AS actor_name,
           SUM(total_votes)                                                                                           AS total_votes,
           COUNT(m.id)                                                                                                AS movie_count,
           ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2)                                                      AS actor_avg_rating,
           RANK() OVER(ORDER BY ROUND(SUM(total_votes * avg_rating)/SUM(total_votes), 2) DESC, SUM(total_votes) DESC) AS actor_rank
FROM       movie                                                                                                      AS m
INNER JOIN ratings                                                                                                    AS r
ON         m.id = r.movie_id
INNER JOIN role_mapping AS rm
ON         m.id=rm.movie_id
INNER JOIN names AS n
ON         rm.name_id=n.id
WHERE      category = 'actor'
AND        country = 'India'
GROUP BY   actor_name
HAVING     movie_count >= 5 ;

-- Top actor is Vijay Sethupathi

/* ACTOR's RANK ACCORDING TO THERE 'AVERAGE RATING' HAVING MOVIE COUNT GREATER THAN OR EQUAL TO '5' ARE HERE WITH 'VIJAY SETHUPATHI' TOPPING
 THE LIST FOLLOWED BY 'FAHADH FAASIL' AND MANY MORE. */


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     name                                                                                                       AS actress_name,
           SUM(total_votes)                                                                                           AS total_votes,
           COUNT(m.id)                                                                                                AS movie_count,
           ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2)                                                      AS actress_avg_rating,
           RANK() OVER(ORDER BY ROUND(SUM(total_votes * avg_rating)/SUM(total_votes), 2) DESC, SUM(total_votes) DESC) AS actress_rank
FROM       movie                                                                                                      AS m
INNER JOIN ratings                                                                                                    AS r
ON         m.id = r.movie_id
INNER JOIN role_mapping AS rm
ON         m.id=rm.movie_id
INNER JOIN names AS n
ON         rm.name_id=n.id
WHERE      category = 'actress'
AND        country = 'India'
AND        languages = 'Hindi'
GROUP BY   actress_name
HAVING     movie_count >= 3 ;

/* ACTRESS's RANK ACCORDING TO THERE 'AVERAGE RATING' HAVING MOVIE COUNT GREATER THAN OR EQUAL TO '3' ARE HERE WITH 'TAAPSEE PANNU' TOPPING
 THE LIST FOLLOWED BY 'DIVYA DUTTA', 'KRITI KHARBANDA' AND 'SONAKSHI SINHA'. */


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title AS movie_title,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       end   AS movie_category
FROM   ratings AS r
       INNER JOIN movie AS m
               ON r.movie_id = m.id
       INNER JOIN genre AS g
               ON m.id = g.movie_id
WHERE  genre = 'Thriller'; 

-- IF WE WANT WE CAN ORDERED IT BY 'TITLE' TO GET THE OUTPUT IN ALPHABETICAL ORDER.


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT     genre,
           ROUND(AVG(duration),2)              AS avg_duration,
           SUM(ROUND(AVG(duration),2)) OVER w1 AS running_total_duration,
           AVG(ROUND(AVG(duration),2)) OVER w2 AS moving_avg_duration
FROM       movie                               AS m
INNER JOIN genre                               AS g
ON         m.id = g.movie_id
GROUP BY   genre 
WINDOW w1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING),
	   w2 AS (ORDER BY genre ROWS 10 PRECEDING)
ORDER BY   genre ;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genre
AS
  (
             SELECT     genre,
                        COUNT(movie_id) AS no_of_movies
             FROM       genre           AS g
             INNER JOIN movie           AS m
             ON         g.movie_id = m.id
             GROUP BY   genre
             ORDER BY   no_of_movies DESC
             LIMIT      3 ),
  top_5_movies
AS
  (
             SELECT     genre,
                        year ,
                        title AS movie_name,
                        worlwide_gross_income,
                        DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC ) AS movie_rank
             FROM       movie                                                                     AS m
             INNER JOIN genre                                                                     AS g
             ON         m.id = g.movie_id
             WHERE      genre IN
                        (
                               SELECT genre
                               FROM   top_3_genre ) )
  SELECT *
  FROM   top_5_movies
  WHERE  movie_rank <= 5 ;

/* MOVIE NAME 'SHATAMANAM BHAVATI' WHOSE GENRE IS 'DRAMA' IS HIGHEST GROSSING MOVIE OF YEAR '2017' FOLLOWED BY OTHER's.
MOVIE NAME 'THE VILLAIN' WHOSE GENRE IS 'THRILLER' IS HIGHEST GROSSING MOVIE OF YEAR '2018' FOLLOWED BY OTHER's.
MOVIE NAME 'PRESCIENCE' WHOSE GENRE IS 'THRILLER' IS HIGHEST GROSSING MOVIE OF YEAR '2019' FOLLOWED BY OTHER's.*/


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_info
     AS (SELECT production_company,
                COUNT(id)                         AS movie_count,
                RANK()
                  OVER( ORDER BY COUNT(id) DESC ) AS prod_comp_rank
         FROM   movie AS m
                inner join ratings AS r
                        ON m.id = r.movie_id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND POSITION(',' IN languages) > 0
         GROUP  BY production_company)
SELECT *
FROM   production_info
WHERE  prod_comp_rank <= 2; 

/* 'STAR CINEMA' & 'TWENTIETH CENTURY FOX' ARE THE TOP TWO PRODUCTION HOUSE's THAT HAS PRODUCED HIGHEST NUMBER OF HITS HAVING
MEDIAN RATING MORE THAN OR EQUAL TO 8 AMONG MULTILINGUAL MOVIES.*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actress
     AS (SELECT NAME                                                       AS
                actress_name,
                SUM(total_votes)                                           AS
                   total_votes,
                COUNT(r.movie_id)                                          AS
                   movie_count,
                ROUND(SUM(total_votes * avg_rating) / SUM(total_votes), 2) AS
                   actress_avg_rating,
                RANK()
                  OVER(
                    ORDER BY COUNT(r.movie_id) DESC)                       AS
                   actress_rank
         FROM   names AS n
                INNER JOIN role_mapping AS rm
                        ON n.id = rm.name_id
                INNER JOIN genre AS g
                        ON rm.movie_id = g.movie_id
                INNER JOIN ratings AS r
                        ON rm.movie_id = r.movie_id
         WHERE  category = 'actress'
                AND genre = 'Drama'
                AND avg_rating > 8
         GROUP  BY actress_name)
SELECT *
FROM   top_actress
WHERE  actress_rank <= 3; 

-- HERE I HAVE NOT USED THE 'LIMIT' CLAUSE AS IT WILL ONLY GIVE A SPECIFIC NUMBER OF OUTPUT IRRESPECTIVE OF ACTRESS AVERAGE RATING.
 

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_information
     AS (SELECT dm.name_id,
                n.NAME,
                dm.movie_id,
                r.avg_rating,
                r.total_votes,
                m.duration,
                date_published,
                LAG(date_published, 1)
                  OVER(
                    PARTITION BY dm.name_id
                    ORDER BY date_published) AS previous_date_published
         FROM   names n
                INNER JOIN director_mapping dm
                        ON n.id = dm.name_id
                INNER JOIN movie m
                        ON dm.movie_id = m.id
                INNER JOIN ratings r
                        ON m.id = r.movie_id),
     
     -- RANKING DIRECTOR's BASED ON NUMBER OF MOVIES
     
     top_directors
     AS (SELECT name_id                                                       AS
                director_id,
                NAME                                                          AS
                   director_name,
                COUNT(movie_id)                                               AS
                   number_of_movies,
                ROUND(AVG(DATEDIFF(date_published, previous_date_published))) AS
                avg_inter_movie_days,
                ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2)    AS
                   avg_rating,
                SUM(total_votes)                                              AS
                   total_votes,
                ROUND(MIN(avg_rating), 1)                                     AS
                   min_rating,
                ROUND(MAX(avg_rating), 1)                                     AS
                   max_rating,
                SUM(duration)                                                 AS
                   total_duration,
                RANK()
                  OVER(
                    ORDER BY COUNT(movie_id) DESC)                            AS
                   director_rank
         FROM   director_information
         GROUP  BY director_id)

-- TOP 9 DIRECTOR's ARE :-

SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   top_directors
WHERE  director_rank <= 9; 

-- ALL THE DETAILS REQUIRED AS PER QUESTION IS GIVEN OF TOP 9 DIRECTORS AS PER NUMBER OF MOVIES.


