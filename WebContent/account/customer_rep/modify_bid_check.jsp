<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
if ((session.getAttribute("account_type") != "Customer_rep")) {
	response.sendRedirect("../../index.jsp");
}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Modify Bid</title>
	</head>
	<body>
		<%
			//out.println("bid " + request.getParameter("bid_id")  + "<br>");
			//out.println("field " + request.getParameter("field") + "<br>");
			//out.println("new value " + request.getParameter("change") + "<br>");	
		
			Class.forName("com.mysql.jdbc.Driver");
			
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			// check if bid_id is being changed
			boolean used = false;
			
			if (request.getParameter("field").equals("bid_id")) {
				String bid_id_query = "SELECT * FROM Bid WHERE bid_id = " + request.getParameter("change");
				rs = stmt.executeQuery(bid_id_query);
				out.println("field = bid_id<br>");
				if (rs.next()) {
					used = true;
				}
			}
			
			if (used == false) {
				
				// show bid before it is changed
				String bid_query = "SELECT * FROM Bid WHERE bid_id = " + request.getParameter("bid_id");
				
				rs = stmt.executeQuery(bid_query);
				
				out.println("Auction Fields Prior to Change <br>");
				out.println("<table border=1>");
				out.println("<tr>");
				out.println("<th>bid_id</th>");
				out.println("<th>amount</th>");
				out.println("<th>winning_bid</th>");
				out.println("<th>time_</th>");
				out.println("</tr>");
				while (rs.next()) {
					out.println("<tr>");
					out.println("<td>" + rs.getInt("bid_id") + "</td>");
					out.println("<td>" + rs.getFloat("amount") + "</td>");
					out.println("<td>" + rs.getInt("winning_bid") + "</td>");
					out.println("<td>" + rs.getDate("time_") + " " + rs.getTime("time_") +"</td>");
					out.println("</tr>");
				}
				out.println("</table>" + "<br>");
				
				// change bid
				//String auction_update = "UPDATE Auction SET " + request.getParameter("field") + " = " + request.getParameter("change") + " WHERE auction_id = " + request.getParameter("auction_id");
				// UPDATE Bid SET amount = 200 WHERE bid_id = 3;
				
				String bid_update = "UPDATE Bid SET " + request.getParameter("field") + " = " + request.getParameter("change") + " WHERE bid_id = " + request.getParameter("bid_id");
				// change formating for time_
				if (request.getParameter("field").equals("time_")) {
					bid_update = "UPDATE Bid SET " + request.getParameter("field") + " = '" + request.getParameter("change") + "' WHERE bid_id = " + request.getParameter("bid_id");
				}
				stmt.executeUpdate(bid_update);
				
				// show bid after it is changed
				if (request.getParameter("field").equals("bid_id") == true) {
					bid_query = "SELECT * FROM Bid WHERE bid_id = " + request.getParameter("change");
				}
				
				rs = stmt.executeQuery(bid_query);
				
				out.println("Auction Fields Prior to Change <br>");
				out.println("<table border=1>");
				out.println("<tr>");
				out.println("<th>bid_id</th>");
				out.println("<th>amount</th>");
				out.println("<th>winning_bid</th>");
				out.println("<th>time_</th>");
				out.println("</tr>");
				while (rs.next()) {
					out.println("<tr>");
					out.println("<td>" + rs.getInt("bid_id") + "</td>");
					out.println("<td>" + rs.getFloat("amount") + "</td>");
					out.println("<td>" + rs.getInt("winning_bid") + "</td>");
					out.println("<td>" + rs.getDate("time_") + " " + rs.getTime("time_") +"</td>");
					out.println("</tr>");
				}
				out.println("</table>" + "<br>");
				
				// get auction_id from bid_id for link below
				String auction_id_query = "SELECT a.auction_id FROM Bid b, Auction a, on_ o WHERE a.auction_id = o.auction_id and o.bid_id = b.bid_id and b.bid_id = " + request.getParameter("bid_id");
				if (request.getParameter("field").equals("bid_id") == true) {
					auction_id_query = "SELECT a.auction_id FROM Bid b, Auction a, on_ o WHERE a.auction_id = o.auction_id and o.bid_id = b.bid_id and b.bid_id = " + request.getParameter("change");
				}
						
						
				rs = stmt.executeQuery(auction_id_query);
				//out.println(auction_id_query + "<br>");
				int auction_id = -1;
				while (rs.next()) {
					auction_id = rs.getInt("auction_id");
				}
			} else {
				out.println(used);
				out.println("bid_id " + request.getParameter("change") + " is already being used<br>");
				
			} 	
			
			conn.close();
			//out.println("<a href=\"view_bids.jsp?auction_id=" + "\">Back to Bids</a>)";
		%>
		<br>
		<br>
		<br>
		<a href="view_bids.jsp?auction_id=<%=request.getParameter("auction_id")%>">Back to Bids</a> <br>
		<a href="view_auctions.jsp">Back to Auctions</a> <br>
		<a href="../account_redirect.jsp">Back to Account</a> <br>
		<a href="../logout.jsp">Logout</a> <br>
	</body>
</html>