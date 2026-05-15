package com.vehiclerental.service;

import com.vehiclerental.model.Booking;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class BookingService {
    public static List<Booking> getAllBookings(File file) throws IOException {
        List<Booking> bookings = new ArrayList<>();
        if (!file.exists()) {
            return bookings;
        }
        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (!line.trim().isEmpty()) {
                Booking booking = Booking.fromFileString(line);
                if (booking != null) {
                    bookings.add(booking);
                }
            }
        }
        reader.close();
        return bookings;
    }

    public static void saveAllBookings(List<Booking> bookings, File file) throws IOException {
        File parent = file.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }
        BufferedWriter writer = new BufferedWriter(new FileWriter(file, false));
        for (Booking booking : bookings) {
            writer.write(booking.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    public static void addBooking(Booking booking, File file) throws IOException {
        File parent = file.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }
        BufferedWriter writer = new BufferedWriter(new FileWriter(file, true));
        writer.write(booking.toFileString());
        writer.newLine();
        writer.close();
    }

    public static void updateStatus(String bookingId, String status, File file) throws IOException {
        updateStatus(bookingId, status, "", file);
    }

    public static void updateStatus(String bookingId, String status, String cancelReason, File file) throws IOException {
        List<Booking> bookings = getAllBookings(file);
        for (Booking booking : bookings) {
            if (booking.getBookingId().equals(bookingId)) {
                booking.setStatus(status);
                booking.setCancelReason(cancelReason == null ? "" : cancelReason);
                break;
            }
        }
        saveAllBookings(bookings, file);
    }

    public static void deleteBooking(String bookingId, File file) throws IOException {
        List<Booking> bookings = getAllBookings(file);
        bookings.removeIf(booking -> booking.getBookingId().equals(bookingId));
        saveAllBookings(bookings, file);
    }
}
