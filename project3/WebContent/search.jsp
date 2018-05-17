<%@page import="java.sql.*" %>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- these statements are just normal Java code, they need to be inside the <% %> brackets--%>
<%
    String loginUser = "mytestuser";
    String loginPasswd = "mypassword";
    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	
    Class.forName("com.mysql.jdbc.Driver").newInstance();
	// create database connection
	Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
	// declare statement
	


	String title=request.getParameter("title");
	String year=request.getParameter("year");
	String director=request.getParameter("director");
	String star_name=request.getParameter("star_name");
	String browse_type=request.getParameter("browse_type");
	String browse_genre=request.getParameter("browse_genre");
	int number_per_page=Integer.parseInt(request.getParameter("number_per_page"));
	int start_from=Integer.parseInt(request.getParameter("start_from"));
	String sorted_by=request.getParameter("sorted_by");

	System.out.println("Now sorted_by is:"+sorted_by);
	if(sorted_by==null){
		sorted_by="m.title";
	}
	
	if(sorted_by.equals("rating")) {
		sorted_by="r.rating desc";
	}else if(sorted_by.equals("title")){
		sorted_by="m.title";
	}

	if(title==null) {
		title="";
	}
	if(year==null) {
		year="";
	}
	if(director==null) {
		director="";
	}
	if(star_name==null) {
		star_name="";
	}

	if(start_from<1){
		start_from=1;
	}
	
	String query="empty";
	PreparedStatement preparedStatement=connection.prepareStatement(query);
	if(browse_type==null || browse_type.equals("")){
		/***
		query="select m.id from movies as m, "
				+ "(select distinct sm.movieId  from stars_in_movies as sm, stars as s "
				+ "where s.name like \"%"+star_name+"%\" and s.id=sm.starId) as nm, ratings as r "
				+ "where m.title LIKE \"%"+title+"%\"  "
				+ "and m.year Like \"%"+year+"%\" "
				+ "and m.director Like \"%"+director+"%\" "
				+ "and nm.movieid=m.id and r.movieId= m.id "
				+ "order by "+sorted_by+" "
				+ "limit "+number_per_page+" "
				+ "offset "+(start_from-1)*number_per_page+";";
				***/
				
		query="select m.id from (select m.id,m.title from movies as m, "
				+ "(select distinct sm.movieId  from stars_in_movies as sm, stars as s "
				+ "where s.name like ? and s.id=sm.starId) as nm "
				+ "where m.title LIKE ? "
				+ "and m.year Like ?  "
				+ "and m.director Like ?  "
				+ "and nm.movieid=m.id) as m left join ratings as r on r.movieId=m.id "
				+ "order by ? "
				+ "limit ? "
				+ "offset ?;";
		preparedStatement=connection.prepareStatement(query);
		preparedStatement.setString(1,"%"+star_name+"%");
		preparedStatement.setString(2,"%"+title+"%");
		preparedStatement.setString(3,"%"+year+"%");
		preparedStatement.setString(4,"%"+director+"%" );
		preparedStatement.setString(5,sorted_by);
		preparedStatement.setInt(6,number_per_page);
		preparedStatement.setInt(7,(start_from-1)*number_per_page);
		
		
	}else if(browse_type.equals("a")){
		
		query="select m.id from movies as m , ratings as r where m.title LIKE ? and r.movieId=m.id"
				+ " order by ? "
				+ "limit ? "
				+ "offset ?;";
				
		preparedStatement=connection.prepareStatement(query);
		preparedStatement.setString(1,title+"%");
		preparedStatement.setString(2,sorted_by);
		preparedStatement.setInt(3,number_per_page);
		preparedStatement.setInt(4,(start_from-1)*number_per_page);
		
	}else if(browse_type.equals("g")){
		query="select m.id ,m.title,g.name from movies as m, ratings as r, genres as g, genres_in_movies as gm "
				+ "where g.name=? and g.id=gm.genreId and gm.movieId=m.id and m.id=r.movieId "
				+ "order by ? "
				+ "limit ? "
				+ "offset ?;";
		
		preparedStatement=connection.prepareStatement(query);
		preparedStatement.setString(1,browse_genre);
		preparedStatement.setString(2,sorted_by);
		preparedStatement.setInt(3,number_per_page);
		preparedStatement.setInt(4,(start_from-1)*number_per_page);
	}
	
	
	ResultSet resultSet = preparedStatement.executeQuery();
	//ResultSetMetaData metadata = resultSet.getMetaData();
	
    HttpServletRequest httpRequest = (HttpServletRequest) request;
    HttpServletResponse httpResponse = (HttpServletResponse) response;
    
    httpRequest.setAttribute(sorted_by,"rating");
%>

