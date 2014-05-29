<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>CSE135</title>
</head>
<body>
	<%@include file="welcome.jsp" %>

	<%

	//so we can create a customer list
class Customer
{
	private int id=0;
	private String name;
	private int age = 0;
	private String state;
	private float price = 0f;
	
	public int getId() {return id;}
	public void setId(int id) {	this.id = id;}
	public String getName() {return name;}
	public void setName(String name) {this.name = name;}
	public int getAge() {return age;}
	public void setAge(){this.age = age;}
	public String getState(){return state;}
	public void setState(){this.state = state;}
	public void setPrice(float price) {this.price = price;}
	public float getPrice(){return price;}
}

	// creating a product list
class Product
{
	private int id=0;
	private int cid = 0;
	private String name=null;
	private int SKU = 0;
	private float price = 0f;
	
	public int getId() {return id;}
	public void setId(int id) {	this.id = id;}
	public String getName() {return name;}
	public void setName(String name) { this.name = name;}
	//public void getcid() { return categoryid;}
	//public void setcid(int cid) {this.categoryid = categoryid; }
	//public void getsku() { return SKU;}
	//public void setsku(int sku) {this.sku = sku;}
	public void setPrice(float price) {this.price = price;}
	public float getPrice(){return price;}
}

//initialize both lists
ArrayList<Customer> customerlist= new ArrayList<Customer>();
ArrayList<Product> productlist = new ArrayList<Product>();

Connection conn=null;
Statement stmt;
Statement stmt2;
ResultSet rs=null;
ResultSet rs2=null; 

