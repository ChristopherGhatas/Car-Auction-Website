<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
if ((session.getAttribute("account_type") != "End_user")) {
	response.sendRedirect("../../index.jsp");
}
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
		<title>Set Alias</title>
		</head>
	<body>
		<form action="set_alias_check.jsp" method=post>
			Alias <input type="text" name="alias" maxlength="20" required required> <br>
			<input type="submit" value="Set Alias">
		</form>
		<br>
		<br>
		<a href="../account_redirect.jsp">Back to Account</a> <br>
		<a href="../logout.jsp">Logout Here</a>
	</body>
</html>