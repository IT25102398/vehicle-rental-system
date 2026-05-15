<%@ page import="com.vehiclerental.service.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Vehicle Rental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/app.css" rel="stylesheet">
</head>
<body class="app-dark">
<div class="app-shell">
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
<nav class="navbar app-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="vehicles.jsp"><span class="brand-mark">VR</span><span>Vehicle Rental</span></a>
    </div>
</nav>

<main class="container py-5">
<div class="surface auth-card">
    <h2 class="mb-1">Payment</h2>
    <p class="page-subtitle">Choose card or cash. Card fields are only needed for card payments.</p>
    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>
    <p><strong><%= vehicleName %></strong></p>

    <form action="<%= request.getContextPath() %>/processPayment" method="post">
        <label class="form-label">Booking ID</label>
        <input class="form-control" type="text" name="bookingId" value="<%= bookingId %>" readonly>

        <label class="form-label mt-3">User ID</label>
        <input class="form-control" type="text" name="userId" value="<%= loggedInUser.getUserId() %>" readonly>

        <label class="form-label mt-3">Amount</label>
        <input class="form-control" type="number" name="amount" value="<%= amount %>" required>

        <label class="form-label mt-3">Payment Method</label>
        <select class="form-select" name="method" id="paymentMethod">
            <option value="card">Card</option>
            <option value="cash">Cash</option>
        </select>

        <div id="cardFields">
            <label class="form-label mt-3">Cardholder Name</label>
            <input class="form-control" type="text" name="cardholderName" id="cardholderName" placeholder="Name on card">

            <label class="form-label mt-3">Card Number</label>
            <input class="form-control" type="text" name="cardNumber" id="cardNumber" maxlength="19" inputmode="numeric" placeholder="1234 5678 9012 3456">

            <label class="form-label mt-3">Expiry</label>
            <input class="form-control" type="text" name="expiry" id="expiry" maxlength="5" inputmode="numeric" placeholder="MM/YY">

            <label class="form-label mt-3">CVV</label>
            <input class="form-control" type="password" name="cvv" id="cvv" maxlength="3" inputmode="numeric" placeholder="123">
        </div>

        <button class="btn btn-primary w-100 mt-4" type="submit">Pay Now</button>
    </form>
</div>
</main>
</div>
<script>
    const paymentMethod = document.getElementById("paymentMethod");
    const cardFields = document.getElementById("cardFields");
    const cardInputs = [
        document.getElementById("cardholderName"),
        document.getElementById("cardNumber"),
        document.getElementById("expiry"),
        document.getElementById("cvv")
    ];
    const cardNumber = document.getElementById("cardNumber");
    const expiry = document.getElementById("expiry");
    const cvv = document.getElementById("cvv");

    function updatePaymentFields() {
        const isCard = paymentMethod.value === "card";
        cardFields.style.display = isCard ? "block" : "none";
        cardInputs.forEach(input => {
            input.required = isCard;
            if (!isCard) {
                input.value = "";
            }
        });
    }

    paymentMethod.addEventListener("change", updatePaymentFields);
    cardNumber.addEventListener("input", function () {
        const digits = cardNumber.value.replace(/\D/g, "").slice(0, 16);
        cardNumber.value = digits.replace(/(.{4})/g, "$1 ").trim();
    });
    expiry.addEventListener("input", function () {
        const digits = expiry.value.replace(/\D/g, "").slice(0, 4);
        expiry.value = digits.length > 2 ? digits.slice(0, 2) + "/" + digits.slice(2) : digits;
    });
    cvv.addEventListener("input", function () {
        cvv.value = cvv.value.replace(/\D/g, "").slice(0, 3);
    });
    document.querySelector("form").addEventListener("submit", function (event) {
        if (paymentMethod.value !== "card") {
            return;
        }
        const cardDigits = cardNumber.value.replace(/\s/g, "");
        if (!/^\d{16}$/.test(cardDigits) || !/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry.value) || !/^\d{3}$/.test(cvv.value)) {
            event.preventDefault();
            alert("Please enter a valid 16-digit card number, MM/YY expiry, and 3-digit CVV.");
        }
    });
    updatePaymentFields();
</script>
</body>
</html>
