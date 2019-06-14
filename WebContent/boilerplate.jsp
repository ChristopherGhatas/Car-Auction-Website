<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- This is an HTML comment -->

<!-- This import is required for SQL commands -->
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
		<%
			// These get the session attributes for url, database_login_name, and database_password set in index.jsp
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			
			// This creates a connection to the RDS server
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			// creates a statement for running queries
			Statement stmt = conn.createStatement();
			// ResultSet is used to get the results from a query
			ResultSet rs;
			
			// create a query
			String query = "SELECT * FROM Email";
			
			// run the query and get the results as rs
			// use stmt.executeQuery whenever the query you are using will give you results back
			rs = stmt.executeQuery(query);
			
			// go through each row of the result
			while (rs.next()) {
				// print out the email_id and subject_ of each email
				// <br> is line break
				// there is also rs.getFloat and so on
				// no rs.getDateTime, you have to use rs.getDate and rs.getTime
				out.println(rs.getInt("email_id") + ", " + rs.getString("subject_") + "<br>");
			}
			
			// add a new email to the database
			String create_email = "INSERT INTO Email VALUES(null, 'I made this', '', '2019-03-19 12:30:00', 'name1', 'name1')";
			
			// note that this isn't setting rs to anything and its executeUpdate not executeQuery
			stmt.executeUpdate(create_email);
			
			out.println("<br>Now lets see the new email<br><br>");
			
			// now lets see the emails again
			rs = stmt.executeQuery(query);
			while (rs.next()) {
				out.println(rs.getInt("email_id") + ", " + rs.getString("subject_") + "<br>");
			}
			
			// closes the connection.  Dont forget this! and make sure its before any redirects
			conn.close();
		%>	
	</body>
</html>