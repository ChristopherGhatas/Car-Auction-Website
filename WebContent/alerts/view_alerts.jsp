<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>View Alerts</title>
	</head>
	<body>
		<h1>Current Active Alerts</h1>
		<h4>Alerts Checked Every (1)Minute(s)</h4>
		
		<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
	
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String username = session.getAttribute("username").toString();
			
			// Query for Alerts made by the user
			String alert_query = "SELECT A.alert_id 'alert', A.model 'model', A.make 'make'," +
			" A.color 'color', A.car_type 'type', A.alert_date 'date' " +
			" FROM Alert A, create_alert C WHERE A.alert_id = C.alert_id AND C.username = '" + username +
			"'";
					
			rs = stmt.executeQuery(alert_query);
		
			out.println("<table border=9>");
			out.println("<tr>");
			out.println("<th>Model</th>");
			out.println("<th>Make</th>");
			out.println("<th>Color</th>");
			out.println("<th>Type</th>");
			out.println("<th>Date Made</th>");
			out.println("</tr>");
			
			while(rs.next())
			{
				out.println("<tr>");
				
				out.println("<td>");
				out.println(rs.getString("model"));
				out.println("</td>");
				
				out.println("<td>");
				out.println(rs.getString("make"));
				out.println("</td>");
				
				out.println("<td>");
				out.println(rs.getString("color"));
				out.println("</td>");
			
				out.println("<td>");
				out.println(rs.getString("type"));
				out.println("</td>");
				
				out.println("<td>");
				out.println(rs.getDate("date"));
				out.println(" ");
				out.println(rs.getTime("date"));
				out.println("</td>");
			}
			
			out.println("</table>");
				
			conn.close();
		%>
		<br><a href="create_alert.html">Create New Alert</a><br>
		<a href="../account/account_redirect.jsp">Back to account</a><br>
		<a href="../account/logout.jsp">Logout Here</a><br>
	</body>
</html>