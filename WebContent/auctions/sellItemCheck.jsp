<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Info</title>
</head>
<body>
<% 			
			if(
				request.getParameter("VIN").equals("")||
				request.getParameter("model").equals("")||
				request.getParameter("make").equals("")||
				request.getParameter("color").equals("")||
				request.getParameter("mileage").equals("")||
				request.getParameter("type").equals("")||
				request.getParameter("date").equals("")||
				request.getParameter("time").equals("")||
				request.getParameter("init_price").equals("")||
				request.getParameter("bid_inc").equals("")||
				request.getParameter("min_price").equals(""))
			{
				response.sendRedirect("view_auctions.jsp");
				
			}else
			{
			int vin = Integer.parseInt(request.getParameter("VIN"));//NEED TO CAST THESE TO CORRECT TYPE
			String model = request.getParameter("model");
			String make = request.getParameter("make");
			String color = request.getParameter("color");
			int mileage = Integer.parseInt(request.getParameter("mileage"));
			String type = request.getParameter("type");
			String date = request.getParameter("date");
			String time = request.getParameter("time")+":00";
			float initial_price= Float.parseFloat(request.getParameter("init_price"));
			float bid_increment= Float.parseFloat(request.getParameter("bid_inc"));
			float minimum_price= Float.parseFloat(request.getParameter("min_price"));
			
			
			
			Class.forName("com.mysql.jdbc.Driver");
			
			String url = session.getAttribute("url").toString();
			String database_login_name = session.getAttribute("database_login_name").toString();
			String database_password = session.getAttribute("database_password").toString();
			Connection conn = DriverManager.getConnection(url, database_login_name, database_password);
			
			Statement stmt = conn.createStatement();
			ResultSet rs;
			
			String DateTimeQ=date+" "+time;
			String dateQuery="select now()>'"+DateTimeQ+"' as oldDate";
			//out.println(dateQuery);
			rs=stmt.executeQuery(dateQuery);
			rs.next();
			
			if(rs.getInt("oldDate")==1)
			{
				//out.println(rs.getInt("oldDate"));
				response.sendRedirect("sellitem.html");
			}
			else
			{
			
			//ResultSet rs2;
			String auction_query = "select * from Auction join for_ using (auction_id) join Car using (VIN) where VIN="+vin+"";
			rs=stmt.executeQuery(auction_query);
			String cars_query="select * from Car where VIN="+vin+"";
			//rs2=stmt.executeQuery(cars_query);
			
			String VINQuery="-1";
			int auc_id=-1;
			
			
			//while(rs.next()) 
			//{
			//	VINQuery = rs.getString("VIN");
			//	out.println(VINQuery);
			//}
			if(rs.next())
			{
			//out.println("Blah");
			//out.println("HERE: "+VINQuery);
			//if(VINQuery.equals(""))
				//out.println(rs.toString());
				out.println("This car is already being sold.");
				response.sendRedirect("sellitem.html");
			}
			
			//If car exists, use that car from the query 
			else
			{
				rs=stmt.executeQuery(cars_query);
				
				if(!rs.next())
				{
					String car_insert="INSERT INTO Car Values("+vin+",'"+ model+"','"+ make+"','"+ color+"',"+ mileage+")";
					//out.println(car_insert);				
					stmt.executeUpdate(car_insert);
					
					if(type.equals("Sedan"))
					{
						String sedan_insert="insert into Sedan values("+vin+")";
						stmt.executeUpdate(sedan_insert);
					} else if(type.equals("Minivan"))
					{
						String minivan_insert="insert into Minivan values("+vin+")";
						stmt.executeUpdate(minivan_insert);
					} else if(type.equals("SUV"))
					{
						String suv_insert="insert into SUV values("+vin+")";
						stmt.executeUpdate(suv_insert);
					}
					
					String DateTime=date+" "+time;
					String auc_insert="INSERT INTO Auction VALUES("+null+",'"+ DateTime+"',"+ initial_price+","+ bid_increment+","+ minimum_price+")";
					String last_auc_id="select LAST_INSERT_ID()";
					stmt.executeUpdate(auc_insert);
					//out.print(auc_insert);
					rs=stmt.executeQuery(last_auc_id);
					while(rs.next()) 
					{
						auc_id=rs.getInt("LAST_INSERT_ID()");
					}
					String username=session.getAttribute("username").toString();
					String createAuc="Insert into creates_Auc values("+auc_id+",'"+username+"')";
					stmt.executeUpdate(createAuc);
					String for_Query="Insert into for_ values("+auc_id+","+vin+")";
					stmt.executeUpdate(for_Query);
					response.sendRedirect("view_auctions.jsp");
				}else
				{
					model=rs.getString("model");
					make=rs.getString("make");
					color=rs.getString("color");
					mileage=rs.getInt("mileage");
					//out.println(vin+model+make+color+mileage);
					
					String DateTime=date+" "+time;
					String auc_insert="INSERT INTO Auction VALUES("+null+",'"+ DateTime+"',"+ initial_price+","+ bid_increment+","+ minimum_price+")";
					String last_auc_id="select LAST_INSERT_ID()";
					stmt.executeUpdate(auc_insert);
					out.print(auc_insert);
					rs=stmt.executeQuery(last_auc_id);
					while(rs.next()) 
					{
						auc_id=rs.getInt("LAST_INSERT_ID()");
					}
					String username=session.getAttribute("username").toString();
					String createAuc="Insert into creates_Auc values("+auc_id+",'"+username+"')";
					stmt.executeUpdate(createAuc);
					String for_Query="Insert into for_ values("+auc_id+","+vin+")";
					stmt.executeUpdate(for_Query);					
					response.sendRedirect("view_auctions.jsp");
				}
				//response.sendRedirect("view_auctions.jsp");
				
			}
			conn.close();
			}
	}

		%>
</body>
</html>