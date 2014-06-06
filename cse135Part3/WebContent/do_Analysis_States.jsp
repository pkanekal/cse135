<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>

<body>
<%
ArrayList<String> p_name_list=new ArrayList<String>();//product name, 10
ArrayList<String> s_name_list=new ArrayList<String>();//state name,20
HashMap<String, Integer> product_name_amount	=	new HashMap<String, Integer>();
HashMap<String, Integer> state_name_amount=	new HashMap<String, Integer>();
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
String  	SQL_s=null,SQL_p=null, SQL_amount_cell=null;
int 		p_id=0,u_id=0;
String		p_name=null,s_name=null;
int 		p_amount_price=0,s_amount_price=0;

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
	
	
	if(("All").equals(state) && ("0").equals(category))// no filters
	{
		SQL_s = "SELECT state.name, sum(precomputeprodstate.sum) "
			+	"FROM precomputeprodstate, state "
			+	"WHERE precomputeprodstate.stateid = state.id "
			+	"GROUP BY state.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, products p "
			+	"WHERE precomputeproduser.prodid = p.id "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";
	}
	
	if(("All").equals(state) && !("0").equals(category))// category filter
	{
		SQL_s = "SELECT state.name, sum(precomputeprodstate.sum) "
			+	"FROM precomputeprodstate, state, categories, products p "
			+	"WHERE precomputeprodstate.stateid = state.id AND precomputeprodstate.prodid = p.id AND p.cid = categories.id AND categories.name = '"+category+"' "
			+	"GROUP BY state.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.name, sum(precomputeproduser.sum) "
			+	"FROM precomputeproduser, products p, categories c "
			+	"WHERE precomputeproduser.prodid = p.id AND p.cid = c.id AND c.name = '"+category+"' "
			+	"GROUP BY p.id "
			+	"ORDER BY sum desc LIMIT 10";
	}

	if(!("All").equals(state) && ("0").equals(category))// state filter
	{
		SQL_s = "SELECT state.name, sum(precomputeprodstate.sum) "
			+	"FROM state, precomputeprodstate "
			+	"WHERE precomputeprodstate.stateid = state.id AND state.id = '"+state+"' "
			+	"GROUP BY state.id "
			+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.name, sum(precomputeprodstate.sum) "
				+	"FROM precomputeprodstate, products p "
				+	"WHERE precomputeprodstate.prodid = p.id " 
				+	"AND precomputeprodstate.stateid = '"+state+"' "
				+	"GROUP BY p.id "
				+	"ORDER BY sum desc LIMIT 10";
	}
	if(!("All").equals(state) && !("0").equals(category))// state and category filter
	{
		SQL_s = "SELECT state.name, sum(precomputeprodstate.sum) "
				+	"FROM state, precomputeprodstate, categories, products p "
				+	"WHERE precomputeprodstate.stateid = state.id AND precomputeprodstate.prodid = p.id AND p.cid = categories.id AND categories.name = '"+category+"' AND state.id = '"+state+"' "
				+	"GROUP BY state.id "
				+	"ORDER BY sum desc LIMIT 20";
		SQL_p="SELECT p.name, sum(ps.sum) "
				+	"FROM precomputeprodstate ps, state, products p, categories c "
				+	"WHERE ps.stateid = state.id AND ps.prodid = p.id AND p.cid = c.id AND c.name = '"+category+"' AND state.id = '"+state+"' "
				+	"GROUP BY p.name "
				+	"ORDER BY sum desc LIMIT 10";
	}

	System.err.println("SQL_s:");
	System.err.println(SQL_s);
	System.err.println("SQL_p:");
	System.err.println(SQL_p);
	
	//state name
	rs=stmt.executeQuery(SQL_s);
	while(rs.next())
	{
		s_name=rs.getString(1);
		s_name_list.add(s_name);
		s_amount_price = rs.getInt(2);
		state_name_amount.put(s_name, s_amount_price);
		
	}
//	out.println(SQL_1+"<br>"+SQL_2+"<br>"+SQL_pt+"<BR>"+SQL_ut+"<br>"+SQL_row+"<BR>"+SQL_col+"<br>");
	//product name
	rs=stmt.executeQuery(SQL_p);
	while(rs.next())
	{
		p_name=rs.getString(1);
	    p_name_list.add(p_name);
	    p_amount_price = rs.getInt(2);
		product_name_amount.put(p_name,p_amount_price);
		
	}
	conn.setAutoCommit(false);

%>	
<%	

	
	
	
//	out.println(SQL_amount_row+"<br>"+SQL_amount_col+"<br>"+SQL_amount_cell+"<BR>");
	
   
    int i=0,j=0;
	
	int amount=0;
	
%>
	<table align="center" width="100%" border="1">
		<tr align="center">
			<td width="12%"><table align="center" width="100%" border="0"><tr align="center"><td><strong><font size="+2" color="#9933CC">STATE</font></strong></td></tr></table></td>
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
		for(i=0;i<s_name_list.size();i++)
		{
			s_name			=	s_name_list.get(i);
			if(state_name_amount.get(s_name)!=null)
			{
				amount_show=(Integer)state_name_amount.get(s_name);
				if(amount_show!=0)
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+s_name+"(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td></tr>");
				}
				else
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+s_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
				}	
			}
			else
			{
				out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+s_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
			}
		}
	%>
	</table>
</td>
<td width="88%">	
	<%	
/*
		SQL_amount_cell="select u.state, s.pid, sum(s.quantity*s.price) from us_t u,ps_t p, sales s where s.uid=u.id and s.pid=p.id group by u.state, s.pid;";
		 rs=stmt.executeQuery(SQL_amount_cell);
		 while(rs.next())
		 {
			 s_name=rs.getString(1);
			 p_id=rs.getInt(2);
			 amount=rs.getInt(3);
		 }
		*/
	%>	 
	<table align="center" width="100%" border="1">
	<%	/*
		String idPair="";
		for(i=0;i<s_name_list.size();i++)
		{
			out.println("<tr  align='center'>");
			for(j=0;j<p_name_list.size();j++)
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
				amount=0;
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
  out.println("Fail! Please connect your database first.");
}
%>	

</body>
</html>