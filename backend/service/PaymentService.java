package com.vehiclerental.service;

import com.vehiclerental.model.Payment;
import java.io.*;

public class PaymentService {

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
}
