-- Segment 7: Recommendations

-- Based on the analysis, provide recommendations for the types of content Bolly movies should focus on producing.

-- Based on the analysis, 
-- Top 5 genres are Drama, Others, Romance, Family and Crime based on average ratings.
-- Where as based on worldwide income, it is Adventure, Action, Drama, Comedy and Sci_Fi.
-- So, it is recommended that Bolly Movies should produce maximum movies in these genres.

-- Further, Top 10 directors are Srinivas Gundareddy, Balavalli Darshith Bhat, Abhinav Thakur, Pradeep Kalipurayath, Prince Singh, Arjun Prabhakaran, Antoneta Kastrati, Manoj K. Jha, Arsel Arumugam and Sumnash Sri Kaljai
-- Top 10 actors are Priyanka Augustin, Shilpa Mahendar, Gopi Krishna, Naveen D. Padil, Aryan Gowda. Ravi Bhat, Aloknath Pathak, Siju Wilson, Prasanth and Preetyka Chauhan
-- Top 10 actress are Sangeetha Bhat, Pranati Rai Prakash, Fatmire Sahiti, Neeraja, Leera Kaljai, Dorothée Berryman, Susan Brown, Amanda Lawrence, Bhagyashree Milind and Miao Chen

-- Further, their biggest competition are the top 10 production Houses.
-- Based on average ratings, Top 10 Production houses are Archway Pictures, A square productions, Bestwin Production, SLN Cinemas, Epiphany Entertainments, Eastpool Films, Piecewing Productions, Manikya Productions, Crossing Bridges Films and Lovely World Entertainment
-- Whereas based on gross income, they are Walt Disney Pictures, Marvel Studios, Universal Pictures, Columbia Pictures, Warner Bros., Twentieth Century Fox, Paramount Pictures, Fairview Entertainment, Beijing Dengfeng International Culture Communications Company and Bona Film Group

-- Bolly Movies should produce movies with duration between 100 minutes and 130 minutes as,
-- average duration of top 100 movies based on average ratings is 124.6600
-- average duration of top 100 movies based on worldwide gross income is 121.6800
-- average duration of top 100 movies in Crime is 125.0100
-- average duration of top 100 movies in Drama is 128.7200
-- average duration of top 100 movies in Family is 100.1600
-- average duration of top 100 movies in Romance is 127.0400

-- Further, the top countries based on Gross Income are USA, China, South Korea, Japan, India, France, Russia, UK, Germany and Spain.
-- Therefore, Bolly Movies should produce Movies in these countries to ensure maximum income.


-- top 5 genre based on average rating
select * from (select genre, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m left join genre g on g.movie_id=m.id
left join ratings r on r.movie_id=m.id
group by genre) a where ranks<=5;

-- top 5 genre based on world_wide gross income
select * from (select genre, concat('$',sum(worlwide_gross_income)) as worldwide_gross_income,
row_number() over (order by sum(worlwide_gross_income) desc) as ranks
from movie m left join genre g on g.movie_id=m.id
left join ratings r on r.movie_id=m.id
group by genre) a where ranks<=5;

-- top 10 directors based on average ratings
select * from (select d.name_id as director_id, n.name as director_name, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks from movie m
left join ratings r on r.movie_id=m.id
left join director_mapping d on d.movie_id=m.id
left join names n on n.id=d.name_id
where d.name_id is not null
group by name_id,n.name) a where ranks<=10;

-- top 10 actors based on average ratings
select * from (select n.id,n.name as actor_name, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m
left join ratings r on r.movie_id=m.id
left join role_mapping d on d.movie_id=m.id
left join names n on n.id=d.name_id
where d.name_id is not null
and category='actor'
group by name_id,n.name) a where ranks<=10;

-- top 10 actress based on average ratings
select * from (select n.id,n.name as actor_name, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m
left join ratings r on r.movie_id=m.id
left join role_mapping d on d.movie_id=m.id
left join names n on n.id=d.name_id
where d.name_id is not null
and category='actress'
group by name_id,n.name) a where ranks<=10;

-- top 10 production houses based on average ratings
select * from (select production_company, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m
left join ratings r on r.movie_id=m.id
group by production_company) a where ranks<=10;

