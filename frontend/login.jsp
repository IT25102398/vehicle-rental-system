<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Vehicle Rental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/app.css" rel="stylesheet">
</head>
<body class="app-dark">
<div class="app-shell d-flex align-items-center">
    <main class="surface auth-card">
        <div class="d-flex align-items-center gap-2 mb-4">
            <span class="brand-mark">VR</span>
            <div>
                <h1 class="h4 mb-0">Welcome Back</h1>
                <p class="page-subtitle mb-0">Login to book and manage vehicles.</p>
            </div>
        </div>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input class="form-control" type="text" name="username" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input class="form-control" type="password" name="password" required>
            </div>
            <button class="btn btn-primary w-100" type="submit">Login</button>
        </form>

        <p class="mt-3 mb-0 muted-text">New user? <a href="register.jsp">Create an account</a></p>
    </main>
</div>
</body>
</html>
