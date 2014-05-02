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
                // Create the statement

            %>         

	<%
        // Create the statement
        Statement statement = conn.createStatement();
    %>
	
	<h3 align = "center">Product Order</h3>
	<p align = "left"> <a href="../shoppingcart.jsp">Buy Shopping Cart</a> <p>

	Selected <% String displayProduct = request.getParameter("productname"); 
				out.println(displayProduct); %>.
	
	<form method="POST" action="productadd.jsp">	
		How many do you want to add to cart?
		<input type="number" min="1" value="1" name="quantity"/>		
		<input type="submit" value="Add to Cart"/> 
		<input type="hidden" name="productsku" value="<%=request.getParameter("sku")%>"/>
		<input type="hidden" name="name" value="<%=session.getAttribute("name")%>"/>	
	</form>
	
	
	<% rs = statement.executeQuery(
			"SELECT products.sku, products.category, products.productname, products.price, shoppingcart.quantity " +
			"FROM products " + "INNER JOIN shoppingcart " + "ON products.sku = shoppingcart.product " +
			"WHERE shoppingcart.customer = '" + session.getAttribute("name") +"'");		
	%>
	
	<h3>Cart:</h3>
	
	<table border="1">
	<th>Category</th>
	<th>Product</th>
	<th>SKU</th>
	<th>Price</th>
	<th>Quantity</th>
	
	<%	while (rs.next()) { %>

	<tr align="center">
			<td> <% String sku1 = rs.getString("sku"); 
					out.println(sku1);%> </td>
			<td> <% String category1 = rs.getString("category"); 
					out.println(category1);%>  </td>
			<td> <% String pn1 = rs.getString("productname"); 
					out.println(pn1); %> </td>
			<td> <% String price1 = rs.getString("price");
					out.println(price1); %> </td>
			<td> <% String quant1 = rs.getString("quantity");
					out.println(quant1); %> </td>

	</tr>
	
	<% } %>
	
	</table>
	
	

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