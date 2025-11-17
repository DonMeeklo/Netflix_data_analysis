-- Netflix Project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
( 
	show_id	varchar(6),
	type	varchar(10),
	title	varchar(150),
	director	varchar(208),
	casts	varchar(1000),
	country	varchar(150),
	date_added	varchar(50),
	release_year	int,
	rating	varchar(10),
	duration	varchar(15),
	listed_in	varchar(100),
	description varchar(250)
);

select * from netflix;

select count(*) total_content
from netflix;

select distinct type
from netflix;

-- 15 business questions in Netflix

-- Q1 Count the number of movies vs TV Shows

select type,
count(*) total_count
from netflix
group by type;

-- Q2 Find the most common rating for movies and TV Shows

select
	type,
	rating
from
(
	select type, 
		rating,
		count(*),
		rank() over(partition by type order by count(*) desc) ranking
	from netflix
	group by type, rating
) T1
where ranking = 1

-- Q3 List all movies released in a specific year (e.g, 2020)

select *
from netflix
where 
	type = 'Movie'
	and
	release_year = 2020

-- Q4 Find the top 5 countries with the most content on Netflix

select
	unnest(string_to_array(country, ',')) new_country,
	count(show_id) content
from netflix
group by new_country
order by content desc
limit 5

--Q5 Identify the longest movie

select *
from netflix
	where 
	type = 'Movie'
	and
	duration = (select max(duration) from netflix)

--Q6 Find contents added in the last 5 years

select *
from netflix
where 
	to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years'

--Q7 Find all movies/TV shows by director 'Rajiv Chilaka'

select *
from 
	netflix
where
	director ilike '%Rajiv Chilaka%'
-- ilike helps to generalize case sensitive words

--Q8 List all TV Shows with more than 5 seasons

select * 
from netflix
where 
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::numeric > 5

--Q9 Count the number of content items in each genre

select
	unnest(string_to_array(listed_in, ',')) genre,
	count(show_id) contents
from
	netflix
group by genre

--Q10 Find each year and the average number of content released by India on Netflix. 
--Return top 5 years with highest average content release

select 
	unnest(string_to_array(country, ',')) new_country,
	release_year,
	count(show_id) contents
from netflix
where country = 'India'
group by 1, 2
order by contents desc
limit 5

--Q11 List all movies that are documentaries

select type,
	listed_in,
	unnest(string_to_array(listed_in, ',')) genres
from
	netflix
where
	type = 'Movie'
	and
	listed_in ilike '%Documentaries%'

--Q12 Find all contents without a director

select *
from netflix
where
	director is null

--Q13 Find how many movies actor 'Salman Khan'appeared in in the last 10 years

select type, 
		casts, 
		release_year,
		COUNTRY
from netflix
where
	type = 'Movie'
	and
	casts ilike '%Salman Khan%'
order by
	release_year desc

--Q14 Find the top 10 actors who have appeared in the highest number of movies produced in India

select 
	unnest(string_to_array(casts, ',')) actors,
	count(*) total_contents
from
	netflix
where
	type = 'Movie'
	and
	country ilike '%India'
group by 1
order by 2 desc
limit 10

--Q15 Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
--Label contents containing these keywords as 'Bad' and all other contents as 'Good'. Count how many items fall into each category

with new_table
as 
(
select *,
	case
	when description ilike 'kill%' 
	or
	description ilike '%violen%' then 'Bad_Content'
	else 'Good_Content'
	end category
from netflix
)
select
	category,
	count(*)
from
	new_table
group by 1

