<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Sales Analytics" />
<%

class Item 
{
	private int id=0;
	private String name=null;
	private float amount_price=0f;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public float getAmount_price() {
		return amount_price;
	}
	public void setAmount_price(float amount_price) {
		this.amount_price = amount_price;
	}
}

ArrayList<Item> p_list=new ArrayList<Item>();
ArrayList<Item> s_list=new ArrayList<Item>();
Item item=null;
Connection conn=null;
Statement stmt,stmt_2,stmt_3;
ResultSet rs=null,rs_2=null,rs_3=null;
String SQL=null;
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://localhost/cse135?";
	String user="postgres";
	String password="postgres";
	conn =DriverManager.getConnection(url, user, password);
            
/* 	conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
    	"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); */
            
	stmt =conn.createStatement();
	stmt_2 =conn.createStatement();
	stmt_3 =conn.createStatement();

	System.out.println("=================");

	String scope = ""+request.getParameter("scope");
	System.out.println("scope: " + scope);

	String r_offset, next_r_offset;
	if(request.getParameter("r_offset") != null && !request.getParameter("r_offset").equals("0"))
	{
		r_offset = String.valueOf(Integer.valueOf(request.getParameter("r_offset")));
		next_r_offset = String.valueOf(Integer.valueOf(request.getParameter("r_offset"))+20);
	}
	else
	{
		r_offset = "0";
		next_r_offset = "20";
	}
	System.out.println("r_offset: " + r_offset);
	System.out.println("next_r_offset: " + next_r_offset);

	String c_offset, next_c_offset;
	if(request.getParameter("c_offset") != null && !request.getParameter("c_offset").equals("0"))
	{
		c_offset = String.valueOf(Integer.valueOf(request.getParameter("c_offset")));
		next_c_offset = String.valueOf(Integer.valueOf(request.getParameter("c_offset"))+10);
	}
	else
	{
		c_offset = "0";
		next_c_offset = "10";
	}

	System.out.println("c_offset: " + c_offset);
	System.out.println("next_c_offset: " + next_c_offset);

	String state = request.getParameter("state");
	System.out.println("state: " + state);

	String category = request.getParameter("category");
	System.out.println("category: " + category);

	String age = request.getParameter("ages");
	System.out.println("age: " + age);

	//Determine if buttons need to be disabled because of offset
	String disabled = "disabled";
	if(r_offset.equals("0") && c_offset.equals("0"))
	{
		disabled = "";
	}
	System.out.println(disabled);

	String SQL_1 = null;
	String SQL_2 = null;

	String SQL_11 = null;
	String SQL_21 = null;

	if(category == null || category.equals("all"))
	{
		System.out.println("columns: product - no filters");
		/** pulls product names, no filters**/
		SQL_1="select p.id, p.name, sum(s.quantity*s.price) as amount from products p, sales s "+
					 "where s.pid=p.id "+
					 "group by p.name,p.id "+
					 "order by  p.name asc "+
					 "limit 10" +"offset "+c_offset+";"; 
		SQL_11="select p.id, p.name, sum(s.quantity*s.price) as amount from products p, sales s "+
				 "where s.pid=p.id "+
				 "group by p.name,p.id "+
				 "order by  p.name asc "+
				 "limit 1" +"offset "+next_c_offset+";"; 
	}
	else
	{
		System.out.println("columns: product - category filters");
		/** pulls product names, category filter**/		 
		SQL_1="select p.id, p.name, sum(s.quantity*s.price) as amount from products p, sales s "+
					 "where s.pid=p.id AND p.cid='"+ category +"'" +
					 "group by p.name,p.id "+
					 "order by  p.name asc "+
					 "limit 10" +"offset "+c_offset+";"; 	
		SQL_11="select p.id, p.name, sum(s.quantity*s.price) as amount from products p, sales s "+
				 "where s.pid=p.id AND p.cid='"+ category +"'" +
				 "group by p.name,p.id "+
				 "order by  p.name asc "+
				 "limit 1" +"offset "+next_c_offset+";"; 
	}			


	//scope = states
	if(scope.equals("states"))
	{
		if(state == null || state.equals("all"))
		{
			System.out.println("rows: states - no filters");
			/** pulls state names, no filters**/
			SQL_2="select  u.state, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
						  "where s.uid=u.id and s.pid=p.id "+ 
						  "group by u.state "+ 
						  "order by u.state asc "+
						  "limit 20" +"offset "+r_offset+";"; 
			SQL_21="select  u.state, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id "+ 
					  "group by u.state "+ 
					  "order by u.state asc "+
					  "limit 1" +"offset "+next_r_offset+";";
		}
		else
		{
			System.out.println("rows: states - state filters");
			/* pulls state names, state filter */
			SQL_2="select  u.state, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
						"where s.uid=u.id and s.pid=p.id AND u.state='"+ state +"'" + 
						"group by u.state "+ 
						"order by u.state asc "+
						"limit 20" +"offset "+r_offset+";"; 
			SQL_21="select  u.state, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					"where s.uid=u.id and s.pid=p.id AND u.state='"+ state +"'" + 
					"group by u.state "+ 
					"order by u.state asc "+
					"limit 1" +"offset "+next_r_offset+";"; 
		}
	}
	//scope = customers
	else
	{
		int selector = 11;
		if (state != null && !state.equals("all"))
			selector -= 1;
		if (age != null && !age.equals("all"))
			selector -= 10;
		System.out.println("selector: " + selector);

		if(selector == 11)
		{
			System.out.println("rows: user - no filters");
			/** pulls user names, no filters**/
			SQL_2="select  u.name, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id "+ 
					  "group by u.name "+ 
					  "order by u.name asc "+
					  "limit 20" +"offset "+r_offset+";"; 
			SQL_21="select  u.name, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id "+ 
					  "group by u.name "+ 
					  "order by u.name asc "+
					  "limit 1" +"offset "+next_r_offset+";"; 
		}
		else if(selector == 10) 
		{
			System.out.println("rows: user - state filters");
			/* pulls user names, state filter */ 	
			SQL_2="select  u.name, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id AND u.state='"+ state +"'" + 
					  "group by u.name "+ 
					  "order by u.name asc "+
					  "limit 20" +"offset "+r_offset+";"; 
			SQL_21="select  u.name, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id AND u.state='"+ state +"'" + 
					  "group by u.name "+ 
					  "order by u.name asc "+
					  "limit 1" +"offset "+next_r_offset+";"; 
		}
		else if (selector == 01)
		{
			System.out.println("rows: user - age filters");
			/* pulls user names, age filter */ 	
			SQL_2="select  u.name, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id AND u.age between " + age +  
					  "group by u.name "+ 
					  "order by u.name asc "+
					  "limit 20" +"offset "+r_offset+";"; 
			SQL_21="select  u.name, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id AND u.age between " + age +  
					  "group by u.name "+ 
					  "order by u.name asc "+
					  "limit 1" +"offset "+next_r_offset+";"; 
		}
		else if (selector == 00)
		{
			System.out.println("rows: user - age and state filters");
			/* pulls user names, age and state filter */ 	
			SQL_2="select  u.name, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id AND u.age between " + age + " AND u.state='"+ state +"'" +
					  "group by u.name "+ 
					  "order by u.name asc "+
					  "limit 20" +"offset "+r_offset+";"; 
			SQL_21="select  u.name, sum(s.quantity*s.price) as amount from users u, sales s,  products p "+
					  "where s.uid=u.id and s.pid=p.id AND u.age between " + age + " AND u.state='"+ state +"'" +
					  "group by u.name "+ 
					  "order by u.name asc "+
					  "limit 1" +"offset "+next_r_offset+";"; 
		}
	}

	/* Determine if there are more rows and columns */
	Statement stmt_11 =conn.createStatement();
	ResultSet rs_11=stmt_11.executeQuery(SQL_11);
	boolean moreColumns = false;
	while(rs_11.next())
	{
		moreColumns = true;
	}
	Statement stmt_21 =conn.createStatement();
	ResultSet rs_21=stmt_21.executeQuery(SQL_21);
	boolean moreRows = false;
	while(rs_21.next())
	{
		moreRows = true;
	}

	System.out.println("moreColumns: " + moreColumns);
	System.out.println("moreRows: " + moreRows);


	rs=stmt.executeQuery(SQL_1);

	int p_id=0;
	String p_name=null;
	float p_amount_price=0;
	while(rs.next())
	{
		p_id=rs.getInt(1);
		p_name=rs.getString(2);
		p_amount_price=rs.getFloat(3);
		item=new Item();
		item.setId(p_id);
		item.setName(p_name);
		item.setAmount_price(p_amount_price);
		p_list.add(item);

	}

	rs_2=stmt_2.executeQuery(SQL_2);//state not id, many users in one state
	String s_name=null;
	float s_amount_price=0;
	while(rs_2.next())
	{
		s_name=rs_2.getString(1);
		s_amount_price=rs_2.getFloat(2);
		item=new Item();
		item.setName(s_name);
		item.setAmount_price(s_amount_price);
		s_list.add(item);
	}	
