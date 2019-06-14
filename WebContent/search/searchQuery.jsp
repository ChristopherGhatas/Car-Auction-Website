<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Search Results</title>
</head>


<body>

 <div class="content">
<%	
			
String url = session.getAttribute("url").toString();
String database_login_name = session.getAttribute("database_login_name").toString();
String database_password = session.getAttribute("database_password").toString();


ResultSet results = null;
String[] types = null;
StringBuilder[] searchQuery = new StringBuilder[6];
String[] fields = {"make", "model","color", "username"};
String[] bid = {"min_bid","max_bid", "mileage"};
ResultSet typeSet[] = null;
Statement stmt = null;
String field = null;
Connection conn = null;
int types_length = 1;
int full_length = 2;
boolean general = false;

for (int i = 0; i < searchQuery.length; i++) {
    searchQuery[i] = new StringBuilder("");
}
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		conn = DriverManager.getConnection(url, database_login_name, database_password);
		
		Boolean all = false;
	if(request.getParameterValues("types") == null){
			searchQuery[0].append("SELECT c.VIN,c.model,c.make,c.color,c.mileage,a.auction_id,b.bid_id,MAX(b.amount),b.winning_bid,b.time_,a2.end_date, cb.username FROM 336db.Car c INNER JOIN 336db.for_ f ON f.VIN = c.VIN INNER JOIN 336db.on_ a ON f.auction_id=a.auction_id INNER JOIN 336db.Auction a2 ON a.auction_id = a2.auction_id INNER JOIN 336db.Bid b ON a.bid_id = b.bid_id INNER JOIN 336db.creates_Bid cb ON cb.bid_id = b.bid_id WHERE ");
			searchQuery[1].append("SELECT c.VIN,c.model,c.make,c.color,c.mileage,a.auction_id,a.end_date, cb.username,a.initial_price as 'MAX(b.amount)'  FROM 336db.Car c INNER JOIN 336db.for_ f ON f.VIN = c.VIN INNER JOIN 336db.Auction a ON a.auction_id = f.auction_id INNER JOIN 336db.creates_Auc cb ON a.auction_id = cb.auction_id WHERE ");
			general = true;
		}
	else{
		types = request.getParameterValues("types");
		types_length = types.length;
		full_length = types_length*2;
		for (int i=0;i<types.length;i++){
		searchQuery[i].append("SELECT c.VIN,c.model,c.make,c.color,c.mileage,a.auction_id,b.bid_id,MAX(b.amount),b.winning_bid,b.time_,a2.end_date, cb.username FROM 336db.Car c INNER JOIN 336db."+ types[i]+ " s ON s.VIN = c.VIN INNER JOIN 336db.for_ f ON f.VIN = s.VIN INNER JOIN 336db.on_ a ON f.auction_id=a.auction_id INNER JOIN 336db.Auction a2 ON a.auction_id = a2.auction_id INNER JOIN 336db.Bid b ON a.bid_id = b.bid_id INNER JOIN 336db.creates_Bid cb ON cb.bid_id = b.bid_id WHERE ");
		}
		int j = 0;
		for (int i=types_length;i<full_length;i++){
			searchQuery[i].append("SELECT c.VIN,c.model,c.make,c.color,c.mileage,a.auction_id,a.end_date, cb.username,a.initial_price as 'MAX(b.amount)'  FROM 336db.Car c INNER JOIN 336db."+ types[j]+ " s ON s.VIN = c.VIN INNER JOIN 336db.for_ f ON f.VIN = c.VIN INNER JOIN 336db.Auction a ON a.auction_id = f.auction_id INNER JOIN 336db.creates_Auc cb ON a.auction_id = cb.auction_id WHERE ");
		j++;	
		}
		
		}
		String[] fields_input = new String[fields.length];
		for(int j = 0;j<fields.length;j++){
			if(request.getParameter(fields[j]) == null){
				fields_input[j] = ""; 
			}
			else{
			fields_input[j] = request.getParameter(fields[j]);
			}
		}
		
		String[] bid_input = new String[bid.length];
		for(int j = 0;j<bid.length;j++){
			if(request.getParameter(bid[j]) == "" || request.getParameter(bid[j])==null){
				if(bid[j] == "min_bid"){
				bid_input[j] = "0"; 
				}
				else if(bid[j] == "max_bid"){
					bid_input[j] = "99999999999"; 
					}
				else if(bid[j] == "mileage"){
					bid_input[j] = "99999999999"; 

					}
			}
			else{
			bid_input[j] = request.getParameter(bid[j]);
			}
		}
		
		for(int i=0;i<full_length;i++){	
			for (int j=0;j<fields.length;j++){
				if(j==(fields.length-1)){
					searchQuery[i].append(fields[j] +" LIKE '%"+ fields_input[j] + "%' ");
				}
				else{
				searchQuery[i].append(fields[j] +" LIKE '%"+ fields_input[j] + "%' AND ");
				}
			}
		
		if(i>=types_length){
			 searchQuery[i].append("AND mileage <= " + bid_input[2] + " AND initial_price >= "+ bid_input[0] +" AND initial_price <= "+ bid_input[1]);
		}
		else{
			 searchQuery[i].append("AND mileage <= " + bid_input[2] + " AND amount >= "+ bid_input[0] +" AND amount <= "+ bid_input[1]);
		}
		 if(request.getParameter("active") != null){
			String active = request.getParameter( "active" );
			
			if(active.equals("active")){
				searchQuery[i].append(" AND end_date>now()");
			}
			else if(active.equals("completed")){
				searchQuery[i].append(" AND end_date<now()");
			}
			else{
			}
			
		} 
		
		if(request.getParameter( "similar" ).equals("true")){
			searchQuery[i].append(" AND end_date >= DATE_SUB(curdate(), INTERVAL 1 MONTH)");	
		}
		
		if(i < types_length){
		if(request.getParameter( "bid" ).equals("true")){
			searchQuery[i].append(" GROUP BY bid_id;");	
		}
		else{
			searchQuery[i].append(" GROUP BY auction_id;");
		}
		}
		
		else{
		searchQuery[i].append(" AND NOT EXISTS(SELECT * FROM 336db.on_ O WHERE O.auction_id = a.auction_id) GROUP BY auction_id;");
		}
	}
		
		stmt = conn.createStatement();
		 %>
		<% if(request.getParameter( "bid" ).equals("true")){%>
			<h2>Showing All Bids and Auctions by Selected User</h2>
		<%}else{%>
			<h2>Search Results</h2>
			<h3>Click Column Headers To Sort By Column. One Click For Ascending and Two Clicks For Descending</h3>
			<%}%>
			
			<table id="auctionList" border = 9>
				<tr>
					<th onclick="sortAlpha(0)">Car</th>
					<th onclick="sortNum(1)">VIN</th>
					<th onclick="sortAlpha(2)">Color</th>
					<th onclick="sortNum(3)">Mileage</th>
					<th onclick="sortNum(4)">Current Bid</th>
					<th onclick="sortAlpha(5)">End Date/Time</th>
					<th onclick="sortAlpha(6)">User</th>
					<th>Similar Items</th>
				</tr>
				
				<script>
