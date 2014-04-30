<html>

<body>
<h2>Products</h2>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            
<div style="float:left">
 <%
	Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null; 
    try {
        /* -------- Open Connection Code -------- */
      	if (session.getAttribute("role").equals("customer"))
          	{
          		out.println("Sorry! You don't have the permissions to view this page.");
          	}
          	if (session.getAttribute("role").equals("owner"))
          	{
        // Registering Postgresql JDBC driver with the DriverManager
        Class.forName("org.postgresql.Driver");

        // Open a connection to the database using DriverManager
        conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/cse135?" +
            "user=postgres&password=postgres");
       	%>
        <p>Search bar:
        	<form action="/cse135_part1/Products/Products.jsp" method="POST" id="search">
        	<input type="hidden" name="filter2" id="filter2" value="<%=request.getParameter("filter") %>"/>
        	<input type="text" name="searchText" value="">
        	<input type="submit" value="search">
        	</form>
       	</p>
		<%       	
        // populate list of links with categories
        Statement stmt = conn.createStatement();
             			ResultSet res = stmt.executeQuery("SELECT * FROM categories");
        %> 
        <form action="/cse135_part1/Products/Products.jsp" method="POST" id="categoryFilter">
        	<input type="hidden" name="filter" id="filter" value=""/>
        	<input type="hidden" name="search2" id="search2" value="<%=request.getParameter("searchText") %>"/>
        	
            <input type="hidden" value="" name="all" size="10"/>
        		<a href="javascript:{}" 
        		onclick="document.getElementById('filter').value='all'; 
        		document.getElementById('categoryFilter').submit(); return false;">
        		All Products</a><br>
		<%
  		while (res.next()) {
        	res.getString("name");             			
		%>
		<input type="hidden" name="<%= res.getString("name") %>">
		<a href="javascript:{}" 
		onclick="document.getElementById('filter').value='<%=res.getString("name") %>';
		document.getElementById('categoryFilter').submit(); return false;">
		<%= res.getString("name") %></a><br>
		<% } %>
		</form>
</div>

<table style="float:right">
    <tr>
        <%--- <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
           <%-- <jsp:include page="/menu.html" />  
        </td>--%>
        <td>


            
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested

                if (action != null && action.equals("insert")) {
                	// Check if sku already exists in table
                	double price;
                	// stmt = conn.createStatement();
                	// rs = stmt.executeQuery("SELECT * FROM products WHERE \"category\"= '" + request.getParameter("category")+"'");
                	// boolean categoryExists = rs.next();

                	stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM products WHERE \"sku\" = '" + request.getParameter("sku")+"'");
          			try {
          				price = Double.parseDouble(request.getParameter("price"));
          			}
          			catch (NumberFormatException e) {
          				price = -1;
          			}
					if (price < 0 || rs.next() || request.getParameter("productName") == ""
						/* || !categoryExists*/) {
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
                	// Check if sku already exists in table
               	    double price;
               	 	//stmt = conn.createStatement();
             		//rs = stmt.executeQuery("SELECT * FROM products WHERE \"category\"= '" + request.getParameter("category")+"'");
             		//boolean categoryExists = rs.next();
                	stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM products WHERE \"sku\" = '" + request.getParameter("sku")+"'"
                    		+ " AND \"id\" != '" + request.getParameter("id") +"'");
          			try {
          				price = Double.parseDouble(request.getParameter("price"));
          			}
          			catch (NumberFormatException e) {
          				price = -1.0;
          			}
          			boolean uniqueSKU = rs.next();

					if ( price < 0 || uniqueSKU /*|| !categoryExists*/
						|| request.getParameter("productName") == ""
						) {
						out.println("Failure to insert new product.");
						rs = null;
					}
					else {
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
                String filter = request.getParameter("filter");
                String filter2 = request.getParameter("filter2");
				String search = request.getParameter("searchText");
				String search2 = request.getParameter("search2");

				if (filter == null && filter2 != null && !filter2.equals("null")) 
					filter = filter2;
				
				if (search == null && search2 != null && !search2.equals("null"))
					search = search2;
					
                if (filter == null || filter.equals("") || filter.equals("all")) {
                	rs = statement.executeQuery("SELECT * FROM products");
                }
                else {
                    rs = statement.executeQuery("SELECT * FROM products WHERE \"category\" ='"+filter+"'");
                }
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
                    <th>
                    <select name="category">
                    <%  
                    	stmt = null;
                    	res = null;
                    	stmt = conn.createStatement();
             			ResultSet r = stmt.executeQuery("SELECT * FROM categories");
             			while (r.next()) {
             		%>
                    	<option> <%=r.getString("name")%></option>
                    <% } %>
                    </select>
                    </th>
                    <th><input value="" name="price" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
                	if (search == null || search.equals("") ||
                		rs.getString("productName").contains(search)) {
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
                
                    <select name="category">
                    <%  
                    	stmt = conn.createStatement();
             			res = stmt.executeQuery("SELECT * FROM categories");
             			while (res.next()) {
             		%>
                    	<option <% 
                    		if (rs.getString("category").equals(res.getString("name"))) { %>selected<% } %>>
                    	<%=res.getString("name") %></option>
                    <% } %>
                    </select>
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
          	}
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