//    out.println("product #:"+p_list.size()+"<br>state #:"+s_list.size()+"<p>");
	int i=0,j=0;
	String SQL_3="";	
	float amount=0;
%>
	<table align="center" width="98%" border="1">
		<tr align="center">
			<%
			if(scope.equals("states")) {
				%>
				<td><strong><font color="#FF0000">STATE</font></strong></td>
				<%
			}
			else{
				%>
				<td><strong><font color="#FF0000">USER</font></strong></td>
				<%
			}
			%>
<%	
	for(i=0;i<p_list.size();i++)
	{
		p_id			=   p_list.get(i).getId();
		p_name			=	p_list.get(i).getName();
		p_amount_price	=	p_list.get(i).getAmount_price();
		out.print("<td> <strong>"+p_name+"<br>["+p_amount_price+"]</strong></td>");
	}

	if(moreColumns)
	{
		//out.print("<td><input type='submit' class='btn btn-primary' value='Next 10'></td>");
		int offset = Integer.valueOf(c_offset) + 10;
		%>
		<td colspan="10">

	   	<form action="roughdraft.jsp" method="GET">
			<div class="form-group">
				<input type ="hidden" name=scope value="<%=scope%>">
				<input type ="hidden" name=r_offset value="<%=r_offset%>">
				<input type ="hidden" name=c_offset value="<%=offset%>">
				<input type ="hidden" name=state value="<%=state%>">
				<input type ="hidden" name=category value="<%=category%>">
				<input type ="hidden" name=ages value="<%=age%>">
			</div>
			<button type="submit" class="btn btn-primary">Next 10</button>
		</form>
		</td>
		<%
	}

	if(p_list.size() == 0)
	{
		out.print("<td> <strong> No Items in Category </strong></td>");
	}