function sortAlpha(n) {
  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  table = document.getElementById("auctionList");
  switching = true;
  dir = "asc";
  while (switching) {
    switching = false;
    rows = table.rows;
    for (i = 1; i < (rows.length - 1); i++) {
      shouldSwitch = false;
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      if (dir == "asc") {
        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
          shouldSwitch = true;
          break;
        }
      } else if (dir == "desc") {
        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
          shouldSwitch = true;
          break;
        }
      }
    }
    if (shouldSwitch) {
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      switchcount ++;
    } else {
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}
</script>
<script>
function sortNum(n) {
  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  table = document.getElementById("auctionList");
  switching = true;
  // Set the sorting direction to ascending:
  dir = "asc";
  while (switching) {
    switching = false;
    rows = table.rows;
    for (i = 1; i < (rows.length - 1); i++) {
      shouldSwitch = false;
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      if (dir == "asc") {
    	  if (Number(x.innerHTML) > Number(y.innerHTML)) {
    		  shouldSwitch = true;
    		  break;
    		}
      } else if (dir == "desc") {
    	  if (Number(x.innerHTML) < Number(y.innerHTML)) {
    		  shouldSwitch = true;
    		  break;
    		}
      }
    }
    if (shouldSwitch) {
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      switchcount ++;
    } else {
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}
</script>


		<%for(int i=0;i<full_length;i++){
			results = stmt.executeQuery(searchQuery[i].toString());
			
			if (results.next()) {
				do { %>
					<tr>
						<td>
							<a href="/cs336Spring/auctions/view_bids.jsp?auction_id=<%= results.getInt("a.auction_id")%>">
										<%= results.getString("make") + " " + results.getString("model") %>
							</a>
						</td>
					<td><%= results.getInt("VIN")%></td>
					<td><%= results.getString("color") %></td>
					<td><%= results.getInt("mileage")%></td>
					<td><%= results.getFloat("MAX(b.amount)") %></td>
					<td><%= results.getString("end_date") %></td>
					<td>
							<a href="/cs336Spring/search/searchQuery.jsp?make=&model=&mileage=&color=&min_bid=&max_bid=&username=<%=results.getString("username")%>&bid=true&similar=&active=both">
										<%= results.getString("username") %>
							</a>
						</td>
					<td>
							<a href="/cs336Spring/search/searchQuery.jsp?make=<%=results.getString("make")%>&model=<%=results.getString("model")%>&mileage=&color=&min_bid=&max_bid=&seller=&bid=&similar=true&active=both">
										<%= "Similar Items" %>
							</a>
						</td>
					</tr>
		<%	} while (results.next()); %> 
		<%	}
			
			}
			%></table><%
		
		
	} finally {
	    try { results.close(); } catch (Exception e) {}
	    try { stmt.close(); } catch (Exception e) {}
	    try { conn.close(); } catch (Exception e) {}
	}
%>
</div>
</body>
</html>
					

