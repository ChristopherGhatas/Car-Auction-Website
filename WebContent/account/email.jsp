<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Email</title>
	</head>
	<body>
		<%//= request.getParameter("email_id")%>
		<%
		
		String url = session.getAttribute("url").toString();
		String database_login_name = session.getAttribute("database_login_name").toString();
		String database_password = session.getAttribute("database_password").toString();
		Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
		Statement stmt = conn.createStatement();
		ResultSet rs;
		
		String query = "SELECT * FROM Email WHERE email_id=" + request.getParameter("email_id");
		//out.println(query);
		rs = stmt.executeQuery(query);
		while(rs.next()) {
			out.println("from " + rs.getString("from_") + " " + rs.getString("email_id"));
			out.println("<br>");
			out.println(rs.getString("subject_"));
			out.println("<br>");
			out.println(rs.getDate("date_time"));
			out.println("<br>");
			out.println(rs.getString("content"));
		}
		
		conn.close();
		%>
		<br>
		<br>
		<a href="inbox.jsp">back to Inbox</a> <br>
		<a href="account_redirect.jsp">back to Account</a> <br>
		<a href="logout.jsp">Logout Here</a>
	</body>
</html>