%>
		</tr>
<%	
	System.out.println("s_list: " + s_list.size());
	System.out.println("p_list: " + p_list.size());
	for(i=0;i<s_list.size();i++)
	{
		s_name			=	s_list.get(i).getName();
		s_amount_price	=	s_list.get(i).getAmount_price();
		out.println("<tr  align=\"center\">");
		out.println("<td><strong>"+s_name+"["+s_amount_price+"]</strong></td>");
		for(j=0;j<p_list.size();j++)
		{
			p_id			=   p_list.get(j).getId();
			p_name			=	p_list.get(j).getName();
			p_amount_price	=	p_list.get(j).getAmount_price();

			if (scope.equals("states"))
			{
				if(age == null || age.equals("all"))
				{
					SQL_3="select sum(s.quantity*p.price) as amount from users u, products p, sales s "+
							 "where s.uid=u.id and s.pid=p.id and u.state='"+s_name+"' and p.id='"+p_id+"' group by u.state, p.name";
				}
				else
				{
					SQL_3="select sum(s.quantity*p.price) as amount from users u, products p, sales s "+
							 "where u.age between " + age + "and s.uid=u.id and s.pid=p.id and u.state='"+s_name+"' and p.id='"+p_id+"' group by u.state, p.name";
				}
			}
			else
			{
				SQL_3="select sum(s.quantity*p.price) as amount from users u, products p, sales s "+
						 "where s.uid=u.id and s.pid=p.id and u.name='"+s_name+"' and p.id='"+p_id+"' group by u.name, p.name";
			}

			 rs_3=stmt_3.executeQuery(SQL_3);
			 if(rs_3.next())
			 {
				 amount=rs_3.getFloat(1);
				 out.print("<td><font color='#0000ff'>"+amount+"</font></td>");
			 }
			 else
			 {
			 	out.println("<td><font color='#ff0000'>0</font></td>");
			 }

		}
		if(p_list.size() == 0)
		{
			out.println("<td><font color='#ff0000'>n/a</font></td>");
		}
		out.println("</tr>");
	}

	if(s_list.size() == 0)
	{
		if(scope.equals("states"))
		{
			%>
			<t:message type="warning" message="State does not exist. Please choose another state."></t:message>
			<%
		}
		else
		{
			%>
			<t:message type="warning" message="No such users."></t:message>
			<%
		}
	}

	session.setAttribute("TOP_10_Products",p_list);

	if(moreRows)
	{
		int offset = Integer.valueOf(r_offset) + 20;
		%>
		<tr><td colspan="10">

	   	<form action="roughdraft.jsp" method="GET">
			<div class="form-group">
				<input type ="hidden" name=scope value="<%=scope%>">
				<input type ="hidden" name=r_offset value="<%=offset%>">
				<input type ="hidden" name=c_offset value="<%=c_offset%>">
				<input type ="hidden" name=state value="<%=state%>">
				<input type ="hidden" name=category value="<%=category%>">
				<input type ="hidden" name=ages value="<%=age%>">
			</div>
			<button type="submit" class="btn btn-primary">Next 20</button>
		</form>
		</td></tr>
		<%
	}
