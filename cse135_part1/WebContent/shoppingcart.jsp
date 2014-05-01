<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<%@ page import="org.postgresql.util.*" %>
<!-- Include the UserInfo page -->
<jsp:include page="userview.jsp" />

<title>Shopping Cart</title>
</head>
<body>
<%--------- Displaying products added ---------%>

<h2>Your Cart: </h2>
<table>
<tr>
<th>product </th>
<th>quantity</th>
<th>price</th>
</tr>


<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement query = null;
     ResultSet result = null;
     double total = 0.0;
     
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
         //System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);
            
            Statement stmt= conn.createStatement();
            result = stmt.executeQuery("SELECT id FROM users WHERE \"name\"='"+ session.getAttribute("name") +"'");
            int userID = 0;
            if (result.next())
             userID = result.getInt("id");
            
            
            Statement statement = conn.createStatement();  
            result = statement.executeQuery("SELECT p.productname, sc.quantity, p.price FROM shoppingcart AS sc, products AS p, users AS u WHERE sc.product = p.sku AND u.id = "+ userID);

%>
<%
while (result.next()){
	String name = result.getString("productname");

	int quantity = Integer.parseInt(result.getString("quantity"));
	double price = Double.parseDouble(result.getString("price"));

	total += quantity * price;
%>
<tr>
<td><%=name%></td>
<td><%=quantity%></td>
<td><%=price%></td>
</tr>
<%	
}

%>

</table>
</div>

Your total is: <%=total%>

<form method="post" action="confirmation.jsp">
<label>Credit Card<input type="text" name="creditcard" /></label>
<input type="hidden" name="userID" value="<%= userID %>" />
<input type="submit" value="Place your Order!" />
</form>
<%
            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
    %>
    <%-- -------- Close Connection Code -------- --%>
    <%
        // Close the Connection
         conn.close();
    %>
    <%-- -------- Error catching ---------- --%>
    <%
     } catch (SQLException e) {
         throw new RuntimeException(e);
    }
    finally {
        if (query != null) {
            try {
                query.close();
            } catch (SQLException e) { }
            query = null;
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) { } 
            conn = null;
        }
    }
    %>


    
    
</body>
</html>