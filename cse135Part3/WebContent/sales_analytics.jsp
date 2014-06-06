<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>

<body>
<%@include file="welcome.jsp" %>
<%
//if(session.getAttribute("name")!=null)
//{
//	int userID  = (Integer)session.getAttribute("userID");
//	String role = (String)session.getAttribute("role");


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
	stmt =conn.createStatement();
	
%>	

<input type="hidden" id="currentFlag_row" value="0">
<input type="hidden" id="currentFlag_col" value="0">
<div style="position:absolute; top:35px; left:0px; width:100%; height:70px; background-color:#66CCFF">
<table align="left" width="200px" border="1">
	<tr>
		<td>
			<select name="search_key" id="search_key" onChange="change()">
				<option value="1" selected="selected">Customers</option>
				<option value="2">States</option>
			</select>
		</td>
		<td>
			<table  align="center" width="100%" border="1">
				<tr>
					<td>State</td>
					<td>Category</td>
					<td>Age</td>
				</tr>
				<tr>
					<td>
						<select name="search_key_1" id="search_key_1">
							<option value="All" selected="selected">All States</option>
							<option value="1">Alabama</option> 
							<option value="2">Alaska</option>
							<option value="3">Arizona</option>
							<option value="4">Arkansas</option>
							<option value="5">California</option>
							<option value="6">Colorado</option>
							<option value="7">Connecticut</option>
							<option value="8">Delaware</option>
							<option value="9">Florida</option>
							<option value="10">Georgia</option>
							<option value="11">Hawaii</option>
							<option value="12">Idaho</option>
							<option value="13">Illinois</option>
							<option value="14">Indiana</option>
							<option value="15">Iowa</option>
							<option value="16">Kansas</option>
							<option value="17">Kentucky</option>
							<option value="18">Louisiana</option>
							<option value="19">Maine</option>
							<option value="20">Maryland</option>
							<option value="21">Massachusetts</option>
							<option value="22">Michigan</option>
							<option value="23">Minnesota</option>
							<option value="24">Mississippi</option>
							<option value="25">Missouri</option>
							<option value="26">Montana</option>
							<option value="27">Nebraska</option>
							<option value="28">Nevada</option>
							<option value="29">New Hampshire</option>
							<option value="30">New Jersey</option>
							<option value="31">New Mexico</option>
							<option value="32">New York</option>
							<option value="33">North Carolina</option>
							<option value="34">North Dakota</option>
							<option value="35">Ohio</option>
							<option value="36">Oklahoma</option>
							<option value="37">Oregon</option>
							<option value="38">Pennsylvania</option>
							<option value="39">Rhode Island</option>
							<option value="40">South Carolina</option>
							<option value="41">South Dakota</option>
							<option value="42">Tennessee</option>
							<option value="43">Texas</option>
							<option value="44">Utah</option>
							<option value="45">Vermont</option>
							<option value="46">Virginia</option>
							<option value="47">Washington</option>
							<option value="48">West Virginia</option>
							<option value="49">Wisconsin</option>
							<option value="50">Wyoming</option>
						</select>
					</td>
					<td>
						<select name="search_key_2" id="search_key_2">
							<option value="0" selected="selected">All Categories</option>
<%
							/**SQL_1 for (state, amount)**/
								String SQL_1="SELECT * FROM categories";
								rs=stmt.executeQuery(SQL_1);
								int c_id=0;
								String c_name=null;
								while(rs.next())
								{
									c_id=rs.getInt(1);
									c_name=rs.getString(2);
									out.println("<option value=\""+c_name+"\">"+c_name+"</option>");
								}
%>
						</select>
					</td>
					<td>
						<select name="search_key_3" id="search_key_3">
							<option value="0" selected="selected">All Ages</option>
							<option value="12_18">12-18</option>
							<option value="18_45">18-45</option>
							<option value="45_65">45-65</option>
							<option value="65_100">65-</option>
						</select>
					</td>
				</tr>
			</table>
		</td>
		<td>
			<input type="button" value="Run Query" onClick="doSearch()">
		</td>
	</tr>
</table>
<div>
<div id="results" style="position:absolute; top:75px; left:0px; width:100%;">
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
//}	
%>

</body>
</html>