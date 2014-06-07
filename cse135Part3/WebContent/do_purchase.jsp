<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%@include file="welcome.jsp" %>
<%
if(session.getAttribute("name")!=null)
{

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>

<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products_browsing.jsp" target="_self">Show Produts</a></td></tr>
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
	</table>	
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<p><table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td align="left"><font size="+3">
	<%
	String uName=(String)session.getAttribute("name");
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	String card=null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	int card_num=0;
	try {card=request.getParameter("card"); }catch(Exception e){card=null;}
	try
	{
		 card_num    = Integer.parseInt(card);
		 if(card_num>0)
		 {
	
				Connection conn=null;
				Statement stmt=null;
				Statement stmt2=null;

				try
				{
					
					String SQL_copy="INSERT INTO sales (uid, pid, quantity, price) select c.uid, c.pid, c.quantity, c.price from carts c where c.uid="+userID+";";
					
					
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
					String url="jdbc:postgresql://localhost/cse135?";
					String user="postgres";
					String password="postgres";
					conn =DriverManager.getConnection(url, user, password);
					stmt =conn.createStatement();
					stmt2 =conn.createStatement();

					try{
						conn.setAutoCommit(false);

						String salesByUser = "select c.uid, c.pid, c.quantity, c.price from carts c where c.uid='"+userID+"' ";
						System.err.println("salesByCurrentUser: ");
						System.err.println(salesByUser);
						
						/**record log,i.e., sales table**/
						
						rs = stmt.executeQuery(salesByUser);
						while (rs.next()) { // for each sale by the current user
							int uid = rs.getInt(1);
							int pid = rs.getInt(2);
							int qty = rs.getInt(3);
							int price = rs.getInt(4);
							int sum = qty * price;
							int stateID = 0;
							System.err.println("uid: " + uid);
							// find out what state user is from
							String findState = "SELECT u.state FROM users u WHERE u.id = '"+uid+"' ";
							rs2 = stmt2.executeQuery(findState);
							if (rs2.next()) {
								stateID = rs2.getInt(1);
							}
							System.err.println("The users stateID is : " +stateID);
							String check1 = "SELECT * FROM precomputeproduser pu WHERE pu.userid = '"+uid+"' AND pu.prodid = '"+pid+"' ";
							System.err.println("check1: ");
							System.err.println(check1);
							
							rs2 = stmt2.executeQuery(check1);
							if (rs2.next()) { // update precomputeproduser
								System.err.println("updating precomputeproduser");
								stmt2.execute("UPDATE precomputeproduser SET sum = sum + "+sum+" WHERE userid = '"+uid+"' AND prodid = '"+pid+"'");
							}
							else { // insert into precomputeproduser
								stmt2.execute("INSERT INTO precomputeproduser (userid, prodid, sum) VALUES ('"+uid+"', '"+pid+"', '"+sum+"') ");
							}
							
							String check2 = "SELECT * FROM precomputeprodstate ps, users u WHERE u.id = '"+uid+"' AND ps.stateid = '"+stateID+"' AND ps.prodid = '"+pid+"';";
							System.err.println("check2: ");
							System.err.println(check2);
							
							rs2 = stmt2.executeQuery(check2);
							if (rs2.next()) { // update precomputeprodstate
								stmt2.execute("UPDATE precomputeprodstate SET sum = sum + "+sum+" WHERE stateid = '"+stateID+"' AND prodid = '"+pid+"' ");
							}
							else { // insert into precomputeprodstate
								stmt2.execute("INSERT INTO precomputeprodstate (stateid, prodid, sum) VALUES ('"+stateID+"', '"+pid+"', '"+sum+"')");
							}
							
							String check3 = "SELECT * FROM precomputeproducts pp WHERE pp.productID = '"+pid+"' ";
							System.err.println("check3: ");
							System.err.println(check3);
							
							rs2 = stmt2.executeQuery(check3);
							if (rs2.next()) { // update precomputeproducts
								stmt2.execute("UPDATE precomputeproducts SET sum = sum + "+sum+" WHERE productID = '"+pid+"' ");
							}
							else { // insert into precomputeproducts
								stmt2.execute("INSERT INTO precomputeproducts (productID, sum) VALUES ('"+pid+"', '"+sum+"')");
							}
							
							String check4 = "SELECT * FROM precomputeusers pu WHERE pu.userID = '"+uid+"' ";
							System.err.println("check4: ");
							System.err.println(check4);
							
							rs2 = stmt2.executeQuery(check4);
							if (rs2.next()) { // update precomputeproducts
								stmt2.execute("UPDATE precomputeusers SET sum = sum + "+sum+" WHERE userID = '"+uid+"' ");
							}
							else { // insert into precomputeproducts
								stmt2.execute("INSERT INTO precomputeusers (userID, sum) VALUES ('"+uid+"', '"+sum+"')");
							}
						}
						
						conn.commit();
						conn.setAutoCommit(true);
						String  SQL_del="delete from carts where uid="+userID+";";
						stmt.execute(SQL_del);
						
						out.println("Dear customer '"+uName+"', Thanks for your purchasing.<br> Your card '"+card+"' has been successfully proved. <br>We will ship the products soon.");
						out.println("<br><font size=\"+2\" color=\"#990033\"> <a href=\"products_browsing.jsp\" target=\"_self\">Continue purchasing</a></font>");
					}
					catch(Exception e)
					{
						e.printStackTrace();
						out.println("Fail! Please try again <a href=\"purchase.jsp\" target=\"_self\">Purchase page</a>.<br><br>");
						
					}
					conn.close();
				}
				catch(Exception e)
				{
						out.println("<font color='#ff0000'>Error.<br><a href=\"purchase.jsp\" target=\"_self\"><i>Go Back to Purchase Page.</i></a></font><br>");
						
				}
			}
			else
			{
			
				out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
			}
		}
	catch(Exception e) 
	{ 
		out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
	}
%>
	
	</font><br>
</td></tr>
</table>
</div>
</body>
</html>
<%}%>