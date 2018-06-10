<%@page import="java.sql.*" %>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="javax.naming.Context" %>
<%@page import="javax.naming.InitialContext" %>
<%@page import="javax.sql.*" %>    
<%
	HttpServletRequest httpRequest = (HttpServletRequest) request;
	HttpServletResponse httpResponse = (HttpServletResponse) response;
	

	Context initCtx = new InitialContext();
    Context envCtx = (Context) initCtx.lookup("java:comp/env");
    if (envCtx == null)
        out.println("envCtx is NULL");

    // Look up our data source
    DataSource ds = (DataSource) envCtx.lookup("jdbc/TestDB");


    if (ds == null)
        out.println("ds is null.");

    Connection connection = ds.getConnection();
    if (connection == null)
        out.println("dbcon is null.");
	
	String movieId=request.getParameter("movieId");
	
	System.out.println("Now movieId is:"+movieId);
	
	String movieQuery="select m.title,m.year,m.director from movies as m where m.id=?;";
	PreparedStatement moviesStatement=connection.prepareStatement(movieQuery);
	moviesStatement.setString(1,movieId);
	
	ResultSet movieResult = moviesStatement.executeQuery();
	String movie_title="";
	String movie_year="";
	String movie_director="";
	String movie_rating="";
	while(movieResult.next()){
		movie_title=movieResult.getString("title");
		movie_year=movieResult.getString("year");
		movie_director=movieResult.getString("director");
	}
	
	String ratingQuery="select r.rating from movies as m, ratings as r where m.id=r.movieId and m.id=?;";
	PreparedStatement ratingStatement=connection.prepareStatement(ratingQuery);
	ratingStatement.setString(1,movieId);
	ResultSet ratingResult = ratingStatement.executeQuery();
	while(ratingResult.next()){
		movie_rating=ratingResult.getString("rating");
	}
	if(movie_rating.equals("")){
		movie_rating="null";
	}
	
	String genresQuery="select g.name from genres as g, genres_in_movies as gm where gm.movieId=? and gm.genreId=g.id;";
	PreparedStatement genresStatement=connection.prepareStatement(genresQuery);
	genresStatement.setString(1,movieId);
	ResultSet genresResult = genresStatement.executeQuery();
	ArrayList<String> genres = new ArrayList();
	while(genresResult.next()){
		genres.add(genresResult.getString("name"));	
	}
	
	String starsQuery="select s.name from stars as s, stars_in_movies as sm where sm.movieId=? and sm.starId=s.id;";
	PreparedStatement starsStatement=connection.prepareStatement(starsQuery);
	starsStatement.setString(1, movieId);
	ResultSet starsResult = starsStatement.executeQuery();
	ArrayList<String> stars = new ArrayList();
	while(starsResult.next()){
		stars.add(starsResult.getString("name"));	
	}
%>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=movie_title %></title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href='style.css'>
</head>
<body>
<%@ include file="header.html"%>
<div>
<h1>Movie Information</h1>
<table border>
<tr>
<th colspan="2"><h2><%=movie_title %></h2></th>
</tr>
<tr>
<td>Year</td>
<td><%=movie_year %></td>
</tr>
<tr>
<td>Director</td>
<td><%=movie_director %></td>
</tr>
<tr>
<td>Rating</td>
<td><%=movie_rating %></td>
</tr>
<tr>
<td>Genres</td>
<td>
<% for (String g:genres){  %>
<a href="search.jsp?browse_genre=<%=g%>&browse_type=g&start_from=1&number_per_page=20"><label><%= g %></label></a><br />
<%} %>
</td>
</tr>
<tr>
<td>Stars</td>
<td>
<% for (String s:stars){  %>
<a href="StarPage.jsp?star_name=<%=s%>"><label><%= s %></label></a><br />
<%} %>
</td>
</tr>
<tr>
<td  ><a href="SearchPage.jsp?">
<button>Back to Search</button></a></td>
<td  ><a href="shoppingcart.jsp?movieId=<%=movieId %>&q=233">
<button>Add to the cart</button></a></td>
</tr>
</table>
<%
if (httpRequest.getSession().getAttribute("isEmployeeLogin") != null) {
	%>
<br />
<table>
<tr>
	<td colspan="2" style="background:#ffc107"><a href="_dashboard.jsp?">
	<button>Back to Dashboard</button></a></td>
	
</tr>	
</table>
	<% 
    }  %>

</div>
</body>
</html>