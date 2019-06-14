<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import ="java.lang.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Generate Sales Reports</title>
	</head>
	<body>
		<%
		if ((session.getAttribute("account_type") != "Admin")) {
			response.sendRedirect("../index.jsp");
		}
		
		// connection stuff
		String url = session.getAttribute("url").toString();
		String database_login_name = session.getAttribute("database_login_name").toString();
		String database_password = session.getAttribute("database_password").toString();
		Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
		Statement stmt = conn.createStatement();
		ResultSet rs;
			
		String sale_report = request.getParameter("sales_report");

		StringBuilder sb = new StringBuilder();
		String report_type = "";
		
		if (sale_report.equals("total_earnings")) {
			sb.append("total earnings<br>");
			report_type = "total earnings";
			
			String query = "SELECT sum(amount) as total_earnings " +
					"FROM Car c, for_ f, Auction a, on_ o, Bid b " +
					"WHERE c.VIN = f.VIN and f.auction_id = a.auction_id and " +
					"a.auction_id = o.auction_id and o.bid_id = b.bid_id and b.winning_bid = true";
			
			rs = stmt.executeQuery(query);
			
			sb.append("<table border=1>");
			sb.append("<tr>");
			sb.append("<th>total_earnings</th>");
			sb.append("</tr>");
			while (rs.next()) {
				sb.append("<tr>");
				sb.append("<td>" + rs.getFloat("total_earnings") + "</td>");
				sb.append("<tr>");
			}
			sb.append("</table> <br>");
			out.println(sb);
			
			
		} else if (sale_report.equals("earnings_per_item")) {
			sb.append("earnings per item <br>");
			report_type = "earnings per item";
			
			String query = "SELECT sum(b.amount) as earnings_per_item, c.VIN, c.model, c.make " +
					"FROM Auction a, for_ f, Car c, on_ o, Bid b " +
					"WHERE a.auction_id = f.auction_id and f.VIN = c.VIN and " +
					"f.auction_id = o.auction_id and o.bid_id = b.bid_id and b.winning_bid = TRUE " +
					"GROUP BY c.VIN";
			rs = stmt.executeQuery(query);
			
			sb.append("<table border=1>");
			sb.append("<tr>");
			sb.append("<th>earnings_per_item</th>");
			sb.append("<th>VIN</th>");
			sb.append("<th>model</th>");
			sb.append("<th>make</th>");
			sb.append("</tr>");
			
			while (rs.next()) {
				sb.append("<tr>");
				sb.append("<td>" + rs.getString("earnings_per_item") + "</td>");
				sb.append("<td>" + rs.getInt("VIN") + "</td>");
				sb.append("<td>" + rs.getString("model") + "</td>");
				sb.append("<td>" + rs.getString("make") + "</td>");
				sb.append("<tr>");
			}
			sb.append("</table> <br>");
			out.println(sb);
			
		} else if (sale_report.equals("earnings_per_item_type")) {
			sb.append("earnings per item type<br>");
			report_type = "earnings per item type";
			
			String query = "SELECT sum(amount) \"sedan_earnings\", minivan.minivan_earnings, suv.suv_earnings " +
					"FROM Car c, for_ f, Auction a, on_ o, Bid b, Sedan, " +
					"(SELECT sum(amount) \"minivan_earnings\" " +
					"FROM Car c, for_ f, Auction a, on_ o, Bid b, Minivan " +
					"WHERE c.VIN = f.VIN and f.auction_id = a.auction_id and " +
					"a.auction_id = o.auction_id and o.bid_id = b.bid_id and b.winning_bid = true " +
					"and c.VIN=Minivan.VIN) minivan, " +
					 	"(SELECT sum(amount) \"suv_earnings\" " +
					"FROM Car c, for_ f, Auction a, on_ o, Bid b, SUV " +
					"WHERE c.VIN = f.VIN and f.auction_id = a.auction_id and " +
					"a.auction_id = o.auction_id and o.bid_id = b.bid_id and b.winning_bid = true " +
					"and c.VIN=SUV.VIN) suv " +
				"WHERE c.VIN = f.VIN and f.auction_id = a.auction_id " +
				"and a.auction_id = o.auction_id and o.bid_id = b.bid_id " +
				"and b.winning_bid = true and c.VIN=Sedan.VIN";
			
			rs = stmt.executeQuery(query);
			
			sb.append("<table border=1>");
			sb.append("<tr>");
			sb.append("<th>sedan_earnings</th>");
			sb.append("<th>minivan_earnings</th>");
			sb.append("<th>suv_earnings</th>");
			sb.append("</tr>");
			while (rs.next()) {				
				sb.append("<tr>");
				sb.append("<td>" + rs.getFloat("sedan_earnings") + "</td>");
				sb.append("<td>" + rs.getFloat("minivan_earnings") + "</td>");
				sb.append("<td>" + rs.getFloat("suv_earnings") + "</td>");
				sb.append("<tr>");
			}
			sb.append("</table> <br>");
			out.println(sb);
			
		} else if (sale_report.equals("earnings_per_end_user")) {
			sb.append("earnings per End-user<br>");
			report_type = "earnings per End-user";
			
			String query = "SELECT u.username, sum(amount) as earnings_per_user " +
					"FROM User u, Auction a, creates_Auc ca, Auction, on_ o, Bid b " +
					"WHERE u.username = ca.username and ca.auction_id = a.auction_id and " +
					"a.auction_id = o.auction_id and o.bid_id = b.bid_id " +
					"GROUP BY u.username";

			rs = stmt.executeQuery(query);
			
			sb.append("<table border=1>");
			sb.append("<tr>");
			sb.append("<th>username</th>");
			sb.append("<th>earnings_per_user</th>");
			sb.append("</tr>");
			while (rs.next()) {
				sb.append("<tr>");
				sb.append("<td>" + rs.getString("username") + "</td>");
				sb.append("<td>" + rs.getFloat("earnings_per_user") + "</td>");
				sb.append("<tr>");
			}
			sb.append("</table> <br>");
			out.println(sb);
			
		} else if (sale_report.equals("best_selling_items")) {
			sb.append("best selling items<br>");
			report_type = "best selling items";
			
			String query = "SELECT count(*) as sales_per_car, c.model, c.make " +
					"FROM Auction a, for_ f, Car c " +
					"WHERE a.auction_id = f.auction_id and f.VIN = c.VIN " +
					"GROUP BY c.VIN " +
					"ORDER BY sales_per_car DESC";
			
			rs = stmt.executeQuery(query);
			
			sb.append("<table border=1>");
			sb.append("<tr>");
			sb.append("<th>sales_per_car</th>");
			sb.append("<th>model</th>");
			sb.append("<th>make</th>");
			sb.append("</tr>");
			while (rs.next()) {
				sb.append("<tr>");
				sb.append("<td>" + rs.getInt("sales_per_car") + "</td>");
				sb.append("<td>" + rs.getString("model") + "</td>");
				sb.append("<td>" + rs.getString("make") + "</td>");
				sb.append("<tr>");
			}
			sb.append("</table> <br>");
			out.println(sb);
			
		} else if (sale_report.equals("best_buyers")) {
			sb.append("best buyers<br>");
			report_type = "best_buyers";
			
			String query = "SELECT u.username, sum(amount) as amount_spent " +
					"FROM Car c, for_ f, Auction a, on_ o, Bid b, creates_Bid cb, User u, End_user eu " +
					"WHERE c.VIN = f.VIN and f.auction_id = a.auction_id and " +
					"a.auction_id = o.auction_id and o.bid_id = b.bid_id and b.winning_bid = true and " +
					"b.bid_id = cb.bid_id and cb.username = u.username " +
					"and u.username = eu.end_user_username " +
					"GROUP BY u.username " +
					"ORDER BY amount_spent DESC";
			
			rs = stmt.executeQuery(query);

			sb.append("<table border=1>");
			sb.append("<tr>");
			sb.append("<th>username</th>");
			sb.append("<th>amount_spent</th>");
			sb.append("</tr>");
			while (rs.next()) {				
				sb.append("<tr>");
				sb.append("<td>" + rs.getString("username") + "</td>");
				sb.append("<td>" + rs.getFloat("amount_spent") + "</td>");
				sb.append("<tr>");
			}
			sb.append("</table> <br>");
			out.println(sb);
		}
		
		java.util.Date date = new java.util.Date();
		SimpleDateFormat sql_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date_time = sql_format.format(date);
		String insert_report = "INSERT INTO Report VALUES(null, " +
				"'" + report_type + "', " +		
				"'" + date_time + "', " +
				"'" + sb + "'" +
				")";
		stmt.executeUpdate(insert_report);
						
		out.println("saved report");
		
		conn.close();
		%>
		
		<br>
		<br>
		<a href="reports.jsp">View Reports</a> <br>
		<a href="account_redirect.jsp">back to Account</a> <br>
		<a href="logout.jsp">Logout</a>
	</body>
</html>