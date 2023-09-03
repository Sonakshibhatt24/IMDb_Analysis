-- Segment 6: Broader Understanding of Data

-- 1. Classify thriller movies based on average ratings into different categories.

select id, title, genre, avg_rating,
case
when avg_rating>=8 then 'superhit'
when avg_rating>=6 then 'hit'
when avg_rating<=3 then 'flop'
else 'average' end as category
from movie m
left join ratings r on m.id=r.movie_id
left join genre g on m.id=g.movie_id
where genre='Thriller';
-- It classifies Thriller Movies based on their average ratings. 
-- For ratings>=8, the movies are categorized as super-hit. 
-- For ratings, between 6-8, the movies are categorized as hit. 
-- For ratings<=3, the movies are categorized as flop and remaining movies are categorized as average.


-- 2. analyse the genre-wise running total and moving average of the average movie duration.

select id,title, genre, duration, sum(duration) over (partition by genre order by id) as running_total, 
avg(duration) over (partition by genre order by id) as moving_average
from movie join genre on id=movie_id; 
-- It gives genre-wise running total and moving-average of the movies.


-- 3. Identify the five highest-grossing movies of each year that belong to the top three genres.

with cte as (select * from (select genre,count(id) as movie_count, 
row_number() over (order by count(id) desc) as ranks from movie m
left join genre g on m.id=g.movie_id
group by genre) a where ranks<=3)
(select * from (select id, title, genre, year, concat('$',worlwide_gross_income) as worldwide_income,
row_number() over (partition by year order by worlwide_gross_income desc) as income_rank
from movie left join genre on movie_id=id
where genre in (select genre from cte)) a where income_rank<=5);
-- It gives top 5 movies for top 3 genres in each year. 
-- In 2017, The highest grossing movie is The Fate of the Furious, followed by Despicable Me 3 and so on.
-- In 2018, it is Bohemian Rhapsody followed by Venom and so on.
-- In 2019, it is Avengers: Endgame, Followed by The Lion King and so on


-- 4. Determine the top two production houses that have produced the highest number of hits among multilingual movies.

select * from (select production_company, count(id) as movie_count,
row_number() over (order by count(id) desc) as ranks
from movie left join ratings on id=movie_id
where languages like '%,%' and avg_rating>=6 and production_company is not null
group by production_company) a where ranks<=2;
-- Top 2 production companies in multilingual movies with highest hits (average ratings>=6) are Warner Bros. and Star Cimena  


-- 5. Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.
select * from (select name_id,name as actress_name, count(m.id) as movie_count,
row_number() over (order by count(m.id) desc) as ranks
from movie m
join role_mapping r on m.id=r.movie_id
join genre g on m.id=g.movie_id
join ratings a on m.id=a.movie_id
join names n on n.id=r.name_id
where category='actress' and avg_rating>8 and genre='drama'
group by name_id,name) a where ranks<=3;
-- Top 3 actress in drama genre with average ratings>8 are Susan Brown, Amanda lawrence and Denise Gough. 


-- 6. Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.
select * from (select n.id as director_id, n.name as director_name, count(m.id) as movie_count,
avg(duration) as average_duration, avg(avg_rating) as average_rating,
row_number() over (order by count(m.id) desc) as ranks
from movie m join ratings r on m.id=r.movie_id
join director_mapping d on d.movie_id=r.movie_id
join names n on n.id=d.name_id
group by n.id,n.name) a where ranks<=9;
-- It gives top 9 directors based on no of movies. A.L. Vijay is ranked 1, Andrew Jones is ranked 2 and so on.