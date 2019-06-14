<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Admin Page</title>
	</head>
	<body>
		<%
		if ((session.getAttribute("account_type") != "Admin")) {
			response.sendRedirect("../index.jsp");
		}
		%>
		<h2> Admin page tools</h2>
		Generate Sales Report <br>
		<select name="sales_report" form="report_form">
			<option value="total_earnings">Total Earnings</option>
			<option value="earnings_per_item">Earnings Per Item</option>
			<option value="earnings_per_item_type">Earnings Per Item Type</option>
			<option value="earnings_per_end_user">Earnings Per End-User</option>
			<option value="best_selling_items">Best Selling Items</option>
			<option value="best_buyers">Best Buyers</option>
		</select> 
		<form action="generate_reports.jsp" id="report_form">
			<input type="submit">
		</form>
		<br>
		<a href="reports.jsp">View Reports</a> <br>
		<a href="questions/view_questions.jsp">View Questions</a> <br>
		<a href="inbox.jsp">Email inbox</a> <br>
		<a href="admin_createRep.jsp">Create Customer Representative Account</a> <br>
		<a href="logout.jsp">Logout</a>
	</body>
</html>