<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>create account info</title>
	</head>
	<body>
	
		<%
			String user = request.getParameter("username");
			String pass = request.getParameter("password");
			String email = request.getParameter("email_address");
			String bank = request.getParameter("bank_account_number");
		
			Class.forName("com.mysql.jdbc.Driver");
			
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			// TODO CHANGE
			// check if username is in table
			String username_query = "select * from User where username='" + user + "'";
			//out.println(username_query);
			rs = stmt.executeQuery(username_query);
			
			if (rs.next()) {
				// username already exists
				//session.setAttribute("user_login", user);
				out.println("error: "+ user + " is already taken as a username");
			} else {
				// if username isn't in table, add user to table
				/*
				String create_user = "INSERT INTO User VALUES(" +
						"null, " +
						"null, " +
						"\"" + user + "\"" + ", " +
						"0, " +
						"\"" + pass + "\"" + ", " +
						"\"" + email + "\"" + ", " +
						bank +
						")";
				*/
				String create_user = "INSERT INTO User VALUES(" +
					"\"" + user + "\"" + ", " +
					"null, " +
					"0, " +
					"\"" + pass + "\"" + ", " +
					"\"" + email + "\"" + ", " +
					bank +
					")";
				
				//out.println(create_user);
				stmt.executeUpdate(create_user);
				
				// make the user an End_user
				// first get user_id
				String user_id_query = "SELECT username FROM User WHERE username=\"" + user + "\"";
				//out.println(user_id_query);
				rs = stmt.executeQuery(user_id_query);
				String username = "";
				while(rs.next()) {
					username = rs.getString("username");
				}
				// use user_id to make user an End_user
				String create_End_user = "INSERT INTO End_user(end_user_username) SELECT username FROM User WHERE username =\"" + username + "\"";
				//out.println(create_End_user);
				stmt.executeUpdate(create_End_user);
				
				out.println("Successfully created account: " + user);
				
			}
			
			conn.close();
		%>
		<br>
		<a href="createAccount.html">Back to Create Account</a>
		<a href="login.html">Login to Account</a>
		
	</body>
</html>