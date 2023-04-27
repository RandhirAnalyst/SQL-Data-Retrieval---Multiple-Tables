-- we are going to learn join in MySQL
-- Inner, left right, full, and cross joins

-- Inner join
-- Inner join fetches only comman records from tables
select
    m.movie_id, budget, revenue,
    unit, currency
from movies m
inner join financials f
on m.movie_id = f.movieID ;

-- Left join
select
    m.movie_id, budget, revenue,
    unit, currency
from movies m -- movies table is left teable
left join financials f -- financials table is right teable
on m.movie_id = f.movieID ;

-- Right join
select
    m.movie_id, budget, revenue,
    unit, currency
from movies m -- movies table is left teable
right join financials f -- financials table is right teable
on m.movie_id = f.movieID ;

-- full join
select
    m.movie_id, budget, revenue,
    unit, currency
from movies m -- movies table is left teable
left join financials f -- financials table is right teable
on m.movie_id = f.movieID 

union

select
    m.movie_id, budget, revenue,
    unit, currency
from movies m -- movies table is left teable
right join financials f -- financials table is right teable
on m.movie_id = f.movieID ;

-- Note:- both queries (left and right) shuold be same columns name and same number of columns

-- 1. Show all the movies with their language names
select 
   title,
   name as language
from movies m
inner join languages l
using (language_id); -- language_id is same field name in both tables, so we can use "using" clause

-- 2. Show all Telugu movie names (assuming you don't know the language id for Telugu)
select 
   title,
   name as language
from movies m
inner join languages l
using (language_id)
where m.language_id = (select language_id from languages where name ='Telugu');

-- 3. Show the language and number of movies released in that language
select 
   name as language,
   count(title) as movie_count
from movies m
inner join languages l
using (language_id)
group by language
order by movie_count desc;


-- Cross join
-- Cross join is useful when you don't have any comman column between two tables
select
   *,
   concat(name," ",variant_name) as full_name,
   (price + variant_name) as full_price
from food_db.items -- food_db is database name
cross join  food_db.variants;

-- print movie_id, title, budget, revenue, currency, unit,and profit
-- and profit should be in million (profit_mln)
SELECT 
    title,
    budget,
    revenue,
    currency,
    unit,
    CASE
        WHEN unit = 'Billions' THEN ROUND((revenue - budget) * 1000, 2)
        WHEN unit = 'Thousands' THEN ROUND((revenue - budget) / 1000, 2)
        ELSE ROUND(revenue - budget, 2)
    END AS profit_mln
FROM
    movies m
        INNER JOIN
    financials f ON m.movie_id = f.movieID
ORDER BY profit_mln DESC;

-- print movie_id, title, budget, revenue, currency, unit,and profit
-- and profit should be in million (profit_mln), but for only hollywood movies
SELECT 
    title,
    budget,
    revenue,
    currency,
    unit,
    CASE
        WHEN unit = 'Billions' THEN ROUND((revenue - budget) * 1000, 2)
        WHEN unit = 'Thousands' THEN ROUND((revenue - budget) / 1000, 2)
        ELSE ROUND(revenue - budget, 2)
    END AS profit_mln
FROM
    movies m
        INNER JOIN
    financials f ON m.movie_id = f.movieID
where industry="Hollywood"
ORDER BY profit_mln DESC ;

-- print How many movies has each actor performed in and sort by thier movies in descending order?
select
     a.name, 
     GROUP_CONCAT(m.title SEPARATOR ' | ') as movies,
     COUNT(m.title) as movie_count
from movies m 
join movie_actor ma -- by default JOIN performs inner join in MySQL
on m.movie_id = ma.movie_id
join actors a
on a.actor_id = ma.actor_id	
group by a.actor_id 
order by movie_count desc;
  
-- print How many actors have each movie?
select
     m.title, 
     GROUP_CONCAT(a.name SEPARATOR ' | ') as actor_name
from movies m 
join movie_actor ma
on m.movie_id = ma.movie_id
join actors a
on a.actor_id = ma.actor_id	
group by m.movie_id ;

-- Generate a report of all Hindi movies sorted by their revenue amount in millions.
-- Print movie name, revenue, currency, and unit
SELECT 
    title,
    CASE
        WHEN unit = 'Billions' THEN ROUND(revenue* 1000, 2)
        WHEN unit = 'Thousands' THEN ROUND(revenue/ 1000, 2)
        ELSE ROUND(revenue , 2)
    END AS revenue_mln
FROM movies m
INNER JOIN financials f 
    ON m.movie_id = f.movieID
inner join languages l
   on  l.language_id = m.language_id
where l.name ="hindi"
ORDER BY revenue DESC ;
