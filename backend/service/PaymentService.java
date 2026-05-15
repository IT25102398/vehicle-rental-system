package com.vehiclerental.service;

import com.vehiclerental.model.Payment;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentService {
    public static List<Payment> getAllPayments(File paymentFile) throws IOException {
        List<Payment> payments = new ArrayList<>();
        if (!paymentFile.exists()) {
            return payments;
        }

        BufferedReader reader = new BufferedReader(new FileReader(paymentFile));
        String line;
        while ((line = reader.readLine()) != null) {
            if (!line.trim().isEmpty()) {
                Payment payment = Payment.fromFileString(line);
                if (payment != null) {
                    payments.add(payment);
                }
            }
        }
        reader.close();
        return payments;
    }

    public static void saveAllPayments(List<Payment> payments, File paymentFile) throws IOException {
        File parent = paymentFile.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }
        BufferedWriter writer = new BufferedWriter(new FileWriter(paymentFile, false));
        for (Payment payment : payments) {
            writer.write(payment.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    // Save payment
    public static void savePayment(Payment payment) throws IOException {
        savePayment(payment, new File("database/payments.txt"));
    }

    public static void savePayment(Payment payment, File paymentFile) throws IOException {
        File parent = paymentFile.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }

        BufferedWriter writer = new BufferedWriter(new FileWriter(paymentFile, true));
        writer.write(payment.toFileString());
        writer.newLine();
        writer.close();
    }

    // Update booking status to Paid
    public static void updateBookingStatus(String bookingId) throws IOException {
        updateBookingStatus(bookingId, new File("database/bookings.txt"));
    }

    public static void updateBookingStatus(String bookingId, File inputFile) throws IOException {
        File databaseDir = inputFile.getParentFile();
        if (databaseDir != null) {
            databaseDir.mkdirs();
        }
        File tempFile = new File(databaseDir, "temp.txt");

        BufferedReader reader = new BufferedReader(new FileReader(inputFile));
        BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile));

        String line;

        while ((line = reader.readLine()) != null) {
            String[] parts = line.split(",");

            if (parts.length >= 7 && parts[0].equals(bookingId)) {
                parts[6] = "Paid";
                line = String.join(",", parts);
            }

            writer.write(line);
            writer.newLine();
        }

        reader.close();
        writer.close();

        inputFile.delete();
        tempFile.renameTo(inputFile);
    }

    public static void deletePayment(String paymentId, File paymentFile) throws IOException {
        List<Payment> payments = getAllPayments(paymentFile);
        payments.removeIf(payment -> payment.getPaymentId().equals(paymentId));
        saveAllPayments(payments, paymentFile);
    }
}
