<%@page import="java.util.*" %>
<%
if (session.getAttribute("role").equals("owner"))
{%>
	<a href="/cse135_part1/categories/categories.jsp">Categories</a>
	<a href="/cse135_part1/Products/Products.jsp">Products</a>
<% }
else if (session.getAttribute("role").equals("customer")) { 
%>
	<a href="/cse135_part1/Products/productbrowse.jsp">Browse Products</a>
	<a href="/cse135_part1/shoppingcart.jsp">Buy Shopping Cart</a>

<%
    }
else if (session.getAttribute("role").equals(null)){ 
%>
	<h3> You are not logged in.</h3>

<%
    }
%>