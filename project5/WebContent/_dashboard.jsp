<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%> 
<%@ page import ="java.util.*"%>   
<%@page import="java.sql.*" %>

<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="javax.naming.Context" %>
<%@page import="javax.naming.InitialContext" %>
<%@page import="javax.sql.*" %>
<% 
	HttpServletRequest httpRequest = (HttpServletRequest) request;
	HttpServletResponse httpResponse = (HttpServletResponse) response;
	if (httpRequest.getSession().getAttribute("isEmployeeLogin") == null) {
		System.out.println("check here");
	    httpResponse.sendRedirect("_dashboard.html");
	    } 
	
	

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
	
	
	
    
	String Query ="SELECT table_name  FROM information_schema.tables where table_schema=\"moviedb\";";
	PreparedStatement preparedStatement= connection.prepareStatement(Query);
	ResultSet rs = preparedStatement.executeQuery();
	ArrayList<String> tables = new ArrayList();
	while (rs.next()){
		tables.add(rs.getString("table_name"));
	}
%>
  
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Employee Dashboard</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href="style.css">
</head>
<body>
<%@ include file="header.html"%>
<br />
<h1>Welcome back</h1>
<%
for(String tableName:tables){
	String subQuery="show fields from "+tableName+";";
	PreparedStatement subStatement=connection.prepareStatement(subQuery);
	ResultSet each_table=subStatement.executeQuery();
	%>
	<table><tr>
	<th colspan="2" ><%= tableName %></th></tr>
	<tr>
	<th>Field</th><th>Type</th>
	</tr>
	<% 
	while(each_table.next()){
		String field=each_table.getString("Field");
		String type=each_table.getString("Type");
		String isNull=each_table.getString("Null");
		%>
	<tr>
	<td><%=field %></td><td><%=type %></td>
	</tr>
<% 
	} 
	%>
</table>
<br />
<%
}
%>
<div align=center>
<table style="background:#ffc107">
<tr>
<th style="background:#ffc107" > Insert New Star</th>
</tr>
<tr><td style="background:#ffc107">
<form id="insert_star" method="get" action="insertStar.jsp">
    <label><b>Star name</b></label>
    <br />
    <input type="text" placeholder="Star name" name="name">
    <br />
    </td></tr>
    <tr><td style="background:#ffc107">
    <label><b>Birth Year</b></label>
    <br />
    <input type="text" placeholder="Birth Year" name="year" onkeyup="this.value=this.value.replace(/[^0-9-]+/,'');" >
    <br />
    </td></tr>
    <tr><td style="background:#ffc107">
    <input type="submit" value="Insert">
</form>
</td></tr>
</table>
</div>
<br />
<div align=center>
<table style="background:#ffc107">
<tr>
<th style="background:#ffc107" > Insert New Movie</th>
</tr>
<tr><td style="background:#ffc107">
<form id="insert_movie" method="get" action="insertMovie.jsp">
    <label><b>Movie name</b></label>
    <br />
    <input type="text" placeholder="Movie name" name="name" required="required">
    <br />
    </td></tr>
    <tr><td style="background:#ffc107">
    <label><b>Director</b></label>
    <br />
    <input type="text" placeholder="Director" name="director" required="required">
    <br />
    </td></tr>
    <tr><td style="background:#ffc107">
    <label><b>Year</b></label>
    <br />
    <input type="text" placeholder="Year" name="year" onkeyup="this.value=this.value.replace(/[^0-9-]+/,'');" required="required">
    <br />
    </td></tr>
    <tr><td style="background:#ffc107">
    <label><b>Genre</b></label>
    <br />
    <input type="text" placeholder="Genre" name="genre"  required="required">
    <br />
    </td></tr>
    </td></tr>
    <tr><td style="background:#ffc107">
    <label><b>Star</b></label>
    <br />
    <input type="text" placeholder="Star" name="star" required="required" >
    <br />
    </td></tr>
    <tr><td style="background:#ffc107">
    <input type="submit" value="Insert">
</form>
</td></tr>
</table>
</div>
<br />
</body>
</html>