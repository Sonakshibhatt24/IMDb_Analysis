-- Segment 1: Database - Tables, Columns, Relationships

-- 1. What are the different tables in the database and how are they connected to each other in the database?

-- There are 6 tables, named as movie, genre, ratings, names, director_mapping, role_mapping
-- In this movie and genre have many-to-many relationship on movie.id and genre.movie_id
-- Movie and role_mapping are in one-to-many relationship on movie.id and role_mapping.movie_id
-- Movie and ratings are in many-to-many relationship on movie.id and ratings.movie_id
-- Movie and director_mapping are in one-to-many relationship on movie.id and director_mapping.movie_id
-- Names and role_mapping are in one-to-many relationship on names.id and role_mapping.name_id
-- Names and director_mapping are in one-to-many relationship on names.id and director_mapping.name_id


-- 2. Find the total number of rows in each table of the schema.

select count(*) from movie;
-- 7997
select count(*) from names;
-- 25735
select count(*) from genre;
-- 14662
select count(*) from ratings;
-- 7997
select count(*) from director_mapping;
-- 3867
select count(*) from role_mapping;
-- 15615


-- 3. Identify which columns in the movie table have null values.

select sum(case when id is null then 1 else 0 end) as id_nulls,
sum(case when title is null then 1 else 0 end) as title_nulls,
sum(case when year is null then 1 else 0 end) as year_nulls,
sum(case when date_published is null then 1 else 0 end) as date_published_nulls,
sum(case when duration is null then 1 else 0 end) as duration_nulls,
sum(case when country is null then 1 else 0 end) as country_nulls,
sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income_nulls,
sum(case when languages is null then 1 else 0 end) as languages_nulls,
sum(case when production_company is null then 1 else 0 end) as production_company_nulls
from movie;
-- country, worlwide_gross_income, languages, production_company columns contains nulls