-- top 10 production houses based on worldwide gross income
select * from (select production_company, concat('$',sum(worlwide_gross_income)) as worldwide_gross_income,
row_number() over (order by sum(worlwide_gross_income) desc) as ranks
from movie group by production_company) a where ranks<=10;

-- average duration of top 100 movies based on worldwide gross income
select avg(duration) from (select * from (select title, duration, worlwide_gross_income,
row_number() over (order by worlwide_gross_income desc) as ranks from movie) a where ranks<=100) a;

-- average duration of top 100 movies based on average ratings
select avg(duration) from (select * from (select title, duration, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks from movie
left join ratings on movie_id=id
group by title,duration) a where ranks<=100) a;

-- average duration of top 100 movies in each top genre
with cte as (select * from (select title, duration, genre, avg(avg_rating) as average_rating,
row_number() over (partition by genre order by avg(avg_rating) desc) as ranks from movie
left join ratings r on r.movie_id=id
left join genre g on g.movie_id=id
group by genre,title,duration) a where ranks<=100),
cte2 as (select * from (select genre, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m left join genre g on g.movie_id=m.id
left join ratings r on r.movie_id=m.id
group by genre) a where ranks<=5)
(select genre, avg(duration) from cte where genre in (select genre from cte2)
group by genre);

-- Top 10 countries based on gross_income
select * from (select country, concat('$',sum(worlwide_gross_income)) as worldwide_gross_income,
row_number() over (order by sum(worlwide_gross_income) desc) as ranks
from movie where country not like '%,%'
group by country) a where ranks<=10;

-- top 10 directors in each top genre based on average ratings
with cte as (select genre,d.name_id as director_id, n.name as director_name, avg(avg_rating) as average_rating,
row_number() over (partition by genre order by avg(avg_rating) desc) as ranks from movie m
left join genre g on m.id=g.movie_id
left join ratings r on r.movie_id=m.id
left join director_mapping d on d.movie_id=m.id
left join names n on n.id=d.name_id
where d.name_id is not null
group by genre,name_id,n.name),
cte2 as (select * from (select genre, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m left join genre g on g.movie_id=m.id
left join ratings r on r.movie_id=m.id
group by genre) a where ranks<=5)
(select * from cte where genre in (select genre from cte2) and ranks<=10);

-- Top 10 actors in each top genre based on average ratings
with cte as (select n.id,n.name as actor_name, genre, avg(avg_rating) as average_rating,
row_number() over (partition by genre order by avg(avg_rating) desc) as ranks
from movie m
left join genre g on m.id=g.movie_id
left join ratings r on r.movie_id=m.id
left join role_mapping d on d.movie_id=m.id
left join names n on n.id=d.name_id
where d.name_id is not null
and category='actor'
group by genre,name_id,n.name),
cte2 as (select * from (select genre, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m left join genre g on g.movie_id=m.id
left join ratings r on r.movie_id=m.id
group by genre) a where ranks<=5)
(select * from cte where genre in (select genre from cte2) and ranks<=10);

-- Top 10 actress in each top genre based on average ratings
with cte as (select n.id,n.name as actor_name, genre, avg(avg_rating) as average_rating,
row_number() over (partition by genre order by avg(avg_rating) desc) as ranks
from movie m
left join genre g on m.id=g.movie_id
left join ratings r on r.movie_id=m.id
left join role_mapping d on d.movie_id=m.id
left join names n on n.id=d.name_id
where d.name_id is not null
and category='actress'
group by genre,name_id,n.name),
cte2 as (select * from (select genre, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m left join genre g on g.movie_id=m.id
left join ratings r on r.movie_id=m.id
group by genre) a where ranks<=5)
(select * from cte where genre in (select genre from cte2) and ranks<=10);

-- Top 10 production companies for each top genre based on average ratings
with cte as (select production_company, genre, avg(avg_rating) as average_rating,
row_number() over (partition by genre order by avg(avg_rating) desc) as ranks
from movie m
left join genre g on m.id=g.movie_id
left join ratings r on r.movie_id=m.id
group by genre,production_company),
cte2 as (select * from (select genre, avg(avg_rating) as average_rating,
row_number() over (order by avg(avg_rating) desc) as ranks
from movie m left join genre g on g.movie_id=m.id
left join ratings r on r.movie_id=m.id
group by genre) a where ranks<=5)
(select * from cte where genre in (select genre from cte2) and ranks<=10);