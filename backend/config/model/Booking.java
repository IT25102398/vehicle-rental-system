package com.vehiclerental.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Booking {
    private String bookingId;
    private String userId;
    private String vehicleId;
    private String startDate;
    private String endDate;
    private double totalCost;
    private String status;
    private String cancelReason;

    public Booking(String bookingId, String userId, String vehicleId, String startDate,
                   String endDate, double totalCost, String status) {
        this(bookingId, userId, vehicleId, startDate, endDate, totalCost, status, "");
    }

    public Booking(String bookingId, String userId, String vehicleId, String startDate,
                   String endDate, double totalCost, String status, String cancelReason) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.vehicleId = vehicleId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalCost = totalCost;
        this.status = status;
        this.cancelReason = cancelReason;
    }

    public static double calculateCost(String startDate, String endDate, double dailyRate) {
        long days = ChronoUnit.DAYS.between(LocalDate.parse(startDate), LocalDate.parse(endDate));
        if (days < 1) {
            days = 1;
        }
        return days * dailyRate;
    }

    public String toFileString() {
        return bookingId + "," + userId + "," + vehicleId + "," + startDate + "," +
                endDate + "," + totalCost + "," + status + "," + cancelReason.replace(",", " ");
    }

    public static Booking fromFileString(String line) {
        String[] parts = line.split(",", -1);
        if (parts.length < 7) {
            return null;
        }
        String cancelReason = parts.length >= 8 ? parts[7] : "";
        return new Booking(parts[0], parts[1], parts[2], parts[3], parts[4],
                Double.parseDouble(parts[5]), parts[6], cancelReason);
    }

    public String getBookingId() { return bookingId; }
    public String getUserId() { return userId; }
    public String getVehicleId() { return vehicleId; }
    public String getStartDate() { return startDate; }
    public String getEndDate() { return endDate; }
    public double getTotalCost() { return totalCost; }
    public String getStatus() { return status; }
    public String getCancelReason() { return cancelReason; }

    public void setBookingId(String bookingId) { this.bookingId = bookingId; }
    public void setUserId(String userId) { this.userId = userId; }
    public void setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }
    public void setTotalCost(double totalCost) { this.totalCost = totalCost; }
    public void setStatus(String status) { this.status = status; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }
}
