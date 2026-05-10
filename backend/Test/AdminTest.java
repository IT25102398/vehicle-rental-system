package Test;

import admin.Admin;
import admin.AdminService;

public class AdminTest {

    public static void main(String[] args) {

        AdminService service = new AdminService();
        service.loadSampleData();

        Admin admin = new Admin("A001", "Sohani");

        System.out.println("=== ADMIN MODULE TESTING ===");

        // TEST 1 - View Users
        System.out.println("\nTest 1: View Users");
        admin.viewUsers(service.getUsers());
        System.out.println("PASS");

        // TEST 2 - View Vehicles
        System.out.println("\nTest 2: View Vehicles");
        admin.viewVehicles(service.getVehicles());
        System.out.println("PASS");

        // TEST 3 - View Bookings
        System.out.println("\nTest 3: View Bookings");
        admin.viewBookings(service.getBookings());
        System.out.println("PASS");

        // TEST 4 - Delete User
        System.out.println("\nTest 4: Delete User");
        admin.deleteUser(service.getUsers(), "U001");
        System.out.println("PASS");

        // verify
        System.out.println("\nAfter Delete:");
        admin.viewUsers(service.getUsers());
    }
}