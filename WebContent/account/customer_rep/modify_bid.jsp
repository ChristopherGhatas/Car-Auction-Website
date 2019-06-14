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
		<title>Modify Bid</title>
	</head>
	<body>
		<form action= "modify_bid_check.jsp?auction_id=<%=request.getParameter("auction_id")%>&bid_id=<%=request.getParameter("bid_id")%>" method= "POST">
			<h2>Modifying Bid <%=request.getParameter("bid_id")%> </h2><br>
			Select Field to Edit
			<select name="field">
				<option value="bid_id">bid_id</option>
				<option value="amount">amount</option>
				<option value="winning_bid">winning_bid</option>
				<option value="time_">time_</option>
			</select>
			<br>
			New Value <input type="text" name="change" required> <br>
			<input type="submit" value="Edit Bid">
		</form>
	</body>
	<br>
		<br>
		<br>
		<a href="view_bids.jsp?auction_id=<%=request.getParameter("auction_id")%>">Back to Bids for Auction</a> <br>
		<a href="view_auctions.jsp">Back to Auctions</a> <br>
		<a href="../account_redirect.jsp">Back to Account</a> <br>
		<a href="../logout.jsp">Logout</a> <br>
</html>