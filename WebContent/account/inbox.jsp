<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Email Inbox</title>
	</head>
	<body>
		<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String username = session.getAttribute("username").toString();
			String email_query = "SELECT * FROM Email WHERE to_='" + username + "'";
			
			rs = stmt.executeQuery(email_query);
			
			out.println("<table border=9>");
			out.println("<tr>");
			out.println("<th>From</th>");
			out.println("<th>Subject</th>");
			out.println("<th>Date</th>");
			out.println("</tr>");
			while(rs.next()) {
				out.println("<tr>");
				out.println("<th>");
				out.println(rs.getString("from_") + " ");
				out.println("</th>");
				
				// print out each from, subject, datetime
				out.println("<th>");
				out.println("<a href=\"email.jsp?email_id=");
				out.println(rs.getString("email_id") + " ");
				out.println("\">");
				out.println(rs.getString("subject_") + " ");
				//out.println("test");
				out.println("</a>");
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getDate("date_time") + " ");
				out.println("</th>");
				
				out.println("</tr>");
			}
			out.println("</table>");
			
			conn.close();
			
		%>
		<a href="send_email.jsp">Send Email</a> <br>
		<a href="account_redirect.jsp">back to Account</a> <br>
		<a href="logout.jsp">Logout Here</a>
	</body>
</html>