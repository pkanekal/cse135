<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<center>
        <form action=LoginServlet>
            <table border=1>
                <tr>
                    <th colspan="2">Login Form</th>
                </tr>
                <tr>
                    <td>Enter your UserId:</td>
                    <td><input type=text name=userId></td>
                </tr>
                <tr>
                    <td>Enter your Password:</td>
                    <td><input type=password name=pwd></td>
                </tr>
                <tr>
                    <td><input type=submit value=submit></td>
                    <td><input type=reset value=refresh></td>
                </tr>
            </table>
        </form>
    </center> 
</body>
</html>