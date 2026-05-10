<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Vehicle Rental</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; margin: 0; }
        .box { max-width: 460px; margin: 50px auto; background: #fff; padding: 24px; border: 1px solid #ddd; }
        h2 { margin-top: 0; }
        label { display: block; margin-top: 12px; }
        input { width: 100%; padding: 9px; margin-top: 5px; box-sizing: border-box; }
        button { margin-top: 16px; padding: 10px 16px; background: #2457a6; color: #fff; border: 0; cursor: pointer; }
        .error { background: #ffe1e1; padding: 10px; margin-bottom: 12px; }
        a { color: #2457a6; }
    </style>
</head>
<body>
<div class="box">
    <h2>Create Account</h2>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/register" method="post">
        <label>Full Name</label>
        <input type="text" name="fullName" required>

        <label>Email</label>
        <input type="email" name="email" required>

        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit">Register</button>
    </form>

    <p>Already registered? <a href="login.jsp">Login here</a></p>
</div>
</body>
</html>
