--query for normal search--
select m.id, m.title,r.rating from movies as m, (select distinct sm.movieId  from stars_in_movies as sm, stars as s where s.name like "%%" and s.id=sm.starId) as nm, ratings as r where m.title LIKE "%%"  and m.year Like "%%" and m.director Like "%%" and nm.movieid=m.id and r.movieId= m.id order by r.rating desc limit 20 offset 0;

--display the result which may have no rating info---
select m.id from (select m.id,m.title from movies as m,  (select distinct sm.movieId  from stars_in_movies as sm, stars as s where s.name like "%%" and s.id=sm.starId) as nm where m.title LIKE "%le%" and m.year Like "%%" and m.director Like "%%" and nm.movieid=m.id) as m left join ratings as r on r.movieId=m.id order by r.rating desc limit 20  offset 0;

--get actors'name by movie id--
select m.title,m.year,m.director,r.rating from movies as m, ratings as r where m.id="tt0498362" and r.movieId=m.id;

--get genres'name by movie id--
select  g.name from genres as g, genres_in_movies as gm where gm.movieId="" and gm.genreId=g.id;

--get actors'name by movie id--
select s.name from stars as s, stars_in_movies as sm where sm.movieId="tt0498362" and sm.starId=s.id;

--get movies by alpha--
select m.id from movies as m , ratings as r where m.title LIKE "a%" and m.id=r.movieId order by m.title limit 10 offset 0;

--get movies by genres--
select m.id ,m.title,g.name from movies as m, ratings as r, genres as g, genres_in_movies as gm where g.name="Action" and g.id=gm.genreId and gm.movieId=m.id and m.id=r.movieId order by r.rating desc limit 10 offset 0;


--get sale info--
select s.id ,m.title from sales as s , movies as m where s.saleDate="2018/05/04" and s.customerId="961" and s.movieId=m.id;




















