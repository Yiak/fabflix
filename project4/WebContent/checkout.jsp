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
Statement statement = connection.createStatement();

String user_id=(String)session.getAttribute("id");
Map<String,Integer> previousItems = (Map<String,Integer>)session.getAttribute("previousItems");



String check = request.getParameter("check");
if(check==null){
	check="";
}else{
	String firstname = request.getParameter("firstname");
	String lastname = request.getParameter("lastname");
	String cardnumber = request.getParameter("cardnumber");
	String expiredate = request.getParameter("expiredate");
	
	String query="select id from creditcards where firstName=? and lastName=? and id=? and expiration=?;";
	PreparedStatement preparedStatement =connection.prepareStatement(query);
	
	preparedStatement.setString(1,firstname );
	preparedStatement.setString(2,lastname );
	preparedStatement.setString(3,cardnumber);
	preparedStatement.setString(4,expiredate );
	
	//System.out.println("The user email is: ");
	ResultSet resultSet = preparedStatement.executeQuery();
	
	
	
	
	String card_number="-1";
	if(resultSet.next()) {
		card_number= resultSet.getString("id");
	}
	
	if(card_number=="-1"){
		check="no";
	}else{
		String insertQuery="";
		for(String m_id:previousItems.keySet()){
			int quantity=previousItems.get(m_id);
			while(quantity>0){
				Date date = new Date();
				SimpleDateFormat dateFormat= new SimpleDateFormat("yyyy/MM/dd");
				System.out.println(dateFormat.format(date));
				insertQuery="INSERT INTO sales VALUES(null, "+user_id+",\""+m_id+"\",\""+dateFormat.format(date)+"\");";
				int insertResult = statement.executeUpdate(insertQuery);
				System.out.println("Insert result is:"+insertResult);
				quantity-=1;
			}
		}
		previousItems.clear();
		request.setAttribute("previousItems", previousItems);
		response.sendRedirect("confirmation.jsp"); 
	}
}



%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Checkout</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href='style.css'>
</head>
<body>
<%@ include file="header.html"%>
<br />
<div align="center"><h2>Check Credit Card Info</h2></div>
<%if(check.equals("no")){ %>
<table >
<tr>
<td>Credit Card Information Incorrect<br />Please Try Again!</td></tr></table>
<%} %>
<%if(check==""||check.equals("no")){ %>
<br />
<div align="center">
<!-- Set the method to POST to avoid username/password showing on URL
     Disable the default action because our JS function will handle it. -->
<table >
<tr>
<td>
<form id="login_form" method="post" action="checkout.jsp">
    <label><b>Last Name</b></label>
    <input type="text" placeholder="Last Name" name="lastname" value="">
    </td></tr>
    <tr><td>
    <label><b>First Name</b></label>
    <input type="text" placeholder="First Name" name="firstname" value="">
    </td></tr>
    <tr><td>
    <label><b>Card Number</b></label>
    <input type="text" placeholder="Card Number" name="cardnumber" value="">
    </td></tr>
    <tr><td>
    <label><b>Expire Date</b></label>
    <input type="text" placeholder="YYYY/MM/DD" name="expiredate" value="">
    <input type="hidden" name="check" value="yes">
    </td></tr>
    <tr><td>
    <input type="submit" value="Check Credit Card Info">
</form>
</td>
</tr>
</table>
<%} %>
</body>
</html>