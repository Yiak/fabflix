<%@page import="java.sql.*" %>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    String loginUser = "mytestuser";
    String loginPasswd = "mypassword";
    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	
    Class.forName("com.mysql.jdbc.Driver").newInstance();
	// create database connection
	Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
	// declare statement
	Statement statement = connection.createStatement();
	String star_name=request.getParameter("star_name");
	
	
	
	String starQuery="select name,birthYear from stars as s where s.name=\""+star_name+"\";";
	
	ResultSet starResult = statement.executeQuery(starQuery);
	
	String star_year="";
	
	while(starResult.next()){
		star_year=starResult.getString("birthYear");
		
	}
	
	
	String movieQuery="select m.title, m.id from stars as s, movies as m, stars_in_movies as sm where s.name=\""+star_name+"\" and s.id=sm.starId and sm.movieId=m.id;";
	ResultSet moviesResult = statement.executeQuery(movieQuery);
	ArrayList<String> movies_name = new ArrayList();
	ArrayList<String> movies_id = new ArrayList();
	while(moviesResult.next()){
		movies_name.add(moviesResult.getString("title"));	
		movies_id.add(moviesResult.getString("id"));	
	}
	
	
%>    
   
    
    
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=star_name %></title>
<link rel='stylesheet' href='style.css'>
</head>
<body>
<div>
<h1>Star Information</h1>
<table border>
<tr>
<th colspan="2"><h2><%=star_name %></h2></th>
</tr>
<tr>
<td>Birth Year</td>
<td><%=star_year %></td>
</tr>
<tr>
<td>Movies</td>
<td>
<% for (int i=0;i<movies_name.size();++i){  %>
<a href="MoviePage.jsp?movieId=<%=movies_id.get(i)%>"><label><%= movies_name.get(i) %></label><br />
<%} %>
</td>
</tr>
</table>
</div>
</body>
</html>