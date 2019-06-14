<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%
if ((session.getAttribute("account_type") != "End_user")) {
	response.sendRedirect("../../index.jsp");
}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
		<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String set_alias = "UPDATE User SET alias = '" + request.getParameter("alias") + "' WHERE username = '" + session.getAttribute("username") + "'";
			//out.println(set_alias);
			stmt.executeUpdate(set_alias);
			conn.close();
			session.setAttribute("alias", request.getParameter("alias"));
			response.sendRedirect("../account_redirect.jsp");
		%>
	</body>
</html>