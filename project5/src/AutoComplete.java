
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.*;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import javax.sql.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;

@WebServlet("/autocomplete")
public class AutoComplete extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/*
	 * populate the Marvel heros and DC heros hash map.
	 * Key is hero ID. Value is hero name.
	 */
	

	
	
	
    public AutoComplete() {
        super();
    }

    /*
     * 
     * Match the query against Marvel and DC heros and return a JSON response.
     * 
     * For example, if the query is "super":
     * The JSON response look like this:
     * [
     * 	{ "value": "Superman", "data": { "category": "dc", "heroID": 101 } },
     * 	{ "value": "Supergirl", "data": { "category": "dc", "heroID": 113 } }
     * ]
     * 
     * The format is like this because it can be directly used by the 
     *   JSON auto complete library this example is using. So that you don't have to convert the format.
     *   
     * The response contains a list of suggestions.
     * In each suggestion object, the "value" is the item string shown in the dropdown list,
     *   the "data" object can contain any additional information.
     * 
     * 
     */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 PrintWriter out = response.getWriter();

		
		try {
			
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
			
			
			// setup the response json arrray
			JsonArray jsonArray = new JsonArray();
			
			// get the query string from parameter
			String query = request.getParameter("query");
			
			// return the empty json array if query is null or empty
			if (query == null || query.trim().isEmpty()) {
				response.getWriter().write(jsonArray.toString());
				return;
			}	
			
			// search on marvel heros and DC heros and add the results to JSON Array
			// this example only does a substring match
			// TODO: in project 4, you should do full text search with MySQL to find the matches on movies and stars
			
			String title_query="select * from movies where title like ? limit 5";
			PreparedStatement preparedStatement=connection.prepareStatement(title_query);
			preparedStatement.setString(1,"%"+query+"%");
			
			
			ResultSet resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				String movieId = resultSet.getString("id");
				String movieTitle = resultSet.getString("title");
				jsonArray.add(generateJsonObject(movieId, movieTitle, "movie"));
			}
			
			
			
			response.getWriter().write(jsonArray.toString());
			return;
		} catch (Exception e) {
			System.out.println(e);
			response.sendError(500, e.getMessage());
		}
	}
	
	/*
	 * Generate the JSON Object from hero and category to be like this format:
	 * {
	 *   "value": "Iron Man",
	 *   "data": { "category": "marvel", "heroID": 11 }
	 * }
	 * 
	 */
	private static JsonObject generateJsonObject(String movieId, String movieTitle, String categoryName) {
		JsonObject jsonObject = new JsonObject();
		jsonObject.addProperty("value", movieTitle);
		
		JsonObject additionalDataJsonObject = new JsonObject();
		additionalDataJsonObject.addProperty("category", categoryName);
		additionalDataJsonObject.addProperty("movieId", movieId);
		
		jsonObject.add("data", additionalDataJsonObject);
		return jsonObject;
	}


}
