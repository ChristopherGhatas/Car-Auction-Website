<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Admin Page For Creating Customer Representative</title>
		</head>
	<body>
		<%
		if ((session.getAttribute("account_type") != "Admin")) {
			response.sendRedirect("../index.html");
		}
		%>
		<h2>Create Sales Rep</h2>
			<form action= "admin_createRep_check.jsp" method= "POST">
				Enter Customer Representative name and password: <br>
				Customer Rep name <input type="text" name="rep_name" maxlength="20" required> <br>
				password <input type="text" name="rep_password" rmaxlength="20" required> <br>
				email address <input type="text" name="rep_email_address" maxlength="40" required> <br>
				<input type="submit" value="Create Customer Representative Account">
			</form>
		<a href="admin.jsp">Back to Admin Tools</a> <br>
		<a href="logout.jsp">Logout</a>
	</body>
</html>