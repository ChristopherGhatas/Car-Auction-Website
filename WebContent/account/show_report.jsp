<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Report <%=request.getParameter("report_id")%></title>
	</head>
	<body>
		<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String query = "SELECT * FROM Report WHERE report_id = " + request.getParameter("report_id");
			rs = stmt.executeQuery(query);
			
			while (rs.next()) {
				out.println("Report " + rs.getInt("report_id") + "<br>");
				out.println("Date " + rs.getDate("report_date") + " " + rs.getTime("report_date") +"<br>");
				out.println(rs.getString("report_data") + "<br>");
			}
			
			conn.close();
		%>
		<br>
		<a href="reports.jsp">back to Report List</a> <br>
		<a href="account_redirect.jsp">back to Account</a> <br>
		<a href="logout.jsp">Logout</a>
	</body>
</html>