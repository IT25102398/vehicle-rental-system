package com.vehiclerental.service;

import com.vehiclerental.model.Review;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewService {
    public static List<Review> getAllReviews(File file) throws IOException {
        List<Review> reviews = new ArrayList<>();
        if (!file.exists()) {
            return reviews;
        }
        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (!line.trim().isEmpty()) {
                Review review = Review.fromFileString(line);
                if (review != null) {
                    reviews.add(review);
                }
            }
        }
        reader.close();
        return reviews;
    }

    public static void saveAllReviews(List<Review> reviews, File file) throws IOException {
        File parent = file.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }
        BufferedWriter writer = new BufferedWriter(new FileWriter(file, false));
        for (Review review : reviews) {
            writer.write(review.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    public static String generateReviewId(List<Review> reviews) {
        int max = 0;
        for (Review review : reviews) {
            try {
                max = Math.max(max, Integer.parseInt(review.getReviewId().replace("R", "")));
            } catch (Exception ignored) {}
        }
        return String.format("R%03d", max + 1);
    }
}