ResultSet categories=null;
String SQL=null;
// one offset variable for products, the other for the actual rows (either customers or states)
int offsetvar = 0;	
int offsetvar2 = 0;
try
{
	// Connection code
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://localhost/cse135?";
	String user="postgres";
	String password="postgres";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	stmt2 =conn.createStatement();

	%>
	<!------------------Left Side Panel------------------->
	<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<form action="salesanalytics2.jsp" method="post">
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
				// Get categories
				categories = stmt.executeQuery("SELECT * FROM categories order by id asc;");
				
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
				<option value= "12 AND 18">12-18</option>
				<option value= "18 AND 45">18-45</option>
				<option value= "45 AND 65">45-65</option>
				<option value= "65 AND 200">65-</option>
			</select>
		</div>
	</form>
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">

<%
// save the values of the filters
String state = request.getParameter("state");
String category = request.getParameter("category");
String age = request.getParameter("age");

StringBuilder SQL_1 = new StringBuilder();
StringBuilder SQL_2 = new StringBuilder();
String SQL_3;
String SQL_4;
String SQL_5 = null;

boolean ageFilter = (!age.equals("All") && age != null);
boolean categoryFilter = (!category.equals("All") && category != null) ;
boolean stateFilter = (!state.equals("All") && state != null);
boolean Zeroes = false;

if (stateFilter){
SQL_4="SELECT p.id, p.name, SUM(s.quantity*s.price) as total " +
"FROM products p LEFT OUTER JOIN sales s ON p.id = s.pid INNER JOIN users u ON u.id = s.uid AND u.state ='" + state + "'AND u.id = s.uid " +
"GROUP BY p.name, p.id ORDER BY p.name asc OFFSET 0 FETCH NEXT 10 ROWS ONLY";
System.err.println(SQL_4.toString());

rs2=stmt2.executeQuery(SQL_4.toString());
if(!rs2.next()){
	System.out.println("MUST DO FAT QUERY");
	SQL_5="SELECT p.id, p.name, coalesce(Sum(total), 0) FROM products p LEFT OUTER JOIN " +
		  "("+SQL_4+") " +
		  "as x ON x.id = p.id GROUP BY p.id ORDER BY p.name asc OFFSET " + offsetvar + " FETCH NEXT 10 ROWS ONLY";
	System.err.println(SQL_5.toString());
	Zeroes = true;
}
else{

// PRODUCTS with  filters 

// SELECT
	SQL_1.append("SELECT p.id, p.name, SUM(s.quantity*s.price) ");

// FROM
	SQL_1.append("FROM products p LEFT OUTER JOIN sales s ON p.id = s.pid ");
		
	// if category filtering on
	if (categoryFilter)
		SQL_1.append("INNER JOIN categories c ON c.id = p.cid AND c.name = '"+category+"' ");
	
	// if age or state filtering on
	if (ageFilter || stateFilter) 
		SQL_1.append("INNER JOIN users u ON u.id = s.uid ");
		
	// if age filtering is on
	if (ageFilter)
		SQL_1.append("AND u.age BETWEEN "+ age +" ");
	
	// if state filtering is on
	if (stateFilter)
		SQL_1.append("AND u.state = '"+ state + "' ");

// GROUP BY
	SQL_1.append("GROUP BY p.name, p.id ");


// ORDER BY
	SQL_1.append("ORDER BY p.name asc ");

// PAGINATION
	SQL_1.append("OFFSET " + offsetvar + " FETCH NEXT 10 ROWS ONLY");

System.err.println("SQL 1 " + SQL_1.toString());

}
}
else{
	// PRODUCTS with  filters 

	// SELECT
		SQL_1.append("SELECT p.id, p.name, SUM(s.quantity*s.price) ");

	// FROM
		SQL_1.append("FROM products p LEFT OUTER JOIN sales s ON p.id = s.pid ");
			
		// if category filtering on
		if (categoryFilter)
			SQL_1.append("INNER JOIN categories c ON c.id = p.cid AND c.name = '"+category+"' ");
		
		// if age or state filtering on
		if (ageFilter || stateFilter) 
			SQL_1.append("INNER JOIN users u ON u.id = s.uid ");
			
		// if age filtering is on
		if (ageFilter)
			SQL_1.append("AND u.age BETWEEN "+ age +" ");
		
		// if state filtering is on
		if (stateFilter)
			SQL_1.append("AND u.state = '"+ state + "' AND u.id = s.uid ");

	// GROUP BY
		SQL_1.append("GROUP BY p.name, p.id ");


	// ORDER BY
		SQL_1.append("ORDER BY p.name asc ");

	// PAGINATION
		SQL_1.append("OFFSET " + offsetvar + " FETCH NEXT 10 ROWS ONLY");

	System.err.println(SQL_1.toString());

}

boolean stateRow = true;
String rowDD = request.getParameter("rowDD"); 
// if states was chosen as the row value
if (rowDD.equals("States") && rowDD != null)
{
	// SELECT
		SQL_2.append("SELECT u.state, SUM(s.quantity*s.price) ");

	// FROM
		SQL_2.append("FROM users u INNER JOIN sales s ON u.id = s.uid ");
			
		// if category filtering on
		if (categoryFilter)
			SQL_2.append(", products INNER JOIN categories c ON c.id = products.cid AND c.name = '"+category+"' ");
			
		// if age filtering is on
		if (ageFilter)
			SQL_2.append("AND u.age BETWEEN "+ age +" ");
		
		// if state filtering is on
		if (stateFilter)
			SQL_2.append("AND u.state = '"+ state + "' ");

	// GROUP BY
		SQL_2.append("GROUP BY u.state ");


	// ORDER BY
		SQL_2.append("ORDER BY u.state asc ");

	// PAGINATION
		SQL_2.append("OFFSET " + offsetvar2 + " FETCH NEXT 10 ROWS ONLY");
	System.err.println("SQL 2: " + SQL_2.toString());
}

// if customers was chosen as the row value 
else if (rowDD.equals("Customers") && rowDD != null)
{

}

if (Zeroes){
	rs=stmt.executeQuery(SQL_5);
}
else{
rs=stmt.executeQuery(SQL_1.toString());
}
int product_id=0;
String product_name = null;
float product_price = 0;

while (rs.next()){
	Product product = new Product();
	product.setId(rs.getInt(1));
	product.setName(rs.getString(2));
	product.setPrice(rs.getFloat(3));
	productlist.add(product);
}
%>
	<table align="center" width="98%" border="1">
		<tr align="center">
		<%if (rowDD.equals("Customers")){%>
			<td>Customer</td><% 
		} else {
		%> <td>State</td> <% } %>

<%	
for(int i=0;i<productlist.size();i++)
{
	product_id			=   productlist.get(i).getId();
	product_name	    =	productlist.get(i).getName();
	product_price	    =	productlist.get(i).getPrice();
	%><td><%= product_name %><br><%=product_price %> </td><% 
}
%></tr>
<% 

rs2=stmt2.executeQuery(SQL_2.toString());
System.out.println("rs2 query");
String customer_name=null;
float customer_price=0;
int customer_id =0;

if (stateRow){
	while(rs2.next())
	{
		Customer customer =new Customer();
		customer.setName(rs2.getString(1));
		customer.setPrice(rs2.getFloat(2));
		customerlist.add(customer);
		System.out.println("IN THE IF RS2");
	}
	for(int i=0;i<customerlist.size();i++)
	{
		customer_name	=	customerlist.get(i).getName();
		customer_price	=	customerlist.get(i).getPrice();
		%><tr><td><%= customer_name %><br><%=customer_price %> </td></tr><% 
	
	}
}
else{
	/*while(rs2.next())
	{
		customer_id = rs2.getInt(1);
		customer_name=rs2.getString(2);
		customer_price=rs2.getFloat(3);
		Customer customer =new Customer();
		customer.setName(customer_name);
		customer.setPrice(customer_price);
		customer.setId(customer_id);
		customerlist.add(customer);
		System.out.println("IN THE ELSE RS2");
	}

	for(int i=0;i<customerlist.size();i++)
	{
		customer_name	=	customerlist.get(i).getName();
		customer_price	=	customerlist.get(i).getPrice();*/
				//FOR EVERY ROW, BUILD THE INNER DATA USING COMBINATION OF CUSTOMER NAME AND THE PRODUCT NAME
				// DO SUM QUERY 
				//"SELECT SUM(sales.price*sales.quantity) FROM users, sales, products"+
				//"WHERE "
	//}
}
 
}

		
catch(Exception e)
{
	out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}	
