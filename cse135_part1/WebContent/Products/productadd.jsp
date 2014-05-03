<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%-- Import the java.sql package --%>
	<%@ page import="java.sql.*"%>
            <jsp:include page="../userview.jsp" />
	
	    <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            int loggedin = 0;
            try {
            	if (session.getAttribute("role").equals("owner"))
              	{
              		out.println("Sorry! You don't have the permissions to view this page.");
              	}
              	if (session.getAttribute("role").equals("customer"))
              	{
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
                // Create the statement
                Statement statement = conn.createStatement();
            %>         
            

       	

<% 
		conn.setAutoCommit(false);
		String name = request.getParameter("name"); 
		String productsku = request.getParameter("productsku"); 
		String quantity = request.getParameter("quantity"); 
        // Create the prepared statement and use it to
        // INSERT student values INTO the students table.
        pstmt = conn
        .prepareStatement("INSERT INTO shoppingcart (customer, product, quantity) VALUES (?,?,?)");

        pstmt.setString(1, name);
        pstmt.setString(2, productsku);
        pstmt.setInt(3, Integer.parseInt(quantity));
        int rowCount = pstmt.executeUpdate();

        // Commit transaction
        conn.commit();
        conn.setAutoCommit(true);
        String redirectURL = "productbrowse.jsp";
        response.sendRedirect(redirectURL);
  	%>
    
                   <%-- -------- Close Connection Code -------- --%>
            <%

            	statement.close();
                // Close the Connection
                conn.close(); 
              	}
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            catch (Exception e)
            {
            	out.println("Error occurred.");
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

</body>
</html>