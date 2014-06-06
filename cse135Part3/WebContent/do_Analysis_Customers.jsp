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
ArrayList<String> u_name_list=new ArrayList<String>();//customer ID,20
HashMap<String, Integer> product_name_amount	=	new HashMap<String, Integer>();
HashMap<String, Integer> customer_name_amount=	new HashMap<String, Integer>();
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
String  	SQL_u=null,SQL_p=null;
String  	SQL_amount_cell=null;
String		p_name=null,u_name=null;
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
		SQL_u="SELECT u.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, users u "
			+	"WHERE precomputeproduser.userid = u.id "
			+	"GROUP BY u.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, products p "
			+	"WHERE precomputeproduser.prodid = p.id "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";

	}
	
	if(("All").equals(state) && !("0").equals(category))// only category filter
	{
		SQL_u="SELECT u.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, users u, products p, categories "
			+	"WHERE precomputeproduser.userid = u.id AND precomputeproduser.prodid = p.id AND p.cid = categories.id AND categories.name = '"+category+"' "
			+	"GROUP BY u.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, products p, categories c "
			+	"WHERE precomputeproduser.prodid = p.id AND p.cid = c.id AND c.name = '"+category+"' "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";

	}
	if(!("All").equals(state) && ("0").equals(category))// only state filter
	{
		SQL_u=" SELECT u.name, sum(pu.sum) "
			+	"FROM state, precomputeproduser pu, users u "
			+	"WHERE pu.userid = u.id AND u.state = state.id AND u.state = '"+state+"' "
			+	"GROUP BY u.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.name, sum(precomputeprodstate.sum) "
			+	"FROM precomputeprodstate, products p "
			+	"WHERE precomputeprodstate.prodid = p.id " 
			+	"AND precomputeprodstate.stateid = '"+state+"' "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";

	}
	if(!("All").equals(state) && !("0").equals(category))// both filters
	{
		SQL_u="SELECT u.name, sum(pu.sum) "
			+	"FROM precomputeproduser pu, users u, products p, categories c "
			+	"WHERE pu.userid = u.id AND pu.prodid = p.id AND p.cid = c.id AND c.name = '"+category+"' AND u.state = '"+state+"' "
			+	"GROUP BY u.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.name, sum(ps.sum) "
			+	"FROM precomputeprodstate ps, state, products p, categories c "
			+	"WHERE ps.stateid = state.id AND ps.prodid = p.id AND p.cid = c.id AND c.name = '"+category+"' AND state.id = '"+state+"' "
			+	"GROUP BY p.name "
			+	"ORDER BY sum desc LIMIT 10";

	}
	System.err.println("SQL_u:");
	System.err.println(SQL_u);
	System.err.println("SQL_p:");
	System.err.println(SQL_p);

	System.err.println("reached1");

	//customer name and amount
	rs=stmt.executeQuery(SQL_u);
	System.err.println("reached2");

	while(rs.next())
	{
		u_name=rs.getString(1);
		u_name_list.add(u_name);
		u_amount_price=rs.getInt(2);
		customer_name_amount.put(u_name, u_amount_price);
		
	}

	//product name and amount
		System.err.println("reached3");

	rs=stmt.executeQuery(SQL_p);
	System.err.println("reached4");

	while(rs.next())
	{
		p_name=rs.getString(1);
	    p_name_list.add(p_name);
		p_amount_price=rs.getInt(2);

		product_name_amount.put(p_name,p_amount_price);
		
	}
	
	
	//temporary table
	conn.setAutoCommit(false);
	System.err.println("reached5");	
%>	
<%	

	
	
	
//	out.println(SQL_amount_row+"<br>"+SQL_amount_col+"<br>"+SQL_amount_cell+"<BR>");
	

   
    int i=0,j=0;
	HashMap<String, String> pos_idPair=new HashMap<String, String>();
	HashMap<String, Integer> idPair_amount=new HashMap<String, Integer>();	
	int amount=0;
	
%>
	<table align="center" width="100%" border="1">
		<tr align="center">
			<td width="12%"><table align="center" width="100%" border="0"><tr align="center"><td><strong><font size="+2" color="#FF00FF">CUSTOMER</font></strong></td></tr></table></td>
			<td width="88%">
				<table align="center" width="100%" border="1">
					<tr align="center">
<%	
	int amount_show=0;
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
			for(j=0;j<p_name_list.size();j++)
			{
				p_name	=   p_name_list.get(j);
				pos_idPair.put(i+"_"+j, u_name+"_"+p_name);
				idPair_amount.put(u_name+"_"+p_name,0);
			}
		}
	%>
	</table>
</td>
<td width="88%">	
	<%	
		/*SQL_amount_cell="select s.uid, s.pid, sum(s.quantity*s.price) from u_t u,p_t p, sales s where s.uid=u.id and s.pid=p.id group by s.uid, s.pid;";
		 rs=stmt.executeQuery(SQL_amount_cell);
		 while(rs.next())
		 {
			 u_id=rs.getInt(1);
			 p_id=rs.getInt(2);
			 amount=rs.getInt(3);
			 idPair_amount.put(u_id+"_"+p_id, amount);
		 }*/
		
	%>	 
	<table align="center" width="100%" border="1">
	<%	
		String idPair="";
		/*for(i=0;i<u_list.size();i++)
		{
			out.println("<tr  align='center'>");
			for(j=0;j<p_list.size();j++)
			{
				idPair=(String)pos_idPair.get(i+"_"+j);
				amount=(Integer)idPair_amount.get(idPair);
				if(amount==0)
				{
					out.println("<td width=\"10%\"><font color='#ff0000'>0</font></td>");
				}
				else
				{
					out.println("<td width=\"10%\"><font color='#0000ff'><b>"+amount+"</b></font></td>");
				}
			}
			out.println("</tr>");
		}*/
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
}
%>	

</body>
</html>