package com.vehiclerental.servlet;

import com.vehiclerental.model.Payment;
import com.vehiclerental.service.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
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

        String bookingId = request.getParameter("bookingId");
        String userId = request.getParameter("userId");
        String amountText = request.getParameter("amount");
        String method = request.getParameter("method");

        if (bookingId == null || bookingId.isEmpty() ||
                userId == null || userId.isEmpty() ||
                amountText == null || amountText.isEmpty()) {
            request.setAttribute("error", "Please fill in all payment details");
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
            return;
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
