<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.service.User" %>
<%@ page import="com.vehiclerental.service.VehicleService" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicles - Vehicle Rental</title>
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
    List<Vehicle> vehicles = VehicleService.getAllVehicles(new File(databaseDir, "vehicles.txt"));
%>
<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="vehicles.jsp">
            <span class="brand-mark">VR</span>
            <span>Vehicle Rental</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNav">
            <div class="navbar-nav ms-auto align-items-lg-center">
                <a class="nav-link" href="myBookings.jsp">My Bookings</a>
                <a class="nav-link" href="reviews.jsp">Reviews</a>
                <a class="nav-link" href="profile.jsp">Profile</a>
                <% if ("admin".equals(loggedInUser.getRole())) { %>
                    <a class="nav-link" href="admin.jsp">Admin</a>
                <% } %>
                <span class="nav-link d-flex align-items-center gap-2">
                    <span class="user-icon"><%= loggedInUser.getUsername().substring(0, 1).toUpperCase() %></span>
                    <%= loggedInUser.getUsername() %>
                </span>
                <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </div>
</nav>

<main class="container py-4">
    <div class="mb-4">
        <h1 class="page-title">Choose Your Vehicle</h1>
        <p class="page-subtitle">Browse live vehicle records from vehicles.txt and book an available ride.</p>
    </div>
    <div class="row g-3">
        <% for (Vehicle vehicle : vehicles) { %>
            <div class="col-md-4">
                <div class="card vehicle-card">
                    <div class="card-body">
                        <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
                            <div>
                                <h5 class="card-title mb-1"><%= vehicle.getName() %></h5>
                                <span class="badge badge-soft"><%= vehicle.getType() %></span>
                            </div>
                            <span class="vehicle-icon"><%= vehicle.getBrand().substring(0, 1).toUpperCase() %></span>
                        </div>
                        <p class="mb-1 muted-text"><strong>Brand:</strong> <%= vehicle.getBrand() %></p>
                        <p class="mb-1 muted-text"><strong>Daily Rate:</strong> Rs. <%= vehicle.getDailyRate() %></p>
                        <p class="mb-1 muted-text"><strong>Added:</strong> <%= vehicle.getAddedDate() == null || vehicle.getAddedDate().isEmpty() ? "N/A" : vehicle.getAddedDate() %></p>
                        <p class="mb-3"><strong>Status:</strong> <span class="badge <%= vehicle.isAvailable() ? "text-bg-success" : "text-bg-secondary" %>"><%= vehicle.getAvailability() %></span></p>

                        <% if (vehicle.isAvailable()) { %>
                            <form action="booking.jsp" method="get">
                                <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>">
                                <button type="submit" class="btn btn-primary w-100">Book Now</button>
                            </form>
                        <% } else { %>
                            <button class="btn btn-secondary w-100" disabled>Not Available</button>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
</main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
