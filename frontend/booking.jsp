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
    <title>Booking - Vehicle Rental</title>
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

    String vehicleId = request.getParameter("vehicleId");
    if (vehicleId == null) vehicleId = (String) request.getAttribute("vehicleId");
    String appRoot = application.getRealPath("/");
    File databaseDir = appRoot == null ? new File("database") : new File(new File(appRoot).getParentFile(), "database");
    List<Vehicle> vehicles = VehicleService.getAllVehicles(new File(databaseDir, "vehicles.txt"));
    Vehicle vehicle = VehicleService.findById(vehicles, vehicleId);
    if (vehicle == null || !vehicle.isAvailable()) {
        response.sendRedirect("vehicles.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="vehicles.jsp"><span class="brand-mark">VR</span><span>Vehicle Rental</span></a>
        <a href="vehicles.jsp" class="btn btn-outline-light btn-sm">Back to Vehicles</a>
    </div>
</nav>

<main class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="surface">
                <div class="p-4 border-bottom border-secondary">
                    <h4 class="mb-0">Booking Details</h4>
                </div>
                <div class="p-4">
                    <h5><%= vehicle.getName() %></h5>
                    <p class="text-muted"><%= vehicle.getBrand() %> <%= vehicle.getType() %> | Rs. <span id="dailyRate"><%= vehicle.getDailyRate() %></span> per day</p>
                    <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/createBooking" method="post">
                        <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>">
                        <input type="hidden" name="vehicleName" value="<%= vehicle.getName() %>">
                        <input type="hidden" name="dailyRate" value="<%= vehicle.getDailyRate() %>">

                        <div class="mb-3">
                            <label class="form-label">Start Date</label>
                            <input type="date" id="startDate" name="startDate" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">End Date</label>
                            <input type="date" id="endDate" name="endDate" class="form-control" required>
                        </div>

                        <div class="alert alert-info">
                            Total Amount: Rs. <span id="totalAmount"><%= vehicle.getDailyRate() %></span>
                        </div>

                        <button type="submit" class="btn btn-primary">Continue to Payment</button>
                        <a href="vehicles.jsp" class="btn btn-outline-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>
</div>

<script>
    const startDate = document.getElementById("startDate");
    const endDate = document.getElementById("endDate");
    const totalAmount = document.getElementById("totalAmount");
    const dailyRate = Number(document.getElementById("dailyRate").textContent);
    const today = new Date().toISOString().split("T")[0];

    startDate.min = today;
    endDate.min = today;

    function updateTotal() {
        if (startDate.value) {
            endDate.min = startDate.value;
        }
        if (!startDate.value || !endDate.value) {
            totalAmount.textContent = dailyRate.toFixed(2);
            return;
        }
        const start = new Date(startDate.value);
        let end = new Date(endDate.value);
        if (end < start) {
            endDate.value = startDate.value;
            end = new Date(endDate.value);
        }
        const diff = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
        const days = diff < 1 ? 1 : diff;
        totalAmount.textContent = (days * dailyRate).toFixed(2);
    }

    startDate.addEventListener("change", updateTotal);
    endDate.addEventListener("change", updateTotal);
</script>
</body>
</html>
