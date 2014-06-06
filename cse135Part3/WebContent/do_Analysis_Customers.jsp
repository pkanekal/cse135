<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>

<body>
<%

ArrayList<String> p_name_list=new ArrayList<String>();//product ID, 10
ArrayList<Integer> p_id_list=new ArrayList<Integer>();//product ID, 10
ArrayList<Integer> u_id_list=new ArrayList<Integer>();//customer ID,20
ArrayList<String> u_name_list=new ArrayList<String>();//customer ID,20
HashMap<String, Integer> product_name_amount	=	new HashMap<String, Integer>();
HashMap<String, Integer> customer_name_amount=	new HashMap<String, Integer>();
HashMap<String, Integer> innerTable =	new HashMap<String, Integer>();

%>
<%
	String  state=null, category=null;
	try { 
			state     =	request.getParameter("state"); 
			category  =	request.getParameter("category"); 
	}
	catch(Exception e) 
	{ 
       state=null; category=null;
	}
	String  pos_row_str=null, pos_col_str=null;
	int pos_row=0, pos_col=0;
	try { 
			pos_row_str     =	request.getParameter("pos_row"); 
			pos_row=Integer.parseInt(pos_row_str);		
			pos_col_str     =	request.getParameter("pos_col"); 
			pos_col=Integer.parseInt(pos_col_str);		
	}
	catch(Exception e) 
	{ 
       pos_row_str=null; pos_row=0;
       pos_col_str=null; pos_col=0;

	}
%>
<%
Connection	conn=null;
Statement 	stmt,stmt2;
ResultSet 	rs=null;
String  	SQL_u=null,SQL_p=null, SQL_amount_cell=null;
String  	SQL_ut=null,SQL_pt=null,SQL_su=null,SQL_sp=null;
String		p_name=null,u_name=null;
int			p_id=0,u_id=0;
int 		p_amount_price=0,u_amount_price=0;

int show_num_row=20, show_num_col=10;
	
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://localhost/cse135?";
	String user="postgres";
	String password="postgres";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	stmt2 =conn.createStatement();
	
	if(("All").equals(state) && ("0").equals(category))//no filters
	{
		SQL_u="SELECT u.id, u.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, users u "
			+	"WHERE precomputeproduser.userid = u.id "
			+	"GROUP BY u.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.id, p.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, products p "
			+	"WHERE precomputeproduser.prodid = p.id "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";
		System.err.println("users with no filter");

	}
	
	if(("All").equals(state) && !("0").equals(category))// only category filter
	{
		SQL_u="SELECT u.id, u.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, users u, products p, categories "
			+	"WHERE precomputeproduser.userid = u.id AND precomputeproduser.prodid = p.id AND p.cid = categories.id AND categories.name = '"+category+"' "
			+	"GROUP BY u.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.id, p.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, products p, categories c "
			+	"WHERE precomputeproduser.prodid = p.id AND p.cid = c.id AND c.name = '"+category+"' "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";
		System.err.println("users with only category filter");

	}
	if(!("All").equals(state) && ("0").equals(category))// only state filter
	{
		SQL_u=" SELECT u.id, u.name, sum(pu.sum) "
			+	"FROM precomputeproduser pu, users u "
			+	"WHERE pu.userid = u.id AND u.state = '"+state+"' "
			+	"GROUP BY u.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.id, p.name, sum(pu.sum) "
			+	"FROM precomputeproduser pu, products p, users u "
			+	"WHERE pu.prodid = p.id AND u.id = pu.userid " 
			+	"AND u.state = '"+state+"' "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";
		System.err.println("users with only state filter");

	}
	if(!("All").equals(state) && !("0").equals(category))// both filters
	{
		SQL_u="SELECT u.id, u.name, sum(pu.sum) "
			+	"FROM precomputeproduser pu, users u, products p, categories c "
			+	"WHERE pu.userid = u.id AND pu.prodid = p.id AND p.cid = c.id AND c.name = '"+category+"' AND u.state = '"+state+"' "
			+	"GROUP BY u.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.id, p.name, sum(pu.sum) "
			+	"FROM precomputeproduser pu, products p, categories c, users u "
			+	"WHERE pu.userid = u.id AND pu.prodid = p.id AND p.cid = c.id AND c.name = '"+category+"' AND u.state = '"+state+"' "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";
		System.err.println("users with category and state filter");

	}
	System.err.println("SQL_u:");
	System.err.println(SQL_u);
	System.err.println("SQL_p:");
	System.err.println(SQL_p);
	
	SQL_ut="insert into u_t (id, name, sum) "+SQL_u;
	SQL_pt="insert into p_t (id, name, sum) "+SQL_p;
	conn.setAutoCommit(false);

	stmt2.execute("CREATE TEMP TABLE u_t (id int, name text, sum int)");
	stmt2.execute("CREATE TEMP TABLE p_t (id int, name text, sum int)");
	
	System.err.println("SQL_ut:");
	System.err.println(SQL_ut);
	System.err.println("SQL_pt:");
	System.err.println(SQL_pt);
	
	//user tempory table
	long start=System.currentTimeMillis();
	stmt2.execute(SQL_ut);
	long end=System.currentTimeMillis();
    System.out.println("Finished user query, running time:"+(end-start)+"ms");
    
	//product tempory table
	start=System.currentTimeMillis();
	stmt2.execute(SQL_pt);
	end=System.currentTimeMillis();
    System.out.println("Finished products query, running time:"+(end-start)+"ms");
    
	SQL_su = "SELECT * FROM u_t ORDER BY sum DESC";
	SQL_sp = "SELECT * FROM p_t ORDER BY sum DESC";
	

	//customer name and amount
	rs=stmt.executeQuery(SQL_su);

	while(rs.next())
	{
		u_id = rs.getInt(1);
		u_id_list.add(u_id);
		u_name=rs.getString(2);
		u_name_list.add(u_name);
		u_amount_price=rs.getInt(3);
		customer_name_amount.put(u_name, u_amount_price);
		
	}

	//product name and amount

	rs=stmt.executeQuery(SQL_sp);

	while(rs.next())
	{
		p_id = rs.getInt(1);
		p_id_list.add(p_id);
		p_name=rs.getString(2);
	    p_name_list.add(p_name);
		p_amount_price=rs.getInt(3);

		product_name_amount.put(p_name,p_amount_price);
		
	}
	for (int i = 0; i < u_id_list.size(); i++) {
		int userID = u_id_list.get(i);
		for (int j = 0; j < p_id_list.size(); j++) {
			int prodID = p_id_list.get(j);
			
			innerTable.put(userID+"_"+prodID,0);
		}
	}
