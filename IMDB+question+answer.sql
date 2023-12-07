USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(*) AS NO_OF_ROWS_IN_DIRECTOR_MAPPING
		FROM director_mapping; -- rows in director_mapping

SELECT count(*) AS NO_OF_ROWS_IN_GENRE
		FROM genre;  -- rows in genre

SELECT count(*) AS NO_OF_ROWS_IN_MOVIE
		FROM movie;  -- rows in movie

SELECT count(*) AS NO_OF_ROWS_IN_NAMES
		FROM names ;  -- rows in names

SELECT count(*) AS NO_OF_ROWS_IN_RATINGS
		FROM ratings;  -- rows in ratings

SELECT count(*) AS NO_OF_ROWS_IN_ROLE_MAPPING
		FROM role_mapping;  -- rows in role_mapping
/*
 findings : 
 -- total rows in table director_mapping : 3867
-- total rows in genre 					 : 14662
-- total rows in table movie			 : 7997
-- total rows in table names 			 : 25735
-- total rows in table ratings			 : 7997
-- total rows in table role_mapping 	 : 15615 
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT Sum(
			CASE
			WHEN id IS NULL THEN 1
			ELSE 0
            END) AS id_NULL_COUNT,
       Sum(
			CASE
			WHEN title IS NULL THEN 1
			ELSE 0
			END) AS title_NULL_COUNT,
       Sum(
			CASE
			WHEN year IS NULL THEN 1
			ELSE 0
            END) AS year_NULL_COUNT,
       Sum(
			CASE
			WHEN date_published IS NULL THEN 1
			ELSE 0
            END) AS date_published_NULL_COUNT,
       Sum(
			CASE
			WHEN duration IS NULL THEN 1
			ELSE 0
			END) AS duration_NULL_COUNT,
       Sum(
			CASE
			WHEN country IS NULL THEN 1
			ELSE 0
			END) AS country_NULL_COUNT,
       Sum(
			CASE
			WHEN worlwide_gross_income IS NULL THEN 1
			ELSE 0
			END) AS worlwide_gross_income_NULL_COUNT,
       Sum(
			CASE
			WHEN languages IS NULL THEN 1
			ELSE 0
			END) AS languages_NULL_COUNT,
       Sum(
			CASE
            WHEN production_company IS NULL THEN 1
            ELSE 0
            END) AS production_company_NULL_COUNT
FROM   movie; 
/*
 findings : 
-- when count(*) > count(column_name) it means that respective columns have null values.
-- columns having null rows are 1.country
								2.worlwide_gross_income
								3.languages and
                                4.production_company
*/
        
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

-- FOR YEAR BASED CLASSIFICATION 
SELECT 
	year AS Year ,
    COUNT(id) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year ;

-- FOR MONTH BASED CLASSIFICATION
SELECT 
	MONTH(date_published) AS month_num ,
    COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num ;
/* 
findings  : 
-- Lowest number of movies were published in the year 2019(2001 movies).
-- Highest number of movies were published in the year 2017(3052 movies).
-- Lowest number of movies were published in the month of December(438 movies).
-- Highest number of movies were published in the month of March(824 movies).
-- Observed certain films with same names but with different publishing dates.
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
 -- Type your code below:

SELECT COUNT(id) AS TOTAL_NO_OF_MOVIES_PRODUCED
FROM movie
WHERE 
	(country  like '%USA%' OR
	country like '%India%')
	AND year= 2019;
    
/* finding  :
-- Total number of movies produced in the year 2019 by USA or India are 1059.
*/


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre 
FROM genre;

/* finding :
-- Different types of genre are Drama, fantasy, thriller,comedy, horror,
   family, romance, adventure, action, sc-fi, crime, mystery, others.
*/



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- CREATION OF VIEW HAVING ALL COLUMNS FROM MOVIE ALONG WITH ALL COLUMNS FROM GENRE
CREATE VIEW movie_along_genre AS
(
SELECT * 
FROM genre g
INNER JOIN movie m
ON g.movie_id = m.id
);
-- FINDING THE GENRE THAT HAD MAXIMUM NUMBER OF MOVIES IN ALL YEARS
SELECT 
		genre,
		count(id) AS number_of_movies
FROM  movie_along_genre 
GROUP BY genre 
ORDER BY number_of_movies DESC
 LIMIT 1; 
 
 

