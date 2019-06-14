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
		<title>Modify Auction</title>
	</head>
	<body>
		<%
			//out.println("auction " + request.getParameter("auction_id")  + "<br>");
			//out.println("field " + request.getParameter("field") + "<br>");
			//out.println("new value " + request.getParameter("change") + "<br>");
			
			Class.forName("com.mysql.jdbc.Driver");
			
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			
			// if the field to change is auction_id, make sure the new auction_id isn't being used
			boolean used = false;
			if (request.getParameter("field").equals("auction_id")) {
				String auction_id_query = "SELECT * FROM Auction WHERE auction_id = " +	request.getParameter("change");
				rs = stmt.executeQuery(auction_id_query);
				if (rs.next()) {
					used = true;
				}
			}
			if (!used) {
				// get auction values before they are changed
				String user_query = "SELECT * FROM Auction WHERE auction_id=" + request.getParameter("auction_id");
				
				rs = stmt.executeQuery(user_query);
				
				out.println("Auction Fields Prior to Change <br>");
				out.println("<table border=1>");
				out.println("<tr>");
				out.println("<th>auction_id</th>");
				out.println("<th>end_date</th>");
				out.println("<th>initial_price</th>");
				out.println("<th>bid_increment</th>");
				out.println("<th>minimum_price</th>");
				out.println("</tr>");
				while (rs.next()) {
					out.println("<tr>");
					out.println("<td>" + rs.getInt("auction_id") + "</td>");
					out.println("<td>" + rs.getDate("end_date") + " " + rs.getTime("end_date") +"</td>");
					out.println("<td>" + rs.getFloat("initial_price") + "</td>");
					out.println("<td>" + rs.getFloat("bid_increment") + "</td>");
					out.println("<td>" + rs.getFloat("minimum_price") + "</td>");
					out.println("</tr>");
				}
				out.println("</table>" + "<br>");
				
				// update the auction
				String auction_update = "UPDATE Auction SET " + request.getParameter("field") + " = " + request.getParameter("change") + " WHERE auction_id = " + request.getParameter("auction_id");
				// change update if it is for end_date
				if (request.getParameter("field").equals("end_date")) {
					auction_update = "UPDATE Auction SET " + request.getParameter("field") + " = '" + request.getParameter("change") + "' WHERE auction_id = " + request.getParameter("auction_id");
				}
				//out.println(auction_update + "<br>");
				stmt.executeUpdate(auction_update);
				
				
				// get auction values after they are changed
				// request.getParameter("field") != "auction_id"
				if (request.getParameter("field").equals("auction_id") == true) {
					user_query = "SELECT * FROM Auction WHERE auction_id=" + request.getParameter("change");
				}
				rs = stmt.executeQuery(user_query);
				out.println("Auction Fields After they are Changed <br>");
				out.println("<table border=1>");
				out.println("<tr>");
				out.println("<th>auction_id</th>");
				out.println("<th>end_date</th>");
				out.println("<th>initial_price</th>");
				out.println("<th>bid_increment</th>");
				out.println("<th>minimum_price</th>");
				out.println("</tr>");
				while (rs.next()) {
					out.println("<tr>");
					out.println("<td>" + rs.getInt("auction_id") + "</td>");
					out.println("<td>" + rs.getDate("end_date") + " " + rs.getTime("end_date") +"</td>");
					out.println("<td>" + rs.getFloat("initial_price") + "</td>");
					out.println("<td>" + rs.getFloat("bid_increment") + "</td>");
					out.println("<td>" + rs.getFloat("minimum_price") + "</td>");
					out.println("</tr>");
				}
				out.println("</table>");
			} else {
				out.println("Error: cannot change " + request.getParameter("field") + " to " + request.getParameter("change") + " because it is already being used<br>");
			}
			
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