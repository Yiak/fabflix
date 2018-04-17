

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class MovieServlet
 */
@WebServlet("/MovieServlet")
public class MovieServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MovieServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		
		
		// change this to your own mysql username and password
        String loginUser = "mytestuser";
        String loginPasswd = "mypassword";
        String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
		
        // set response mime type
        response.setContentType("text/html"); 

        // get the printwriter for writing response
        PrintWriter out = response.getWriter();

        out.println("<html>");
        out.println("<head><title>Fabflix</title><link rel='stylesheet' href='style.css'></head>");
        
        
        try {
        		Class.forName("com.mysql.jdbc.Driver").newInstance();
        		// create database connection
        		Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
        		// declare statement
        		Statement statement = connection.createStatement();
        		// prepare query
        		String query = "select r_table.title, r_table.year, r_table.director, r_table.rating, group_concat(g.name) as genre_name, r_table.star_name\n" + 
        				"from genres g, genres_in_movies g_m,\n" + 
        				"(select o_table.id, o_table.title, o_table.year, o_table.director, o_table.rating, group_concat(s.name) as star_name\n" + 
        				"from stars s, stars_in_movies s_m\n" + 
        				"inner join\n" + 
        				"(select distinct m.id, m.title, m.year, m.director, r.rating\n" + 
        				"from movies m, ratings r\n" + 
        				"where m.id=r.movieId\n" + 
        				"order by r.rating desc\n" + 
        				"limit 20) as o_table\n" + 
        				"on o_table.id=s_m.movieId\n" + 
        				"where s.id=s_m.starId\n" + 
        				"group by o_table.id,o_table.title, o_table.year, o_table.director, o_table.rating) as r_table\n" + 
        				"where r_table.id=g_m.movieId and g.id=g_m.genreId\n" + 
        				"group by r_table.title, r_table.year, r_table.director, r_table.rating, r_table.star_name\n" + 
        				"order by r_table.rating desc;";
        		// execute query
        		ResultSet resultSet = statement.executeQuery(query);

        		out.println("<body>");
        		out.println("<h1>MovieDB Top 20</h1>");
        		
        		out.println("<table border>");
        		
        		// add table header row
        		out.println("<tr>");
        		out.println("<td>title</td>");
        		out.println("<td>year</td>");
        		out.println("<td>director</td>");
        		out.println("<td>rating</td>");
        		out.println("<td>genres</td>");
        		out.println("<td>stars</td>");

        		out.println("</tr>");
        		
        		// add a row for every star result
        		while (resultSet.next()) {
        			// get a star from result set
        			
        			String movieTitle = resultSet.getString("title");
        			String movieYear = resultSet.getString("year");
        			String movieDirector = resultSet.getString("director");
        			String movieRating = resultSet.getString("rating");
        			String movieGenre = resultSet.getString("genre_name");
        			String movieStars = resultSet.getString("star_name");
        			out.println("<tr>");
        			out.println("<td>" + movieTitle + "</td>");
        			out.println("<td>" + movieYear + "</td>");
        			out.println("<td>" + movieDirector + "</td>");
        			out.println("<td>" + movieRating + "</td>");
        			out.println("<td>" + movieGenre + "</td>");
        			out.println("<td>" + movieStars + "</td>");
        			out.println("</tr>");
        		}
        		
        		out.println("</table>");
        		
        		out.println("</body>");
        		
        		resultSet.close();
        		statement.close();
        		connection.close();
        		
        } catch (Exception e) {
        		/*
        		 * After you deploy the WAR file through tomcat manager webpage,
        		 *   there's no console to see the print messages.
        		 * Tomcat append all the print messages to the file: tomcat_directory/logs/catalina.out
        		 * 
        		 * To view the last n lines (for example, 100 lines) of messages you can use:
        		 *   tail -100 catalina.out
        		 * This can help you debug your program after deploying it on AWS.
        		 */
        		e.printStackTrace();
        		
        		out.println("<body>");
        		out.println("<p>");
        		out.println("Exception in doGet: " + e.getMessage());
        		out.println("</p>");
        		out.print("</body>");
        }
        
        out.println("</html>");
        out.close();
        
	}
		
		
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
