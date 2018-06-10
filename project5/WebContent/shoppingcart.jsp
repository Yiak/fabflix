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

String user_id=(String)session.getAttribute("id");
Map<String,Integer> previousItems = (Map<String,Integer>)session.getAttribute("previousItems");
if (previousItems == null) {
    previousItems = new HashMap();
    session.setAttribute("previousItems", previousItems); 
}

String movieId = request.getParameter("movieId");
if(movieId!=null){
	String q=request.getParameter("q");
	if(q.equals("233")){
		q="1";
	}
	if(previousItems.get(movieId)==null){
		previousItems.put(movieId,1);
	}else if (Integer.parseInt(q)<0){
		q=Integer.toString(previousItems.get(movieId));
	}else{
		previousItems.put(movieId,Integer.parseInt(q));
	}
	
	
	session.setAttribute("previousItems", previousItems); 
}

%>    
      
    
    
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Shopping Cart</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href='style.css'>
</head>
<body>
<%@ include file="header.html"%>
<br />
<div>
<table border>
<tr><th colspan="3">Shopping Cart</th></tr>
<td >Movie Name</td><td>Quantity</td><td>Modify the Quantity</td></tr>
<%
int exist_item=0;
for(String m_id:previousItems.keySet()){ 
	int quantity=previousItems.get(m_id);
	
	if(quantity>0){
	exist_item=1;
	String movie_title="";
	String movieQuery="select title from movies where id=?;";
	PreparedStatement preparedStatement = connection.prepareStatement(movieQuery);
	preparedStatement.setString(1, m_id);
	ResultSet movieResult = preparedStatement.executeQuery();
	while(movieResult.next()){
		movie_title=movieResult.getString("title");
	}%>
<tr>
<td><%=movie_title %></td><td><%=quantity%></td>
<td>
<form id="quantity_form" method="post" action="shoppingcart.jsp">
<input type="hidden" name="movieId" value="<%=m_id%>">
<input type="text" name="q" placeholder="<%=quantity%>" value="<%=quantity%>">
<input type="submit" value="Apply">
</form>
<a href="shoppingcart.jsp?movieId=<%=m_id %>&q=0">
<button>Delete All</button></a>
</td>
</tr>

<%}
}%>
<tr>
<td colspan="3"><a href="index.html">
<button>Continue Shopping</button></a></td>
</tr>
<% if(exist_item==1){ %>
<tr>
<td colspan="3">
<a href="checkout.jsp">
<button>Checkout!</button></a></td>
</td>
</tr>
<%} %>
</table>


</body>
</html>