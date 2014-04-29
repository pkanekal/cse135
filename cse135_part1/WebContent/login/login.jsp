<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<table>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
        </td>
    <tr>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
     <td>
	<form action="login.jsp" method="post">
		<label>Name: <input type="text" name="name" value="" /></label>
		<br />
		<input type="hidden" name="loggedin" value="yes" />
		<input type="submit" value="Login" />
	</form>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
            %>
            <%-- -------- INSERT Code -------- --%>
     <%
        String action = request.getParameter("loggedin");
        // Check if an insertion is requested
        if (action != null && action.equals("yes")) {
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            pstmt = conn
            .prepareStatement("SELECT name FROM users WHERE name='" + request.getParameter("name") + "'");
            rs = pstmt.executeQuery();
            
            
            if ( !rs.next() ){
            	out.println("Sorry, " + request.getParameter("name") + " is not registered. Please sign up.");
            }
            else{
            	String name = rs.getString("name");
            	out.println("Hello " + name);
            	session.setAttribute("user", name);
            }
            
            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
    %>
            <%-- -------- Close Connection Code -------- --%>
            <%

                // Close the Connection
                conn.close(); }
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
          </table>
        </td>
    </tr>
</body>
</html>