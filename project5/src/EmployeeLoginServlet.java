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
import javax.sql.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;
//
@WebServlet(name = "EmployeeLoginServlet", urlPatterns = "/api/employee_login")
public class EmployeeLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;


    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	PrintWriter out = response.getWriter();

    	response.setContentType("text/html");
    	String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
        System.out.println("gRecaptchaResponse=" + gRecaptchaResponse);

    	
    	 try {
             RecaptchaVerifyUtils.verify(gRecaptchaResponse);
         } catch (Exception e) {
             out.println("<html>");
             out.println("<head><title>Error</title></head>");
             out.println("<body>");
             out.println("<p>recaptcha verification error</p>");
             out.println("<p>" + e.getMessage() + "</p>");
             out.println("</body>");
             out.println("</html>");
             
             out.close();
             return;
         }
    	
    	
        
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
			
			
			String password=request.getParameter("password");
			String user=request.getParameter("user_email");
			
			PasswordEncryptor passwordEncryptor = new StrongPasswordEncryptor();
			String query = "SELECT * from employees where email= ?;";
			PreparedStatement preparedStatement =connection.prepareStatement(query);
			
			preparedStatement.setString(1, user);
			System.out.println("the query is: "+preparedStatement);
			ResultSet rs = preparedStatement.executeQuery();
			String employee_name = "";
			boolean success = false;
			if (rs.next()) {
			    // get the encrypted password from the database
				String encryptedPassword = rs.getString("password");
				employee_name=rs.getString("fullname");
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
				
				
				session.setAttribute("isEmployeeLogin", 1);
				session.setAttribute("EmployeeName", employee_name);
				
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
