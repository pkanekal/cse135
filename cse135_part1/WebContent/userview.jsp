<%@page import="java.util.*" %>
<%
out.println(session.getAttribute("role"));
if (session.getAttribute("role").equals("owner"))
{%>

	<a href="/cse135_part1/categories/categories.jsp">Categories</a></li>
	<a href="/cse135_part1/Products/Products.jsp">Products</a></li>
<% }
else if (session.getAttribute("role").equals("customer")) { 
%>
	<a href="/cse135_part1/Products/productbrowse.jsp">Browse Products</a>
	<a href="/cse135_part1/shoppingcart.jsp">Buy Shopping Cart</a>

<%  }
else if (session.getAttribute("role").equals("customer")) { 
	out.println("Please log in.");
}
