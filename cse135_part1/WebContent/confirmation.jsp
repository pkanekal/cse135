
<!DOCTYPE html>
<html>
<head>
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<%@ page import="org.postgresql.util.*" %>
<jsp:include page="userview.jsp" />


</head>
<body>
<%--------- Displaying products added ---------%>
<h3> Shopping Cart</h3>
Your Cart:
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
     int userID = 0;
     int quantity = 0;
     double price = 0.0;
     
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

            conn.setAutoCommit(false);
            
            Statement stmt= conn.createStatement();
            result = stmt.executeQuery("SELECT id FROM users WHERE name='"+ session.getAttribute("name") +"'");
            if (result.next())
             userID = result.getInt("id");
            
            
            Statement statement = conn.createStatement();  
            result = statement.executeQuery("SELECT p.productname, sc.quantity, p.price FROM shoppingcart AS sc, products AS p, users AS u WHERE sc.product = p.sku AND u.id = "+ userID);

%>
<%
while (result.next()){
String name = result.getString("productname");
quantity = Integer.parseInt(result.getString("quantity"));
price = Double.parseDouble(result.getString("quantity"));

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

Your total was: <%=total%>

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
     out.println("Sorry, something went wrong.");
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