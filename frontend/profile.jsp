<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Vehicle Rental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/app.css" rel="stylesheet">
</head>
<body class="app-dark">
<div class="app-shell">
<%
    com.vehiclerental.service.User loggedInUser =
        (com.vehiclerental.service.User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="vehicles.jsp"><span class="brand-mark">VR</span><span>Vehicle Rental</span></a>
        <div class="navbar-nav ms-auto align-items-lg-center">
            <a class="nav-link" href="vehicles.jsp">Vehicles</a>
            <a class="nav-link" href="myBookings.jsp">My Bookings</a>
            <span class="nav-link d-flex align-items-center gap-2"><span class="user-icon"><%= loggedInUser.getUsername().substring(0, 1).toUpperCase() %></span><%= loggedInUser.getUsername() %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-light btn-sm">Logout</a>
        </div>
    </div>
</nav>

<main class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="surface p-4">
                <div class="d-flex align-items-center gap-3 mb-4">
                    <span class="user-icon" style="width:56px;height:56px;"><%= loggedInUser.getUsername().substring(0, 1).toUpperCase() %></span>
                    <div>
                        <h1 class="h3 mb-0">My Profile</h1>
                        <p class="page-subtitle mb-0">Update your name, email, or password.</p>
                    </div>
                </div>

                <form action="<%= request.getContextPath() %>/updateProfile" method="post">
                    <div class="mb-3">
                        <label class="form-label">User ID</label>
                        <input type="text" class="form-control" value="<%= loggedInUser.getUserId() %>" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control" value="<%= loggedInUser.getUsername() %>" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="fullName" class="form-control" value="<%= loggedInUser.getFullName() %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" value="<%= loggedInUser.getEmail() %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">New Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current password">
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Save Changes</button>
                </form>
            </div>
        </div>
    </div>
</main>
</div>
</body>
</html>
