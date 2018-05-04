<%@page import="java.sql.*" %>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%>

<%-- these statements are just normal Java code, they need to be inside the <% %> brackets--%>
<%
    String loginUser = "mytestuser";
    String loginPasswd = "mypassword";
    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	
    Class.forName("com.mysql.jdbc.Driver").newInstance();
	// create database connection
	Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
	// declare statement
	Statement statement = connection.createStatement();


	String title=request.getParameter("title");
	String year=request.getParameter("year");
	String director=request.getParameter("director");
	String star_name=request.getParameter("star_name");
	int number_per_page=Integer.parseInt(request.getParameter("number_per_page"));
	int start_from=Integer.parseInt(request.getParameter("start_from"));
	String sorted_by=request.getParameter("sorted_by");

	
	if(sorted_by.equals("rating")) {
		sorted_by="r.rating desc";
	}else {
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
	if(start_from<0){
		start_from=0;
	}
	
	String query="select m.id from movies as m, "
			+ "(select distinct sm.movieId  from stars_in_movies as sm, stars as s "
			+ "where s.name like \"%"+star_name+"%\" and s.id=sm.starId) as nm, ratings as r "
			+ "where m.title LIKE \"%"+title+"%\"  "
			+ "and m.year Like \"%"+year+"%\" "
			+ "and m.director Like \"%"+director+"%\" "
			+ "and nm.movieid=m.id and r.movieId= m.id "
			+ "order by "+sorted_by+" "
			+ "limit "+number_per_page+" "
			+ "offset "+start_from*number_per_page+";";
	
	query=query+";";
	ResultSet resultSet = statement.executeQuery(query);
	ResultSetMetaData metadata = resultSet.getMetaData();
	
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
<head><title>Fabflix</title><link rel='stylesheet' href='style.css'></head>
<body>
<form id="inside_search_form" method="get" action="search.jsp">
    <input type="hidden" name="title" value="<%=title %>" />
    <input type="hidden" name="year" value="<%=year %>" />
    <input type="hidden" name="director" value="<%=director %>" />
    <input type="hidden" name="star_name" value="<%=star_name %>" />
    <label><b>Current page is: <%=start_from %></b></label>
    <label><b>Jump to Page</b></label>
    <input type="text" name="start_from" value="0" />
    <label><b>Results per page</b></label>
    <input type="text" name="number_per_page" value="20" />
    <label><b>Sorted by</b></label>
    <input type="radio" id="sortedOption1" name="sorted_by" value="title" checked>
    <label for="sortedOptione1">Title</label>
    <input type="radio" id="sortedOption2" name="sorted_by" value="rating">
    <label for="sortedOption2">Rating</label>
    <input type="submit" value="Apply">
</form>


<a href="search.jsp?$title=<%=title %>&year=<%=year %>&director=<%=director %>&star_name=<%=star_name %>&number_per_page=<%=number_per_page %>&start_from=<%=start_from-1 %>&sorted_by=<%=sorted_by %>">
<button>Previous</button></a>

<a href="search.jsp?$title=<%=title %>&year=<%=year %>&director=<%=director %>&star_name=<%=star_name %>&number_per_page=<%=number_per_page %>&start_from=<%=start_from+1 %>&sorted_by=<%=sorted_by %>">
<button>Next</button></a>


<table border>
<tr><td >Title</td><td>Year</td><td>Director</td><td>Rating</td><td>Genres</td><td>Stars</td></tr>

<% while (resultSet.next()) { 
	System.out.println("check");
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
<td> <%= movie_title %> </td>
<td> <%= movie_year %> </td>
<td> <%= movie_director %> </td>
<td> <%= movie_rating %> </td>
</tr>
<% } %>
</table>
</body>


</html>