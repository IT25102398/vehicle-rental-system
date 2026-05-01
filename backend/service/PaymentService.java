package com.vehiclerental.service;

import com.vehiclerental.model.Payment;
import java.io.*;

public class PaymentService {

    private static final String PAYMENT_FILE = "database/payments.txt";
    private static final String BOOKING_FILE = "database/bookings.txt";

    // Save payment
    public static void savePayment(Payment payment) throws IOException {
        BufferedWriter writer = new BufferedWriter(new FileWriter(PAYMENT_FILE, true));
        writer.write(payment.toFileString());
        writer.newLine();
        writer.close();
    }

    // Update booking status to Paid
    public static void updateBookingStatus(String bookingId) throws IOException {

        File inputFile = new File(BOOKING_FILE);
        File tempFile = new File("database/temp.txt");

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
