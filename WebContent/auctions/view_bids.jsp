<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>

<%--
if ((session.getAttribute("account_type") != "Customer_rep")) {
	response.sendRedirect("../index.jsp");
}
--%>
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
			
			
			java.util.Date date = new java.util.Date();
			SimpleDateFormat sql_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date_time_now = sql_format.format(date);
			//out.println(date_time);		
			
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			String auction_id2 = request.getParameter("auction_id");
			
			String auc_date_time="";
			
			
			String auction_query = "select *, 'sedan' as type from Auction join for_ using (auction_id) join Car using (VIN) join Sedan using(VIN) join creates_Auc using (auction_id) join User using (username) where auction_id="+auction_id2
					+" union select *, 'minivan' as type from Auction join for_ using (auction_id) join Car using (VIN) join Minivan using(VIN) join creates_Auc using (auction_id) join User using (username) where auction_id="+auction_id2+""
					+" union select *, 'SUV' as type from Auction join for_ using (auction_id) join Car using (VIN) join SUV using(VIN) join creates_Auc using (auction_id) join User using (username) where auction_id="+auction_id2+"";
			//String auction_query = "select * from Auction join for_ using (auction_id) join Car using (VIN) where auction_id="+request.getParameter("auction_id")+"";
			rs = stmt.executeQuery(auction_query);
			int auction_id=-1;
			
			
			
			
			out.println("<table border=1>");
			out.println("<tr>");
			//out.println("<th>auction_id</th>");
			out.println("<th> Seller </th>");
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
			out.println("</tr>");
			
			
			while (rs.next()) {
				out.println("<tr>");
				/*
				out.println("<th>");
				auction_id=rs.getInt("auction_id");
				out.println(auction_id);
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
				out.println(rs.getString("auction_id"));
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
				auc_date_time=rs.getDate("end_date")+" " + rs.getTime("end_date");
				//out.println(rs.getDate("end_date"));
				//out.println(" " + rs.getTime("end_date"));
				out.print(auc_date_time);
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
				out.println("</tr>");
			}
			out.println("</table>");
	
			
			//String bid_query = "SELECT * FROM Auction a, Bid b, on_ o join creates_Auc using (auction_id) join User using (username) WHERE a.auction_id=o.auction_id and o.bid_id=b.bid_id and amount > 0 and a.auction_id=" + request.getParameter("auction_id");
			String bid_query = "select * from Auction join on_ using (auction_id) join Bid using (bid_id) join creates_Bid using (bid_id) join User using (username) where amount >0 and auction_id=" + request.getParameter("auction_id");
			//out.println(bid_query);
			
			rs = stmt.executeQuery(bid_query);
			
			
			boolean winningBid=false;
			
			
			out.println("<table border=1>");
			out.println("<tr>");
			//out.println("<th>bid_id</th>");
			out.println("<th>Bidder</th>");
			out.println("<th>Amount</th>");
			out.println("<th>Winner</th>");
			out.println("<th>Time</th>");
			out.println("</tr>");
			while (rs.next()) {
				out.println("<tr>");
				
				/*
				out.println("<td>");
				out.println(rs.getInt("bid_id"));
				out.println("</td>");
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
				
				
				out.println("<td>");
				out.println(rs.getFloat("amount"));
				out.println("</td>");
				
				out.println("<td>");
			
				out.println(rs.getBoolean("winning_bid"));
				out.println("</td>");
				
				out.println("<td>");
				out.println(rs.getDate("time_") + " " + rs.getTime("time_"));
				out.println("</td>");
				
		
				
				out.println("</tr>");
			}
			out.println("</table>");
			
		String dateCheck="select now()>'"+auc_date_time+"' as check_";
		//out.println(dateCheck);
		rs = stmt.executeQuery(dateCheck);
		if(rs.next())
		{
			if(rs.getBoolean("check_"))
				out.println("Auction is now closed, no bids will be accepted!");
		}
		
			
			
		conn.close();
		/*
		out.println("<select name=\"bid_type?auction_id=\"" + auction_id2 + ">");
		out.println("<option>Manual</option>");
		out.println("<option>Automatic</option>");
		out.println("</select>");
		out.println("<input type=\"submit\" value=\"Choose Method\">");
		out.println("</form>)");
		*/
		%>
		<form action= "view_bids.jsp?auction_id=<%=request.getParameter("auction_id")%>" method= "POST">
			Choose Bidding Style
			<select name="field">
				<option value="manual">manual</option>
				<option value="automatic">automatic</option>
			</select>
			<br>
			<input type="submit" value="Add Bid">
			
		</form>
		<%
			//String auc_id=request.getParameter("auction_id");
			
			
			boolean used = false;
			if (request.getParameter("field") != null) {
				used = true;
			}
			//out.println(used + " is used");
			// (username.equals("") == false)
			if (used == true) {
				
				
				String field = request.getParameter("field");
				if (field.equals("manual") == true ) 
				{
					//out.println(auction_id2);
					//out.println("manual field stuff <br>");
					
					//out.println("<form action= \"makebid.jsp?auction_id= \""+auc_id+ "method=\"POST\">");
					out.println("<form action= \"makebid.jsp\" method=\"POST\">");
					out.println("Enter Information: <br>");
					out.println("Bid Amount <input type=\"number\" name=\"bid\"> <br>");
					out.println("<input type=\"hidden\" name=\"auc_id\" value="+auction_id2+"> <br>");
					out.println("<input type=\"submit\" value=\"Make Bid\">");
					out.println("</form>");
				}
				if (field.equals("automatic") == true ) 
				{
					//out.println("automatic stuff here <br>");
					out.println("<form action= \"make_autobid.jsp\" method=\"POST\">");
					out.println("Enter Information: <br>");
					out.println("Upper Limit <input type=\"number\" name=\"upper_limit\"> <br>");
					out.println("<input type=\"hidden\" name=\"auc_id\" value="+auction_id2+"> <br>");
					out.println("<input type=\"submit\" value=\"Start Auto Bidding\">");
					out.println("</form>");
				}
				
			}
		%>
		<!-- 
		<br>
		<br>
		<br>
		<form action="view_bids.jsp" method="POST">
		<% out.println("<select name=\"bid_type?auction_id=\"" + request.getParameter("auction_id") + ">");
		%>
		
			<option>Manual</option>
			<option>Automatic</option>
		</select>
		<input type="submit" value="Choose Method">
		</form>
		 -->
		 
		 
		 <br>
		<br>
		<br>
		<a href="../account/account_redirect.jsp">Back to Account</a> <br>
		<a href="../account/logout.jsp">Logout</a> <br>
	</body>
</html>