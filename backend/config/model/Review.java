package com.vehiclerental.model;

public class Review {
    private String reviewId;
    private String userId;
    private String vehicleId;
    private int rating;
    private String comment;
    private String date;

    public Review(String reviewId, String userId, String vehicleId, int rating, String comment, String date) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.vehicleId = vehicleId;
        this.rating = rating;
        this.comment = comment;
        this.date = date;
    }

    public String toFileString() {
        return reviewId + "," + userId + "," + vehicleId + "," + rating + "," +
                comment.replace(",", " ") + "," + date;
    }

    public static Review fromFileString(String line) {
        String[] parts = line.split(",", -1);
        if (parts.length < 6) {
            return null;
        }
        return new Review(parts[0], parts[1], parts[2], Integer.parseInt(parts[3]), parts[4], parts[5]);
    }

    public String getReviewId() { return reviewId; }
    public String getUserId() { return userId; }
    public String getVehicleId() { return vehicleId; }
    public int getRating() { return rating; }
    public String getComment() { return comment; }
    public String getDate() { return date; }

    public void setReviewId(String reviewId) { this.reviewId = reviewId; }
    public void setUserId(String userId) { this.userId = userId; }
    public void setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }
    public void setRating(int rating) { this.rating = rating; }
    public void setComment(String comment) { this.comment = comment; }
    public void setDate(String date) { this.date = date; }
}
