package com.vehiclerental.servlet;

import com.vehiclerental.service.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class BookingServlet extends HttpServlet {

    private File getDatabaseFile(String fileName) {
        String appRoot = getServletContext().getRealPath("/");
        if (appRoot == null) {
            return new File("database", fileName);
        }

        File frontendDir = new File(appRoot);
        File projectDir = frontendDir.getParentFile();
        return new File(new File(projectDir, "database"), fileName);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String bookingId = request.getParameter("bookingId");
        String vehicleId = request.getParameter("vehicleId");
        String vehicleName = request.getParameter("vehicleName");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String amount = request.getParameter("amount");

        if (bookingId == null || bookingId.isEmpty()) {
            bookingId = "B" + System.currentTimeMillis();
        }

        File bookingFile = getDatabaseFile("bookings.txt");
        File parent = bookingFile.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }

        BufferedWriter writer = new BufferedWriter(new FileWriter(bookingFile, true));
        writer.write(bookingId + "," + loggedInUser.getUserId() + "," + vehicleId + "," +
                startDate + "," + endDate + "," + amount + ",confirmed");
        writer.newLine();
        writer.close();

        request.setAttribute("bookingId", bookingId);
        request.setAttribute("vehicleName", vehicleName);
        request.setAttribute("amount", amount);
        request.getRequestDispatcher("/payment.jsp").forward(request, response);
    }
}
