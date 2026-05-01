package com.vehiclerental.servlet;

import com.vehiclerental.model.Payment;
import com.vehiclerental.service.PaymentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/processPayment")
public class PaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingId = request.getParameter("bookingId");
        String userId = request.getParameter("userId");
        double amount = Double.parseDouble(request.getParameter("amount"));

        String paymentId = "P" + System.currentTimeMillis();
        String date = LocalDate.now().toString();
        String method = "card";
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

        PaymentService.savePayment(payment);
        PaymentService.updateBookingStatus(bookingId);

        response.sendRedirect("paymentConfirmation.jsp");
    }
}
