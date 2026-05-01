package com.vehiclerental.model;

public class Payment {
    private String paymentId;
    private String bookingId;
    private String userId;
    private double amount;
    private String paymentDate;
    private String method;
    private String status;

    public Payment() {}

    public Payment(String paymentId, String bookingId, String userId,
                   double amount, String paymentDate, String method, String status) {
        this.paymentId = paymentId;
        this.bookingId = bookingId;
        this.userId = userId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.method = method;
        this.status = status;
    }

    public String toFileString() {
        return paymentId + "," + bookingId + "," + userId + "," +
               amount + "," + paymentDate + "," + method + "," + status;
    }

    public static Payment fromFileString(String line) {
        String[] parts = line.split(",");
        if (parts.length < 7) return null;

        return new Payment(
                parts[0],
                parts[1],
                parts[2],
                Double.parseDouble(parts[3]),
                parts[4],
                parts[5],
                parts[6]
        );
    }

    // Getters
    public String getPaymentId() { return paymentId; }
    public String getBookingId() { return bookingId; }
    public String getUserId() { return userId; }
    public double getAmount() { return amount; }
    public String getPaymentDate() { return paymentDate; }
    public String getMethod() { return method; }
    public String getStatus() { return status; }

    // Setters
    public void setPaymentId(String paymentId) { this.paymentId = paymentId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }
    public void setUserId(String userId) { this.userId = userId; }
    public void setAmount(double amount) { this.amount = amount; }
    public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }
    public void setMethod(String method) { this.method = method; }
    public void setStatus(String status) { this.status = status; }
}
