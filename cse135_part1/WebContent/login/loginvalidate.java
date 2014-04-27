import java.io.*;  
import java.net.*;  
import java.sql.*;  
import javax.servlet.*;  
import javax.servlet.http.*;  
import com.example.java.StringUtil;  
   
public class LoginValidate extends HttpServlet {  
      
    protected void processRequest(HttpServletRequest request, HttpServletResponse response, boolean withErrorMessage)  
    throws ServletException, IOException {  
        if (withErrorMessage) {  
            response.sendRedirect("/Intranet/login.jsp?error=yes");  
        } else {  
            response.sendRedirect("/Intranet/postlogin.jsp");  
        }  
    }  
      
    protected void doGet(HttpServletRequest request, HttpServletResponse response)  
    throws ServletException, IOException {  
        doPost(request, response);
    }  
      
    protected void doPost(HttpServletRequest request, HttpServletResponse response)  
    throws ServletException, IOException {  
        String userName = request.getParameter("userName");  
        String password = request.getParameter("passWord");  
        if (login(userName, password)) {  
            //send cookie to the browser  
            HttpSession session = request.getSession(true);  
            session.setAttribute("loggedIn", new String("true"));  
            response.sendRedirect("/Intranet/login.jsp");  
        } else {  
            processRequest(request, response, true);  
        }  
    }  
      
    public static boolean login(String userName, String passWord) {  
        try {  
            Class.forName("org.postgresql.Driver");  
            System.out.println("JDBC driver loaded");  
            Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/users?user=postgres&password=postgres");  
            System.out.println("got connection");  
            Statement s = con.createStatement();  
            String sql = "SELECT username FROM users" +  
                    " WHERE username='" + StringUtil.fixSqlFieldValue(userName) + "'" +  
                    " AND password='" + StringUtil.fixSqlFieldValue(passWord) + "'";  
              
            ResultSet rs = s.executeQuery(sql);  
              
            if (rs.next()) {  
                rs.close();  
                s.close();  
                con.close();  
                return true;  
            }  
            rs.close();  
            s.close();  
            con.close();  
        } catch (ClassNotFoundException e) {  
            System.out.println(e.toString());  
        } catch (SQLException e) {  
            System.out.println(e.toString());  
        } catch (Exception e) {  
            System.out.println(e.toString());  
        }  
        return false;  
    }  
}  