%>	
</tr>
</table>
</div>
</body>
</html>

SELECT p.id, p.name, coalesce(Sum(total), 0) FROM products p LEFT OUTER JOIN 
(SELECT p.id, p.name, SUM(s.quantity*s.price) as total
FROM products p LEFT OUTER JOIN sales s ON p.id = s.pid INNER JOIN users u ON u.id = s.uid AND u.state = 'Colorado' 
GROUP BY p.name, p.id ORDER BY p.name asc OFFSET 0 FETCH NEXT 10 ROWS ONLY) 
as x ON x.id = p.id group by p.id order by p.name


SELECT p.id, p.name, coalesce(Sum(total), 0) 
FROM products p LEFT OUTER JOIN (SELECT p.id, p.name, SUM(s.quantity*s.price) as total FROM products p 
LEFT OUTER JOIN sales s ON p.id = s.pid INNER JOIN users u ON u.id = s.uid AND u.state = 'Alabama' 
GROUP BY p.name, p.id ORDER BY p.name asc OFFSET 0 FETCH NEXT 10 ROWS ONLY) as x ON x.id = p.id GROUP BY p.id ORDER BY p.name


// ZEROES HANDLING SPECIFIC CATEGORY
SELECT p.id, p.name, coalesce(Sum(total), 0) 
FROM products p LEFT OUTER JOIN 
(SELECT p.id, p.name, SUM(s.quantity*s.price) as total
FROM products p LEFT OUTER JOIN sales s ON p.id = s.pid INNER JOIN users u ON u.id = s.uid AND u.state = 'West Virginia' 
GROUP BY p.name, p.id ORDER BY p.name asc OFFSET 0 FETCH NEXT 10 ROWS ONLY) as x 
ON x.id = p.id WHERE p.cid = "CATEGORY FILTER" or 1 (1 is the index)
group by p.id
order by p.name

<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>CSE135</title>
</head>
<body>
	<%@include file="welcome.jsp" %>

	<%

	//so we can create a customer list
class Customer
{
	private int id=0;
	private String name;
	private int age = 0;
	private String state;
	private float price = 0f;

	public int getId() {return id;}
	public void setId(int id) {	this.id = id;}
	public String getName() {return name;}
	public void setName(String name) {this.name = name;}
	public int getAge() {return age;}
	public void setAge(){this.age = age;}
	public String getState(){return state;}
	public void setState(){this.state = state;}
	public void setPrice(float price) {this.price = price;}
	public float getPrice(){return price;}
}

	// creating a product list
class Product
{
	private int id=0;
	private int cid = 0;
	private String name=null;
	private int SKU = 0;
	private float price = 0f;

	public int getId() {return id;}
	public void setId(int id) {	this.id = id;}
	public String getName() {return name;}
	public void setName(String name) { this.name = name;}
	//public void getcid() { return categoryid;}
	//public void setcid(int cid) {this.categoryid = categoryid; }
	//public void getsku() { return SKU;}
	//public void setsku(int sku) {this.sku = sku;}
	public void setPrice(float price) {this.price = price;}
	public float getPrice(){return price;}
}

