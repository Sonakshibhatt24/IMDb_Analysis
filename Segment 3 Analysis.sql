-- Segment 3: Production Statistics and Genre Analysis

-- 1. Retrieve the unique list of genres present in the dataset.

select distinct genre
from movie
left join genre on movie_id=id;
-- it gives all the unique genres, such as Drama, Fantasy, Thriller etc.


-- 2. Identify the genre with the highest number of movies produced overall.

select * from (select distinct genre, count(id) as movies_produced,
row_number() over (order by count(id) desc) as ranks
from movie
left join genre on movie_id=id
group by genre) a where ranks=1;
-- Top Genre is Drama with total movies of 4285


-- 3. Determine the count of movies that belong to only one genre.

select count(*) as movies_for_1_genre from 
(select id, count(genre) from movie left join genre on movie_id=id
group by id having count(genre)=1) a;
-- 3289 movies belong to only one genre


-- 4. Calculate the average duration of movies in each genre.

select distinct genre, avg(duration) as avg_duration
from movie
left join genre on movie_id=id
group by genre;
-- It gives average duration of all gneres. For Drama, it is 106.7746. For Fantasy, it is 105.1404, and so on.


-- 5. Find the rank of the 'thriller' genre among all genres in terms of the number of movies produced.

select *  from (select distinct genre, count(id) as movies_produced, rank() over (order by count(id) desc) as genre_rank
from movie
left join genre on movie_id=id
group by genre) a where genre='Thriller';
-- Rank of thriller genre is 3