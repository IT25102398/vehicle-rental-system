<%@ page import="com.vehiclerental.service.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Vehicle Rental</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; margin: 0; }
        .box { max-width: 520px; margin: 50px auto; background: #fff; padding: 24px; border: 1px solid #ddd; }
        label { display: block; margin-top: 12px; }
        input, select { width: 100%; padding: 9px; margin-top: 5px; box-sizing: border-box; }
        button { margin-top: 16px; padding: 10px 16px; background: #2457a6; color: #fff; border: 0; cursor: pointer; }
        .error { background: #ffe1e1; padding: 10px; margin-bottom: 12px; }
    </style>
</head>
<body>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String bookingId = request.getParameter("bookingId");
    String amount = request.getParameter("amount");
    String vehicleName = request.getParameter("vehicleName");
    if (bookingId == null) bookingId = (String) request.getAttribute("bookingId");
    if (amount == null) amount = (String) request.getAttribute("amount");
    if (vehicleName == null) vehicleName = (String) request.getAttribute("vehicleName");
    if (bookingId == null) bookingId = "";
    if (amount == null) amount = "";
    if (vehicleName == null) vehicleName = "Selected vehicle";

    String error = (String) request.getAttribute("error");
%>
<div class="box">
    <h2>Payment</h2>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>
    <p><strong><%= vehicleName %></strong></p>

    <form action="<%= request.getContextPath() %>/processPayment" method="post">
        <label>Booking ID</label>
        <input type="text" name="bookingId" value="<%= bookingId %>" readonly>

        <label>User ID</label>
        <input type="text" name="userId" value="<%= loggedInUser.getUserId() %>" readonly>

        <label>Amount</label>
        <input type="number" name="amount" value="<%= amount %>" required>

        <label>Payment Method</label>
        <select name="method">
            <option value="card">Card</option>
            <option value="cash">Cash</option>
        </select>

        <button type="submit">Pay Now</button>
    </form>
</div>
</body>
</html>
