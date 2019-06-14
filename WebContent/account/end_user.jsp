<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Login Successful</title>
	</head>
	<body>
		<%
		if ((session.getAttribute("account_type") != "End_user")) {
			response.sendRedirect("../index.jsp");
		}
		%>
			<table border=1>
				<tr>
					<th>Username</th>
					<th>Alias <br> <a href="end_user/set_alias.jsp"> Change Alias</a></th>
					<th>Balance</th>
					<th>Email</th>
					<th>Bank Account Number</th>
				</tr>
				<tr>
					<td><%=session.getAttribute("username")%></td>
					<td><%
							if (session.getAttribute("alias") != null) {
								out.println(session.getAttribute("alias"));	
							} else {
								//out.println("<a href=\"end_user/set_alias.jsp\"> Create Alias</a>");
							}
					
					%></td>
					<td><%=session.getAttribute("balance")%></td>
					<td><%=session.getAttribute("email")%></td>
					<td><%=session.getAttribute("bank")%></td>
				</tr>
			</table> <br>
			<br>
			<a href="../alerts/view_alerts.jsp">View Your Alerts</a><br>
			<a href="../auctions/view_auctions.jsp"> View Auctions</a> <br>
			<a href="../search/search.jsp">Search Auctions</a> <br>
			<a href="questions/view_questions.jsp">View Questions</a> <br>
			<a href="questions/ask_question.jsp">Ask a Question</a> <br>
			<a href="inbox.jsp">Email inbox</a> <br>
			<a href="send_email.jsp">Send Email</a> <br>
			<a href="../alerts/create_alert.html">Set up Alert</a><br>
			<a href="logout.jsp">Logout Here</a>

	</body>
</html>