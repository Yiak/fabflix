<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@ page import ="java.util.ArrayList"%>
<%@ page import ="java.util.List"%>
<%@ page import ="java.util.*"%> 
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
    DataSource ds = (DataSource) envCtx.lookup("jdbc/InsertDB");


    if (ds == null)
        out.println("ds is null.");

    Connection connection = ds.getConnection();
    if (connection == null)
        out.println("dbcon is null.");
    
	String movie_name=request.getParameter("name");
	String movie_director=request.getParameter("director");
	String movie_year=request.getParameter("year");
	String movie_genre=request.getParameter("genre");
	String movie_star=request.getParameter("star");
	
	String check_exist_query="select * from movies where title=? and director=? and year=?;";
	PreparedStatement preparedStatement=connection.prepareStatement(check_exist_query);
	preparedStatement.setString(1,movie_name);
	preparedStatement.setString(2,movie_director);
	preparedStatement.setString(3,movie_year);
	
	ResultSet rs=preparedStatement.executeQuery();
	
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert New Movie</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<link rel='stylesheet' href="style.css">
</head>
<body>
<%@ include file="header.html"%>
<%
String m_id="-1";
while(rs.next()){
	m_id=rs.getString("id");
}
if(!m_id.equals("-1")){
	%>
	<br />
	<table>
	<tr><th colspan="2">Sorry! The movie is already existed in the moviedb.</th></tr>
	<tr>
	<td  ><a href="_dashboard.jsp?">
	<button>Back to Dashboard</button></a></td>
	<td  ><a href="MoviePage.jsp?movieId=<%= m_id %>&q=233">
	<button>Check movie infomation</button></a></td>
	</tr>
	</table>
	<% 
}else{
	String find_star_query="select * from stars where name=?;";
	PreparedStatement starStatement=connection.prepareStatement(find_star_query);
	starStatement.setString(1,movie_star);
	ResultSet star_rs=starStatement.executeQuery();
	String star_id="-1";
	while(star_rs.next()){
		star_id=star_rs.getString("id");
	}
	if (star_id.equals("-1")){
		
		String maxStarIDquery="select max(id) as id from stars;";
		
		PreparedStatement findMaxIdStatement =connection.prepareStatement(maxStarIDquery);
		ResultSet max_star_id_rs=findMaxIdStatement.executeQuery();
		String max_star_id="";
		while(max_star_id_rs.next()){
			max_star_id = max_star_id_rs.getString("id");
			max_star_id = "nm" + (Integer.parseInt(max_star_id.substring(2,max_star_id.length()))+1);
		}

		String insert_star_Query="INSERT INTO stars(id,name) VALUES(?,?);";
		PreparedStatement insert_star_Statement =connection.prepareStatement(insert_star_Query);
		insert_star_Statement.setString(1,max_star_id);
		insert_star_Statement.setString(2,movie_star);
		
		int result=insert_star_Statement.executeUpdate();
		star_id=max_star_id;
	}
	
	
	
	
	String find_genre_query="select * from genres where name=?;";
	PreparedStatement genreStatement=connection.prepareStatement(find_genre_query);
	genreStatement.setString(1,movie_genre);
	ResultSet genre_rs=genreStatement.executeQuery();
	String genre_id="-1";
	while(genre_rs.next()){
		genre_id=genre_rs.getString("id");
	}
	if (genre_id.equals("-1")){
		
		String maxGenreIDquery="select max(id) as id from genres;";
		
		PreparedStatement findMaxGenreStatement =connection.prepareStatement(maxGenreIDquery);
		ResultSet max_genre_id_rs=findMaxGenreStatement.executeQuery();
		String max_genre_id="";
		while(max_genre_id_rs.next()){
			max_genre_id = max_genre_id_rs.getString("id");
			max_genre_id = ""+(Integer.parseInt(max_genre_id)+1);
		}

		String insert_genre_Query="INSERT INTO genres VALUES(?,?);";
		PreparedStatement insert_genre_Statement =connection.prepareStatement(insert_genre_Query);
		insert_genre_Statement.setString(1,max_genre_id);
		insert_genre_Statement.setString(2,movie_genre);
		
		int result=insert_genre_Statement.executeUpdate();
		genre_id=max_genre_id;
	}
	
	
	
	String maxMovieIDquery="select max(id) as id from movies;";
	
	PreparedStatement findMaxMovieStatement =connection.prepareStatement(maxMovieIDquery);
	ResultSet max_movie_id_rs=findMaxMovieStatement.executeQuery();
	String max_movie_id="";
	while(max_movie_id_rs.next()){
		max_movie_id = max_movie_id_rs.getString("id");
		max_movie_id = "tt" + (Integer.parseInt(max_movie_id.substring(2,max_movie_id.length()))+1);
	}
	
	String insert_movie_query="INSERT INTO movies VALUES(?,?,?,?);";
	PreparedStatement insertMovieStatement =connection.prepareStatement(insert_movie_query);
	insertMovieStatement.setString(1,max_movie_id);
	insertMovieStatement.setString(2,movie_name);
	insertMovieStatement.setString(3,movie_year);
	insertMovieStatement.setString(4,movie_director);
	int movie_result=insertMovieStatement.executeUpdate();
	
	String insert_sm_query="INSERT INTO stars_in_movies VALUES(?,?);";
	PreparedStatement insertSMStatement =connection.prepareStatement(insert_sm_query);
	insertSMStatement.setString(1,star_id);
	insertSMStatement.setString(2,max_movie_id);
	int sm_result=insertSMStatement.executeUpdate();
	
	String insert_gm_query="INSERT INTO genres_in_movies VALUES(?,?);";
	PreparedStatement insertGMStatement =connection.prepareStatement(insert_gm_query);
	insertGMStatement.setString(1,genre_id);
	insertGMStatement.setString(2,max_movie_id);
	int gm_result=insertGMStatement.executeUpdate();

	String insert_rating_query="INSERT INTO ratings VALUES(?,0.0,0);";
	PreparedStatement insertRStatement =connection.prepareStatement(insert_rating_query);
	insertRStatement.setString(1,max_movie_id);
	int rating_result=insertRStatement.executeUpdate();
	%>

<br />
	<table>
	<tr><th colspan="2">Insert Finished</th></tr>
	<tr>
	<td  ><a href="_dashboard.jsp?">
	<button>Back to Dashboard</button></a></td>
	<td  ><a href="MoviePage.jsp?movieId=<%= max_movie_id %>&q=233">
	<button>Check movie infomation</button></a></td>
	</tr>
	</table>
	
	
	<% 
	
}
%>
</body>
</html>