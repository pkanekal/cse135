<%@page import="java.util.*" %>
<%
out.println(session.getAttribute("role"));
if (session.getAttribute("role").equals("owner"))
{%>
<ul>
	<li><a href="categories/categories.jsp">Categories</a></li>
	<li><a href="Products/Products.jsp">Products</a></li>
</ul>
<% }
else { 
%>
<ul>
	<li><a href="productbrowse.jsp">Browse Products</a></li>
	<li><a href="shoppingcart.jsp">Buy Shopping Cart</a></li>
</ul>

<%
    }
%>