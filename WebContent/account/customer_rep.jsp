<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Customer Rep Page</title>
	</head>
	<body>
		<%
		if ((session.getAttribute("account_type") != "Customer_rep")) {
			response.sendRedirect("../index.jsp");
		}
		%>
		Customer Rep page tools <br>
		<a href="customer_rep/view_auctions.jsp">Modify Auctions</a> <br>
		<a href="customer_rep/edit_account.jsp">Edit Accounts</a> <br>
		<a href="questions/view_questions.jsp">View Questions</a> <br>
		<a href="inbox.jsp">Email inbox</a> <br>
		<a href="logout.jsp">Logout</a> <br>
	</body>
</html>