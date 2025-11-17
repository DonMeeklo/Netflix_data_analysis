# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### Q1. Count the Number of Movies vs TV Shows

```sql
select type,
count(*) total_count
from netflix
group by type;
```

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select *
from netflix
where 
	type = 'Movie'
	and
	release_year = 2020
```

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select
	unnest(string_to_array(country, ',')) new_country,
	count(show_id) content
from netflix
group by new_country
order by content desc
limit 5
```

### 5. Identify the Longest Movie

```sql
select *
from netflix
	where 
	type = 'Movie'
	and
	duration = (select max(duration) from netflix)
```

### 6. Find Content Added in the Last 5 Years

```sql
select *
from netflix
where 
	to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years'
```

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select *
from 
	netflix
where
	director ilike '%Rajiv Chilaka%'
```

### 8. List All TV Shows with More Than 5 Seasons

```sql
select * 
from netflix
where 
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::numeric > 5
```

### 9. Count the Number of Content Items in Each Genre

```sql
select
	unnest(string_to_array(listed_in, ',')) genre,
	count(show_id) contents
from
	netflix
group by genre
```

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select 
	unnest(string_to_array(country, ',')) new_country,
	release_year,
	count(show_id) contents
from netflix
where country = 'India'
group by 1, 2
order by contents desc
limit 5
```

### 11. List All Movies that are Documentaries

```sql
select type,
	listed_in,
	unnest(string_to_array(listed_in, ',')) genres
from
	netflix
where
	type = 'Movie'
	and
	listed_in ilike '%Documentaries%'
```

### 12. Find All Content Without a Director

```sql
select *
from netflix
where
	director is null
```

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
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
```

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - DonMeeklo

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

mykiano84@gmail.com

Thank you for your support, and I look forward to connecting with you!
