package com.vehiclerental.service;

import com.vehiclerental.model.Booking;
import com.vehiclerental.model.Payment;
import java.util.List;

public class Admin extends User {
    public Admin(String userId, String username, String password, String fullName, String email) {
        super(userId, username, password, fullName, email, "admin");
    }

    public String generateSummary(List<User> users, List<Booking> bookings, List<Payment> payments) {
        double revenue = 0;
        for (Payment payment : payments) {
            if ("success".equalsIgnoreCase(payment.getStatus())) {
                revenue += payment.getAmount();
            }
        }
        return "Users: " + users.size() + ", Bookings: " + bookings.size() + ", Revenue: " + revenue;
    }
}
