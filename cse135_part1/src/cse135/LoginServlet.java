package cse135;

import java.io.IOException;
import java.sql.*;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String password = request.getParameter("pwd");
        String searchQuery = "select * from users where username='" + userId
                + "' AND password='" + password + "'";
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } 
        catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        try {
            Connection con = DriverManager.getConnection(
            		"jdbc:postgresql://localhost/cse135?" +
            		"user=postgres&password=postgres");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(searchQuery);
            boolean isEmpty = rs.next();
            if (!isEmpty) {
                // redirect to error page
                response.sendRedirect("LoginFailure.jsp");
            } 
            else if (isEmpty) {
                // fetch the session from request, create new session if session
                // is not present in the request
                HttpSession session = request.getSession(true); 
                session.setAttribute("FirstName", rs.getString("firstname"));
                session.setAttribute("LastName", rs.getString("lastname"));
                // redirect to success page
                response.sendRedirect("LoginSuccess.jsp"); 
            }
        } 
        catch (SQLException e) {
            System.out.println("SQLException occured: " + e.getMessage());
            e.printStackTrace();
        }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
