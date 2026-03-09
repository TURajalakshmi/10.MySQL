USE NetflixDB;
-- 1)List all users subscribed to the Premium plan:
SELECT user_id, user_name, email, registration_date, plan
FROM Users
WHERE plan = 'PREMIUM';

-- 2)Retrieve all movies in the Drama genre with a rating higher than 8.5:
SELECT movie_id, title
FROM Movies
WHERE genre = 'Drama' AND rating >= 8.5; 

-- 3)Find the average rating of all movies released after 2015:
SELECT AVG (rating) AS average_rating
FROM Movies
WHERE release_year > 2015;

-- 4)List the names of users who have watched the movie Stranger Things along with their completion percentage: 
SELECT user_name, title, completion_percentage
FROM Users
JOIN WatchHistory ON Users.user_id = WatchHistory.user_id
JOIN Movies ON WatchHistory.movie_id = Movies.movie_id
WHERE title = 'Stranger Things';

-- 5)Find the name of the user(s) who rated a movie the highest among all reviews:
SELECT user_name, Reviews.rating
FROM Users
JOIN Reviews ON Users.user_id = Reviews.user_id
WHERE Reviews.rating = (SELECT MAX(rating) FROM Reviews);

-- 6)Calculate the number of movies watched by each user and sort by the highest count: 
SELECT U.user_id, U.user_name, COUNT(WH.movie_id) AS movies_watched
FROM Users U
JOIN WatchHistory WH ON U.user_id = WH.user_id
GROUP BY U.user_id, U.user_name
ORDER BY movies_watched DESC;

-- 7)List all movies watched by John Doe, including their genre, rating, and his completion percentage:
SELECT U.user_name, M.title, M.genre, M.rating, WH.completion_percentage
FROM Users U
JOIN WatchHistory WH ON U.user_id = WH.user_id
JOIN Movies M ON WH.movie_id = M.movie_id
WHERE user_name = 'John Doe';

-- 8)Update the movie's rating for Stranger Things:
SET SQL_SAFE_UPDATES = 0;
UPDATE Movies
SET rating = 9
WHERE title = 'Stranger Things';

-- 9)Remove all reviews for movies with a rating below 4.0:
DELETE FROM Reviews
WHERE movie_id IN (SELECT movie_id FROM Movies WHERE rating < 4.0);

-- 10)Fetch all users who have reviewed a movie but have not watched it completely (completion percentage < 100): 
SELECT U.user_id, u.user_name, R.review_text, WH.completion_percentage
FROM Users U
JOIN WatchHistory WH ON U.user_id = WH.user_id
JOIN Reviews R ON WH.user_id = R.user_id AND WH.movie_id = R.movie_id
WHERE WH.completion_percentage < 100;

-- 11)List all movies watched by John Doe along with their genre and his completion percentage:
SELECT U.user_name, M.title, M.genre, WH.completion_percentage
FROM Users U
JOIN WatchHistory WH ON U.user_id = WH.user_id
JOIN Movies M ON WH.movie_id = M.movie_id
WHERE U.user_name = 'John Doe';

-- 12)Retrieve all users who have reviewed the movie Stranger Things, including their review text and rating:
SELECT U.user_id, U.user_name, M.title, R.review_text, R.rating
FROM Users U
JOIN Reviews R ON U.user_id = R.user_id
JOIN Movies M ON R.movie_id = M.movie_id
WHERE M.title = 'Stranger Things';

-- 13)Fetch the watch history of all users, including their name, email, movie title, genre, watched date, and completion percentage:
SELECT U.user_name, U.email, M.title, M.genre, WH.watched_date, WH.completion_percentage
FROM Users U
LEFT JOIN WatchHistory WH ON U.user_id = WH.user_id
LEFT JOIN Movies M ON WH.movie_id = M.movie_id;

-- 14)List all movies along with the total number of reviews and average rating for each movie, including only movies with at least two reviews: 
SELECT M.title,
	COUNT(R.review_id) AS total_reviews,
    AVG(R.rating) AS avg_rating
FROM Movies M
JOIN Reviews R ON M.movie_id = R.movie_id
GROUP BY M.movie_id, M.title
HAVING COUNT(R.review_id) >= 2;