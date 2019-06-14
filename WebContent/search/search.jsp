
<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Car Search</title>
</head>
<body>
<%--add later --<% if(session.getAttribute("User") == null) { 
    		response.sendRedirect("login.jsp");
       } else { --%>
       
       <ul
        class="nav">
    <div class="content">
    <form action="searchQuery.jsp" method="GET">
        	
    	<input type="checkbox" name="types" value="SUV"> SUV<br>
		<input type="checkbox" name="types" value="Sedan"> Sedan<br>
		<input type="checkbox" name="types" value="Minivan"> Minivan<br>
		
		<label for="Make">Make</label>
		<input type="text" name="make" id="make" placeholder="Enter the Make"> <br>
		
		<label for="Model">Model</label>
		<input type="text" name="model" id="model" placeholder="Enter the Model"> <br>
		
		<label for="Maximum Mileage">Maximum Mileage</label>
		<input type="text" name="mileage" id="mileage" placeholder="Enter the Maximum Bid"> <br>
		
		<label for="Color">Color</label>
		<input type="text" name="color" id="color" placeholder="Enter the Color"> <br>
		
		<label for="Minimum Bid">Minimum Bid</label>
		<input type="text" name="min_bid" id="min_bid" placeholder="Enter the Minimum Bid"> <br>
		
		<label for="Maximum Bid">Maximum Bid</label>
		<input type="text" name="max_bid" id="max_bid" placeholder="Enter the Maximum Bid"> <br>
		
		<label for="Seller">Seller</label>
		<input type="text" name="username" id="username" placeholder="Enter the Seller"> <br>
		
		 <input type="hidden" id="bid" name="bid" value="">
		 <input type="hidden" id="similar" name="similar" value="">
		 
		 
		
		<input type="radio" name="active" value="active" > Show Active Auctions<br>
		<input type="radio" name="active" value="completed" > Show Completed Auctions<br>
		<input type="radio" name="active" value="both" checked> Show All Auctions<br>
		
		
		
		
		<input type="submit" value="Search">
</body>
</html>