<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Vehicle Rental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<%
    // Check if user is logged in
    com.vehiclerental.service.User loggedInUser =
        (com.vehiclerental.service.User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<nav class="navbar navbar-dark bg-primary">
    <div class="container">
        <span class="navbar-brand">Vehicle Rental</span>
        <div>
            <a href="vehicles.html" class="btn btn-outline-light btn-sm me-2">Browse Vehicles</a>
            <a href="/logout" class="btn btn-light btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">

            <div class="card shadow">
                <div class="card-header bg-primary text-white text-center">
                    <h4>My Profile</h4>
                </div>
                <div class="card-body">

                    <!-- Success message -->
                    <% String success = (String) request.getAttribute("success");
                       if (success != null) { %>
                        <div class="alert alert-success"><%= success %></div>
                    <% } %>

                    <form action="/updateProfile" method="post">

                        <div class="mb-3">
                            <label>User ID</label>
                            <input type="text" class="form-control"
                                value="<%= loggedInUser.getUserId() %>" disabled>
                        </div>

                        <div class="mb-3">
                            <label>Username</label>
                            <input type="text" class="form-control"
                                value="<%= loggedInUser.getUsername() %>" disabled>
                        </div>

                        <div class="mb-3">
                            <label>Full Name</label>
                            <input type="text" name="fullName" class="form-control"
                                value="<%= loggedInUser.getFullName() %>" required>
                        </div>

                        <div class="mb-3">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control"
                                value="<%= loggedInUser.getEmail() %>" required>
                        </div>

                        <div class="mb-3">
                            <label>New Password <small class="text-muted">(leave blank to keep current)</small></label>
                            <input type="password" name="password" class="form-control"
                                placeholder="Enter new password">
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>

                    </form>

                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>