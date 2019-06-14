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
		<title>View Bids</title>
	</head>
	<body>
		<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			String bid_query = "SELECT b.* FROM Auction a, Bid b, on_ o WHERE a.auction_id=o.auction_id and o.bid_id=b.bid_id and a.auction_id=" + request.getParameter("auction_id");
			//out.println(bid_query);
			
			rs = stmt.executeQuery(bid_query);
			
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th>bid_id</th>");
			out.println("<th>amount</th>");
			out.println("<th>winning_bid</th>");
			out.println("<th>time_</th>");
			out.println("<th>Remove this Bid</th>");
			out.println("<th>Edit this Bid</th>");
			out.println("</tr>");
			while (rs.next()) {
				out.println("<tr>");
				
				out.println("<td>");
				out.println(rs.getInt("bid_id"));
				out.println("</td>");
				
				out.println("<td>");
				out.println(rs.getFloat("amount"));
				out.println("</td>");
				
				out.println("<td>");
				out.println(rs.getBoolean("winning_bid"));
				out.println("</td>");
				
				out.println("<td>");
				out.println(rs.getDate("time_") + " " + rs.getTime("time_"));
				out.println("</td>");
				
				out.println("<td>");
				out.println("<a href=\"remove_bid.jsp?auction_id=" + request.getParameter("auction_id"));
				out.println("&bid_id=" +rs.getInt("bid_id") + "\">");
				out.println("Remove Bid " + rs.getInt("bid_id"));
				out.println("</a>");
				out.println("</td>");
				
				out.println("<td>");
				//out.println("<a href=\"modify_bid.jsp?bid_id=");
				out.println("<a href=\"modify_bid.jsp?auction_id=" + request.getParameter("auction_id") + "&");
				
				out.println("bid_id=" +rs.getInt("bid_id") + "\">");
				out.println("Modify Bid " + rs.getInt("bid_id"));
				out.println("</a>");
				out.println("</td>");
				
				out.println("</tr>");
			}
			out.println("</table>");
			
			conn.close();
		%>
		<br>
		<br>
		<br>
		<a href="view_auctions.jsp">Back to Auctions</a> <br>
		<a href="../account_redirect.jsp">Back to Account</a> <br>
		<a href="../logout.jsp">Logout</a> <br>
	</body>
</html>