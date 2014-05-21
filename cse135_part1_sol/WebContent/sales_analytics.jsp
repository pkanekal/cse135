<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>CSE135</title>
</head>
<body>
	<%@include file="welcome.jsp" %>

	<%
		Connection conn=null;
		Statement stmt;
		ResultSet rs=null;
		ResultSet categories=null;
		String SQL=null;
		try
		{
			// Connection code
			try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
			String url="jdbc:postgresql://localhost/cse135?";
			String user="postgres";
			String password="postgres";
			conn =DriverManager.getConnection(url, user, password);
			stmt =conn.createStatement();
			
			// Get categories
			categories = stmt.executeQuery("SELECT * FROM categories order by id asc;");
		// Add hidden inputs to form below to pass in parameters to next page
	%>
<!------------------Left Side Panel------------------->
<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">	
	<form action="sales_analytics.jsp" method="post">
		<b>Row Drop Down:</b>
		<select name="rowDD">
			<option value="Customers">Customers</option>
			<option value="States">Customer States</option>
		</select>
		<input type="submit" value="Run Query">
		<br>
		<p> </p><b>Filters:</b>
		<div id="filter">
			State: 
			<select name="state">
				<option value="all">All</option>
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
			<br>
			Category:
			<select name="category">
				<option value="All">All</option>
				
				<% // Populate category options
				while (categories.next()) { 
					int c_id = categories.getInt(1);
					String c_name = categories.getString(2);
					out.println("<option id=\""+c_id+"\">"+c_name+"</option>");					
				 } %>  
				 
			</select>
			<br>
			Age:
			<select name="age">
				<option value="All">All</option>
				<option value="0">12-18</option>
				<option value="1">18-45</option>
				<option value="2">45-65</option>
				<option value="3">65-</option>
			</select>
		</div>
	</form>
</div>
<!----------------------MAIN TABLE AREA----------------------->
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%"  border="1px" align="center">
		<tr>
			<%
				// Get filter options
				String state = request.getParameter("state");
				String category = request.getParameter("category");
				String age = request.getParameter("age");
				
				// Get products & total sales for column headers
				ResultSet products = stmt.executeQuery("SELECT * FROM products order by id asc;");
				String p_name = "";
				double totalSalesPerProduct = 0.0;
				
				while (products.next()) {
					p_name = products.getString(3); // product name
					int p_id = products.getInt(1);  // product id
					System.err.println(p_id);
					// take filters into account
					String query = "SELECT SUM (p.price)FROM users AS u, products AS p, categories AS c, sales as t WHERE u.id = t.id AND p.id =t.pid AND p.id='" + p_id+"'";
					ResultSet salesPerProduct = stmt.executeQuery(query);
					
					if (salesPerProduct.next())
						totalSalesPerProduct = salesPerProduct.getInt(1);
				%>	
				<th><%=p_name %><br>($<%=totalSalesPerProduct %>)</th> <%

					// SELECT SUM (p.price)
					// FROM users AS u, products AS p, categories AS c, carts as t
					// WHERE u.id = t.uid, p.id = t.pid, 
					// c.name = 'testCat', u.state = 'testState', 
				}
			%>
			
		</tr>
	</table>
</div>
	<%
		}
		catch(Exception e)
		{
			out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
			e.printStackTrace();
		}
		finally
		{
			conn.close();
		}
	%>
</body>
</html>