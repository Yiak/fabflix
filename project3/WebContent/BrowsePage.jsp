<%@page import="java.sql.*" %>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	HttpServletRequest httpRequest = (HttpServletRequest) request;
	HttpServletResponse httpResponse = (HttpServletResponse) response;
	

	
    String loginUser = "mytestuser";
    String loginPasswd = "mypassword";
    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
    
    String Query="select * from genres;";
	PreparedStatement genresStatement=connection.prepareStatement(Query);
	
	ResultSet rs = genresStatement.executeQuery();
	ArrayList<String> genres = new ArrayList();
	while(rs.next()){
		genres.add(rs.getString("name"));	
	}
    
    
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Browse the Movies</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href='style.css'>
</head>
<body>
<%@ include file="header.html"%>
<div>
<h1>Browse by movie title first alphanumeric letter</h1>
<a href="search.jsp?title=a&browse_type=a&start_from=1&number_per_page=20">
<button>A</button></a>
<a href="search.jsp?title=b&browse_type=a&start_from=1&number_per_page=20">
<button>B</button></a>
<a href="search.jsp?title=c&browse_type=a&start_from=1&number_per_page=20">
<button>C</button></a>
<a href="search.jsp?title=d&browse_type=a&start_from=1&number_per_page=20">
<button>D</button></a>
<a href="search.jsp?title=e&browse_type=a&start_from=1&number_per_page=20">
<button>E</button></a>
<a href="search.jsp?title=f&browse_type=a&start_from=1&number_per_page=20">
<button>F</button></a>
<a href="search.jsp?title=g&browse_type=a&start_from=1&number_per_page=20">
<button>G</button></a>
<a href="search.jsp?title=h&browse_type=a&start_from=1&number_per_page=20">
<button>H</button></a>
<a href="search.jsp?title=i&browse_type=a&start_from=1&number_per_page=20">
<button>I</button></a>
<a href="search.jsp?title=j&browse_type=a&start_from=1&number_per_page=20">
<button>J</button></a>
<a href="search.jsp?title=k&browse_type=a&start_from=1&number_per_page=20">
<button>K</button></a>
<a href="search.jsp?title=l&browse_type=a&start_from=1&number_per_page=20">
<button>L</button></a>
<a href="search.jsp?title=m&browse_type=a&start_from=1&number_per_page=20">
<button>M</button></a>
<a href="search.jsp?title=n&browse_type=a&start_from=1&number_per_page=20">
<button>N</button></a>
<a href="search.jsp?title=o&browse_type=a&start_from=1&number_per_page=20">
<button>O</button></a>
<a href="search.jsp?title=p&browse_type=a&start_from=1&number_per_page=20">
<button>P</button></a>
<a href="search.jsp?title=q&browse_type=a&start_from=1&number_per_page=20">
<button>Q</button></a>
<a href="search.jsp?title=r&browse_type=a&start_from=1&number_per_page=20">
<button>R</button></a>
<a href="search.jsp?title=s&browse_type=a&start_from=1&number_per_page=20">
<button>S</button></a>
<a href="search.jsp?title=t&browse_type=a&start_from=1&number_per_page=20">
<button>T</button></a>
<a href="search.jsp?title=u&browse_type=a&start_from=1&number_per_page=20">
<button>U</button></a>
<a href="search.jsp?title=v&browse_type=a&start_from=1&number_per_page=20">
<button>V</button></a>
<a href="search.jsp?title=w&browse_type=a&start_from=1&number_per_page=20">
<button>W</button></a>
<a href="search.jsp?title=x&browse_type=a&start_from=1&number_per_page=20">
<button>X</button></a>
<a href="search.jsp?title=y&browse_type=a&start_from=1&number_per_page=20">
<button>Y</button></a>
<a href="search.jsp?title=z&browse_type=a&start_from=1&number_per_page=20">
<button>Z</button></a>
</div>
<div>
<h1>Browse by movie genre</h1>
<a href="search.jsp?browse_genre=action&browse_type=g&start_from=1&number_per_page=20">
<button>Action</button></a>

<%
for(String genre:genres){
	%>
<a href="search.jsp?browse_genre=<%=genre %>&browse_type=g&start_from=1&number_per_page=20">
<button><%=genre %></button></a>
	<% 
}
%>

</div>
</body>
</html>