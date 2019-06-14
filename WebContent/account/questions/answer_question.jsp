<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<%
if ((session.getAttribute("account_type") != "Customer_rep")) {
	response.sendRedirect("../../index.html");
}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Answer Question</title>
	</head>
	<body>
		<% 
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
			Statement stmt = conn.createStatement();
			ResultSet rs;
			String email_query = "SELECT content, date_time, from_ FROM Email WHERE email_id=" + request.getParameter("email_id");
			
			rs = stmt.executeQuery(email_query);
			
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th>From</th>");
			out.println("<th>Question</th>");
			out.println("<th>Datetime</th>");
			out.println("</tr>");
			
			while (rs.next()) {
				out.println("<tr>");
				
				out.println("<th>");
				out.println(rs.getString("from_"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getString("content"));
				out.println("</th>");
				
				out.println("<th>");
				out.println(rs.getDate("date_time") + " ");
				out.println(rs.getTime("date_time"));
				out.println("</th>");
				
				out.println("</tr>");
			}
			
			out.println("</table>");
			
			conn.close();
		%>
		
		<form action= "answer_question_check.jsp?email_id=<%=request.getParameter("email_id")%>" method= "POST">
			<textarea rows="8" cols="50" name="content" required></textarea> <br>
			<input type="submit" value="Answer Question">
		</form>
		<br>
		<a href="../account_redirect.jsp">Back to account</a> <br>
		<a href="../logout.jsp">Logout Here</a>
	</body>
</html>