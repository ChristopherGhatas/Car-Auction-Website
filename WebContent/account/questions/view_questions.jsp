<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>View Questions</title>
	</head>
	<body>
		<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
		
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String email_query = "SELECT e.email_id 'question_id', e.content 'question', e2.content 'answer', e.date_time" +
					" FROM Email e, Email e2, Question q" +
					" WHERE e.email_id=q.question_id and e2.email_id=q.answer_id" +
					" UNION" +
					" SELECT e.email_id, e.content 'question', null 'answer', e.date_time" +
					" FROM Email e, Question q" +
					" WHERE e.email_id=q.question_id and q.answer_id is null";

			rs = stmt.executeQuery(email_query);
			
			out.println("<table border=9>");
			out.println("<tr>");
			out.println("<th>Question</th>");
			out.println("<th>Answer</th>");
			out.println("<th>Datetime</th>");
			out.println("</tr>");
			
			while (rs.next()) {
				out.println("<tr>");
				
				out.println("<td>");
				out.println(rs.getString("question"));
				out.println("</td>");
				
				out.println("<td>");
				String answer = rs.getString("answer");				
				if (answer != null) {
					out.println(answer);
				} else if (session.getAttribute("account_type") == "Customer_rep") {
					//out.println("customer rep can see this");
					//out.println("<a href=\"answer_question.jsp?email_id=");
					//out.println(rs.getInt("question_id") + " ");
					//out.println("</a>");
					out.println("<a href=\"answer_question.jsp?email_id=" +
						rs.getInt("question_id") + "\" " +
						"/>Click Here to Answer Question</a>");
					
				}
				out.println("</td>");
				
				out.println("<td>");
				out.println(rs.getDate("date_time"));
				out.println(" ");
				out.println(rs.getTime("date_time"));
				out.println("</td>");
				
				out.println("</tr>");
			}
			
			out.println("</table>");
			
			conn.close();
		%>
		<br>
		<br>
		<a href="../account_redirect.jsp">Back to account</a> <br>
		<a href="../logout.jsp">Logout Here</a>
	</body>
</html>