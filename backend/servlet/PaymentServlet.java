package com.vehiclerental.servlet;

import com.vehiclerental.model.Payment;
import com.vehiclerental.service.PaymentService;
import com.vehiclerental.service.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;

public class PaymentServlet extends HttpServlet {

    private File getDatabaseFile(String fileName) {
        String appRoot = getServletContext().getRealPath("/");
        if (appRoot == null) {
            return new File("database", fileName);
        }

        File frontendDir = new File(appRoot);
        File projectDir = frontendDir.getParentFile();
        return new File(new File(projectDir, "database"), fileName);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/deletePayment".equals(request.getServletPath())) {
            HttpSession session = request.getSession(false);
            User loggedInUser = session == null ? null : (User) session.getAttribute("loggedInUser");
            if (loggedInUser == null || !"admin".equals(loggedInUser.getRole())) {
                response.sendRedirect("login.jsp");
                return;
            }
            PaymentService.deletePayment(request.getParameter("paymentId"), getDatabaseFile("payments.txt"));
            response.sendRedirect("admin.jsp");
            return;
        }

        String bookingId = request.getParameter("bookingId");
        String userId = request.getParameter("userId");
        String amountText = request.getParameter("amount");
        String method = request.getParameter("method");
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");

        if (bookingId == null || bookingId.isEmpty() ||
                userId == null || userId.isEmpty() ||
                amountText == null || amountText.isEmpty()) {
            request.setAttribute("error", "Please fill in all payment details");
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
            return;
        }

        if ("card".equals(method)) {
            String digitsOnly = cardNumber == null ? "" : cardNumber.replaceAll("\\s", "");
            if (!digitsOnly.matches("\\d{16}") ||
                    expiry == null || !expiry.matches("(0[1-9]|1[0-2])/\\d{2}") ||
                    cvv == null || !cvv.matches("\\d{3}")) {
                request.setAttribute("error", "Please enter valid card details.");
                request.getRequestDispatcher("/payment.jsp").forward(request, response);
                return;
            }
        }

        double amount = Double.parseDouble(amountText);

        String paymentId = "P" + System.currentTimeMillis();
        String date = LocalDate.now().toString();
        if (method == null || method.isEmpty()) {
            method = "card";
        }
        String status = "success";

        Payment payment = new Payment(
                paymentId,
                bookingId,
                userId,
                amount,
                date,
                method,
                status
        );

        PaymentService.savePayment(payment, getDatabaseFile("payments.txt"));
        PaymentService.updateBookingStatus(bookingId, getDatabaseFile("bookings.txt"));

        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/paymentConfirmation.jsp").forward(request, response);
    }
}
