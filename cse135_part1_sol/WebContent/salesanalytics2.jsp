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
	
	public int getId() {return id;}
	public void setId(int id) {	this.id = id;}
	public String getName() {return name;}
	public void setName(String name) {this.name = name;}
	public void getAge() {return age;}
	public void setAge(){this.age = age;}
	public void getState(){return state;}
	public void setState(){this.state = state;}
}

	// creating a product list
class Product
{
	private int id=0;
	private int cid = 0;
	private String name=null;
	private int SKU = 0;
	private int price = 0;
	
	public int getId() {return id;}
	public void setId(int id) {	this.id = id;}
	public String getName() {return name;}
	public void setName(String name) { this.name = name;}
	public void getcid() { return categoryid;}
	public void setcid(int cid) {this.categoryid = categoryid; }
	public void getsku() { return SKU;}
	public void setsku(int sku) {this.sku = sku;}
	public void setPrice(int price) {this.price = price;}
	public void getPrice(){return price}
}

	//initialize both lists
List<Customer> customerlist= new List<Customer>();
List<Product> productlist = new List<Product>();

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
	div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">	
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
				<option value= "12 and 18">12-18</option>
				<option value= "18 and 45">18-45</option>
				<option value= "45 and 65">45-65</option>
				<option value= "65 and 200">65-</option>
			</select>
		</div>
	</form>
</div>
<%
// save the values of the filters
String state = request.getParameter("state");
String category = request.getParameter("category");
String age = request.getParameter("ages");
String SQL_1 = null;
String SQL_2 = null;
String SQL_3 = null;


// PRODUCTS aka column filters 
// no filters
if (category == all || category == null)
{
	SQL_ 1 = "select p.id, p.name, sum(s.quantity*s.price) as amount from products, sales "+
			 "where products.id = sales.id "+
			 "group by products.name,products.id "+
			 "order by  product.name asc "+
			 "offset " + offsetvar + "fetch next 10 rows only;";

}
// if there is a filer, then take into account the category name
else 
{
	SQL_1 =  "select p.id, p.name, sum(s.quantity*s.price) as amount from products, sales "+
			 "where products.cid = categories.id AND categories.name='"+ category +"'" +
			 "group by products.name,products.id "+
			 "order by products.name asc "+
			 "offset " + offsetvar + "fetch next 10 rows only;";
}

String rowDD = request.getParameter("rowDD"); 
// if states was chosen as the row value
if (rowDD.equals("States") && rowDD != null))
{
	// display all states because no filters
	if(state == null || state.equals("All"))
	{
		SQL_2="select  users.state, sum(sales.quantity*sales.price) from users, sales,  products "+
					  //"where sales.uid=users.id and sales.pid=products.id "+ 
					  "group by users.state "+ 
					  "order by users.state asc "+
					  "offset " + offsetvar2 + "fetch next 20 rows only;";
	}
	// states are being filtered
	else
	{
		SQL_2="select  users.state, sum(sales.quantity*sales.price) from users, sales,  products "+
					"where sales.uid=u.id and sales.pid=product.id AND users.state='"+ state +"'" + 
					"group by users.state "+ 
					"order by users.state asc "+
					 "offset " + offsetvar2 + "fetch next 20 rows only;";
	}
}

// if customers was chosen as the row value 
else if (rowDD.equals("Customers") && rowDD != null))
{
	//default case
	if(state == null || state.equals("All") || age.equals("All"))
	{
		SQL_2="select users.id, users.name, sum(sales.quantity*sales.price) from users, sales,  products "+
				  //"where sales.uid=u.id and sales.pid=p.id "+ 
				  "group by users.id "+ 
				  "order by users.id asc "+
				  "offset " + offsetvar2 + "fetch next 20 rows only;";
	}
	// if there is a state filter
	else if(!state.equals("All") && state !=null && age.equals("All")) 
	{
			//no filters	
		SQL_2="select users.id, users.name, sum(s.quantity*s.price) as amount from users, sales,  products "+
				 // "where users.id =sales.uid and sales.pid=products.id AND users.state='"+ state +"'" + 
				  "group by users.id "+ 
				  "order by users.id asc "+
				  "offset " + offsetvar2 + "fetch next 20 rows only;";
	}
		// if there is an age filter
	else if (!age.equals("All") && age != null && state.equals("All"))
	{
		SQL_2="select  users.id , users.name, sum(s.quantity*s.price) as amount from users, sales,  products "+
				  "where users.id = sales.uid and sales.pid=products.id AND users.age between " + age +  
				  "group by users.name "+ 
				  "order by u.name asc "+
				  "offset " + offsetvar2 + "fetch next 20 rows only;";
	}
	  //age/state both filtered turned on 
	  else if (!age.equals("All") && age != null !state.equals("All") && state !=null )
		SQL_2="select  users.name, sum(sales.quantity*sales.price) as amount from users, sales,  products "+
			  "where sales.uid=users.id and sales.pid=products.id AND users.age between " + age + " AND users.state='"+ state +"'" +
			  "group by users.name "+ 
			  "order by users.name asc "+
			  "offset " + offsetvar2 + "fetch next 20 rows only;";
}

rs=stmt.executeQuery(SQL_1);

		
catch(Exception e)
{
	//out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}	
%>	
</body>
</html>