package admin;

import java.util.List;

import user.User;
import vehicle.Vehicle;
import booking.Booking;

public class Admin {

    private String adminId;
    private String name;

    public Admin(String adminId, String name) {
        this.adminId = adminId;
        this.name = name;
    }

    public void viewUsers(List<User> users) {
        System.out.println("---- USERS ----");
        for (User u : users) {
            System.out.println(u);
        }
    }

    public void deleteUser(List<User> users, String userId) {
        users.removeIf(u -> u.getUserId().equals(userId));
        System.out.println("User deleted successfully.");
    }

    public void viewVehicles(List<Vehicle> vehicles) {
        System.out.println("---- VEHICLES ----");
        for (Vehicle v : vehicles) {
            System.out.println(v);
        }
    }

    public void viewBookings(List<Booking> bookings) {
        System.out.println("---- BOOKINGS ----");
        for (Booking b : bookings) {
            System.out.println(b);
        }
    }
}