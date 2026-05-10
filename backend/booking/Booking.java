package booking;

public class Booking {
    private String bookingId;
    private String userId;

    public Booking(String bookingId, String userId) {
        this.bookingId = bookingId;
        this.userId = userId;
    }

    public String getBookingId() {
        return bookingId;
    }

    public String getUserId() {
        return userId;
    }

    @Override
    public String toString() {
        return "Booking ID: " + bookingId + ", User ID: " + userId;
    }
}