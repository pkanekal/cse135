<html>

<body>
<% 
//String action2 = request.getParameter("registered");
//if (action2 != null && action2.equals("yes")){
	//	out.println("Hello" + session.getAttribute("name"));
		//}
%>		
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.util.ArrayList"%>
            <%@ page import="java.sql.*"%>
            <%-- Include the jsp page that sets the views --%>
            <jsp:include page="../userview.jsp" />
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet r = null;
            ArrayList<Integer> a = new ArrayList<Integer>();
            
            try {
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
            
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")){ 
                String action2 = (String)session.getAttribute("role");
            // Check if an insertion is requested
            if (action2.equals("owner")) {
                	Statement stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM categories WHERE \"name\" = '" + request.getParameter("name")+"'");
                    // Begin transaction
                    
                    if (rs.next()) {
						out.println("Failure to insert new category: duplicate name");
						rs = null;
					}
                    else
                    {
                    conn.setAutoCommit(false);
                   

                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    
                    pstmt = conn
                    .prepareStatement("INSERT INTO categories (name, description) VALUES (?, ?)");

                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setString(2, request.getParameter("description"));
                    int rowCount = pstmt.executeUpdate();
                    
                    
                    

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    if (request.getParameter("name") != null)
                    	out.println("Category has been added: " + request.getParameter("name"));
                }
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
                            .prepareStatement("UPDATE categories SET name = ?, description = ? "
                                + " WHERE id = ?");

                        pstmt.setString(1, request.getParameter("name"));
                        pstmt.setString(2, request.getParameter("description"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
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

                    Statement test = conn.createStatement();
                    ResultSet delete = null;
                    ArrayList<Integer> dconc = new ArrayList<Integer>();
                    
      
                    delete = test.executeQuery("SELECT DISTINCT category.id FROM categories AS category, products AS product WHERE category.name = product.category");
                	while (delete.next()){
                 	dconc.add(delete.getInt("id"));
                	}
                 	System.err.println("size is: " + dconc.size());
                     boolean check = false;
                     for( int i = 0; i < dconc.size(); ++i ){
                     	if ( rs.getInt("id") == dconc.get(i) ){
                     	check = true;
                     	}
                     }
                     if ( check ){
                    	 out.println("Can't delete this category, someone just added a product to it.");
	
                     }
                     else
                     {
                    // Begin transaction
                    conn.setAutoCommit(false);
   
                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM categories WHERE id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                     }
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM categories");
            %>
            
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
            </tr>

            <tr>
                <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="name" size="10"/></th>
                    <th><input value="" name="description" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

                <%-- Get the id --%>
                <td>
                    <%=rs.getInt("id")%>
                </td>

                <%-- Get the name --%>
                <td>
                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
                </td>

                <%-- Get the description --%>
                <td>
                    <input value="<%=rs.getString("description")%>" name="description" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                
      <% 
                Statement state = conn.createStatement();
                ResultSet d = null;
  
                d = state.executeQuery("SELECT DISTINCT category.id FROM categories AS category, products AS product WHERE category.name = product.category");
            	while (d.next()){
             	a.add(d.getInt("id"));
            	}
             	
                 boolean check = false;
                 for( int i = 0; i < a.size(); ++i ){
                 	if ( rs.getInt("id") == a.get(i) ){
                 	check = true;
                 	}
                 }
                 if ( !check ){
                	 %>
                     <form action="categories.jsp" method="POST">
                         <input type="hidden" name="action" value="delete"/>
                         <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                         <%-- Button --%>
                     <td><input type="submit" value="Delete"/></td>
                     </form>
                    <%} %>       	  
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
            	}
            	//else
            	//{
            	//	out.println("Sorry, only owners.");
            	//}
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

