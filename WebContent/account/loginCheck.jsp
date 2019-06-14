<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>login info</title>
	</head>
	<body>
	
		<%
			String user = request.getParameter("username");
			String pass = request.getParameter("password");
			Class.forName("com.mysql.jdbc.Driver");
			
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			String username_query = "select * from User where username='" + user + "' and password ='" + pass + "'";
			//out.println(username_query);
			
			rs = stmt.executeQuery(username_query);
			//int user_id = -1;
			String username = "";
			String alias = "";
			int balance = -1;
			String email = "";
			int bank = -1;
			while(rs.next()) {
				//user_id = rs.getInt("user_id");
				username = rs.getString("username");
				alias = rs.getString("alias");
				balance = rs.getInt("balance");
				email = rs.getString("email_address");
				bank = rs.getInt("bank_account_number");
			}

			// if user exists
			if (username.equals("") == false) {
				// set session attributes
				session.setAttribute("username", username);
				session.setAttribute("alias", alias);
				session.setAttribute("balance", balance);
				session.setAttribute("email", email);
				session.setAttribute("bank", bank);
				
				int accountType = -1;
				String answer = "";
				// check if user is Admin
				if (accountType == -1) {
					String query = "SELECT * FROM Admin WHERE admin_username='" + user + "'";
					rs = stmt.executeQuery(query);
					
					while(rs.next()) {
						answer = rs.getString("admin_username");
					}
					//if (answer == user) {
					if (answer.equals("") == false) {
						// is admin
						session.setAttribute("account_type", "Admin");
						accountType = 0;
					}
					//out.println("is user admin?" + accountType);
				}
				// check if user is Customer Rep
				if (accountType == -1) {
					String query = "SELECT * FROM Customer_rep WHERE customer_rep_username='" + user + "'";
					rs = stmt.executeQuery(query);
					
					while(rs.next()) {
						answer = rs.getString("customer_rep_username");
					}
					//if (answer == user) {
					if (answer.equals("") == false) {
						// is customer rep
						session.setAttribute("account_type", "Customer_rep");
						accountType = 1;
					}
					//out.println("is user admin?" + accountType);
				}

				if (accountType == -1){
					// if user isn't admin or customer rep then they are End_user
					accountType = 2;
					session.setAttribute("account_type", "End_user");
				}
				//out.println("accountType" + accountType);
				// redirect to correct page
				
				//out.println("Account type " + accountType);
				
				if (accountType == 0) {
					response.sendRedirect("admin.jsp");
				} else if (accountType == 1) {
					response.sendRedirect("customer_rep.jsp");
				} else {
					response.sendRedirect("end_user.jsp");
				}
				
				
				//response.sendRedirect("loginSuccess.jsp");
				
			} else {
				out.println("Invalid username or Password");
			}
			conn.close();
		%>
		<br>
		<a href="login.html">back to Login page</a>
		<a href="../index.jsp">back to main page</a>
	
	</body>
</html>