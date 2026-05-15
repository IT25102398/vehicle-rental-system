package com.vehiclerental.servlet;

import com.vehiclerental.model.Booking;
import com.vehiclerental.service.BookingService;
import com.vehiclerental.service.User;
import com.vehiclerental.service.VehicleService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

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

    private User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("loggedInUser");
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedInUser = getLoggedInUser(request);
        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String bookingId = "B" + System.currentTimeMillis();
        String vehicleId = request.getParameter("vehicleId");
        String vehicleName = request.getParameter("vehicleName");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        double dailyRate = Double.parseDouble(request.getParameter("dailyRate"));

        try {
            if (startDate == null || startDate.isEmpty() || endDate == null || endDate.isEmpty()) {
                request.setAttribute("error", "Please select valid booking dates.");
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
                return;
            }

            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);
            LocalDate today = LocalDate.now();

            if (start.isBefore(today)) {
                request.setAttribute("error", "Start date cannot be in the past.");
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
                return;
            }

            if (end.isBefore(start)) {
                request.setAttribute("error", "End date cannot be before the start date.");
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
                return;
            }
        } catch (DateTimeParseException e) {
            request.setAttribute("error", "Please select valid booking dates.");
            request.getRequestDispatcher("/booking.jsp").forward(request, response);
            return;
        }

        double totalCost = Booking.calculateCost(startDate, endDate, dailyRate);

        Booking booking = new Booking(bookingId, loggedInUser.getUserId(), vehicleId,
                startDate, endDate, totalCost, "confirmed");
        BookingService.addBooking(booking, getDatabaseFile("bookings.txt"));
        VehicleService.updateAvailability(vehicleId, "booked", getDatabaseFile("vehicles.txt"));

        request.setAttribute("bookingId", bookingId);
        request.setAttribute("vehicleName", vehicleName);
        request.setAttribute("amount", String.valueOf(totalCost));
        request.getRequestDispatcher("/payment.jsp").forward(request, response);
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User loggedInUser = getLoggedInUser(request);
        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String bookingId = request.getParameter("bookingId");
        String vehicleId = request.getParameter("vehicleId");
        String cancelReason = request.getParameter("cancelReason");
        if (cancelReason == null || cancelReason.trim().isEmpty()) {
            response.sendRedirect("myBookings.jsp?cancelError=reason");
            return;
        }

        BookingService.updateStatus(bookingId, "Cancelled", cancelReason.trim(), getDatabaseFile("bookings.txt"));
        if (vehicleId != null && !vehicleId.isEmpty()) {
            VehicleService.updateAvailability(vehicleId, "available", getDatabaseFile("vehicles.txt"));
        }
        response.sendRedirect("myBookings.jsp");
    }

    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User loggedInUser = getLoggedInUser(request);
        if (loggedInUser == null || !"admin".equals(loggedInUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        BookingService.deleteBooking(request.getParameter("bookingId"), getDatabaseFile("bookings.txt"));
        response.sendRedirect("admin.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/createBooking".equals(path)) {
            createBooking(request, response);
        } else if ("/cancelBooking".equals(path)) {
            cancelBooking(request, response);
        } else if ("/deleteBooking".equals(path)) {
            deleteBooking(request, response);
        } else {
            response.sendRedirect("vehicles.jsp");
        }
    }
}
