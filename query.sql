--query which only can select the stars
select o_table.title, o_table.year, o_table.director, o_table.rating, group_concat(s.name) as star_name
from stars s, stars_in_movies s_m
inner join
(select distinct m.id, m.title, m.year, m.director, r.rating
from movies m, ratings r
where m.id=r.movieId
order by r.rating desc
limit 20) as o_table
on o_table.id=s_m.movieId
where s.id=s_m.starId
group by o_table.title, o_table.year, o_table.director, o_table.rating
order by o_table.rating desc;


--query which can select genres and stars but with duplications
select o_table.title, o_table.year, o_table.director, o_table.rating, g.name as genre_name, s.name as star_name
from stars s, genres g, genres_in_movies g_m, stars_in_movies s_m
inner join
(select distinct m.id, m.title, m.year, m.director, r.rating
from movies m, ratings r
where m.id=r.movieId
order by r.rating desc
limit 20) as o_table
on o_table.id=s_m.movieId
where s.id=s_m.starId and g_m.movieId=o_table.id and g.id=g_m.genreId;

--final query, all good.
select r_table.title, r_table.year, r_table.director, r_table.rating, group_concat(g.name) as genre_name, r_table.star_name
from genres g, genres_in_movies g_m,
(select o_table.id, o_table.title, o_table.year, o_table.director, o_table.rating, group_concat(s.name) as star_name
from stars s, stars_in_movies s_m
inner join
(select distinct m.id, m.title, m.year, m.director, r.rating
from movies m, ratings r
where m.id=r.movieId
order by r.rating desc
limit 20) as o_table
on o_table.id=s_m.movieId
where s.id=s_m.starId
group by o_table.id,o_table.title, o_table.year, o_table.director, o_table.rating) as r_table
where r_table.id=g_m.movieId and g.id=g_m.genreId
group by r_table.title, r_table.year, r_table.director, r_table.rating, r_table.star_name
order by r_table.rating desc;
