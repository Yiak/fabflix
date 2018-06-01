
import java.io.IOException;
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


@WebServlet("/autocomplete")
public class AutoComplete extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/*
	 * populate the Marvel heros and DC heros hash map.
	 * Key is hero ID. Value is hero name.
	 */
	

	
	public static HashMap<Integer, String> marvelHerosMap = new HashMap<>();
	public static HashMap<Integer, String> dcHerosMap = new HashMap<>();
	String a;
	static {
		marvelHerosMap.put(1, "Blade");
		marvelHerosMap.put(2, "Ghost Rider");
		marvelHerosMap.put(3, "Luke Cage");
		marvelHerosMap.put(4, "Silver Surfer");
		marvelHerosMap.put(5, "Beast");
		marvelHerosMap.put(6, "Thing");
		marvelHerosMap.put(7, "Black Panther");
		marvelHerosMap.put(8, "Invisible Woman");
		marvelHerosMap.put(9, "Nick Fury");
		marvelHerosMap.put(10, "Storm");
		marvelHerosMap.put(11, "Iron Man");
		marvelHerosMap.put(12, "Professor X");
		marvelHerosMap.put(13, "Hulk");
		marvelHerosMap.put(14, "Cyclops");
		marvelHerosMap.put(15, "Thor");
		marvelHerosMap.put(16, "Jean Grey");
		marvelHerosMap.put(17, "Wolverine");
		marvelHerosMap.put(18, "Daredevil");
		marvelHerosMap.put(19, "Captain America");
		marvelHerosMap.put(20, "Spider-Man");
	}
	
	static {
		dcHerosMap.put(101, "Superman");
		dcHerosMap.put(102, "Batman");
		dcHerosMap.put(103, "Wonder Woman");
		dcHerosMap.put(104, "Flash");
		dcHerosMap.put(105, "Green Lantern");
		dcHerosMap.put(106, "Catwoman");
		dcHerosMap.put(107, "Nightwing");
		dcHerosMap.put(108, "Captain Marvel");
		dcHerosMap.put(109, "Aquaman");
		dcHerosMap.put(110, "Green Arrow");
		dcHerosMap.put(111, "Martian Manhunter");
		dcHerosMap.put(112, "Batgirl");
		dcHerosMap.put(113, "Supergirl");
		dcHerosMap.put(114, "Black Canary");
		dcHerosMap.put(115, "Hawkgirl");
		dcHerosMap.put(116, "Cyborg");
		dcHerosMap.put(117, "Robin");
	}
    
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
		

		String loginUser = "mytestuser";
	    String loginPasswd = "mypassword";
	    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
		
		
		try {
			
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			
			Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			
			
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
