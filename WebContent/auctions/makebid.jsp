<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import ="java.sql.*" %>
    <%@ page import = "java.util.*" %>
	<%@ page import = "java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title> </title>
</head>
<body>
<%
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			//String BidType=request.getParameter("bid_type");
			
			
			java.util.Date date = new java.util.Date();
	
			// convert date_time to proper format
			SimpleDateFormat sql_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String date_time = sql_format.format(date);
			out.println(date_time);
			
			int auction_id=Integer.parseInt(request.getParameter("auc_id"));
			
			String bidString=request.getParameter("bid");
			
			String bidder=session.getAttribute("username").toString();
			
			String bidderIsSeller="select * from Auction join creates_Auc using (auction_id) where username='"+bidder+"' and auction_id="+auction_id;
			//out.println(bidderIsSeller);
			rs=stmt.executeQuery(bidderIsSeller);
			
			
			if(bidString.equals("") || rs.next())
				response.sendRedirect("view_bids.jsp?auction_id="+auction_id);
			else{
				float bid_amount=Float.parseFloat(bidString);
			
			//Returns non empty table when the current is the previously highest bidder, redirects back to bid
			String bidderIsLastBidder="select * from Auction join on_ using (auction_id) join Bid using (bid_id) join creates_Bid using (bid_id)" 
				+"where auction_id="+auction_id+" and username='"+bidder+"' and username in" 
				+"(select username from Auction join on_ using (auction_id) join Bid using (bid_id) join creates_Bid using (bid_id)" 
				+"where auction_id="+auction_id+" and amount="
				+"(select max(amount) from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+"))";	
				
			//out.println(bidderIsLastBidder);
			rs=stmt.executeQuery(bidderIsLastBidder);	
			if(rs.next())
			{
				response.sendRedirect("view_bids.jsp?auction_id="+auction_id);
			}
			else
			{
			
			//TODO ->Check that bid ammount is higher then the highest bid ammount+the bid increment-Done
			//String auction_query = "select * from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+" and "+bid_amount+">=All(select amount+bid_increment from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+")";
			
			String initial_bid="select * from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id;
			rs=stmt.executeQuery(initial_bid);
			if(!rs.next())
			{
				String lessThanInitPrice="select * from Auction where auction_id="+auction_id+" and "+bid_amount+">=initial_price";
				//out.println(lessThanInitPrice);
				rs=stmt.executeQuery(lessThanInitPrice);
				
				if(!rs.next())
				{
					response.sendRedirect("view_bids.jsp?auction_id="+auction_id);
				}
				else{
				int bid_id=-1;
				
				String Bid_insert="INSERT INTO Bid Values("+null+","+bid_amount+",false,'"+date_time+"')";				
				stmt.executeUpdate(Bid_insert);
				
				String last_Bid_id="select LAST_INSERT_ID()";
				rs=stmt.executeQuery(last_Bid_id);
				while(rs.next()) 
				{
					bid_id=rs.getInt("LAST_INSERT_ID()");
				}
				
				String Manual_Bid="INSERT INTO Manual_Bid Values("+bid_id+")";				
				stmt.executeUpdate(Manual_Bid);
				
				String On_Insert="INSERT INTO on_ Values("+bid_id+","+auction_id+")";				
				stmt.executeUpdate(On_Insert);
				
				String username=session.getAttribute("username").toString();
				String createBid="Insert into creates_Bid values("+bid_id+",'"+username+"')";
				stmt.executeUpdate(createBid);
				
				stmt.executeQuery("call autoBidProc("+auction_id+")");
				
				response.sendRedirect("view_auctions.jsp");
				}
			}
			else
			{
			
			String auction_query="select * from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+" and NOW()<end_date and "+bid_amount+">=(select max(amount)+bid_increment from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+")";	
			//String auction_query="select * from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+" and exists (select amount+bid_increment from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+" and amount+bid_increment <="+bid_amount+")";
			//out.println(auction_query);
			rs=stmt.executeQuery(auction_query);
			
			
			//select * from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id=1 and 
			//		2000>= All(select amount+bid_increment from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id=1);
			
			if(rs.next())
			{	
				
				
				stmt.executeQuery("call outBid("+auction_id+")");
				//out.println("call outBid("+auction_id+")");
				//out.println("call aboveUpperLimit("+auction_id+","+bid_amount+")");
				stmt.executeQuery("call aboveUpperLimit("+auction_id+","+bid_amount+")");
				
				int bid_id=-1;
				
				String Bid_insert="INSERT INTO Bid Values("+null+","+bid_amount+",false,'"+date_time+"')";				
				stmt.executeUpdate(Bid_insert);
				
				String last_Bid_id="select LAST_INSERT_ID()";
				rs=stmt.executeQuery(last_Bid_id);
				while(rs.next()) 
				{
					bid_id=rs.getInt("LAST_INSERT_ID()");
				}
				
				String Manual_Bid="INSERT INTO Manual_Bid Values("+bid_id+")";				
				stmt.executeUpdate(Manual_Bid);
				
				String On_Insert="INSERT INTO on_ Values("+bid_id+","+auction_id+")";				
				stmt.executeUpdate(On_Insert);
				
				String username=session.getAttribute("username").toString();
				String createBid="Insert into creates_Bid values("+bid_id+",'"+username+"')";
				stmt.executeUpdate(createBid);
				
				stmt.executeQuery("call autoBidProc("+auction_id+")");
				
				response.sendRedirect("view_auctions.jsp");
			}else
			{
				//out.println("Bid not high enough...");
				//Thread.sleep(5000);
				//response.sendRedirect("view_bids.jsp");
				response.sendRedirect("view_bids.jsp?auction_id="+auction_id);
			}
			}
			}
			}
			conn.close();
		%>
</body>
</html>