//initialize both lists
ArrayList<Customer> customerlist= new ArrayList<Customer>();
ArrayList<Product> productlist = new ArrayList<Product>();

Connection conn=null;
Statement stmt;
Statement stmt2;
ResultSet rs=null;
ResultSet rs2=null; 
Statement stmt3;
ResultSet stateSet = null;

ResultSet categories=null;
String SQL=null;
String disabled = "";
// one offset variable for products, the other for the actual rows (either customers or states)
String offsetvar = "";	
String offsetvar2 = "";
try
{
	// Connection code
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://localhost/cse135?";
	String user="postgres";
	String password="postgres";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	stmt2 =conn.createStatement();
	stmt3 =conn.createStatement();
	Statement stmt4 = conn.createStatement();
	// save the values of the filters
	String state = request.getParameter("state");
	String category = request.getParameter("category");
	String age = request.getParameter("age");
	String rowDD = request.getParameter("rowDD"); 
	if (rowDD == null)
		rowDD ="Customers";
	if (age == null)
		age = "All";
	%>
	<!------------------Left Side Panel------------------->
	<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<form action="salesanalytics2.jsp" method="post">
		<b>Row Drop Down:</b>
		<select name="rowDD">
			<option value="Customers" <% if (rowDD.equals("Customers")) out.println("selected"); %>>Customers</option>
			<option value="States" <% if (rowDD.equals("States")) out.println("selected"); %>>Customer States</option>
		</select>
		<input type="submit" value="Run Query">
		<br>
		<p> </p><b>Filters:</b>
		<div id="filter">
			State: 
			<select name="state">
				<%
				stateSet = stmt3.executeQuery("SELECT * FROM state order by id asc");
				out.println("<option value=\"All\"> All </option> ");
				while (stateSet.next()) {
					String stateName = stateSet.getString(2);
					if (!stateName.equals(state))
						out.println("<option value=\""+stateName+"\">"+stateName+"</option>");
					else
						out.println("<option value=\""+stateName+"\" selected>"+stateName+"</option>");

				}
				%>
			</select>
			<br>
			Category:
			<select name="category">
				<option value="All">All</option>

				<% // Populate category options
				// Get categories
				categories = stmt.executeQuery("SELECT * FROM categories order by id asc;");

				while (categories.next()) { 
					int c_id = categories.getInt(1);
					String c_name = categories.getString(2);

					if (!category.equals(""+c_id))
						out.println("<option value=\""+c_id+"\">"+c_name+"</option>");
					else
						out.println("<option value=\""+c_id+"\" selected>"+c_name+"</option>");

				 } %>  

			</select>
			<br>
			Age:
			<select name="age">
				<option value="All" <% if (age.equals("All")) out.println("selected"); %>>All</option>
				<option value= "12 AND 18" <% if (age.equals("12 AND 18")) out.println("selected"); %>>12-18</option>
				<option value= "18 AND 45" <% if (age.equals("18 AND 45")) out.println("selected"); %>>18-45</option>
				<option value= "45 AND 65" <% if (age.equals("45 AND 65")) out.println("selected"); %>>45-65</option>
				<option value= "65 AND 200" <% if (age.equals("65 AND 200")) out.println("selected"); %>>65-</option>
			</select>
		</div>
	</form>
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">

<%

StringBuilder SQL_1 = new StringBuilder();
StringBuilder SQL_2 = new StringBuilder();
String SQL_3;
String SQL_4;
String SQL_5 = null;
boolean Zeroes = false;
boolean ageFilter = (!age.equals("All") && age != null);
boolean categoryFilter = (!category.equals("All") && category != null) ;
boolean stateFilter = (!state.equals("All") && state != null);
int sizeOfList = 0;
//int executeWhich = 0;
//if((action.equals("Next10Products"))){
	//executeWhich = 1;
//}
//if((action.equals("Next20Rows"))){
	//executeWhich = 2;
//}

String nextProduct = request.getParameter("Next 10 Products");
String nextRow = request.getParameter("Next 20 Rows");

if (nextProduct != null && nextProduct.equals("Next 10 Products")) {
	//offsetvar = String.valueOf(Integer.valueOf(request.getParameter("offsetvar"))+10);
	offsetvar = String.valueOf(Integer.parseInt(request.getParameter("offsetvar"))+10);
	System.out.println("ADDED 10");
	System.out.println(offsetvar);
}
	else { System.out.println("NOT ADDING 10");
	offsetvar = "0";}
if (nextRow != null && (nextRow.equals("Next 20 Customers") 
		|| nextRow.equals("Next 20 States"))) {
	offsetvar2 = String.valueOf(Integer.parseInt(request.getParameter("offsetvar2"))+20);
	System.out.println("ADDED 20");
}
else { System.out.println("NOT ADDING 20"); 
offsetvar2 = "0";
}


	// PRODUCTS with  filters 
	// SELECT
		SQL_1.append("CREATE TEMPORARY TABLE tempProducts AS (SELECT p.id, p.name, SUM(s.quantity*s.price) ");

	// FROM
		SQL_1.append("FROM products p LEFT OUTER JOIN sales s ON p.id = s.pid ");

		// if age or state filtering on
		if (ageFilter || stateFilter) 
			SQL_1.append("LEFT OUTER JOIN users u ON u.id = s.uid ");

		// if age filtering is on
		if (ageFilter)
			SQL_1.append("AND u.age BETWEEN "+ age +" ");

		// if state filtering is on
		if (stateFilter)
			SQL_1.append("AND u.state = '"+ state + "' AND u.id = s.uid ");

		// if category filtering on
		if (categoryFilter)
			SQL_1.append("WHERE p.cid = '"+category+"' ");


	// GROUP BY
		SQL_1.append("GROUP BY p.name, p.id ");


	// ORDER BY
		SQL_1.append("ORDER BY p.name asc ");

	System.out.println(disabled);
	// PAGINATION
		SQL_1.append("OFFSET " + offsetvar + " FETCH NEXT 10 ROWS ONLY)");
	System.err.println("SQL 1: ");
	System.err.println(SQL_1.toString());
	System.err.println();


// if states was chosen as the row value
if (rowDD.equals("States") && rowDD != null)
{
	// SELECT
		SQL_2.append("CREATE TEMPORARY TABLE tempStates AS (SELECT u.state, SUM(s.quantity*s.price) ");

	// FROM
		SQL_2.append("FROM users u LEFT OUTER JOIN sales s ON u.id = s.uid ");

		// if category filtering on
		if (categoryFilter)
			SQL_2.append("LEFT OUTER JOIN products p ON s.pid = p.id WHERE p.cid = "+category + " ");

		// if age filtering is on
		if (ageFilter)
			SQL_2.append("AND u.age BETWEEN "+ age +" ");

		// if state filtering is on
		if (stateFilter)
			SQL_2.append("AND u.state = '"+ state + "' ");

	// GROUP BY
		SQL_2.append("GROUP BY u.state ");

	// ORDER BY
		SQL_2.append("ORDER BY u.state asc ");

	// PAGINATION
		SQL_2.append("OFFSET " + offsetvar2 + " FETCH NEXT 20 ROWS ONLY)");
	System.err.println("SQL 2: ");
	System.err.println(SQL_2.toString());
}

// if customers was chosen as the row value 
else if (rowDD.equals("Customers") && rowDD != null)
{
	// SELECT
	SQL_2.append("CREATE TEMPORARY TABLE tempCustomers AS (SELECT u.id, u.name, SUM(s.quantity*s.price) ");

	// FROM
	SQL_2.append("FROM users u LEFT OUTER JOIN sales s ON u.id = s.uid ");

	// if category filtering on
	if (categoryFilter)
		SQL_2.append("LEFT OUTER JOIN products p ON s.pid = p.id WHERE p.cid = "+category + " ");

	// if age filtering is on
	if (ageFilter)
		SQL_2.append("AND u.age BETWEEN "+ age +" ");

	// if state filtering is on
	if (stateFilter)
		SQL_2.append("AND u.state = '"+ state + "' ");

	// GROUP BY
	SQL_2.append("GROUP BY u.id, u.name ");

	// ORDER BY
	SQL_2.append("ORDER BY u.name asc ");

	// PAGINATION
	SQL_2.append("OFFSET " + offsetvar2 + " FETCH NEXT 20 ROWS ONLY)");

	System.err.println("SQL 2: ");
	System.err.println(SQL_2.toString());
}
if (Zeroes){
	rs=stmt.executeQuery(SQL_5);
	System.err.println("executing sql 5...");
}
else{
	System.err.println("selecting tempProducts");
	stmt.execute(SQL_1.toString());
	rs=stmt4.executeQuery("SELECT id, name, coalesce(sum,0) FROM tempproducts");
	System.err.println("FLSKDJF");
}
int product_id=0;
String product_name = null;
float product_price = 0;

while (rs.next()){
	Product product = new Product();
	product.setId(rs.getInt(1));
	product.setName(rs.getString(2));
	product.setPrice(rs.getFloat(3));
	productlist.add(product);
}
%>
	<table align="center" width="98%" border="1">
		<tr align="center">
		<%if (rowDD.equals("Customers")){%>
			<td>Customer</td><% 
		} else {
		%> <td>State</td> <% } %>

<%	
for(int i=0;i<productlist.size();i++)
{
	product_id			=   productlist.get(i).getId();
	product_name	    =	productlist.get(i).getName();
	product_price	    =	productlist.get(i).getPrice();
	%><td><%= product_name %><br><%=product_price %> </td><% 
}
%></tr>
<% 

stmt2.execute(SQL_2.toString());

System.out.println("rs2 query");
String customer_name=null;
float customer_price=0;
int customer_id =0;

if (request.getParameter("rowDD").equals("States")){
	System.out.println("IN THE IF RS2");

	rs2=stmt2.executeQuery("SELECT * FROM tempStates");

	while(rs2.next())
	{
		Customer customer =new Customer();
		customer.setName(rs2.getString(1));
		customer.setPrice(rs2.getFloat(2));
		customerlist.add(customer);
	}

	for(int i=0;i<customerlist.size();i++)
	{
		customer_name	=	customerlist.get(i).getName();
		customer_price	=	customerlist.get(i).getPrice();
		%><tr><td><%= customer_name %><br><%=customer_price %> </td> <%

		%></tr><% 
	}
}
else{
	rs2=stmt2.executeQuery("SELECT * FROM tempCustomers");
	ResultSet innerTable = stmt.executeQuery("SELECT coalesce(quantity*price,0) AS sum "
			+ "FROM sales s RIGHT OUTER JOIN (SELECT tempProducts.id AS pid, tempProducts.name, "
			+ "tempProducts.sum, tempCustomers.id, tempCustomers.id AS cid, tempCustomers.name, "
			+ "tempCustomers.sum FROM tempProducts, tempCustomers) AS y ON s.uid= y.cid AND s.pid= y.pid;");
	while(rs2.next())
	{
		sizeOfList += 1;
		if (rs2.getFloat(3) != 0.0f){
		Customer customer =new Customer();
		customer.setName(rs2.getString(2));
		customer.setPrice(rs2.getFloat(3));
		customer.setId(rs2.getInt(1));
		customerlist.add(customer);
		
		}
	}
	for(int i=0;i<customerlist.size();i++)
	{
		customer_name	=	customerlist.get(i).getName();
		customer_price	=	customerlist.get(i).getPrice();
		%><tr><td><%= customer_name %><br><%=customer_price %> </td> <%

		for (int j= 0; j < 10; j++) {
			if (innerTable.next()) 
			%> <td><%=innerTable.getInt(1) %></td><%

		}
		%></tr><% 
	}
}

String buttonVal = "";
// Decide which button to show based on the rows selection
if (rowDD.equals("States")) {
	buttonVal = "Next 20 States";
} else {
buttonVal = "Next 20 Customers";
}
System.out.println(request.getParameter("offsetvar"));
System.out.println("HIHIHI");
if (sizeOfList < 20){
	System.out.println("LESS THAN 20 CST");
	System.out.println(customerlist.size());
}
else{
%>
<div align="right"><form action="salesanalytics2.jsp" method="get" value="Next20Rows">
	<input type="submit" name="Next 20 Rows" value="<%=buttonVal%>"/>
	<input type="hidden" name="offsetvar2" value="<%=offsetvar2 %>"/>
	<input type="hidden" name="offsetvar" value="<%=offsetvar %>"/>
	<input type ="hidden" name="state" value="<%=state%>">
	<input type ="hidden" name="category" value="<%=category%>">
	<input type ="hidden" name="age" value="<%=age%>">
	<input type ="hidden" name="rowDD" value="<%=rowDD%>">
	
</form></div>
<% } %>

<% if (productlist.size() < 10){
	System.out.println("LESS THAN 10 PRD");
}
else {
%>

<div align="right"><form action="salesanalytics2.jsp" method="get" value="Next10Products">
    <input type="submit" name="Next 10 Products" value="Next 10 Products"/>
    <input type="hidden" name="offsetvar2" value="<%=offsetvar2 %>"/>
    <input type="hidden" name="offsetvar" value="<%=offsetvar %>"/>
    <input type ="hidden" name="state" value="<%=state%>">
	<input type ="hidden" name="category" value="<%=category%>">
	<input type ="hidden" name="age" value="<%=age%>">
	<input type ="hidden" name="rowDD" value="<%=rowDD%>">
</form></div>
 <% 
}

}


