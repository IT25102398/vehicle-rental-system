package com.vehiclerental.servlet;

import com.vehiclerental.service.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class UserServlet extends HttpServlet {

    private File getDatabaseFile(String fileName) {
        String appRoot = getServletContext().getRealPath("/");
        if (appRoot == null) {
            return new File("database", fileName);
        }

        File frontendDir = new File(appRoot);
        File projectDir = frontendDir.getParentFile();
        return new File(new File(projectDir, "database"), fileName);
    }

    //READ all users from users.txt
    private List<User> getAllUsers() throws IOException {
        List<User> users = new ArrayList<>();
        File file = getDatabaseFile("users.txt");
        if (!file.exists()) return users;

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (!line.trim().isEmpty()) {
                users.add(User.fromFileString(line));
            }
        }
        reader.close();
        return users;
    }

    //WRITE all users back to users.txt
    private void saveAllUsers(List<User> users) throws IOException {
        File file = getDatabaseFile("users.txt");
        File parent = file.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }

        BufferedWriter writer = new BufferedWriter(new FileWriter(file, false));
        for (User u : users) {
            writer.write(u.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    //GENERATE next user ID
    private String generateUserId(List<User> users) {
        int max = 0;
        for (User u : users) {
            String id = u.getUserId().replace("U", "");
            try { max = Math.max(max, Integer.parseInt(id)); } catch (Exception e) {}
        }
        return String.format("U%03d", max + 1);
    }

    // Create
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Check empty fields
        if (fullName == null || fullName.isEmpty() ||
                email == null || email.isEmpty() ||
                username == null || username.isEmpty() ||
                password == null || password.isEmpty()) {
            request.setAttribute("error", "Please fill in all fields");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        List<User> users = getAllUsers();

        // Check username taken
        for (User u : users) {
            if (u.getUsername().equals(username)) {
                request.setAttribute("error", "Username already taken");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
        }

        // Create and save new user
        String userId = generateUserId(users);
        User newUser = new User(userId, username, password, fullName, email, "user");
        users.add(newUser);
        saveAllUsers(users);

        response.sendRedirect("login.jsp");
    }

    //LOGIN
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        List<User> users = getAllUsers();

        for (User u : users) {
            if (u.getUsername().equals(username) && u.validateLogin(password)) {
                // Set session
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", u);

                // Redirect based on role
                if (u.getRole().equals("admin")) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("vehicles.jsp");
                }
                return;
            }
        }

        // No match found
        request.setAttribute("error", "Invalid username or password");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    //UPDATE
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String newFullName = request.getParameter("fullName");
        String newEmail    = request.getParameter("email");
        String newPassword = request.getParameter("password");

        List<User> users = getAllUsers();
        for (User u : users) {
            if (u.getUserId().equals(loggedInUser.getUserId())) {
                u.setFullName(newFullName);
                u.setEmail(newEmail);
                if (newPassword != null && !newPassword.isEmpty()) {
                    u.setPassword(newPassword);
                }
                session.setAttribute("loggedInUser", u);
                break;
            }
        }
        saveAllUsers(users);
        response.sendRedirect("profile.jsp");
    }

    //DELETE
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String userId = request.getParameter("userId");
        List<User> users = getAllUsers();
        users.removeIf(u -> u.getUserId().equals(userId));
        saveAllUsers(users);
        response.sendRedirect("admin.jsp");
    }

    //Route POST requests
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/register":     handleRegister(request, response); break;
            case "/login":        handleLogin(request, response);    break;
            case "/updateProfile": handleUpdate(request, response);  break;
            case "/deleteUser":   handleDelete(request, response);   break;
            default: response.sendRedirect("login.jsp");
        }
    }

    //Route GET requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/logout".equals(request.getServletPath())) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
            return;
        }

        response.sendRedirect("login.jsp");
    }
}
