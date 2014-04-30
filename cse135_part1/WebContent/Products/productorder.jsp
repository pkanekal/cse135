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
<%
		
		String name = (String)session.getAttribute("name");
		String product = request.getParameter("product");
		
%>

            <table border="1">
            <tr>
                <th>Name</th>
                <th>SKU</th>
                <th>Category</th>
                <th>Price</th>
                <th>Quantity</th>
            </tr>
            
            <select>
            	<option>1</option>
            	<option>2</option>
            	<option>3</option>
            	<option>4</option>
            	<option>5</option>
            </select>
            

            
                   <%-- -------- Close Connection Code -------- --%>
            <%

                // Close the Connection
                conn.close(); 
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
</body>
</html>