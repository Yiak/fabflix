import com.google.gson.JsonObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

//
@WebServlet(name = "LoginServlet", urlPatterns = "/api/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;


    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        

    	response.setContentType("text/html");
		
		String loginUser = "mytestuser";
        String loginPasswd = "mypassword";
        String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
        PrintWriter out = response.getWriter();
        try {
	        Class.forName("com.mysql.jdbc.Driver").newInstance();
			
			Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			
			Statement statement = connection.createStatement();
			
			String password=request.getParameter("password");
			String user=request.getParameter("user_email");
			
			
			String query="select id, firstName, lastName from customers where email=\""+user+"\" and password=\""+password+"\";";
			System.out.println("The user email is: "+user+" password is "+password);
			ResultSet resultSet = statement.executeQuery(query);
			
			
			
			
			int user_id=-1;
			if(resultSet.next()) {
				user_id= (int) resultSet.getInt("id");
			}

			System.out.println("The user_id is: "+user_id);
			
        
			if (user_id==-1) {
				JsonObject responseJsonObject = new JsonObject();
	            responseJsonObject.addProperty("status", "fail");
	            responseJsonObject.addProperty("message", "email or password incorrect!");
	            response.getWriter().write(responseJsonObject.toString());
			
			}else {
				HttpSession session = request.getSession(true);
				
				session.setAttribute("id", user_id);
				session.setAttribute("isLogin", 1);
				
				
				JsonObject responseJsonObject = new JsonObject();
	            responseJsonObject.addProperty("status", "success");
	            responseJsonObject.addProperty("message", "success");

	            response.getWriter().write(responseJsonObject.toString());
				
				
			}
    }catch(Exception e) {
    	e.printStackTrace();
		
		out.println("<body>");
		out.println("<p>");
		out.println("Exception in doGet: " + e.getMessage());
		out.println("</p>");
		out.print("</body>");
    }


    }
}
