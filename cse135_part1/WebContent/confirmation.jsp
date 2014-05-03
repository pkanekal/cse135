
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
     ResultSet rs = null;
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
            rs = stmt.executeQuery("SELECT id FROM users WHERE name='"+ session.getAttribute("name") +"'");
            if (rs.next())
             userID = rs.getInt("id");
            
            
            Statement st = conn.createStatement();  
            rs = st.executeQuery("SELECT p.productname, s.quantity, p.price FROM shoppingcart AS s, products AS p, users AS u WHERE s.product = p.sku AND u.id = "+ userID);

%>
<%
while (rs.next()){
String name = rs.getString("productname");
quantity = Integer.parseInt(rs.getString("quantity"));
price = Double.parseDouble(rs.getString("price"));

total += quantity * price;

%>
<tr>
<td><%=name%></td>
<td><%=quantity%></td>
<td><%=price%></td>
</tr>
<%	
}
Statement newStmt= conn.createStatement();
newStmt.executeUpdate("DELETE FROM shoppingcart WHERE \"customer\" = '" + session.getAttribute("name")+ "'");
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

    <%
     } catch (SQLException e) {
     //out.println("Error: Unable to confirm");
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