%>	

	<table align="center" width="100%" border="1">
		<tr align="center">
			<td width="12%"><table align="center" width="100%" border="0"><tr align="center"><td><strong><font size="+2" color="#FF00FF">CUSTOMER</font></strong></td></tr></table></td>
			<td width="88%">
				<table align="center" width="100%" border="1">
					<tr align="center">
<%	
	int amount_show=0;
	int i;
	for(i=0;i<p_name_list.size();i++)
	{
		p_name			=	p_name_list.get(i);
		if(product_name_amount.get(p_name)!=null)
		{
			amount_show=(Integer)product_name_amount.get(p_name);
			if(amount_show!=0)
			{
				out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td>");
			}
			else
			{
				out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#ff0000'>$0</font>)</strong></td>");
			}	
		}
		else
		{
			out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#ff0000'>$0</font>)</strong></td>");
		}
	}
%>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<table align="center" width="100%" border="1">
<tr><td width="12%">
	<table align="center" width="100%" border="1">
	<%	
		for(i=0;i<u_name_list.size();i++)
		{
			u_name			=	u_name_list.get(i);
			if(customer_name_amount.get(u_name)!=null)
			{
				amount_show=(Integer)customer_name_amount.get(u_name);
				if(amount_show!=0)
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td></tr>");
				}
				else
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
				}	
			}
			else
			{
				out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
			}
		}
	%>
	</table>
</td>
<td width="88%">	

	<table align="center" width="100%" border="1">
	<%	
		// inner table query
		SQL_amount_cell="SELECT pu.userid, pu.prodid, pu.sum FROM ("+SQL_su+") AS x, ("+SQL_sp+") AS y, precomputeproduser pu "
				+ "WHERE x.id = pu.userid AND y.id = pu.prodid ORDER BY x.sum desc ";
		System.err.println("SQL_amount_cell:");
		System.err.println(SQL_amount_cell);
		
		// execute query
		long startInner=System.currentTimeMillis();
		rs=stmt.executeQuery(SQL_amount_cell);
		long endInner=System.currentTimeMillis();
		System.out.println("Finished inner table query, running time:"+(endInner-startInner)+"ms");
		
		
		int counter = 0;
		int amount = 0;
		while(rs.next()) {
			u_id = rs.getInt(1);
			p_id = rs.getInt(2);
			String check = u_id+"_"+p_id;
			
			if (innerTable.containsKey(check)) {
				int sum = rs.getInt(3);
				innerTable.put(check, sum);
			}
			
		}
		for (i = 0; i < u_id_list.size(); i++) {
			u_id = u_id_list.get(i);
			out.println("<tr>");
			for (int j = 0; j < p_id_list.size(); j++) {
				p_id = p_id_list.get(j);
				String check = u_id+"_"+p_id;
				int sum = innerTable.get(check);
				if(sum==0) 
					out.println("<td width=\"10%\"><font color='#ff0000'>0</font></td>");
				else
					out.println("<td width=\"10%\"><font color='#0000ff'><b>"+sum+"</b></font></td>");
			}
			out.println("</tr>");
		}

	%>
	</table>
	
</td>
</tr>
</table>	
<%
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
catch(Exception e)
{
  e.printStackTrace();
  out.println("Fail! Please connect your database first.");

}
%>	

</body>
</html>