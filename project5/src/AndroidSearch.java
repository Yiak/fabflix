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
      
		

        // Output stream to STDOUT
        PrintWriter out = response.getWriter();
    
        

        try
           {
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
              // Declare our statement
              

              String input = request.getParameter("search");
              System.out.println("user input " + input);
 
            
              String query="select id, title, year,director from movies where title like ?";
              
              PreparedStatement preparedStatement=connection.prepareStatement(query);
              preparedStatement.setString(1,"%"+input+"%");
              
              // Perform the query
              ResultSet rs = preparedStatement.executeQuery();
              //ResultSet rs = statement.executeQuery(query);

             
         
              
              JsonArray jsonArray = new JsonArray();
              while (rs.next())
              {
            	  
            	  String movie_id = rs.getString(1);
                  String movie_title = rs.getString(2);
                  int movie_year = rs.getInt(3);
                  String movie_director = rs.getString(4);
                
                  
                  System.out.println(movie_id);
                  
                  
                  Statement temp_statement = connection.createStatement(); 
                  String genresQuery="select g.name from genres as g, genres_in_movies as gm where gm.movieId=\""+movie_id+"\" and gm.genreId=g.id;";
              		ResultSet genresResult = temp_statement.executeQuery(genresQuery);
              		String genre_type = "";
              		while(genresResult.next()){
              			genre_type+=genresResult.getString("name");	
              		}
              	
              		String starsQuery="select s.name from stars as s, stars_in_movies as sm where sm.movieId=\""+movie_id+"\" and sm.starId=s.id;";
              		ResultSet starsResult = temp_statement.executeQuery(starsQuery);
              		String star_name = "";
              		while(starsResult.next()){
              			star_name+=starsResult.getString("name");	
              		}
                  
                  
              		String ratingQuery="select rating from ratings where movieId=\""+movie_id+"\";";
              		
              		ResultSet ratingResult = temp_statement.executeQuery(ratingQuery);
              		String rating="null";
              		while(ratingResult.next()){
              			rating=ratingResult.getString("rating");	
              		}
              		
              		
                  
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
                  temp_statement.close();
                  
                  
              }
              response.getWriter().write(jsonArray.toString());
              System.out.println(" after json");
              rs.close();
              preparedStatement.close();
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
