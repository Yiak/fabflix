import com.google.gson.JsonObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;


import org.jasypt.util.password.PasswordEncryptor;
import org.jasypt.util.password.StrongPasswordEncryptor;

//
@WebServlet(name = "AndroidLogin", urlPatterns = "/api/android_login")
public class AndroidLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;


    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	PrintWriter out = response.getWriter();

    	response.setContentType("text/html");
    	

    	
		String loginUser = "mytestuser";
        String loginPasswd = "mypassword";
        String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
        
        try {
	        Class.forName("com.mysql.jdbc.Driver").newInstance();
			
			Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			
			
			
			String password=request.getParameter("password");
			String user=request.getParameter("user_email");
			
			PasswordEncryptor passwordEncryptor = new StrongPasswordEncryptor();
			String query = "SELECT * from customers where email= ?;";
			PreparedStatement preparedStatement =connection.prepareStatement(query);
			
			preparedStatement.setString(1, user);
			System.out.println("the query is: "+preparedStatement);
			ResultSet rs = preparedStatement.executeQuery();
			int user_id=-1;
			boolean success = false;
			if (rs.next()) {
			    // get the encrypted password from the database
				String encryptedPassword = rs.getString("password");
				user_id=rs.getInt("id");
				// use the same encryptor to compare the user input password with encrypted password stored in DB
				success = new StrongPasswordEncryptor().checkPassword(password, encryptedPassword);
			}

			
			
        
			if (!success) {
				JsonObject responseJsonObject = new JsonObject();
	            responseJsonObject.addProperty("status", "fail");
	            responseJsonObject.addProperty("message", "email or password incorrect!");
	            response.getWriter().write(responseJsonObject.toString());
			
			}else {
				HttpSession session = request.getSession(true);
				
				session.setAttribute("id", Integer.toString(user_id));
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
