<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.vehiclerental.model.Booking" %>
<%@ page import="com.vehiclerental.model.Payment" %>
<%@ page import="com.vehiclerental.model.Review" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.service.BookingService" %>
<%@ page import="com.vehiclerental.service.PaymentService" %>
<%@ page import="com.vehiclerental.service.ReviewService" %>
<%@ page import="com.vehiclerental.service.User" %>
<%@ page import="com.vehiclerental.service.VehicleService" %>
<%@ page import="java.time.LocalDate" %>
<%!
    private User findUser(List<User> users, String userId) {
        for (User user : users) {
            if (user.getUserId().equals(userId)) {
                return user;
            }
        }
        return null;
    }

    private Booking findBooking(List<Booking> bookings, String bookingId) {
        for (Booking booking : bookings) {
            if (booking.getBookingId().equals(bookingId)) {
                return booking;
            }
        }
        return null;
    }

    private Vehicle findVehicle(List<Vehicle> vehicles, String vehicleId) {
        for (Vehicle vehicle : vehicles) {
            if (vehicle.getVehicleId().equals(vehicleId)) {
                return vehicle;
            }
        }
        return null;
    }

    private boolean isActiveBooking(Booking booking) {
        return booking != null && !"Cancelled".equalsIgnoreCase(booking.getStatus());
    }

    private String firstLetter(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "U";
        }
        return value.substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Vehicle Rental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/app.css" rel="stylesheet">
