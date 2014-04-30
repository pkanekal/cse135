<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
</head>
<body>
<table>
    <tr>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
     <td>
	<form action="login.jsp" method="post">
		<label>Name: <input type="text" name="name" value="" /></label>
		<br />
		<input type="hidden" name="registered" value="yes" />
		<input type="submit" value="Login" />
	</form>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            int loggedin = 0;
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
        String action = request.getParameter("registered");
        // Check if an insertion is requested
        if (action != null && action.equals("yes")) {
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            pstmt = conn
            .prepareStatement("SELECT name, age, state, role FROM users WHERE name='" + request.getParameter("name") + "'");
            rs = pstmt.executeQuery();
            
            
            if ( !rs.next() ){
            	loggedin = 1;
            }
            else{
            	String name = rs.getString("name");
            	String role = rs.getString("role");
            	String age = rs.getString("age");
            	String state = rs.getString("state");
            	session.setAttribute("name", name);
            	session.setAttribute("role", role);
            	session.setAttribute("age", age);
            	session.setAttribute("state", state);
            	loggedin = 2;
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
    <a href="../signup/signup.jsp" >Return to registration page.</a>
    <% 
    //if ((Boolean)session.getAttribute("role")){
    //if (request.getParameter("role") == "owner"){
    	//response.sendRedirect("../categories/categories.jsp");
    //}
    %>
    <% 
    if (loggedin == 1){
    	out.println("Sorry, " + request.getParameter("name") + " is not registered. Please sign up.");	
    }
    %>
    <% 
    if (loggedin == 2){
    	out.println("Hello " + request.getParameter("name")); 
    	//<input name="signedup" type="hidden" value="yes"/>; 
    	session.setAttribute("name", request.getParameter("name"));
    }
    %>
    <form action="../categories/categories.jsp">
    	<input type="submit" value="Categories">
    </form>
        <form action="../Products/Products.jsp">
    	<input type="submit" value="View Products/Owner">
    </form>
            <form action="../Products/productbrowse.jsp">
    	<input type="submit" value="View Products/Customer">
    </form>
    
</body>
</html>