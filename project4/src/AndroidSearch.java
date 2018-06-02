import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

@WebServlet(name = "AndroidSearch", urlPatterns = "/api/android_search")




public class AndroidSearch extends HttpServlet
{
    public String getServletInfo()
    {
       return "Servlet connects to MySQL database and displays result of a SELECT";
    }

    // Use http GET

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
      
		String loginUser = "mytestuser";
        String loginPasswd = "mypassword";
        String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

        response.setContentType("application/json");    // Response mime type

        // Output stream to STDOUT
        PrintWriter out = response.getWriter();
    
        

        try
           {
        	Class.forName("com.mysql.jdbc.Driver").newInstance();
			
			Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			

            
              // Declare our statement
              

              String input = request.getParameter("search");
              System.out.println("user input " + input);
 
            
              String query="select m.id from (select m.id,m.title from movies as m, "
      				+ "(select distinct sm.movieId  from stars_in_movies as sm, stars as s "
      				+ "where s.name like ? and s.id=sm.starId) as nm "
      				+ "where m.title LIKE ? "
      				+ "and nm.movieid=m.id) as m left join ratings as r on r.movieId=m.id "
      				+ "limit ? "
      				+ "offset ?;";
              
              PreparedStatement preparedStatement=connection.prepareStatement(query);
              preparedStatement.setString(1,"%"+star_name+"%");
              
              // Perform the query
              ResultSet rs = pstmt.executeQuery();
              //ResultSet rs = statement.executeQuery(query);

             
         
              
              JsonArray jsonArray = new JsonArray();
              while (rs.next())
              {
            	  	  String movie_id = rs.getString(1);
                  String movie_title = rs.getString(2);
                  int movie_year = rs.getInt(3);
                  String movie_director = rs.getString(4);
                  String star_name = rs.getString(5);
                  String genre_type = rs.getString(6);
                  double rating = rs.getDouble(7);
                  
//                  System.out.print(movie_id);
//                  System.out.print(movie_title);
//                  System.out.print(movie_year);
//                  System.out.print(movie_director);
//                  System.out.print(star_name);
//                  System.out.print(genre_type);
//                  System.out.println(rating);
//                  
                  
                  JsonObject jsonObject = new JsonObject();
                  jsonObject.addProperty("movie_id", movie_id);
                  jsonObject.addProperty("movie_title", movie_title);
                  jsonObject.addProperty("movie_year", movie_year);
                  jsonObject.addProperty("movie_director", movie_director);
                  jsonObject.addProperty("star_name", star_name);
                  jsonObject.addProperty("genre_type", genre_type);
                  jsonObject.addProperty("rating", rating);
                  
                  jsonArray.add(jsonObject);
                  
                  
              }
              out.write(jsonArray.toString());
              System.out.println(" after json");
              rs.close();
              statement.close();
              connection.close();
             
              
              System.out.println(" go back to jsssss");
              
              
            }
        catch (SQLException ex) {
              while (ex != null) {
                    System.out.println ("SQL Exception:  " + ex.getMessage ());
                    ex = ex.getNextException ();
                }  // end while
            }  // end catch SQLException

        catch(java.lang.Exception ex)
            {
                out.println("<HTML>" +
                            "<HEAD><TITLE>" +
                            "MovieDB: Error" +
                            "</TITLE></HEAD>\n<BODY>" +
                            "<P>SQL error in doGet: " +
                            ex.getMessage() + "</P></BODY></HTML>");
                return;
            }
         out.close();
    }
    
    /* public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
	doGet(request, response);
	} */
 
}
