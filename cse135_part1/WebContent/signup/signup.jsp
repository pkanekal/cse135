<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sign Up</title>
</head>
<body>
<h2>Sign Up</h2>
	<form id="signup" name="signup" method="post" action="signup.jsp">
  
   		<label>Username :
   			<input type="text" id="name" name="name" />
   		</label>
     	<label> Role :
     		<select id="role" name="role" >
     			<option value="customer">Customer</option>
     			<option value="owner">Owner</option>
     		</select>
     	</label>
     	<label> Age :
     		<input type="text" id="age" name="age" />
     	</label>
     	<label> State
     		<select name="state" id="state">
				<option value="AL">Alabama</option>
				<option value="AK">Alaska</option>
				<option value="AZ">Arizona</option>
				<option value="AR">Arkansas</option>
				<option value="CA">California</option>
				<option value="CO">Colorado</option>
				<option value="CT">Connecticut</option>
				<option value="DE">Delaware</option>
				<option value="DC">District Of Columbia</option>
				<option value="FL">Florida</option>
				<option value="GA">Georgia</option>
				<option value="HI">Hawaii</option>
				<option value="ID">Idaho</option>
				<option value="IL">Illinois</option>
				<option value="IN">Indiana</option>
				<option value="IA">Iowa</option>
				<option value="KS">Kansas</option>
				<option value="KY">Kentucky</option>
				<option value="LA">Louisiana</option>
				<option value="ME">Maine</option>
				<option value="MD">Maryland</option>
				<option value="MA">Massachusetts</option>
				<option value="MI">Michigan</option>
				<option value="MN">Minnesota</option>
				<option value="MS">Mississippi</option>
				<option value="MO">Missouri</option>
				<option value="MT">Montana</option>
				<option value="NE">Nebraska</option>
				<option value="NV">Nevada</option>
				<option value="NH">New Hampshire</option>
				<option value="NJ">New Jersey</option>
				<option value="NM">New Mexico</option>
				<option value="NY">New York</option>
				<option value="NC">North Carolina</option>
				<option value="ND">North Dakota</option>
				<option value="OH">Ohio</option>
				<option value="OK">Oklahoma</option>
				<option value="OR">Oregon</option>
				<option value="PA">Pennsylvania</option>
				<option value="RI">Rhode Island</option>
				<option value="SC">South Carolina</option>
				<option value="SD">South Dakota</option>
				<option value="TN">Tennessee</option>
				<option value="TX">Texas</option>
				<option value="UT">Utah</option>
				<option value="VT">Vermont</option>
				<option value="VA">Virginia</option>
				<option value="WA">Washington</option>
				<option value="WV">West Virginia</option>
				<option value="WI">Wisconsin</option>
				<option value="WY">Wyoming</option>
			</select>
		</label>
   		<p>
     		<label>
     			<input type="submit" name="submit" value="submit" />
     		</label>
   		</p>
   		<input type="hidden" name="signup" value="yes" />
	</form>
<table>
    <tr>
        <td valign="top">

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
                		"jdbc:postgresql://localhost/cse135?" +
                		"user=postgres&password=postgres");
                Statement stmt=conn.createStatement();
            %>
            
            <%-- -------- Sign Up Form Code ------------ --%>
   <%
   
   					String action = request.getParameter("signup");
   					// Check if an insertion is requested
   					if (action != null && action.equals("yes")) {
                    // Begin transaction
                    
                    //rs = stmt.executeQuery("SELECT * FROM users WHERE \"name\" = '" + request.getParameter("name")+"'");
   					rs = stmt.executeQuery("SELECT name FROM users WHERE name='" + request.getParameter("name") + "'");
   					//rs=stmt.executeQuery("select * from users where name='"+request.getParameter("name")+"'");
   					boolean invalidAge = false;
   					try {
   						Integer.parseInt(request.getParameter("age"));
   					}
   					catch (NumberFormatException e) {
   						invalidAge = true;
   					}
   					if (rs.next()){
   						out.println("Sorry, this name has been registered.");
   						//rs = null;
   					}
   					else if (invalidAge) {
   						out.println("Sorry, You have entered an invalid age.");
   					}
					else {
						
						conn.setAutoCommit(false);
						
						pstmt = conn
						.prepareStatement("INSERT INTO users (name, role, age, state) VALUES (?, ?, ?, ?)");

	                    pstmt.setString(1, request.getParameter("name"));
	                    pstmt.setString(2, request.getParameter("role"));
	                    pstmt.setInt(3, Integer.parseInt(request.getParameter("age")));
	                    pstmt.setString(4, request.getParameter("state"));
	                    int rowCount = pstmt.executeUpdate();
	                    
	                    conn.commit();
	                    conn.setAutoCommit(true);
	                    
	                    if (request.getParameter("name") != null)
	                    out.println("You have created an account, " + request.getParameter("name") );
					}
   					}
                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.


                    // Commit transaction
                    
                   
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
    <a href="../login/login.jsp">Click here to Login.</a>
</table>
</body>

</html>