/* finding :
-- Highest number of movies were produced under the genre Drama (4285 movies)  in all years.
*/



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH only_one_genre_movies AS 
(
					SELECT 
							movie_id,
							count(GENRE) AS no_of_genre
					FROM movie_along_genre
					GROUP BY movie_id
                    HAVING no_of_genre = 1
					ORDER BY title
)
SELECT COUNT(movie_id) AS movies_with_one_genre_only
FROM only_one_genre_movies;

/* finding  :
-- Number of movies that have only one genre are 3289.
*/

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

SELECT 
		genre,
		ROUND(AVG(duration),2) AS avg_duration
FROM movie_along_genre
GROUP BY genre
ORDER BY avg_duration DESC; 

/* findings :
-- Highest average duration of movies is for Action genre having 112.88 minutes.
-- Lowest average duration of movies is for Horror genre having 92.72 minutes.
-- Average duration of movies in Drama genre is 106.77 minutes.
*/



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

WITH ranked_genres AS
( 
		SELECT 
				genre,
				count(id) AS movie_count,
				RANK() OVER W AS genre_rank
		FROM movie_along_genre
		GROUP BY genre 
		WINDOW W AS (ORDER BY count(id) DESC)
)
SELECT * 
FROM ranked_genres 
WHERE genre = 'Thriller';

/* finding :
The rank of thriller genre is 3 with 1484 movies.
*/


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

SELECT
	MIN(avg_rating) 	AS min_avg_rating ,
    MAX(avg_rating)	    AS max_avg_rating,
    MIN(total_votes) 	AS min_total_votes,
    MAX(total_votes) 	AS max_total_votes,
    MIN(median_rating)  AS min_median_rating ,
    MAX(median_rating)  AS max_median_rating
FROM RATINGS;


    

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

-- CREATION OF VIEW 
CREATE VIEW movie_along_with_rating AS 
					( SELECT * 
					  FROM 
							movie m 
							INNER JOIN ratings r 
							ON m.id = r.movie_id );
SELECT 
		title,
        avg_rating,
        DENSE_RANK() OVER W AS movie_rank
FROM movie_along_with_rating
WINDOW W AS (ORDER BY avg_rating DESC )
LIMIT 10;

/* finding :
-- movie 'Kirket' and 'Love in Kinerry'  has the highest avg_rating of 10
*/



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

SELECT 
		median_rating,
        COUNT(movie_id) AS movie_count	
FROM  ratings 
GROUP BY median_rating
ORDER BY movie_count DESC ;

/* findings : 
-- Movies with a median rating of 7 is highest in number(2257 movies).
-- 346 movies have median rank 0f 10
-- 94 movies have median rank of 1
*/



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

SELECT 
		DISTINCT production_company,
        count(id) AS movie_count,	
		DENSE_RANK() OVER(ORDER BY count(id) DESC) AS prod_company_rank
FROM movie_along_with_rating
WHERE 
		avg_rating > 8
        AND production_company IS NOT NULL
GROUP BY production_company
LIMIT 2 ;

/* finding :
-- Both Dream Warrior Pictures and National Theatre Live have made 3 hit movies each 
*/


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

SELECT 
		genre,
        COUNT(id) AS movie_count
FROM 
		movie_along_genre 
		INNER JOIN ratings 
		USING(movie_id)
WHERE 
		country LIKE '%USA%' 
        AND total_votes > 1000 
        AND year = 2017 
        AND MONTH(date_published) = 3
GROUP BY genre
ORDER BY movie_count DESC
 ;
        
/*findings :
-- 24 movies were produced under the genre Drama.
-- 1 movie under the genre Family.
*/

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

SELECT 
		title,
        avg_rating,
        genre
FROM 
		movie_along_genre 
		INNER JOIN ratings 
		USING(movie_id)
WHERE 
		title like 'The%'
        AND avg_rating > 8
order by genre , avg_rating DESC
 ;
 /* findings :
 -- There are 8 movies with the title beginning with 'The'
 -- The Brighton Miracle have the highest avg_rating of 9.5.
 -- About 7 movies are from Drama genre.
 */


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
		COUNT(ID) AS NO_OF_MOVIES,
		median_rating		
FROM movie_along_with_rating
WHERE 
		 date_published BETWEEN '2018-04-01' AND '2019-04-01' 
		 AND median_rating = 8
GROUP BY median_rating
;
/* finding :
-- 361 movies released between 1 April 2018 and 1 April 2019 were given a median rating of 8.
*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 'Italian movies' AS type_of_movie ,sum(total_votes) as total_votes
FROM movie_along_with_rating
WHERE languages like '%Italian%' 
UNION
SELECT 'German movies'  AS type_of_movie ,sum(total_votes) as total_votes
FROM movie_along_with_rating
WHERE languages like '%German%' ;

/* finding :
-- total votes for German movies : 44,21,525
-- total votes for Italian movies : 25,59,540
-- This shows that German movies do get more votes than Italian movies
 */

