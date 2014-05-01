<%@page import="java.util.*" %>
<%
out.println(session.getAttribute("role"));
if (session.getAttribute("role").equals("owner"))
{%>
<ul>
	<li><a href="/cse135_part1/categories/categories.jsp">Categories</a></li>
	<li><a href="/cse135_part1/Products/Products.jsp">Products</a></li>
</ul>
<% }
else { 
%>
<ul>
	<li><a href="/cse135_part1/Products/productbrowse.jsp">Browse Products</a></li>
	<li><a href="/cse135_part1/shoppingcart.jsp">Buy Shopping Cart</a></li>
</ul>

<%
    }
%>