<%-- the following are HTML mixed with java code, 
     you can see for loops are used to generate a dynamic table.
     normal Java code still needs to be in the <% %> tag
     
     <%= %> is the expression tag. the java code inside needs to be a value
     and that value will be directly write to the html, it's equivalent to out.print()
--%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Fabflix</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href='style.css'>
</head>
<body>
<%@ include file="header.html"%>
<div>
<form id="inside_search_form" method="get" action="search.jsp">
    <input type="hidden" name="title" value="<%=title %>" />
    <input type="hidden" name="year" value="<%=year %>" />
    <input type="hidden" name="director" value="<%=director %>" />
    <input type="hidden" name="star_name" value="<%=star_name %>" />
    <input type="hidden" name="browse_type" value="<%=browse_type %>" />
    <input type="hidden" name="browse_genre" value="<%=browse_genre %>" />
    <label><b>Current page is: <%=start_from %></b></label>
    <label><b>Jump to Page</b></label>
    <input type="text" name="start_from" value="1" />
    <label><b>Results per page</b></label>
    <input type="text" name="number_per_page" value="20" />
    <label><b>Sorted by</b></label>
    <input type="radio" id="sortedOption1" name="sorted_by" value="title" checked>
    <label for="sortedOptione1">Title</label>
    <input type="radio" id="sortedOption2" name="sorted_by" value="rating">
    <label for="sortedOption2">Rating</label>
    <input type="submit" value="Apply">
</form>


<a href="search.jsp?title=<%=title %>&year=<%=year %>&director=<%=director %>&star_name=<%=star_name %>&number_per_page=<%=number_per_page %>&start_from=<%=start_from-1 %>&sorted_by=<%=sorted_by %>&browse_type=<%=browse_type %>&browse_genre=<%=browse_genre %>">
<button>Previous</button></a>

<a href="search.jsp?title=<%=title %>&year=<%=year %>&director=<%=director %>&star_name=<%=star_name %>&number_per_page=<%=number_per_page %>&start_from=<%=start_from+1 %>&sorted_by=<%=sorted_by %>&browse_type=<%=browse_type %>&browse_genre=<%=browse_genre %>">
<button>Next</button></a>
</div>
<br />
<div>
<table border>
<tr><td >Title</td><td>Year</td><td>Director</td><td>Rating</td><td>Genres</td><td>Stars</td><td>Add to cart</td></tr>

<% while (resultSet.next()) { 
	System.out.println("Enter the resultSet");
	String movieId = resultSet.getString("id");
	System.out.println("Now movieId is:"+movieId);
	String movieQuery="select m.title,m.year,m.director,r.rating from movies as m, ratings as r where m.id=\""+movieId+"\" and r.movieId=m.id;";
	Statement temp_statement = connection.createStatement();
	
	ResultSet movieResult = temp_statement.executeQuery(movieQuery);
	String movie_title="";
	String movie_year="";
	String movie_director="";
	String movie_rating="";
	while(movieResult.next()){
		movie_title=movieResult.getString("title");
		movie_year=movieResult.getString("year");
		movie_director=movieResult.getString("director");
		movie_rating=movieResult.getString("rating");
	}
	
	if(movie_title.equals("")){
		continue;
	}
	String genresQuery="select g.name from genres as g, genres_in_movies as gm where gm.movieId=\""+movieId+"\" and gm.genreId=g.id;";
	ResultSet genresResult = temp_statement.executeQuery(genresQuery);
	ArrayList<String> genres = new ArrayList();
	while(genresResult.next()){
		genres.add(genresResult.getString("name"));	
	}
	
	String starsQuery="select s.name from stars as s, stars_in_movies as sm where sm.movieId=\""+movieId+"\" and sm.starId=s.id;";
	ResultSet starsResult = temp_statement.executeQuery(starsQuery);
	ArrayList<String> stars = new ArrayList();
	while(starsResult.next()){
		stars.add(starsResult.getString("name"));	
	}
	
%>
<tr>
<td>  <a href="MoviePage.jsp?movieId=<%=movieId %>"><label><%= movie_title %></label></a> </td>
<td> <%= movie_year %> </td>
<td> <%= movie_director %> </td>
<td> <%= movie_rating %> </td>
<td>
<% for (String g:genres){  %>
<a href="search.jsp?browse_genre=<%= g %>&browse_type=g&start_from=1&number_per_page=20"><label><%= g %></label></a><br />
<%} %>
</td>
<td>
<% for (String s:stars){  %>
<a href="StarPage.jsp?star_name=<%=s%>"><label><%= s %></label></a><br />
<%} %>
</td>
<td>
<a href="shoppingcart.jsp?movieId=<%=movieId %>&q=233">
<button>Add to the cart</button></a></td>
</tr>
<% } %>
</table>
</div>
</body>


</html>