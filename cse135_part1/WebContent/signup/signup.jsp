<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<!--  Include the UserInfo page -->

<title>Sign-up</title>
</head>
<body>

	<form action="signup.jsp" method="post">
		<label>Username: <input type="text" name="username" value="" /></label>
		<br />
		<label>Role: 
			<select name="role" id="role">
				<option value="Owner">Owner</option>
				<option value="Customer">Customer</option>
			</select>
		</label>
		<br />
		<span id="otherOptions">
			<input type="hidden" name="age" value="0" /><input type="hidden" name="state" value="CA" />
		</span>

		<input type="hidden" name="signedup" value="yes" />
		<input type="submit" value="Sign Up" />
	</form>
		<%-- -------- Open Connection Code -------- --%>
     <%
     
     Connection conn = null;
     PreparedStatement query = null;
     
     try {
         // Registering Postgresql JDBC driver with the DriverManager
         Class.forName("org.postgresql.Driver");

         // Open a connection to the database using DriverManager
         conn = DriverManager.getConnection(
             "jdbc:postgresql://localhost/"+ application.getAttribute("database") +"?" +
             "user=postgres&password=postgres");
     %>
    <%-- -------- INSERT Code -------- --%>
    <%
        String action = request.getParameter("signedup");
        // Check if an insertion is requested
        if (action != null && action.equals("yes")) {
        	//System.out.println("In Sign up");
            // Begin transaction
            conn.setAutoCommit(false);
            
            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
            query = conn
            .prepareStatement("INSERT INTO users (username, role, age, state) VALUES (?, ?, ?, ?)");

            query.setString(1, request.getParameter("username"));
            query.setString(2, request.getParameter("role"));
            query.setInt(3, Integer.parseInt(request.getParameter("age")));
            query.setString(4, request.getParameter("state"));
            int rowCount = query.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
            
            out.println("Thank you, " + request.getParameter("username"));
    %>
    <%-- -------- Close Connection Code -------- --%>
    <%
        // Close the Connection
        	conn.close();
        }
    %>
    <%-- -------- Error catching ---------- --%>
    <%
     } catch (SQLException e) {
    	 //System.out.println("In catch");
        // Wrap the SQL exception in a runtime exception to propagate
        // it upwards
    	 out.println("Sorry, something went wrong. Insert did not work.");
    }
    finally {
        // Release resources in a finally block in reverse-order of
        // their creation
		//System.out.println("In finally");
        if (query != null) {
            try {
                query.close();
            } catch (SQLException e) { } // Ignore
            query = null;
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) { } // Ignore
            conn = null;
        }
    }
    %>

    <a href="login.jsp">Click here to Login.</a>
    <script>
    	var roleEl = document.getElementById("role");
    	roleEl.addEventListener("change",function(){
    		if( roleEl.value == "Customer"){
    			otherOptions.innerHTML = "<label>Age: <input type=\"text\" name=\"age\" value=\"\" /></label>" +
    			" <br /> " +
    			"<label>State: " + 
    				"<select name=\"state\">" +
	    				"<option value=\"AL\">AL</option>" +
	    				"<option value=\"AK\">AK</option>"+
	    				"<option value=\"AZ\">AZ</option>"+
	    				"<option value=\"AR\">AR</option>"+
	    				"<option value=\"CA\">CA</option>"+
	    				"<option value=\"CO\">CO</option>"+
	    				"<option value=\"CT\">CT</option>"+
	    				"<option value=\"DE\">DE</option>"+
	    				"<option value=\"FL\">FL</option>"+
	    				"<option value=\"GA\">GA</option>"+
	    				"<option value=\"HI\">HI</option>"+
	    				"<option value=\"ID\">ID</option>"+
	    				"<option value=\"IL\">IL</option>"+
	    				"<option value=\"IN\">IN</option>"+
	    				"<option value=\"IA\">IA</option>"+
	    				"<option value=\"KS\">KS</option>"+
	    				"<option value=\"KY\">KY</option>"+
	    				"<option value=\"LA\">LA</option>"+
	    				"<option value=\"ME\">ME</option>"+
	    				"<option value=\"MD\">MD</option>"+
	    				"<option value=\"MA\">MA</option>"+
	    				"<option value=\"MI\">MI</option>"+
	    				"<option value=\"MN\">MN</option>"+
	    				"<option value=\"MS\">MS</option>"+
	    				"<option value=\"MO\">MO</option>"+
	    				"<option value=\"MT\">MT</option>"+
	    				"<option value=\"NE\">NE</option>"+
	    				"<option value=\"NV\">NV</option>"+
	    				"<option value=\"NH\">NH</option>"+
	    				"<option value=\"NY\">NY</option>"+
	    				"<option value=\"NC\">NC</option>"+
	    				"<option value=\"ND\">ND</option>"+
	    				"<option value=\"OH\">OH</option>"+
	    				"<option value=\"OK\">OK</option>"+
	    				"<option value=\"OR\">OR</option>"+
	    				"<option value=\"PA\">PA</option>"+
	    				"<option value=\"RI\">RI</option>"+
	    				"<option value=\"SC\">SC</option>"+
	    				"<option value=\"SD\">SD</option>"+
	    				"<option value=\"TN\">TN</option>"+
	    				"<option value=\"TX\">TX</option>"+
	    				"<option value=\"UT\">UT</option>"+
	    				"<option value=\"VT\">VT</option>"+
	    				"<option value=\"VA\">VA</option>"+
	    				"<option value=\"WA\">WA</option>"+
	    				"<option value=\"WV\">WV</option>"+
	    				"<option value=\"WI\">WI</option>"+
	    				"<option value=\"WY\">WY</option>"+
    				"</select>"+
    			"</label>"+
    			"<br />";
    		}
    		else{
    			otherOptions.innerHTML ="<input type=\"hidden\" name=\"age\" value=\"0\" /><input type=\"hidden\" name=\"state\" value=\"California\" />";
    		}
    	})
    </script>
</body>
</html>