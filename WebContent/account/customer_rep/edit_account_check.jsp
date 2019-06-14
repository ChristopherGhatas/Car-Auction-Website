<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
if ((session.getAttribute("account_type") != "Customer_rep")) {
	response.sendRedirect("../../index.jsp");
}
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Edit Account Check</title>
	</head>
	<body>
		<%
			//out.println("account name to edit: " + request.getParameter("edit_username") + "<br>");
			//out.println("account field name to edit: " + request.getParameter("field") + "<br>");
			//out.println("new field value: " + request.getParameter("change") + "<br>");
			
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
			
			// show the account info before edit
			String username_query = "SELECT * FROM User WHERE username='" + request.getParameter("edit_username") + "'";
			rs = stmt.executeQuery(username_query);
			out.println("Account Information Prior to Edit <br>");
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th>Username</th>");
			out.println("<th>Alias</th>");
			out.println("<th>Balance</th>");
			out.println("<th>Password</th>");
			out.println("<th>Email Address</th>");
			out.println("<th>Bank Account Number</th>");
			out.println("</tr>");
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString("username") + "</td>");
				out.println("<td>" + rs.getString("alias") + "</td>");
				out.println("<td>" + rs.getFloat("balance") + "</td>");
				out.println("<td>" + rs.getString("password") + "</td>");
				out.println("<td>" + rs.getString("email_address") + "</td>");
				out.println("<td>" + rs.getInt("bank_account_number") + "</td>");
				out.println("</tr>");
			}
			out.println("</table> <br>");
			
			// edit the account info
			String edit_account = "UPDATE User SET " + request.getParameter("field") + "='" + request.getParameter("change") + "' WHERE username='" + request.getParameter("edit_username")+ "'";
			stmt.executeUpdate(edit_account);
			
			// show the account info after edit
			rs = stmt.executeQuery(username_query);
			out.println("Account Information After Edit <br>");
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<th>Username</th>");
			out.println("<th>Alias</th>");
			out.println("<th>Balance</th>");
			out.println("<th>Password</th>");
			out.println("<th>Email Address</th>");
			out.println("<th>Bank Account Number</th>");
			out.println("</tr>");
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString("username") + "</td>");
				out.println("<td>" + rs.getString("alias") + "</td>");
				out.println("<td>" + rs.getFloat("balance") + "</td>");
				out.println("<td>" + rs.getString("password") + "</td>");
				out.println("<td>" + rs.getString("email_address") + "</td>");
				out.println("<td>" + rs.getInt("bank_account_number") + "</td>");
				out.println("</tr>");
			}
			out.println("</table> <br>");
			
			conn.close();
		%>
		<br>
		<br>
		<br>
		<a href="../account_redirect.jsp">Back to Account</a> <br>
		<a href="../logout.jsp">Logout</a> <br>
	</body>
</html>