%>
	</table>

	<div class="row">

		<%
			PreparedStatement c_pstmt = null;
			ResultSet c_rs = null;

			c_pstmt = conn.prepareStatement("SELECT * FROM categories");
			c_rs = c_pstmt.executeQuery();
		%>

		<!-- For Choosing States vs. Customers Table -->
		<form class="navbar-form navbar-left" role="search" action="roughdraft.jsp" method="GET">
		<div class="col-sm-12">
				<select class="form-control" name="scope" <%= disabled %>>
					<option value="states">States</option>
		        	<option value="customers">Customers</option>
		        </select>

		        <select class="form-control" name="ages" <%= disabled %>>
		        	<option value="all">All Ages</option>
		        	<option value="12 and 18">12-18</option>
		        	<option value="18 and 45">18-45</option>
		        	<option value="45 and 65">45-65</option>
		        	<option value="65 and 150">65-</option>
		        </select>
		        <select class="form-control" name="category" <%= disabled %>>
		        	<option value="all">All Categories</option>
		        	<% while(c_rs.next())
		        		{%>
		        		<option value="<%= c_rs.getString("id") %>"><%= c_rs.getString("name")%></option>
		        		<% }
		        		%>
		        </select>
		        <select class="form-control" name="state" <%= disabled %>>
		        	<option value="all">All States</option>
					<option value="Alabama">Alabama</option>
					<option value="Alaska">Alaska</option>
					<option value="Arizona">Arizona</option>
					<option value="Arkansas">Arkansas</option>
					<option value="California">California</option>
					<option value="Colorado">Colorado</option>
					<option value="Connecticut">Connecticut</option>
					<option value="Delaware">Delaware</option>
					<option value="District Of Columbia">District Of Columbia</option>
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
					<option value="Sout Carolina">South Carolina</option>
					<option value="South Dakora">South Dakota</option>
					<option value="Tennessee">Tennessee</option>
					<option value="Texas">Texas</option>
					<option value="Utah">Utah</option>
					<option value="Vermont">Vermont</option>
					<option value="Virginia">Virginia</option>
					<option value="West Virginia">Washington</option>
					<option value="West Virginia">West Virginia</option>
					<option value="Wisconsin">Wisconsin</option>
					<option value="Wyoming">Wyoming</option>
				</select>
				<input type="hidden" name="query" value="true"/>
				<% if(!disabled.equals("disabled")){
		        	%><input type="submit"  class="btn btn-default" /><%
		        }
		        %>

		   	</div>
		   	</form>   
		</div>


<%
}
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