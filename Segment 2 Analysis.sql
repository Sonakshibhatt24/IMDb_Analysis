-- Segment 2: Movie Release Trends

-- 1. Determine the total number of movies released each year and analyse the month-wise trend.

select year, count(id) as movies_released from movie group by year order by year;
-- for 2017, movies released are 3052. For 2018, it is 2944 and for 2019, it is 2001

select year, substr(date_published,4,2) as month, count(id) as movies_released from movie 
group by year, month order by year, month;
-- it gives month-wise trend of each year. In 2017, movies released in jan are 291, in feb it is 228 as so on.
-- In 2018, movies released in jan are 302, in feb it is 215 as so on.
-- In 2019, movies released in jan are 211, in feb it is 197 as so on.

 
-- 2. Calculate the number of movies produced in the USA or India in the year 2019.

select count(id) as movies_released from movie
where year='2019' and country in ('USA','India');
-- movies produced in USA or India in 2019 are 887