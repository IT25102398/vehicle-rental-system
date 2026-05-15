<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Review" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.service.ReviewService" %>
<%@ page import="com.vehiclerental.service.User" %>
<%@ page import="com.vehiclerental.service.VehicleService" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reviews - Vehicle Rental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/app.css" rel="stylesheet">
</head>
<body class="app-dark">
<div class="app-shell">
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String appRoot = application.getRealPath("/");
    File databaseDir = appRoot == null ? new File("database") : new File(new File(appRoot).getParentFile(), "database");
    List<Review> reviews = ReviewService.getAllReviews(new File(databaseDir, "reviews.txt"));
    List<Vehicle> vehicles = VehicleService.getAllVehicles(new File(databaseDir, "vehicles.txt"));
%>
<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="vehicles.jsp"><span class="brand-mark">VR</span><span>Vehicle Rental</span></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#reviewsNav"><span class="navbar-toggler-icon"></span></button>
        <div class="collapse navbar-collapse" id="reviewsNav">
            <div class="navbar-nav ms-auto align-items-lg-center">
                <a class="nav-link" href="vehicles.jsp">Vehicles</a>
                <% if (loggedInUser != null) { %>
                    <a class="nav-link" href="myBookings.jsp">My Bookings</a>
                    <span class="nav-link d-flex align-items-center gap-2"><span class="user-icon"><%= loggedInUser.getUsername().substring(0, 1).toUpperCase() %></span><%= loggedInUser.getUsername() %></span>
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-light btn-sm">Logout</a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-primary btn-sm">Login</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<main class="container py-4">
    <h1 class="page-title mb-1">Reviews</h1>
    <p class="page-subtitle">Share rental feedback and read public customer reviews.</p>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="surface">
                <div class="p-3 border-bottom border-secondary">Submit Review</div>
                <div class="p-3">
                    <% if (loggedInUser == null) { %>
                        <p>Please <a href="login.jsp">login</a> to submit a review.</p>
                    <% } else { %>
                        <form action="<%= request.getContextPath() %>/submitReview" method="post">
                            <div class="mb-3">
                                <label class="form-label">Vehicle</label>
                                <select name="vehicleId" class="form-select" required>
                                    <% for (Vehicle vehicle : vehicles) { %>
                                        <option value="<%= vehicle.getVehicleId() %>"><%= vehicle.getName() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Rating</label>
                                <select name="rating" class="form-select">
                                    <option value="5">5</option>
                                    <option value="4">4</option>
                                    <option value="3">3</option>
                                    <option value="2">2</option>
                                    <option value="1">1</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Comment</label>
                                <textarea name="comment" class="form-control" required></textarea>
                            </div>
                            <button class="btn btn-primary" type="submit">Submit</button>
                        </form>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <h2 class="mb-3">Customer Reviews</h2>
            <% for (Review review : reviews) {
                Vehicle vehicle = VehicleService.findById(vehicles, review.getVehicleId());
                String vehicleName = vehicle == null ? review.getVehicleId() : vehicle.getName();
            %>
                <div class="surface mb-3">
                    <div class="p-3">
                        <h5><%= vehicleName %> <span class="badge bg-warning text-dark"><%= review.getRating() %>/5</span></h5>
                        <p class="mb-1"><%= review.getComment() %></p>
                        <small class="muted-text">User: <%= review.getUserId() %> | <%= review.getDate() %></small>

                        <% if (loggedInUser != null && review.getUserId().equals(loggedInUser.getUserId())) { %>
                            <form action="<%= request.getContextPath() %>/updateReview" method="post" class="row g-2 mt-3">
                                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                                <div class="col-md-2"><input class="form-control" type="number" min="1" max="5" name="rating" value="<%= review.getRating() %>"></div>
                                <div class="col-md-7"><input class="form-control" name="comment" value="<%= review.getComment() %>"></div>
                                <div class="col-md-3"><button class="btn btn-sm btn-primary w-100" type="submit">Update</button></div>
                            </form>
                        <% } %>

                        <% if (loggedInUser != null && (review.getUserId().equals(loggedInUser.getUserId()) || "admin".equals(loggedInUser.getRole()))) { %>
                            <form action="<%= request.getContextPath() %>/deleteReview" method="post" class="mt-2">
                                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                                <button class="btn btn-sm btn-outline-danger" type="submit">Delete</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
