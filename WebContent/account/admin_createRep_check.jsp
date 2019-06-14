<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Created Customer Rep</title>
	</head>
	<body>
		<%
		if ((session.getAttribute("account_type") != "Admin")) {
			response.sendRedirect("../index.html");
		}
		
		String user = request.getParameter("rep_name");
		String pass = request.getParameter("rep_password");
		String email = request.getParameter("rep_email_address");
		
		Class.forName("com.mysql.jdbc.Driver");
		
		String url = session.getAttribute("url").toString();
		String database_login_name = session.getAttribute("database_login_name").toString();
		String database_password = session.getAttribute("database_password").toString();
		Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
		Statement stmt = conn.createStatement();
		ResultSet rs;
		
		// check if username is in table
		String username_query = "select * from User where username='" + user + "'";
		rs = stmt.executeQuery(username_query);
		
		if (rs.next()) {
			// username already exists
			//session.setAttribute("user_login", user);
			out.println("error: "+ user + " is already taken as a username");
		} else {
			// if username isn't in table, add user to table
			String create_user = "INSERT INTO User VALUES(" +
					"\"" + user + "\"" + ", " +
					"null, " +
					"0, " +
					"\"" + pass + "\"" + ", " +
					"\"" + email + "\"" + ", " +
					-1 +
					")";
			//out.println(create_user);
			stmt.executeUpdate(create_user);
			// make the user a Customer_rep
			// first get user_id
			String user_id_query = "SELECT username FROM User WHERE username=\"" + user + "\"";
			//out.println(user_id_query);
			rs = stmt.executeQuery(user_id_query);
			String username = "";
			while(rs.next()) {
				username = rs.getString("username");
			}
			// use user_id to make user a Customer_rep
			String create_Customer_rep = "INSERT INTO Customer_rep(customer_rep_username) SELECT username FROM User WHERE username =\"" + user + "\"";
			//out.println(create_Customer_rep);
			stmt.executeUpdate(create_Customer_rep);
			
			out.println("Successfully created customer rep account");
		}
		
		conn.close();
		%>
		<br>
		<a href="admin.jsp">Back to Admin Tools</a> <br>
		<a href="logout.jsp">Logout</a>
	</body>
</html>