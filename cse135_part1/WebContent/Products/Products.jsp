<html>

<body>
<h2>Attempt 3</h2>
<table>
    <tr>
        <%--- <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
           <%-- <jsp:include page="/menu.html" />  
        </td>--%>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
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
                String action = request.getParameter("action");
                // Check if an insertion is requested

                if (action != null && action.equals("insert")) {
                	// Check if sku already exists in table
                	System.err.println("------------------initial---------------------");
                	 
                	Statement stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM products WHERE \"sku\" = '" + request.getParameter("sku")+"'");
                     
            
                	System.err.println("------------------point1---------------------");

                	System.err.println("------------------point2---------------------");

                	System.err.println("------------------point3---------------------");

					if (Double.parseDouble(request.getParameter("price")) < 0 
						|| rs.next()) {
						out.println("Failure to insert new product.");
						rs = null;
					}
					else {
                    // Begin transaction
                    conn.setAutoCommit(false);
                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    pstmt = conn
                    .prepareStatement("INSERT INTO products (productName, sku, category, price) VALUES (?, ?, ?, ?)");

                    pstmt.setString(1, request.getParameter("productName"));
                    pstmt.setString(2, request.getParameter("sku"));
                    pstmt.setString(3, request.getParameter("category"));
                    pstmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
                    
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    if (request.getParameter("productName") != null)
                    	out.println("product has been added: " + request.getParameter("productName"));
					}
            }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE products SET productName = ?, sku = ?, "
                            + "category = ?, price = ? WHERE id = ?");

                    pstmt.setString(1, request.getParameter("productName"));
                    pstmt.setString(2, request.getParameter("sku"));
                    pstmt.setString(3, request.getParameter("category"));
                    pstmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
                    pstmt.setInt(5, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM products WHERE id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM products");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Name</th>
                <th>SKU</th>
                <th>Category</th>
                <th>Price</th>
            </tr>

            <tr>
                <form action="/cse135_part1/Products/Products.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="productName" size="10"/></th>
                    <th><input value="" name="sku" size="15"/></th>
                    <th><input value="" name="category" size="15"/></th>
                    <th><input value="" name="price" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="/cse135_part1/Products/Products.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>
               

                <%-- Get the product name --%>
                <td>
                    <input value="<%=rs.getString("productName")%>" name="productName" size="15"/>
                </td>

                <%-- Get the SKU --%>
                <td>
                    <input value="<%=rs.getString("sku")%>" name="sku" size="15"/>
                </td>

                <%-- Get the category --%>
                <td>
                    <input value="<%=rs.getString("category")%>" name="category" size="15"/>
                </td>

                <%-- Get the price --%>
                <td>
                    <input value="<%=rs.getString("price")%>" name="price" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="/cse135_part1/Products/Products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
            </tr>

            <%
                }

            %>
        
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

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

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
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
</table>
</body>

</html>

