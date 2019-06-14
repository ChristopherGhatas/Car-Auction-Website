<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
// amazon rds server jdbc:mysql://<url>:3306/336db
session.setAttribute("url", "amazon rds server here");
// username
session.setAttribute("database_login_name", "username here");
// password
session.setAttribute("database_password", "password here");
%>




<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Car Auction Website</title>
	</head>
	<body>
		<h1> Car Auction Website</h1>
		<br>
		<br>
		<a href="account/createAccount.html">Create Account Here</a> <br>
		<a href="account/login.html">Login Here</a>
	</body>
</html>
