<%@ page import="com.vehiclerental.service.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicles - Vehicle Rental</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f8; }
        nav { background: #2457a6; color: #fff; padding: 14px 24px; }
        nav a { color: #fff; margin-left: 14px; }
        .wrap { max-width: 900px; margin: 24px auto; }
        .vehicle { background: #fff; border: 1px solid #ddd; padding: 16px; margin-bottom: 14px; }
        button { padding: 9px 14px; background: #2457a6; color: #fff; border: 0; cursor: pointer; }
    </style>
</head>
<body>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<nav>
    Vehicle Rental System
    <a href="profile.jsp">Profile</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</nav>
<div class="wrap">
    <h2>Available Vehicles</h2>

    <div class="vehicle">
        <h3>Toyota Prius</h3>
        <p>Vehicle ID: V001 | Rs. 3500 per day</p>
        <form action="booking.jsp" method="get">
            <input type="hidden" name="vehicleId" value="V001">
            <input type="hidden" name="vehicleName" value="Toyota Prius">
            <input type="hidden" name="amount" value="3500">
            <button type="submit">Book Vehicle</button>
        </form>
    </div>

    <div class="vehicle">
        <h3>Suzuki Wagon R</h3>
        <p>Vehicle ID: V002 | Rs. 3000 per day</p>
        <form action="booking.jsp" method="get">
            <input type="hidden" name="vehicleId" value="V002">
            <input type="hidden" name="vehicleName" value="Suzuki Wagon R">
            <input type="hidden" name="amount" value="3000">
            <button type="submit">Book Vehicle</button>
        </form>
    </div>

    <div class="vehicle">
        <h3>Honda Vezel</h3>
        <p>Vehicle ID: V003 | Rs. 5500 per day</p>
        <form action="booking.jsp" method="get">
            <input type="hidden" name="vehicleId" value="V003">
            <input type="hidden" name="vehicleName" value="Honda Vezel">
            <input type="hidden" name="amount" value="5500">
            <button type="submit">Book Vehicle</button>
        </form>
    </div>
</div>
</body>
</html>
