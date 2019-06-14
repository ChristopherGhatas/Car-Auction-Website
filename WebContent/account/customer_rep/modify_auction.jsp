<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
if ((session.getAttribute("account_type") != "Customer_rep")) {
	response.sendRedirect("../index.jsp");
}
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Modify Auction</title>
	</head>
	<body>
		<h2>Modifying Auction <%=request.getParameter("auction_id")%> </h2><br>
		<form action= "modify_auction_check.jsp?auction_id=<%=request.getParameter("auction_id")%>" method= "POST">
			Select Field to Edit
			<select name="field">
				<option value="auction_id">auction_id</option>
				<option value="end_date">end_date</option>
				<option value="initial_price">initial_price</option>
				<option value="bid_increment">bid_increment</option>
				<option value="minimum_price">minimum_price</option>
			</select>
			<br>
			New Value <input type="text" name="change" required> <br>
			<input type="submit" value="Edit Auction">
			
		</form>
		
		<br>
		<br>
		<br>
		<a href="view_auctions.jsp">Back to Auctions</a> <br>
		<a href="../account_redirect.jsp">Back to Account</a> <br>
		<a href="../logout.jsp">Logout</a> <br>
	</body>
</html>