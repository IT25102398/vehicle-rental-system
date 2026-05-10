<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.vehiclerental.service.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Vehicle Rental</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f8; }
        nav { background: #2457a6; color: #fff; padding: 14px 24px; }
        nav a { color: #fff; margin-left: 14px; }
        .wrap { max-width: 900px; margin: 24px auto; background: #fff; padding: 20px; border: 1px solid #ddd; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #eef2f7; }
        button { padding: 7px 10px; background: #b42318; color: #fff; border: 0; cursor: pointer; }
    </style>
</head>
<body>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"admin".equals(loggedInUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<User> users = new ArrayList<>();
    File file = new File("database/users.txt");
    if (file.exists()) {
        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (!line.trim().isEmpty()) {
                users.add(User.fromFileString(line));
            }
        }
        reader.close();
    }
%>
<nav>
    Vehicle Rental Admin
    <a href="vehicles.jsp">Vehicles</a>
    <a href="profile.jsp">Profile</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</nav>
<div class="wrap">
    <h2>User Management</h2>
    <table>
        <tr>
            <th>User ID</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Action</th>
        </tr>
        <% for (User user : users) { %>
            <tr>
                <td><%= user.getUserId() %></td>
                <td><%= user.getUsername() %></td>
                <td><%= user.getFullName() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getRole() %></td>
                <td>
                    <% if (!loggedInUser.getUserId().equals(user.getUserId())) { %>
                        <form action="<%= request.getContextPath() %>/deleteUser" method="post">
                            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                            <button type="submit">Delete</button>
                        </form>
                    <% } %>
                </td>
            </tr>
        <% } %>
    </table>
</div>
</body>
</html>
