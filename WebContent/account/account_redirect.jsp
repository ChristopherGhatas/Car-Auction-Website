<%
	if (session.getAttribute("account_type") == "Admin") {
		response.sendRedirect("admin.jsp");
	} else if (session.getAttribute("account_type") == "Customer_rep"){
		response.sendRedirect("customer_rep.jsp");
	} else if (session.getAttribute("account_type") == "End_user") {
		response.sendRedirect("end_user.jsp");
	} else {
		response.sendRedirect("logout.jsp");
	}
%>