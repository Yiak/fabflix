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


    String loginUser = "mytestuser";
    String loginPasswd = "mypassword";
    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	
    Class.forName("com.mysql.jdbc.Driver").newInstance();
	// create database connection
	Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
	// declare statement
	
	String star_name=request.getParameter("star_name");
	
	
	
	String starQuery="select name,birthYear from stars as s where s.name=?;";
	PreparedStatement starStatement= connection.prepareStatement(starQuery);
	starStatement.setString(1,star_name);
	ResultSet starResult = starStatement.executeQuery();
	
	String star_year="";
	
	while(starResult.next()){
		star_year=starResult.getString("birthYear");
		
	}
	
	
	String moviesQuery="select m.title, m.id from stars as s, movies as m, stars_in_movies as sm where s.name=? and s.id=sm.starId and sm.movieId=m.id;";
	PreparedStatement moviesStatement= connection.prepareStatement(moviesQuery);
	moviesStatement.setString(1,star_name);
	ResultSet moviesResult = moviesStatement.executeQuery();
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
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href='style.css'>
</head>
<body>
<%@ include file="header.html"%>
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
<a href="MoviePage.jsp?movieId=<%=movies_id.get(i)%>"><label><%= movies_name.get(i) %></label></a><br />
<%} %>
</td>
</tr>
<tr>
<td colspan="2"><a href="SearchPage.jsp?">
<button>Back to Search</button></a></td>
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