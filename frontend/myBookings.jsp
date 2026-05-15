<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Booking" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.service.BookingService" %>
<%@ page import="com.vehiclerental.service.User" %>
<%@ page import="com.vehiclerental.service.VehicleService" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - Vehicle Rental</title>
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

    String appRoot = application.getRealPath("/");
    File databaseDir = appRoot == null ? new File("database") : new File(new File(appRoot).getParentFile(), "database");
    List<Booking> bookings = BookingService.getAllBookings(new File(databaseDir, "bookings.txt"));
    List<Vehicle> vehicles = VehicleService.getAllVehicles(new File(databaseDir, "vehicles.txt"));
%>
<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="vehicles.jsp"><span class="brand-mark">VR</span><span>Vehicle Rental</span></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#bookingsNav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="bookingsNav">
            <div class="navbar-nav ms-auto align-items-lg-center">
                <a class="nav-link" href="vehicles.jsp">Vehicles</a>
                <a class="nav-link" href="reviews.jsp">Reviews</a>
                <span class="nav-link d-flex align-items-center gap-2"><span class="user-icon"><%= loggedInUser.getUsername().substring(0, 1).toUpperCase() %></span><%= loggedInUser.getUsername() %></span>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </div>
</nav>

<main class="container py-4">
    <h1 class="page-title mb-1">My Bookings</h1>
    <p class="page-subtitle">Check your booking status and cancel active bookings.</p>
    <% if ("reason".equals(request.getParameter("cancelError"))) { %>
        <div class="alert alert-danger">Please enter a reason before cancelling a booking.</div>
    <% } %>
    <div class="table-responsive surface p-2">
        <table class="table table-darkish table-bordered mb-0">
            <thead>
            <tr>
                <th>Booking ID</th>
                <th>Vehicle</th>
                <th>Start</th>
                <th>End</th>
                <th>Total</th>
                <th>Status</th>
                <th>Cancel Reason</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (Booking booking : bookings) {
                if (!booking.getUserId().equals(loggedInUser.getUserId())) {
                    continue;
                }
                Vehicle vehicle = VehicleService.findById(vehicles, booking.getVehicleId());
                String vehicleName = vehicle == null ? booking.getVehicleId() : vehicle.getName();
            %>
                <tr>
                    <td><%= booking.getBookingId() %></td>
                    <td><%= vehicleName %></td>
                    <td><%= booking.getStartDate() %></td>
                    <td><%= booking.getEndDate() %></td>
                    <td>Rs. <%= booking.getTotalCost() %></td>
                    <td><%= booking.getStatus() %></td>
                    <td><%= booking.getCancelReason() == null || booking.getCancelReason().isEmpty() ? "-" : booking.getCancelReason() %></td>
                    <td>
                        <% if (!"Cancelled".equalsIgnoreCase(booking.getStatus())) { %>
                            <form action="<%= request.getContextPath() %>/cancelBooking" method="post">
                                <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                <input type="hidden" name="vehicleId" value="<%= booking.getVehicleId() %>">
                                <textarea class="form-control form-control-sm mb-2" name="cancelReason" rows="2" placeholder="Reason for cancelling" required></textarea>
                                <button class="btn btn-sm btn-danger" type="submit">Cancel</button>
                            </form>
                        <% } %>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
