<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
      <h1>Login Page</h1>  
        <form name="login" action="LoginValidate">  
        <%  
            if (request.getParameter("error")!=null) {  
        %>  
            Login failed. Please try again.  
        <%  
            }  
        %>  
            <table border="0" width="300" cellspacing="5">  
                <tr>  
                    <td>Username:</td>  
                    <td><input type="text" name="userName" value="" width="16" size="16" maxlength="16"/></td>  
                </tr>  
                <tr>  
                    <td>Password:</td>  
                    <td><input type="password" name="passWord" value="" width="16" size="16" maxlength="16"/></td>  
                </tr>  
                <tr>  
                    <td> </td>  
                    <td><input type="submit" value="Login" name="login" /><input type="submit" value="Cancel" name="cancel" /></td>  
                </tr>  
            </table>  
        </form>  
</body>
</html>