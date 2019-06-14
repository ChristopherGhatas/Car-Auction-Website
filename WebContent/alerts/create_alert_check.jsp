<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<title>Alert info</title>
	</head>
	
	<body>
		<%
			
			String model = request.getParameter("model");
			String make = request.getParameter("make");
			String color = request.getParameter("color");
			
			// Check the model make and color strings
			if(model.equals("\"\"") || make.equals("\"\"") || color.equals("\"\""))
			{
				response.sendRedirect("view_alerts.jsp");
			}
				
				
			String type = request.getParameter("type");
		
			Class.forName("com.mysql.jdbc.Driver");	
			
			java.util.Date date = new java.util.Date();
			
			SimpleDateFormat sql_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date_time = sql_format.format(date);
			
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			
			String create_alert = "INSERT INTO Alert VALUES(null, " + 
			"'" + model + "', " +
			"'" + make + "', " +
			"'" + color + "', " +
			"'" + type + "'," +
			"'" + date_time + "')";
			
			out.println(create_alert + "\n");
			//Create Alert
			stmt.executeUpdate(create_alert);
			//Make the Alert an new alert
			String get_alert_ID = "SELECT A.alert_id FROM Alert A, User U WHERE U.username=" +
			"'" + session.getAttribute("username") + "'" +
			" AND A.alert_date=" +
			"'" + date_time + "'";
			
			rs = stmt.executeQuery(get_alert_ID);
			
			int alert_ID = -1;
			
			while(rs.next())
			{
				alert_ID = rs.getInt("alert_id");
			}
			
			String make_new_alert = "INSERT INTO create_alert VALUES(" +
			"'" + session.getAttribute("username") + "'," + alert_ID + ")";
			
			stmt.executeUpdate(make_new_alert);

			conn.close();
			
			response.sendRedirect("view_alerts.jsp");
			
		%>
		
		
	</body>
</html>