<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
		<form action= "ask_questions_check.jsp" method= "POST">
			<textarea rows="8" cols="50" name="content" required></textarea> <br>
			<input type="submit" value="Ask question">
		</form>
		<br>
		<br>
		<a href="../account_redirect.jsp">Back to account</a> <br>
		<a href="../logout.jsp">Logout Here</a>
	</body>
</html>