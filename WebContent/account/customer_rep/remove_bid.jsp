<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<%
if ((session.getAttribute("account_type") != "Customer_rep")) {
	response.sendRedirect("../index.jsp");
}

String url = session.getAttribute("url").toString();
String database_login_name = session.getAttribute("database_login_name").toString();
String database_password = session.getAttribute("database_password").toString();
Connection conn = DriverManager.getConnection(url, database_login_name, database_password);

Statement stmt = conn.createStatement();
ResultSet rs;

String delete_bid = "Delete FROM Bid WHERE bid_id = " + request.getParameter("bid_id");
stmt.executeUpdate(delete_bid);

conn.close();

response.sendRedirect("view_bids.jsp?auction_id=" + request.getParameter("auction_id"));
%>
