<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>

<%
if ((session.getAttribute("account_type") != "Customer_rep")) {
	response.sendRedirect("../../index.jsp");
}

String url = session.getAttribute("url").toString();
String database_login_name = session.getAttribute("database_login_name").toString();
String database_password = session.getAttribute("database_password").toString();
Connection conn = DriverManager.getConnection(url, database_login_name, database_password);

Statement stmt = conn.createStatement();
ResultSet rs;

// create the answer as an email to the person who asked the question

// get the username of the user who asked the question
String username_query = "SELECT username FROM User u, Email e WHERE e.email_id=" + request.getParameter("email_id") +" and e.from_ = u.username";
String username = "";
rs = stmt.executeQuery(username_query);
while (rs.next()) {
	username = rs.getString("username");
}

// get current datetime
java.util.Date date = new java.util.Date();
SimpleDateFormat sql_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String date_time = sql_format.format(date);

// create email to user from rep
String create_email = "INSERT INTO Email VALUES(null, 'Answer to question'," +
	"'" + request.getParameter("content") + "', " +
	"'" + date_time + "', " +
	"'" + session.getAttribute("username") + "', " + 
	"'" + username + "')";
//out.println(create_email);
stmt.executeUpdate(create_email);

// get email_id from email sent just now
String email_id_query = "SELECT email_id FROM Email WHERE date_time =" +
	"'" + date_time + "'" +
	"  and from_ =" +
	"'" + session.getAttribute("username") + "'";
//out.println(email_id_query);
rs = stmt.executeQuery(email_id_query);
int answer_email_id = -1;
while (rs.next()) {
	answer_email_id = rs.getInt("email_id");
}
//out.println(answer_email_id);

// make the email an answer to a question
String make_answer = "UPDATE Question SET answer_id = " + answer_email_id + " WHERE question_id = " + request.getParameter("email_id");
stmt.executeUpdate(make_answer);
conn.close();
response.sendRedirect("view_questions.jsp");
%>
