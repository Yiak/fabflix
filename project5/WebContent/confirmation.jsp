<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%> 
<%@ page import ="java.util.*"%>   
<%@page import="java.sql.*" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%
String loginUser = "mytestuser";
String loginPasswd = "mypassword";
String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

Class.forName("com.mysql.jdbc.Driver").newInstance();
// create database connection
Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
// declare statement


String user_id=(String)session.getAttribute("id");
Date date = new Date();
SimpleDateFormat dateFormat= new SimpleDateFormat("yyyy/MM/dd");

String query="select s.id ,m.title from sales as s , movies as m "
	+ "where s.saleDate=? and s.customerId=? and s.movieId=m.id;";
	PreparedStatement preparedStatement =connection.prepareStatement(query);
	preparedStatement.setString(1,dateFormat.format(date));
	preparedStatement.setString(2,user_id);
	
	ResultSet salesResult = preparedStatement.executeQuery();
%>  
    
    
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Congratulation</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href='style.css'>
</head>
<body>
<%@ include file="header.html"%>
<h1>Thank You!</h1>
<div>
<table>
<tr>
<th colspan="2"> Purchased List</th>
</tr>
<tr>
<td > Purchased ID</td><td>Movie Title</td>
</tr>
<%while(salesResult.next()){
	String saleID=salesResult.getString("id");
	String movie_title=salesResult.getString("title");
%>
<tr>
<td> <%= saleID%></td><td><%=movie_title %></td>
</tr>
<%} %>
<tr>
<td colspan="2"><a href="SearchPage.jsp?">
<button>Back to Search</button></a></td>
</tr>
</table>
</div>
</body>
</html>