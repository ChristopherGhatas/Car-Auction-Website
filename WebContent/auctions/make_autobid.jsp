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
			
			String bidder=session.getAttribute("username").toString();
			
			String bidderIsSeller="select * from Auction join on_ using (auction_id) join Bid using (bid_id) join creates_Auc using (auction_id) where username='"+bidder+"' and auction_id="+auction_id;
			//out.println(bidderIsSeller);
			rs=stmt.executeQuery(bidderIsSeller);
			
			String UpperString=request.getParameter("upper_limit");
			
			if(UpperString.equals("")||rs.next())
				response.sendRedirect("view_bids.jsp?auction_id="+auction_id);
			else{
				float upper_limit=Float.parseFloat(UpperString);
				
			//Returns non empty table when the current is the previously highest bidder, redirects back to bid, autobidder will always be highest bidder till passed
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
				
				
			//initial bid->autobid	
			String initial_bid="select * from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id;
			rs=stmt.executeQuery(initial_bid);
			if(!rs.next())
			{	
				String lessThanInitPrice="select * from Auction where auction_id="+auction_id+" and "+upper_limit+">=initial_price";
				//out.println(lessThanInitPrice);
				rs=stmt.executeQuery(lessThanInitPrice);
				
				if(!rs.next())
				{
					response.sendRedirect("view_bids.jsp?auction_id="+auction_id);
				}
				else
				{
				float bid_amount=-1;//get the max bid from a query then add the bid increment to it as long as its less then the upper limit
				
				//String max_query="select MAX(amount)+bid_increment from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id;
				String max_query="select MAX(amount) from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id;//-bid_inc
				rs=stmt.executeQuery(max_query);
				while(rs.next())
				{
					//bid_amount=rs.getFloat("MAX(amount)+bid_increment");
					bid_amount=rs.getFloat("MAX(amount)");
				}
				
				
				int bid_id=-1;
				
				String Bid_insert="INSERT INTO Bid Values("+null+","+0+",false,'"+date_time+"')";				
				stmt.executeUpdate(Bid_insert);
				
				String last_Bid_id="select LAST_INSERT_ID()";
				rs=stmt.executeQuery(last_Bid_id);
				while(rs.next()) 
				{
					bid_id=rs.getInt("LAST_INSERT_ID()");
				}
				
				String Automatic_Bid="INSERT INTO Automatic_Bid Values("+bid_id+","+bid_amount+","+upper_limit+")";				
				stmt.executeUpdate(Automatic_Bid);
				
				String username=session.getAttribute("username").toString();
				String createBid2="Insert into creates_Bid values("+bid_id+",'"+username+"')";
				stmt.executeUpdate(createBid2);
				
				String On_Insert="INSERT INTO on_ Values("+bid_id+","+auction_id+")";				
				stmt.executeUpdate(On_Insert);
				
				stmt.executeQuery("call autoBidProc("+auction_id+")");
				
				
				response.sendRedirect("view_auctions.jsp");
				}
				
			}
			else 
			{
				
				
			//TODO ->Check that bid amount is higher then the highest bid amount+the bid increment
			/*String auction_query = "select * from Auction join on_ using (auction_id) join Bid using (bid_id) join creates_Bid using (Bid_id) where auction_id="
			+auction_id+" and "+upper_limit+">=All(select amount+bid_increment from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="
			+auction_id+") and username not in(select * from Auction join on_ using (auction_id) join Bid using (bid_id) join Automatic_Bid using (bid_id) join creates_Bid using (Bid_id) where upper_limit <="
			+upper_limit+" auction_id="
			+auction_id+")";*/																											
			String auction_query = "select * from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+" and Now()<end_date and "+upper_limit+">=(select MAX(amount)+bid_increment from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id+")";
			rs=stmt.executeQuery(auction_query);
			
			
			//create bid with the upper limit, save it to auto_bid and createsbid, then make a new bid 
			
			if(rs.next())
			{		
				
				float bid_amount=-1;//get the max bid from a query then add the bid increment to it as long as its less then the upper limit
				
				//String max_query="select MAX(amount)+bid_increment from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id;
				String max_query="select MAX(amount) from Auction join on_ using (auction_id) join Bid using (bid_id) where auction_id="+auction_id;//-bid_inc
				rs=stmt.executeQuery(max_query);
				while(rs.next())
				{
					//bid_amount=rs.getFloat("MAX(amount)+bid_increment");
					bid_amount=rs.getFloat("MAX(amount)");
				}
				
				stmt.executeQuery("call outBid("+auction_id+")");
				stmt.executeQuery("call aboveUpperLimit("+auction_id+","+upper_limit+")");
				
				int bid_id=-1;
				
				String Bid_insert="INSERT INTO Bid Values("+null+","+0+",false,'"+date_time+"')";				
				stmt.executeUpdate(Bid_insert);
				
				String last_Bid_id="select LAST_INSERT_ID()";
				rs=stmt.executeQuery(last_Bid_id);
				while(rs.next()) 
				{
					bid_id=rs.getInt("LAST_INSERT_ID()");
				}
				
				String Automatic_Bid="INSERT INTO Automatic_Bid Values("+bid_id+","+bid_amount+","+upper_limit+")";				
				stmt.executeUpdate(Automatic_Bid);
				
				String username=session.getAttribute("username").toString();
				String createBid2="Insert into creates_Bid values("+bid_id+",'"+username+"')";
				stmt.executeUpdate(createBid2);
				
				String On_Insert="INSERT INTO on_ Values("+bid_id+","+auction_id+")";				
				stmt.executeUpdate(On_Insert);
				
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