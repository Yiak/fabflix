<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%> 
<%@ page import ="java.util.*"%>   
<%@page import="java.sql.*" %>
<%@page import="javax.naming.Context" %>
<%@page import="javax.naming.InitialContext" %>
<%@page import="javax.sql.*" %>

<%
String loginUser = "mytestuser";
String loginPasswd = "mypassword";
String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

Class.forName("com.mysql.jdbc.Driver").newInstance();
// create database connection
Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
// declare statement
String star_name=request.getParameter("name");
String star_year=request.getParameter("year");
if(star_year.equals("")){
	star_year=null;
}
String maxIDquery="select max(id) as id from stars;";
System.out.println(star_year);
PreparedStatement preparedStatement =connection.prepareStatement(maxIDquery);
ResultSet rs=preparedStatement.executeQuery();
String maxid="";
while(rs.next()){
	maxid = rs.getString("id");
	maxid = "nm" + (Integer.parseInt(maxid.substring(2,maxid.length()))+1);
}

String insertQuery="INSERT INTO stars(id,name,birthYear) VALUES(?,?,?);";
PreparedStatement insertStatement =connection.prepareStatement(insertQuery);
insertStatement.setString(1,maxid);
insertStatement.setString(2,star_name);
if(star_year==null){
	insertStatement.setString(3,star_year);
}else{
insertStatement.setInt(3,Integer.parseInt(star_year));
}
int result=insertStatement.executeUpdate();


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert Star</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href='style.css'>
</head>
<body>
<br />
<table><tr><td><h1>Query OK, <%=result %> row affected</h1></td></tr>
<tr><td><a href="_dashboard.jsp?">
<button>Back to Dashboard</button></a></td></tr>
</table>

</body>
</html>