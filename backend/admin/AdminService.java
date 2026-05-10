package admin;

import java.util.ArrayList;
import java.util.List;

import user.User;
import vehicle.Vehicle;
import booking.Booking;

public class AdminService {

    private List<User> users = new ArrayList<>();
    private List<Vehicle> vehicles = new ArrayList<>();
    private List<Booking> bookings = new ArrayList<>();

    public List<User> getUsers() {
        return users;
    }

    public List<Vehicle> getVehicles() {
        return vehicles;
    }

    public List<Booking> getBookings() {
        return bookings;
    }

    // sample data
    public void loadSampleData() {
        users.add(new User("U001", "John"));
        users.add(new User("U002", "Sara"));

        vehicles.add(new Vehicle("V001", "Toyota"));
        vehicles.add(new Vehicle("V002", "Honda"));

        bookings.add(new Booking("B001", "U001"));
    }
}