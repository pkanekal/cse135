<%@page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<%
try {
	Connection conn = null;
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost/cse135?" +
        "user=postgres&password=postgres");
if (session.getAttribute("role").equals("owner"))
{%>
	<h2> Hello, <%out.println(session.getAttribute("name"));%></h2>
	<a href="/cse135_part1/categories/categories.jsp">Categories</a>
	<a href="/cse135_part1/Products/Products.jsp">Products</a>
<% }
else if (session.getAttribute("role").equals("customer")) { 
%>
	<h2> Hello, <%out.println(session.getAttribute("name"));%></h2>
	<a href="/cse135_part1/Products/productbrowse.jsp">Browse Products</a>
	<a href="/cse135_part1/shoppingcart.jsp">Shopping Cart</a>

<%
    }
}
catch (Exception e) {

    out.println	("You are not logged in.");
}%>