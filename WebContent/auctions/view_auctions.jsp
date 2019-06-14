<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<%
//if ((session.getAttribute("account_type") != "Customer_rep")) {
//	response.sendRedirect("../index.jsp");
//}
%>

<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title>View Auctions</title>
	</head>
	<body>
		<h1> All Auctions</h1>
		<% 
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String auction_query = "select *, 'sedan' as type from Auction join for_ using (auction_id) join Car using (VIN) join Sedan using(VIN) join creates_Auc using (auction_id) join User using (username)"
					+"union select *, 'minivan' as type from Auction join for_ using (auction_id) join Car using (VIN) join Minivan using(VIN) join creates_Auc using (auction_id) join User using (username)"
					+"union select *, 'SUV' as type from Auction join for_ using (auction_id) join Car using (VIN) join SUV using(VIN) join creates_Auc using (auction_id) join User using (username)";
			rs = stmt.executeQuery(auction_query);
			
			out.println("<table border=1>");
			out.println("<tr>");
			//out.println("<th>auction_id</th>");
			out.println("<th>Seller</th>");
			out.println("<th>VIN</th>");
			out.println("<th>Model</th>");
			out.println("<th>Make</th>");
			out.println("<th>Color</th>");
			out.println("<th>Mileage</th>");
			out.println("<th>Type</th>");//Sedan,minivan,SUV
			out.println("<th>end_date</th>");
			out.println("<th>initial_price</th>");
			out.println("<th>bid_increment</th>");
			//out.println("<th>minimum_price</th>");

			out.println("<th>see bids</th>");
			out.println("</tr>");
			
			
			while (rs.next()) {
				out.println("<tr>");
				
				/*
				out.println("<th>");
				out.println(rs.getInt("auction_id"));
				out.println("</th>");
				*/
				String alias=rs.getString("alias");
				if(alias ==null)
				{
					out.println("<th>");
					out.println(rs.getString("username"));
					out.println("</th>");
				}
				else
				{
					out.println("<th>");
					out.println(rs.getString("alias"));
					out.println("</th>");
				}
				
				
				out.println("<th>");
				out.println(rs.getInt("VIN"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getString("model"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getString("make"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getString("color"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getInt("mileage"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getString("type"));
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
				/*
				out.println("<th>");
				out.println(rs.getFloat("minimum_price"));
				out.println("</th>");
				*/
				
				out.println("<th>");
				//out.println("link to bids");
				out.println("<a href=\"view_bids.jsp?auction_id=");
				out.println(rs.getInt("auction_id") + "\">");
				out.println("View Bids for " + rs.getInt("auction_id"));
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
		<a href= "sellitem.html"> Sell an Item</a> <br>
		<a href="../account/account_redirect.jsp">Back to Account</a> <br>
		<a href="../account/logout.jsp">Logout</a> <br>
	</body>
</html>