<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
		<%
			String to = request.getParameter("to");
			String subject = request.getParameter("subject");
			String content = request.getParameter("content");
			java.util.Date date = new java.util.Date();
			//out.println("to: " + to + "<br>");
			//out.println("subject: " + subject + "<br>");
			// convert date_time to proper format
			SimpleDateFormat sql_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date_time = sql_format.format(date);
			//out.println("date_time: " + date_time + "<br>");
			//out.println(content + "<br>");


			
			// make sure the email recipient exists
			// get user_id from username of email recipient
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);

				
			Statement stmt = conn.createStatement();
			ResultSet rs;
			String user_id_query = "SELECT * FROM User WHERE username=\"" + to + "\";";
			//out.println(user_id_query + "<br>");
			rs = stmt.executeQuery(user_id_query);
			// the username exists, get the user_id of the recipient
			//int to_id = -1;
			String to_username = "";
			while (rs.next()) {
				//to_id = rs.getInt("user_id");
				to_username = rs.getString("username");
			}
			//if (to_id != -1) {
			if (to_username.equals("") == false) {
				//out.println("send to: " + to_id + "<br>");
				
				// INSERT INTO Email Values(null, "about", "this is the entire email", '2019-03-22 18:25:00', 0,0);
				// # null, subject, content, date_time, from, to
				String create_email = "INSERT INTO Email Values(" +
					"null, " +
					"\"" + subject + "\"" + ", " +
					"\"" + content + "\"" + ", " +
					"\'" + date_time + "\'" + ", " +
					"\"" + session.getAttribute("username") + "\"" + ", " +
					"\"" + to_username + "\"" +
					")";
				//out.println(create_email + "<br>");
				stmt.executeUpdate(create_email);
				//out.println("Successfully sent email to : " + to);
				
			} else {
				// can't send email to invalid user
				out.println("error: cannot send email to " + to + ", username wasn't found " + "<br>");
				%>
					<a href="send_email.jsp">Back to Send Email</a> <br>
				<%
			}
			
			conn.close();
			
		%> <br>
		<a href="account_redirect.jsp">Back to account</a>
		<a href="logout.jsp">Logout Here</a>
	</body>
</html>