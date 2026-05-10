<%@ page import="com.vehiclerental.service.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking - Vehicle Rental</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; margin: 0; }
        .box { max-width: 520px; margin: 50px auto; background: #fff; padding: 24px; border: 1px solid #ddd; }
        label { display: block; margin-top: 12px; }
        input { width: 100%; padding: 9px; margin-top: 5px; box-sizing: border-box; }
        button { margin-top: 16px; padding: 10px 16px; background: #2457a6; color: #fff; border: 0; cursor: pointer; }
    </style>
</head>
<body>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String vehicleId = request.getParameter("vehicleId");
    String vehicleName = request.getParameter("vehicleName");
    String amount = request.getParameter("amount");
    if (vehicleId == null) vehicleId = "V001";
    if (vehicleName == null) vehicleName = "Toyota Prius";
    if (amount == null) amount = "3500";
    String bookingId = "B" + System.currentTimeMillis();
%>
<div class="box">
    <h2>Booking Details</h2>
    <p><strong><%= vehicleName %></strong> (<%= vehicleId %>)</p>
    <form action="<%= request.getContextPath() %>/createBooking" method="post">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">
        <input type="hidden" name="vehicleId" value="<%= vehicleId %>">
        <input type="hidden" name="vehicleName" value="<%= vehicleName %>">
        <input type="hidden" name="amount" value="<%= amount %>">

        <label>Start Date</label>
        <input type="date" name="startDate" required>

        <label>End Date</label>
        <input type="date" name="endDate" required>

        <label>Total Amount</label>
        <input type="text" value="Rs. <%= amount %>" readonly>

        <button type="submit">Continue to Payment</button>
    </form>
</div>
</body>
</html>