catch(Exception e)
{
	out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}	
%>	
</tr>
</table>
</div>
</body>
</html>




<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>CSE135</title>
</head>
<body>
	<%@include file="welcome.jsp" %>

	<%

	//so we can create a customer list
class Customer
{
	private int id=0;
	private String name;
	private int age = 0;
	private String state;
	private float price = 0f;

	public int getId() {return id;}
	public void setId(int id) {	this.id = id;}
	public String getName() {return name;}
	public void setName(String name) {this.name = name;}
	public int getAge() {return age;}
	public void setAge(){this.age = age;}
	public String getState(){return state;}
	public void setState(){this.state = state;}
	public void setPrice(float price) {this.price = price;}
	public float getPrice(){return price;}
}

	// creating a product list
class Product
{
	private int id=0;
	private int cid = 0;
	private String name=null;
	private int SKU = 0;
	private float price = 0f;

	public int getId() {return id;}
	public void setId(int id) {	this.id = id;}
	public String getName() {return name;}
	public void setName(String name) { this.name = name;}
	//public void getcid() { return categoryid;}
	//public void setcid(int cid) {this.categoryid = categoryid; }
	//public void getsku() { return SKU;}
	//public void setsku(int sku) {this.sku = sku;}
	public void setPrice(float price) {this.price = price;}
	public float getPrice(){return price;}
}

