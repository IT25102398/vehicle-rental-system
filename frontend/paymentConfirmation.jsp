<%@ page import="com.vehiclerental.model.Payment" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Confirmation</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; margin: 0; }
        .box { max-width: 520px; margin: 60px auto; background: #fff; padding: 24px; border: 1px solid #ddd; }
        a { color: #2457a6; }
    </style>
</head>
<body>
<%
    Payment payment = (Payment) request.getAttribute("payment");
%>
<div class="box">
    <h2>Payment Successful</h2>
    <% if (payment != null) { %>
        <p>Payment ID: <strong><%= payment.getPaymentId() %></strong></p>
        <p>Booking ID: <%= payment.getBookingId() %></p>
        <p>Amount: Rs. <%= payment.getAmount() %></p>
        <p>Status: <%= payment.getStatus() %></p>
    <% } else { %>
        <p>Your payment has been recorded.</p>
    <% } %>
    <p><a href="vehicles.jsp">Back to vehicles</a></p>
</div>
</body>
</html>