</head>
<body class="app-dark">
<div class="app-shell">
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"admin".equals(loggedInUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String appRoot = application.getRealPath("/");
    File databaseDir = appRoot == null ? new File("database") : new File(new File(appRoot).getParentFile(), "database");

    List<User> users = new ArrayList<>();
    File userFile = new File(databaseDir, "users.txt");
    if (userFile.exists()) {
        BufferedReader reader = new BufferedReader(new FileReader(userFile));
        String line;
        while ((line = reader.readLine()) != null) {
            if (!line.trim().isEmpty()) {
                users.add(User.fromFileString(line));
            }
        }
        reader.close();
    }

    List<Vehicle> vehicles = VehicleService.getAllVehicles(new File(databaseDir, "vehicles.txt"));
    List<Booking> bookings = BookingService.getAllBookings(new File(databaseDir, "bookings.txt"));
    List<Payment> payments = PaymentService.getAllPayments(new File(databaseDir, "payments.txt"));
    List<Review> reviews = ReviewService.getAllReviews(new File(databaseDir, "reviews.txt"));
    double revenue = 0;
    int activeBookings = 0;
    for (Booking booking : bookings) {
        if (isActiveBooking(booking)) {
            activeBookings++;
        }
    }
    for (Payment payment : payments) {
        Booking paidBooking = findBooking(bookings, payment.getBookingId());
        if ("success".equalsIgnoreCase(payment.getStatus()) && isActiveBooking(paidBooking)) {
            revenue += payment.getAmount();
        }
    }
%>
<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="admin.jsp">
            <span class="brand-mark">VR</span>
            <span>Admin Panel</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <div class="navbar-nav ms-auto align-items-lg-center">
                <a class="nav-link" href="vehicles.jsp">Vehicles</a>
                <a class="nav-link" href="myBookings.jsp">Bookings</a>
                <a class="nav-link" href="reviews.jsp">Reviews</a>
                <span class="nav-link d-flex align-items-center gap-2">
                    <span class="user-icon"><%= firstLetter(loggedInUser.getUsername()) %></span>
                    <%= loggedInUser.getUsername() %>
                </span>
                <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </div>
</nav>

<main class="container py-4">
    <div class="mb-4">
        <h1 class="page-title">Dashboard</h1>
        <p class="page-subtitle">Manage vehicle data, payments, bookings, users, and reviews.</p>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3"><div class="stat-card"><div class="stat-label">Users</div><p class="stat-value"><%= users.size() %></p></div></div>
        <div class="col-6 col-lg-3"><div class="stat-card"><div class="stat-label">Vehicles</div><p class="stat-value"><%= vehicles.size() %></p></div></div>
        <div class="col-6 col-lg-3"><div class="stat-card"><div class="stat-label">Active Bookings</div><p class="stat-value"><%= activeBookings %></p></div></div>
        <div class="col-6 col-lg-3"><div class="stat-card"><div class="stat-label">Revenue</div><p class="stat-value">Rs. <%= revenue %></p></div></div>
    </div>

    <section class="surface p-3 p-md-4 mb-4">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-2 mb-3">
            <div>
                <h3 class="h5 mb-1">Booked Vehicle Details</h3>
                <p class="muted-text mb-0">Quick view of vehicles currently booked or paid, including customer and rental dates.</p>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-darkish table-bordered align-middle">
                <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Vehicle</th>
                    <th>Customer</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Payment</th>
                </tr>
                </thead>
                <tbody>
                <% for (Booking booking : bookings) {
                    if (!isActiveBooking(booking)) {
                        continue;
                    }
                    Vehicle bookedVehicle = findVehicle(vehicles, booking.getVehicleId());
                    User bookingUser = findUser(users, booking.getUserId());
                    String vehicleName = bookedVehicle == null ? booking.getVehicleId() : bookedVehicle.getName() + " (" + bookedVehicle.getVehicleId() + ")";
                    String customerName = bookingUser == null ? booking.getUserId() : bookingUser.getFullName() + " (" + bookingUser.getUsername() + ")";
                    String paymentText = "Pending";
                    for (Payment payment : payments) {
                        if (payment.getBookingId().equals(booking.getBookingId()) && "success".equalsIgnoreCase(payment.getStatus())) {
                            paymentText = payment.getMethod() + " - Rs. " + payment.getAmount();
                            break;
                        }
                    }
                %>
                    <tr>
                        <td><%= booking.getBookingId() %></td>
                        <td><%= vehicleName %></td>
                        <td>
                            <span class="user-icon me-2"><%= firstLetter(customerName) %></span>
                            <%= customerName %>
                        </td>
                        <td><%= booking.getStartDate() %></td>
                        <td><%= booking.getEndDate() %></td>
                        <td>Rs. <%= booking.getTotalCost() %></td>
                        <td><span class="badge badge-soft"><%= booking.getStatus() %></span></td>
                        <td><%= paymentText %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="surface p-3 p-md-4 mb-4">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-2 mb-3">
            <div>
                <h3 class="h5 mb-1">Upload New Vehicle Data</h3>
                <p class="muted-text mb-0">Add vehicles to vehicles.txt with simple OOP file handling.</p>
            </div>
        </div>
        <form action="<%= request.getContextPath() %>/addVehicle" method="post" class="row g-2 mb-4">
            <div class="col-md-2"><input class="form-control" name="name" placeholder="Vehicle name" required></div>
            <div class="col-md-2"><input class="form-control" name="type" placeholder="Type" required></div>
            <div class="col-md-2"><input class="form-control" name="brand" placeholder="Brand" required></div>
            <div class="col-md-2"><input class="form-control" name="dailyRate" type="number" step="0.01" placeholder="Daily rate" required></div>
            <div class="col-md-2"><input class="form-control" name="addedDate" type="date" value="<%= LocalDate.now() %>" required></div>
            <div class="col-md-1">
                <select class="form-select" name="availability">
                    <option value="available">available</option>
                    <option value="booked">booked</option>
                </select>
            </div>
            <div class="col-md-1"><button class="btn btn-primary w-100" type="submit">Add</button></div>
        </form>

        <div class="table-responsive">
            <table class="table table-darkish table-bordered align-middle">
                <thead><tr><th>ID</th><th>Name</th><th>Type</th><th>Brand</th><th>Rate</th><th>Added</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                <% for (Vehicle vehicle : vehicles) { %>
                    <tr>
                        <form action="<%= request.getContextPath() %>/updateVehicle" method="post">
                            <td><%= vehicle.getVehicleId() %><input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>"></td>
                            <td><input class="form-control" name="name" value="<%= vehicle.getName() %>"></td>
                            <td><input class="form-control" name="type" value="<%= vehicle.getType() %>"></td>
                            <td><input class="form-control" name="brand" value="<%= vehicle.getBrand() %>"></td>
                            <td><input class="form-control" name="dailyRate" type="number" step="0.01" value="<%= vehicle.getDailyRate() %>"></td>
                            <td><input class="form-control" name="addedDate" type="date" value="<%= vehicle.getAddedDate() == null || vehicle.getAddedDate().isEmpty() ? LocalDate.now().toString() : vehicle.getAddedDate() %>"></td>
                            <td>
                                <select class="form-select" name="availability">
                                    <option value="available" <%= vehicle.isAvailable() ? "selected" : "" %>>available</option>
                                    <option value="booked" <%= !vehicle.isAvailable() ? "selected" : "" %>>booked</option>
                                </select>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-primary" type="submit">Update</button>
                        </form>
                                    <form action="<%= request.getContextPath() %>/deleteVehicle" method="post">
                                        <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>">
                                        <button class="btn btn-sm btn-danger" type="submit">Delete</button>
                                    </form>
                                </div>
                            </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="surface p-3 p-md-4 mb-4">
        <h3 class="h5 mb-3">Payment Details</h3>
        <div class="table-responsive">
            <table class="table table-darkish table-bordered align-middle">
                <thead><tr><th>Payment ID</th><th>User</th><th>Booking</th><th>Amount</th><th>Date</th><th>Method</th><th>Status</th><th>Action</th></tr></thead>
                <tbody>
                <% for (Payment payment : payments) {
                    User paidUser = findUser(users, payment.getUserId());
                    String displayName = paidUser == null ? payment.getUserId() : paidUser.getFullName() + " (" + paidUser.getUsername() + ")";
                %>
                    <tr>
                        <td><%= payment.getPaymentId() %></td>
                        <td>
                            <span class="user-icon me-2"><%= firstLetter(displayName) %></span>
                            <%= displayName %>
                        </td>
                        <td><%= payment.getBookingId() %></td>
                        <td><strong>Rs. <%= payment.getAmount() %></strong></td>
                        <td><%= payment.getPaymentDate() %></td>
                        <td><span class="badge badge-soft"><%= payment.getMethod() %></span></td>
                        <td><%= payment.getStatus() %></td>
                        <td>
                            <form action="<%= request.getContextPath() %>/deletePayment" method="post">
                                <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                                <button class="btn btn-sm btn-danger" type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="surface p-3 p-md-4 mb-4">
        <h3 class="h5 mb-3">Users</h3>
        <div class="table-responsive">
            <table class="table table-darkish table-bordered align-middle">
                <thead><tr><th>User</th><th>Full Name</th><th>Email</th><th>Role</th><th>Action</th></tr></thead>
                <tbody>
                <% for (User user : users) { %>
                    <tr>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <span class="user-icon"><%= firstLetter(user.getUsername()) %></span>
                                <div>
                                    <div><%= user.getUsername() %></div>
                                    <small class="muted-text"><%= user.getUserId() %></small>
                                </div>
                            </div>
                        </td>
                        <td><%= user.getFullName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td>
                            <form action="<%= request.getContextPath() %>/updateUserRole" method="post" class="d-flex gap-2">
                                <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                <select class="form-select form-select-sm" name="role" <%= loggedInUser.getUserId().equals(user.getUserId()) ? "disabled" : "" %>>
                                    <option value="user" <%= "user".equals(user.getRole()) ? "selected" : "" %>>user</option>
                                    <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>admin</option>
                                </select>
                                <% if (!loggedInUser.getUserId().equals(user.getUserId())) { %>
                                    <button class="btn btn-sm btn-outline-light" type="submit">Save</button>
                                <% } %>
                            </form>
                        </td>
                        <td>
                            <% if (!loggedInUser.getUserId().equals(user.getUserId())) { %>
                                <form action="<%= request.getContextPath() %>/deleteUser" method="post">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                    <button class="btn btn-sm btn-danger" type="submit">Delete</button>
                                </form>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="surface p-3 p-md-4 mb-4">
        <h3 class="h5 mb-3">All Bookings</h3>
        <div class="table-responsive">
            <table class="table table-darkish table-bordered align-middle">
                <thead><tr><th>ID</th><th>User</th><th>Vehicle</th><th>Dates</th><th>Total</th><th>Status</th><th>Cancel Reason</th><th>Action</th></tr></thead>
                <tbody>
                <% for (Booking booking : bookings) {
                    User bookingUser = findUser(users, booking.getUserId());
                %>
                    <tr>
                        <td><%= booking.getBookingId() %></td>
                        <td><%= bookingUser == null ? booking.getUserId() : bookingUser.getUsername() %></td>
                        <td><%= booking.getVehicleId() %></td>
                        <td><%= booking.getStartDate() %> to <%= booking.getEndDate() %></td>
                        <td>Rs. <%= booking.getTotalCost() %></td>
                        <td><%= booking.getStatus() %></td>
                        <td><%= booking.getCancelReason() == null || booking.getCancelReason().isEmpty() ? "-" : booking.getCancelReason() %></td>
                        <td>
                            <form action="<%= request.getContextPath() %>/deleteBooking" method="post">
                                <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                <button class="btn btn-sm btn-danger" type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="surface p-3 p-md-4">
        <h3 class="h5 mb-3">Reviews</h3>
        <div class="table-responsive">
            <table class="table table-darkish table-bordered align-middle">
                <thead><tr><th>ID</th><th>User</th><th>Vehicle</th><th>Rating</th><th>Comment</th><th>Date</th><th>Action</th></tr></thead>
                <tbody>
                <% for (Review review : reviews) { %>
                    <tr>
                        <td><%= review.getReviewId() %></td>
                        <td><%= review.getUserId() %></td>
                        <td><%= review.getVehicleId() %></td>
                        <td><%= review.getRating() %>/5</td>
                        <td><%= review.getComment() %></td>
                        <td><%= review.getDate() %></td>
                        <td>
                            <form action="<%= request.getContextPath() %>/deleteReview" method="post">
                                <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                                <button class="btn btn-sm btn-danger" type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
