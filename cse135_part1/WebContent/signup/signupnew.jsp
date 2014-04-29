<html>

<body>
<h2>Sign Up</h2>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="/signup/signup.html" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            int count = 0;
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                		"jdbc:postgresql://localhost/postgres?" +
                		"user=postgres&password=postgres");
                Statement st=conn.createStatement();
            %>
            
            <%-- -------- Sign Up Form Code ------------ --%>
   <%
                    // Begin transaction
                    conn.setAutoCommit(false);
   				
   					pstmt = conn
   					.prepareStatement("SELECT name FROM users WHERE name='" + request.getParameter("name") + "'");
   					//rs=st.executeQuery("select * from users where name='"+request.getParameter("name")+"'");
   					//rs=st.executeQuery("SELECT name FROM users GROUP BY name HAVING COUNT(name) > 0");
   					//rs=st.executeQuery("SELECT * FROM users WHERE \"name\" = '" + request.getParameter("name)")+"'");
					rs = pstmt.executeQuery();
   					
   					if (rs.next()){
   						out.println("Duplicate");
   					}
					else {
						pstmt = conn
						.prepareStatement("INSERT INTO users (name, role, age, state) VALUES (?, ?, ?, ?)");

	                    pstmt.setString(1, request.getParameter("name"));
	                    pstmt.setString(2, request.getParameter("role"));
	                    pstmt.setString(3, request.getParameter("age"));
	                    pstmt.setString(4, request.getParameter("state"));
	                    int rowCount = pstmt.executeUpdate();
					}
                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.


                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                   
                    if (request.getParameter("name") != null)
                    out.println("You have created an account," + request.getParameter("name") );
            %>

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
        </table>
        </td>
    </tr>
</table>
</body>

</html>