//initialize both lists
ArrayList<Customer> customerlist= new ArrayList<Customer>();
ArrayList<Product> productlist = new ArrayList<Product>();

Connection conn=null;
Statement stmt;
Statement stmt2;
ResultSet rs=null;
ResultSet rs2=null; 

ResultSet categories=null;
String SQL=null;
// one offset variable for products, the other for the actual rows (either customers or states)
int offsetvar = 0;	
int offsetvar2 = 0;
try
{
	// Connection code
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://localhost/cse135?";
	String user="postgres";
	String password="postgres";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	stmt2 =conn.createStatement();

	%>
	<!------------------Left Side Panel------------------->
	<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<form action="salesanalytics2.jsp" method="post">
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
				// Get categories
				categories = stmt.executeQuery("SELECT * FROM categories order by id asc;");

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
				<option value= "12 AND 18">12-18</option>
				<option value= "18 AND 45">18-45</option>
				<option value= "45 AND 65">45-65</option>
				<option value= "65 AND 200">65-</option>
			</select>
		</div>
	</form>
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">

<%
// save the values of the filters
String state = request.getParameter("state");
String category = request.getParameter("category");
String age = request.getParameter("age");

StringBuilder SQL_1 = new StringBuilder();
StringBuilder SQL_2 = new StringBuilder();
String SQL_3;
String SQL_4;
String SQL_5 = null;

boolean ageFilter = (!age.equals("All") && age != null);
boolean categoryFilter = (!category.equals("All") && category != null) ;
boolean stateFilter = (!state.equals("All") && state != null);


// PRODUCTS with  filters 

// SELECT
	SQL_1.append("SELECT p.id, p.name, coalesce(Sum(total), 0) FROM products p LEFT OUTER JOIN (SELECT p.id, p.name, SUM(s.quantity*s.price) as total ");

// FROM
	SQL_1.append("FROM products p LEFT OUTER JOIN sales s ON p.id = s.pid ");

	// if category filtering on
	if (categoryFilter)
		SQL_1.append("INNER JOIN categories c ON c.id = p.cid AND c.name = '"+category+"' ");

	// if age or state filtering on
	if (ageFilter || stateFilter) 
		SQL_1.append("INNER JOIN users u ON u.id = s.uid ");

	// if age filtering is on
	if (ageFilter)
		SQL_1.append("AND u.age BETWEEN "+ age +" ");

	// if state filtering is on
	if (stateFilter)
		SQL_1.append("AND u.state = '"+ state + "' ");

// GROUP BY
	SQL_1.append("GROUP BY p.name, p.id ");


// ORDER BY
	SQL_1.append("ORDER BY p.name asc ");

// PAGINATION
	SQL_1.append("OFFSET " + offsetvar + " FETCH NEXT 10 ROWS ONLY) as x ON x.id = p.id GROUP BY p.id ORDER BY p.name");

System.err.println("SQL 1 " + SQL_1.toString());


boolean stateRow = true;
String rowDD = request.getParameter("rowDD"); 
// if states was chosen as the row value
if (rowDD.equals("States") && rowDD != null)
{
	// SELECT
		SQL_2.append("SELECT u.state, SUM(s.quantity*s.price) ");

	// FROM
		SQL_2.append("FROM users u INNER JOIN sales s ON u.id = s.uid ");

		// if category filtering on
		if (categoryFilter)
			SQL_2.append(", products INNER JOIN categories c ON c.id = products.cid AND c.name = '"+category+"' ");

		// if age filtering is on
		if (ageFilter)
			SQL_2.append("AND u.age BETWEEN "+ age +" ");

		// if state filtering is on
		if (stateFilter)
			SQL_2.append("AND u.state = '"+ state + "' ");

	// GROUP BY
		SQL_2.append("GROUP BY u.state ");


	// ORDER BY
		SQL_2.append("ORDER BY u.state asc ");

	// PAGINATION
		SQL_2.append("OFFSET " + offsetvar2 + " FETCH NEXT 10 ROWS ONLY");


	System.err.println("SQL 2: " + SQL_2.toString());
}

// if customers was chosen as the row value 
else if (rowDD.equals("Customers") && rowDD != null)
{

}


rs=stmt.executeQuery(SQL_1.toString());
int product_id=0;
String product_name = null;
float product_price = 0;

while (rs.next()){
	Product product = new Product();
	product.setId(rs.getInt(1));
	product.setName(rs.getString(2));
	product.setPrice(rs.getFloat(3));
	productlist.add(product);
}
%>
	<table align="center" width="98%" border="1">
		<tr align="center">
		<%if (rowDD.equals("Customers")){%>
			<td>Customer</td><% 
		} else {
		%> <td>State</td> <% } %>

<%	
for(int i=0;i<productlist.size();i++)
{
	product_id			=   productlist.get(i).getId();
	product_name	    =	productlist.get(i).getName();
	product_price	    =	productlist.get(i).getPrice();
	%><td><%= product_name %><br><%=product_price %> </td><% 
}
%></tr>
<% 

rs2=stmt2.executeQuery(SQL_2.toString());
System.out.println("rs2 query");
String customer_name=null;
float customer_price=0;
int customer_id =0;

if (stateRow){
	while(rs2.next())
	{
		Customer customer =new Customer();
		customer.setName(rs2.getString(1));
		customer.setPrice(rs2.getFloat(2));
		customerlist.add(customer);
		System.out.println("IN THE IF RS2");
	}
	for(int i=0;i<customerlist.size();i++)
	{
		customer_name	=	customerlist.get(i).getName();
		customer_price	=	customerlist.get(i).getPrice();
		%><tr><td><%= customer_name %><br><%=customer_price %> </td></tr><% 

	}
}
else{
	/*while(rs2.next())
	{
		customer_id = rs2.getInt(1);
		customer_name=rs2.getString(2);
		customer_price=rs2.getFloat(3);
		Customer customer =new Customer();
		customer.setName(customer_name);
		customer.setPrice(customer_price);
		customer.setId(customer_id);
		customerlist.add(customer);
		System.out.println("IN THE ELSE RS2");
	}

	for(int i=0;i<customerlist.size();i++)
	{
		customer_name	=	customerlist.get(i).getName();
		customer_price	=	customerlist.get(i).getPrice();*/
				//FOR EVERY ROW, BUILD THE INNER DATA USING COMBINATION OF CUSTOMER NAME AND THE PRODUCT NAME
				// DO SUM QUERY 
				//"SELECT SUM(sales.price*sales.quantity) FROM users, sales, products"+
				//"WHERE "
	//}
}
 
}


catch(Exception e)
{
	out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}	
%>	
</tr>
</table>
</div>
</body>
</html>