-- Answer is Yes

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

SELECT 	
		COUNT(*) - COUNT(name) AS name_nulls,
        COUNT(*) - COUNT(height) AS height_nulls,
        COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
        COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;

/* findings :
-- null values in column name : 0
-- null values in column height : 17335
-- null values in column date_of_birth : 13431
-- null values in column known_for_movies : 15226
*/

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
-- creation of a view director_along_movie
 WITH director_along_movie AS
(
				SELECT 
						m.movie_id,
						m.title,
						m.genre,
						n.name AS director_name,
						r.avg_rating
				FROM
						director_mapping d
						INNER JOIN names n
						ON d.name_id = n.id
						INNER JOIN movie_along_genre m
						ON m.movie_id = d.movie_id
						INNER JOIN ratings r
						ON r.movie_id =  m.movie_id
),
RANK_STATEMENT AS
( 
				SELECT 
						genre,
						count(id) AS movie_count,
						DENSE_RANK() OVER W AS genre_rank
				FROM 
						movie_along_genre 
                        INNER JOIN  ratings 
                        USING(movie_id)
                WHERE avg_rating > 8
				GROUP BY genre 
                WINDOW W AS (ORDER BY count(id) DESC)
),
ranked_directors AS
 (
 SELECT 
		director_name,
        count(movie_id) AS movie_count,
        DENSE_RANK() OVER( ORDER BY  count(movie_id) DESC ) AS rank_of_directors
 FROM director_along_movie
 WHERE 
		avg_rating > 8 AND
        genre in (
					SELECT genre
                    FROM RANK_STATEMENT
                    WHERE genre_rank <=3
				 )
	
 GROUP BY 
        director_name
 )
SELECT 
	director_name,
	movie_count
FROM ranked_directors
WHERE RANK_OF_DIRECTORS <=3
LIMIT 3;
 
 /* Findings are 
 -- James Mangold have directed 4 movies in the top  3 genre with average rating more than 8.
 -- Following  have directed 3 movies in the top  3 genre with average rating more than 8 : Anthony Russo, Joe Russo, Soubin Sahir
 */


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

CREATE VIEW role_play_names AS
( SELECT 
		movie_id,
        name ,
        category
  FROM role_mapping r
  INNER JOIN names n 
  ON r.name_id = n.id
 );
 SELECT 
		name AS actor_name,
        count(movie_id) AS movie_count
 FROM role_play_names
 INNER JOIN ratings 
 USING(movie_id)
 WHERE 
		median_rating >= 8 AND
		category = 'actor'
GROUP BY name
ORDER BY movie_count DESC
LIMIT 2;

/* finding :
The top two actors whose movies have a median rating >= 8  are : 
1. Mammootty - 8 movies
2. Mohanlal  - 5 movies
*/


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

SELECT 
		production_company,
		sum(total_votes) AS vote_count,
        RANK() OVER (ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM movie_along_with_rating
GROUP BY production_company 
LIMIT 3;

/* finding :
Top 3 production houses are : 1. Marvel Studios, 2. Twentieth Century Fox , 3. Warner Bros.
*/



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

SELECT 
		name as actor_name,
        SUM(total_votes) AS total_votes	,
        count(distinct m.movie_id) AS movie_count	 ,
        ROUND(SUM( avg_rating * total_votes) / SUM(total_votes),2) AS actor_avg_rating,
        RANK()OVER (ORDER BY SUM( avg_rating * total_votes) / SUM(total_votes) DESC ,count(distinct m.movie_id) DESC ) AS actor_rank
FROM role_play_names r
INNER JOIN movie_along_with_rating m 
ON r.movie_id = m.id 
WHERE 
		category = 'actor' AND
        country like '%India%'
GROUP BY actor_name 
HAVING movie_count >= 5
LIMIT 1
;
/* finding is :
The top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu
*/

-- Top actor is Vijay Sethupathi

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

SELECT 
		name AS actress_name,
        SUM(total_votes) AS total_votes	,
        count(m.movie_id) AS movie_count	 ,
        ROUND(SUM( avg_rating * total_votes) / SUM(total_votes),2) AS actress_avg_rating,
        RANK()OVER (ORDER BY SUM( avg_rating * total_votes) / SUM(total_votes) DESC ,count(m.movie_id) DESC ) AS actress_rank
FROM role_play_names r
INNER JOIN movie_along_with_rating m 
ON r.movie_id = m.id 
WHERE 
		country like '%India%' AND
        category = 'actress' AND 
        languages like '%Hindi%'
GROUP BY actress_name
HAVING movie_count >= 3
LIMIT 5;
	
/* findings :
Top 5 actress from Hindi movies are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor,Kriti Kharbanda
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT 
		title,
		avg_rating,
		CASE 
			WHEN avg_rating > 8 then 'Superhit movies'
			WHEN avg_rating between 7 and 8 then 'Hit movies'
			WHEN avg_rating between 5 and 7 then 'One-time-watch movies'
			WHEN avg_rating < 5 then 'Flop movies'
			END AS category
FROM movie_along_genre 
INNER JOIN ratings
USING (movie_id)
WHERE genre = 'Thriller'
ORDER BY avg_rating DESC;

/* findings :
-- the movie 'Safe' has the highest rating of 9.5 .
-- the movie 'Roofied' has the lowest rating of 1.1. 
*/




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
SELECT
		genre, 
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 9 PRECEDING) AS moving_avg_duration
FROM movie_along_genre
GROUP BY genre
ORDER BY genre;


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
WITH selected_genre AS (
							SELECT 
									genre,
                                    count(id) AS movie_count
							FROM MOVIE_ALONG_GENRE
							GROUP BY genre
							ORDER BY movie_count DESC
							LIMIT 3 
						) ,
