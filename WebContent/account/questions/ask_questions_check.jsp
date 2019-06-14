<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
		<%
			String content = request.getParameter("content");
			java.util.Date date = new java.util.Date();
			
			SimpleDateFormat sql_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date_time = sql_format.format(date);
			
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);

				
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String create_question = "INSERT INTO Email VALUES(null, 'question', " +
			"'" + content + "', " +
			"'" + date_time + "', " +
			"'" + session.getAttribute("username") + "', " +
			"'question')";
			
			// create email from question
			stmt.executeUpdate(create_question);
			// turn question into a question
			String get_email_id = "SELECT e.email_id FROM Email e WHERE e.from_=" +
			" '" + session.getAttribute("username") + "'" +
			" and e.date_time=" +
			" '" + date_time + "'";
			
			
			rs = stmt.executeQuery(get_email_id);
			
			int email_id = -1;
			
			while (rs.next()){
				email_id = rs.getInt("email_id");
			}
			
			String make_question = "INSERT INTO Question VALUES(" +
			+ email_id +
			", null)";
			
			/*
			out.println(create_question);
			out.println("<br>");
			out.println(get_email_id);
			out.println("<br>");
			out.println(make_question);
			*/
			stmt.executeUpdate(make_question);
			
			conn.close();
			response.sendRedirect("view_questions.jsp");
		%>
	</body>
</html>