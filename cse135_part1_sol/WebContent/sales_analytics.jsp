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
		Statement stmt2;
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
			<option value="States">States</option>
		</select>
		<input type="submit" value="Run Query">
		<br>
		<p> </p><b>Filters:</b>
		<div id="filter">
			State: 
			<select name="state">
				<option value="All">All</option>
				<option value="Alabama">Alabama</option>
				<option value="Alaska">Alaska</option>
				<option value="Arizona">Arizona</option>
				<option value="Arkansas">Arkansas</option>
				<option value="california">California</option>
				<option value="Colorado">Colorado</option>
				<option value="Connecticut">Connecticut</option>
				<option value="Delaware">Delaware</option>
				<option value="Florida">Florida</option>
				<option value="Georgia">Georgia</option>
				<option value="Hawaii">Hawaii</option>
				<option value="Idaho">Idaho</option>
				<option value="Illinois">Illinois</option>
				<option value="Indiana">Indiana</option>
				<option value="Iowa">Iowa</option>
				<option value="Kansas">Kansas</option>
				<option value="Kentucky">Kentucky</option>
				<option value="Louisiana">Louisiana</option>
				<option value="Maine">Maine</option>
				<option value="Maryland">Maryland</option>
				<option value="Massachusetts">Massachusetts</option>
				<option value="Michigan">Michigan</option>
				<option value="Minnesota">Minnesota</option>
				<option value="Mississippi">Mississippi</option>
				<option value="Missouri">Missouri</option>
				<option value="Montana">Montana</option>
				<option value="Nebraska">Nebraska</option>
				<option value="Nevada">Nevada</option>
				<option value="New Hampshire">New Hampshire</option>
				<option value="New Jersey">New Jersey</option>
				<option value="New Mexico">New Mexico</option>
				<option value="New York">New York</option>
				<option value="North Carolina">North Carolina</option>
				<option value="North Dakota">North Dakota</option>
				<option value="Ohio">Ohio</option>
				<option value="Oklahoma">Oklahoma</option>
				<option value="Oregon">Oregon</option>
				<option value="Pennsylvania">Pennsylvania</option>
				<option value="Rhode Island">Rhode Island</option>
				<option value="South Carolina">South Carolina</option>
				<option value="South Dakota">South Dakota</option>
				<option value="Tennessee">Tennessee</option>
				<option value="Texas">Texas</option>
				<option value="Utah">Utah</option>
				<option value="Vermont">Vermont</option>
				<option value="Virginia">Virginia</option>
				<option value="Washington">Washington</option>
				<option value="West Virginia">West Virginia</option>
				<option value="Wisconsin">Wisconsin</option>
				<option value="Wyoming">Wyoming</option>
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
		<th></th>
			<%
				// Get filter options
				String state = request.getParameter("state");
				String category = request.getParameter("category");
				String age = request.getParameter("age");
				
				// Get products & total sales for column headers
				ResultSet products;
				
				if (category.equals("All"))
					products = stmt.executeQuery("SELECT * FROM products order by id asc;");
				else
					products = stmt.executeQuery("SELECT * FROM products, categories WHERE products.cid=categories.id AND categories.name='"+category+"' order by products.id asc;");

				String p_name = "";
				double totalSalesPerProduct = 0.0;
				ResultSet salesPerProduct = null;
				stmt2 = conn.createStatement();
				
				while (products.next()) {
					p_name = products.getString(3); // product name
					int p_id = products.getInt(1);  // product id
					StringBuilder query = new StringBuilder();

					// General case
					query.append("SELECT SUM(sales.quantity*sales.price) FROM sales,products ");

					// FROM CLAUSE
					// if a specific category selected:
					if (!category.equals("All") && category != null)
						query.append(",categories ");
					
					// if a specific state or age:
					if ((!state.equals("All") || !age.equals("All")) && state != null)
						query.append(",users ");

					// WHERE CLAUSE
					// General case
					query.append("WHERE products.id = '"+ p_id +"' AND sales.pid = products.id ");
					
					if (!category.equals("All") && category != null)
						query.append("AND categories.id = products.cid AND categories.name = '" + category +"' ");
					
					if (!state.equals("All") && state != null) 
							query.append("AND users.id = sales.uid AND users.state = '"+state+"' ");

					// age logic
					if( !age.equals("All") && age != null) {

						switch (Integer.parseInt(age)) {
						case 0:
							// 12-18
							query.append("AND users.id = sales.uid AND users.age > '11' AND users.age < '18'");
							break;
						case 1:
							// 18-45
							query.append("AND users.id = sales.uid AND users.age > '18' AND users.age < '45'");
							break;
						case 2:
							// 45-65
							query.append("AND users.id = sales.uid AND users.age > '44' AND users.age < '65'");	
							break;
						case 3:
							// 65-
							query.append("AND users.id = sales.uid AND users.age > '64' ");

							break;
						}
						
					}

					salesPerProduct = stmt2.executeQuery(query.toString());
					
					if (salesPerProduct.next())
						totalSalesPerProduct = salesPerProduct.getInt(1);
					
					// Truncate product name if greater than 10 chars
					if (p_name.length() > 10) 
						p_name = p_name.substring(0, 9);
			%>	
				<th><%=p_name %><br>($<%=totalSalesPerProduct %>)</th> 
				
			<% } %>
		</tr>
		<% 
			Statement stmt3 = conn.createStatement();
			Statement stmt4 = conn.createStatement();
			double totalSalesPerUser = 0.0;

			if (request.getParameter("rowDD").equals("Customers")) { // Rows are customers
				
				StringBuilder userQuery = new StringBuilder();
				userQuery.append("SELECT users.id, users.name, SUM(sales.price*sales.quantity) FROM users, sales");

				// if any filter is applied, add 'WHERE'
				userQuery.append(" WHERE users.id = sales.uid");
				
				// filter for state
				if (!state.equals("All") && state != null) 
					userQuery.append(" AND users.state = '"+state+"' ");
				
				// filter for age
				if( !age.equals("All") && age != null) {

					switch (Integer.parseInt(age)) {
					case 0:
						// 12-18
						userQuery.append(" AND users.age > '11' AND users.age < '18' ");
						break;
					case 1:
						// 18-45
						userQuery.append(" AND users.age > '18' AND users.age < '45' ");
						break;
					case 2:
						// 45-65
						userQuery.append(" AND users.age > '44' AND users.age < '65' ");	
						break;
					case 3:
						// 65-
						userQuery.append(" AND users.age > '64' ");
	
						break;
					}
					
				}
				userQuery.append(" GROUP BY users.id ORDER by users.id asc");
				System.err.println(userQuery.toString());
				ResultSet userSet = stmt.executeQuery(userQuery.toString());
				while (userSet.next()){

					int u_id = userSet.getInt(1);
					String u_name = userSet.getString(2);
					totalSalesPerUser = userSet.getInt(3);
					
					// Truncate product name if greater than 10 chars
					if (u_name.length() > 10) {
						u_name = u_name.substring(0, 9);
					}
					%>	
					<tr><th><%=u_name %><br>($<%=totalSalesPerUser %>)</th>
					<%
					
					// QUERY FOR INNER CELLS
					if (category.equals("All"))
						products = stmt3.executeQuery("SELECT * FROM products order by id asc;");
					else
						products = stmt3.executeQuery("SELECT * FROM products, categories WHERE products.cid=categories.id AND categories.name='"+category+"' order by products.id asc;");
					
					while (products.next()) {
						int p_id = products.getInt(1);  // product id
						String cellQuery = "SELECT SUM(sales.quantity*sales.price) FROM sales, products, users"
						+" WHERE users.id=sales.uid AND products.id=sales.pid AND products.id='"+p_id+"' AND users.id = '"+u_id+"'";
						System.err.println(cellQuery.toString());
						System.err.println("--------------------------------");
						ResultSet cell = stmt4.executeQuery(cellQuery);

						if (cell.next())
							%><td><%=cell.getInt(1) %> </td><% 
					}
					%>
					</tr>					
				<% 
				}
			}
			else { // Rows are states
				double salesPerState = 0.0;
				// only displaying states with users in it.
				ResultSet stateSet = null;
				if (state.equals("All"))
					stateSet = stmt2.executeQuery("SELECT state FROM users order by state asc;");
				else
					stateSet = stmt2.executeQuery("SELECT state FROM users WHERE state = '"+state+"'order by state asc;");
				
				while (stateSet.next()) {
					String rowState = stateSet.getString(1);
					
					// get total sales per state
					StringBuilder stateTotalQuery = new StringBuilder();
					stateTotalQuery.append("SELECT SUM(sales.quantity*sales.price) FROM sales, users ");
	
					if (!category.equals("All") && category != null || !age.equals("All") && age != null)
						stateTotalQuery.append(", categories, products ");

					// General Case
					stateTotalQuery.append("WHERE users.id=sales.uid AND state = '"+rowState+"' ");

					// category filter
					if (!category.equals("All") && category != null)
						stateTotalQuery.append("AND categories.id = products.cid AND categories.name = '" + category +"' ");
					
					// age filter
					if( !age.equals("All") && age != null) {

						switch (Integer.parseInt(age)) {
						case 0:
							// 12-18
							stateTotalQuery.append(" AND users.age > '11' AND users.age < '18'");
							break;
						case 1:
							// 18-45
							stateTotalQuery.append(" AND users.age > '18' AND users.age < '45'");
							break;
						case 2:
							// 45-65
							stateTotalQuery.append(" AND users.age > '44' AND users.age < '65'");	
							break;
						case 3:
							// 65-
							stateTotalQuery.append(" AND users.age > '64' ");

							break;
						}	
					}
					ResultSet q = stmt.executeQuery(stateTotalQuery.toString());
					double totalPerState = 0.0;
					
					if (q.next())
						totalPerState = q.getInt(1);
					
					%>	
					<tr><th><%=rowState %><br>($<%=totalPerState %>)</th>
					<%
					if (category.equals("All"))
						products = stmt3.executeQuery("SELECT * FROM products order by id asc;");
					else
						products = stmt3.executeQuery("SELECT * FROM products, categories WHERE products.cid=categories.id AND categories.name='"+category+"' order by products.id asc;");
					
					// INNER CELLS
					while(products.next()) {
						int p_id = products.getInt(1);  // product id
						
						// add age and category filters
						StringBuilder cellQuery = new StringBuilder();
						cellQuery.append("SELECT SUM(sales.quantity*sales.price) FROM sales, products, users, categories "
								+ "WHERE users.id=sales.uid AND products.id=sales.pid AND products.id='"+p_id+"' AND state = '"+rowState+"'");
						
						// category filter
						if (!category.equals("All") && category != null)
							cellQuery.append("AND categories.id = products.cid AND categories.name = '" + category +"' ");
						
						// age filter
						if( !age.equals("All") && age != null) {

							switch (Integer.parseInt(age)) {
							case 0:
								// 12-18
								cellQuery.append(" AND users.age > '11' AND users.age < '18'");
								break;
							case 1:
								// 18-45
								cellQuery.append(" AND users.age > '18' AND users.age < '45'");
								break;
							case 2:
								// 45-65
								cellQuery.append(" AND users.age > '44' AND users.age < '65'");	
								break;
							case 3:
								// 65-
								cellQuery.append(" AND users.age > '64' ");

								break;
							}	
						}
						ResultSet sales = stmt4.executeQuery(cellQuery.toString());
						if (sales.next())
							%><td><%=sales.getInt(1) %> </td><%
					} %>
					</tr> <% 
					
				}
			}
				
		%>
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
SELECT p.id, p.name, coalesce(Sum(total), 0) 
FROM products p LEFT OUTER JOIN 
(SELECT p.id, p.name, SUM(s.quantity*s.price) as total
FROM products p LEFT OUTER JOIN sales s ON p.id = s.pid INNER JOIN users u ON u.id = s.uid AND u.state = 'West Virginia' 
GROUP BY p.name, p.id ORDER BY p.name asc OFFSET 0 FETCH NEXT 10 ROWS ONLY) as x 
ON x.id = p.id
group by p.id
order by p.name