SELECTED_MOVIES AS      (

							SELECT 
									genre,
									year,
									title AS movie_name,
									CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worldwide_gross_income ,
									ROW_NUMBER() OVER (PARTITION BY year  ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))DESC ) AS movie_rank
							FROM movie_along_genre
							WHERE genre IN (SELECT 
													genre
											FROM selected_genre
											 )
						)
SELECT * FROM SELECTED_MOVIES WHERE movie_rank <=5;



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

WITH ranked_prod_comp AS
			(SELECT 
					production_company,
					count(movie_id) AS movie_count,
					DENSE_RANK() OVER (ORDER BY count(movie_id) DESC ) AS prod_comp_rank
			FROM movie_along_with_rating
			WHERE 
					languages like '%,%' AND
					median_rating >=8 AND 
					production_company is not null
			GROUP BY production_company
)
SELECT * 
FROM ranked_prod_comp
WHERE prod_comp_rank <=2;

/* finding
The top production_companies that have produced highest number of hits (median rating >= 8) among multilingual movies
are Star Cinema and Twentieth Century Fox
*/





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

SELECT
		name AS actress_name,
        sum(total_votes) AS total_votes,
        COUNT(m.movie_id) AS movie_count,
        ROUND(avg(avg_rating),2) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY COUNT(m.movie_id) DESC ) AS actress_rank
FROM movie_along_with_rating m
INNER JOIN 
role_play_names r
ON m.id = r.movie_id
INNER JOIN 
genre g 
ON g.movie_id = r.movie_id
WHERE 
	category = 'actress' AND
    avg_rating > 8 AND
    genre = 'Drama'
GROUP BY name
LIMIT 3
;
/* findings : 
top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre are
1. Parvathy Thiruvothu
2. Susan Brown
3. Amanda Lawrence
*/


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

WITH director_data AS
(SELECT 
		name_id,
        name,
        title,
        duration,
        total_votes,
        avg_rating,
        date_published,
        lag (date_published ,1) OVER (PARTITION BY name ORDER BY date_published ) AS earlier_movie_date
        
FROM director_mapping d
INNER JOIN 
names n 
ON d.name_id = n.id 
INNER JOIN 
movie_along_with_rating m 
ON m.id = d.movie_id
ORDER BY name , date_published
),
director_data_along_date_diff AS 
(
SELECT 
		*,
        DATEDIFF(date_published , earlier_movie_date) AS date_diff 
FROM director_data
)
SELECT
		name_id AS director_id,
        name AS director_name,
        count(title) AS number_of_movies,
        ROUND(AVG(date_diff) , 2) AS avg_inter_movie_days,
        ROUND(AVG(avg_rating),2) AS avg_rating	,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
FROM director_data_along_date_diff
GROUP BY director_id,director_name
ORDER BY number_of_movies DESC 
LIMIT 9;

/* finding :
Top 9 directors based on number of movies are 
 A.L. Vijay, Andrew Jones, Chris Stokes, Jesse V. Johnson, Justin Price, Özgür Bakar, Sam Liu, Sion Sono and Steven Soderbergh.

*/
