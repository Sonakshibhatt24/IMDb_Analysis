-- Segment 4: Ratings Analysis and Crew Members

-- 1. Retrieve the minimum and maximum values in each column of the ratings table (except movie_id).

select min(avg_rating) as minimum_rating, max(avg_rating) as maximum_rating, 
min(total_votes) as minimum_votes, max(total_votes) as maximum_votes,
min(median_rating) as minimum_median_rating, max(median_rating) as maximum_median_ratings
from ratings;
-- minimum_rating=1, maximum_rating=10
-- minimum_votes=100, maximum_votes=725138
-- minimum_median_rating=1, maximum_median_ratings=10


-- 2. Identify the top 10 movies based on average rating.

select * from (select title,avg_rating as average_rating, 
row_number() over (order by avg_rating desc) as ranks
 from movie
left join ratings on movie_id=id) a where ranks<=10;
-- It gives a list of top 10 movies along with their average_rating. 
-- Love in Kilnerry is ranked 1 with average rating of 10, Kirket is ranked 2 and so on.


-- 3. Summarise the ratings table based on movie counts by median ratings.

select median_rating, count(id) as movie_count from movie
left join ratings on movie_id=id
group by median_rating order by median_rating;
-- It gives movie count for each median rating. For 1, the movie count is 94. For 2, the movie count is 119 and so on.


-- 4. Identify the production house that has produced the most number of hit movies (average rating > 8).

select * from (select production_company, count(id) as movie_count,
row_number() over (order by count(id) desc) as ranks from movie
left join ratings on movie_id=id
where avg_rating>8 and production_company is not null
group by production_company) a where ranks=1;
-- Dream Warrior Pictures has produced the highest no of hit movies, i.e., average rating>8


-- 5. Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.

select genre,count(id) as movie_count from movie
left join genre g on g.movie_id=id
left join ratings r on r.movie_id=id
where total_votes>1000 and substr(date_published,4,2)='03' and year='2017' and country='USA' 
group by genre
order by movie_count desc;
-- It gives a list of genres along with their movie_count in 2017 March for USA.
-- It is 16 in Drama, 8 in Comedy and so on.


-- 6. Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.

select id, title, genre from movie 
join ratings r on id=r.movie_id
join genre g on g.movie_id=id
where title like 'The%' and avg_rating>8 order by genre;
-- it gives a list of all the movies starting with 'The' along with their genres. 
-- Theeran Adhigaaram Ondru belongs to action genre, The irishman belongs to crime and so on.