<%@ page import="com.vehiclerental.model.Payment" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/app.css" rel="stylesheet">
</head>
<body class="app-dark">
<div class="app-shell">
<%
    Payment payment = (Payment) request.getAttribute("payment");
%>
<div id="paymentToast" class="success-toast">
    <strong>Payment confirmed</strong>
    <div>Your booking payment was recorded successfully.</div>
</div>
<main class="container py-5">
<div class="surface auth-card">
    <h2>Payment Successful</h2>
    <% if (payment != null) { %>
        <p>Payment ID: <strong><%= payment.getPaymentId() %></strong></p>
        <p>Booking ID: <%= payment.getBookingId() %></p>
        <p>Amount: Rs. <%= payment.getAmount() %></p>
        <p>Status: <%= payment.getStatus() %></p>
    <% } else { %>
        <p>Your payment has been recorded.</p>
    <% } %>
    <div class="d-grid gap-2">
        <a class="btn btn-primary" href="myBookings.jsp">View My Bookings</a>
        <a class="btn btn-outline-light" href="reviews.jsp">Leave a Review</a>
        <a class="btn btn-outline-light" href="vehicles.jsp">Back to Vehicles</a>
    </div>
</div>
</main>
</div>
<script>
    const toast = document.getElementById("paymentToast");
    setTimeout(function () {
        toast.classList.add("show");
    }, 200);
    setTimeout(function () {
        toast.classList.remove("show");
    }, 4500);
</script>
</body>
</html>
