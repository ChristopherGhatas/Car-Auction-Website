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
		<title>Edit Account Information</title>
	</head>
	<body>
		<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;

			String username_query = "SELECT u.username FROM User u";
			
			rs = stmt.executeQuery(username_query);
			String username = "";
			
			out.println("<form action= \"edit_account_check.jsp\" method= \"POST\">");
			
			out.println("Select Account to Edit ");
			out.println("<select name=\"edit_username\">");
			while(rs.next()) {
				username = rs.getString("username");
				out.println("<option value=\"" + username + "\">" + username + "</option>");
			}
			out.println("</select>");
			out.println("<br>");
			
			out.println("Select Field to Edit");
			out.println("<select name=\"field\">");
			out.println("<option value=\"username\">username</option>");
			out.println("<option value=\"alias\">alias</option>");
			out.println("<option value=\"balance\">balance</option>");
			out.println("<option value=\"password\">password</option>");
			out.println("<option value=\"email_address\">email_address</option>");
			out.println("<option value=\"bank_account_number\">bank_account_number</option>");
			out.println("</select>");
			out.println("<br>");
			
			out.println("New value");
			out.println("<input type=\"text\" name=\"change\" required>");
			out.println("<br>");
			
			out.println("<input type=\"submit\" value=\"Edit Account\">");
			out.println("<br>");
			
			out.println("</form>");
			
			conn.close();
		%>
		<br>
		<br>
		<br>
		<a href="../account_redirect.jsp">Back to Account</a> <br>
		<a href="../logout.jsp">Logout</a> <br>
	</body>
</html>