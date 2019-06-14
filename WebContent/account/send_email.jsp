<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Send Email</title>
	</head>
	<body>
		<form action= "send_email_check.jsp" method= "POST">
				To <input type="text" name="to" maxlength="20" required> <br>
				Subject <input type="text" name="subject" maxlength="140" required> <br>
				<textarea rows="8" cols="50" name="content" required></textarea> <br>
				<input type="submit" value="Send Email">
		</form>
		<a href="account_redirect.jsp">Back to account</a>
		<a href="logout.jsp">Logout Here</a>
	</body>
</html>