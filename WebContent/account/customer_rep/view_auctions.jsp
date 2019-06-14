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
		<title>Remove or Modify Auctions</title>
	</head>
	<body>
		<h1> Select an Auction to Modify or Remove</h1>
		<% 
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String auction_query = "select * from Auction";
			rs = stmt.executeQuery(auction_query);
			
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th>auction_id</th>");
			out.println("<th>end_date</th>");
			out.println("<th>initial_price</th>");
			out.println("<th>bid_increment</th>");
			out.println("<th>minimum_price</th>");
			out.println("<th>remove Auction</th>");
			out.println("<th>modify Auction</th>");
			out.println("<th>see bids</th>");
			out.println("</tr>");
			
			
			while (rs.next()) {
				out.println("<tr>");
				
				out.println("<th>");
				out.println(rs.getInt("auction_id"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getDate("end_date"));
				out.println(" " + rs.getTime("end_date"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getFloat("initial_price"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getFloat("bid_increment"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getFloat("minimum_price"));
				out.println("</th>");
				
				out.println("<th>");
				out.println("<a href=\"remove_auction.jsp?auction_id=");
				out.println(rs.getInt("auction_id") + "\">");
				out.println("Remove Auction " + rs.getInt("auction_id"));
				out.println("</a>");
				out.println("</th>");
				
				out.println("<th>");
				out.println("<a href=\"modify_auction.jsp?auction_id=");
				out.println(rs.getInt("auction_id") + "\">");
				out.println("Modify Auction " + rs.getInt("auction_id"));
				out.println("</a>");
				out.println("</th>");
				
				out.println("<th>");
				//out.println("link to bids");
				out.println("<a href=\"view_bids.jsp?auction_id=");
				out.println(rs.getInt("auction_id") + "\">");
				out.println("Modify Bids for Auction " + rs.getInt("auction_id"));
				out.println("</a>");
				out.println("</th>");
				
				out.println("</tr>");
			}
			out.println("</table>");
			
			conn.close();
		%>
		<br>
		<br>
		<br>
		<a href="../account_redirect.jsp">Back to Account</a> <br>
		<a href="../logout.jsp">Logout</a> <br>
	</body>
</html>