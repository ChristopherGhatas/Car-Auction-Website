<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Sales Reports</title>
	</head>
	<body>
		<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String report_query = "select * from Report";
			rs = stmt.executeQuery(report_query);
			out.println("<table border=5>");
			out.println("<tr>");
			out.println("<th>Report Type</th>");
			out.println("<th>Report Data</th>");
			out.println("<th>Date</th>");
			out.println("<th>Time</th>");
			out.println("</tr>");
			
			while(rs.next()) {
				out.println("<tr>");
				
				out.println("<th>");
				out.println(rs.getString("report_type"));
				out.println("</th>");
				
				out.println("<th>");
				//out.println(rs.getString("report_data"));
				out.println("<a href=\"show_report.jsp?report_id=" + rs.getInt("report_id") + "\">see report</a>");
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getDate("report_date"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getTime("report_date"));
				out.println("</th>");
				
				out.println("</tr>");
			}
			out.println("</table>");
			conn.close();
		%>
		<br>
		<a href="account_redirect.jsp">back to Account</a> <br>
		<a href="logout.jsp">Logout</a>
	</body>
</html>