package com.vehiclerental.servlet;

import com.vehiclerental.model.Vehicle;
import com.vehiclerental.service.User;
import com.vehiclerental.service.VehicleService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;

public class VehicleServlet extends HttpServlet {
    private File getDatabaseFile(String fileName) {
        String appRoot = getServletContext().getRealPath("/");
        if (appRoot == null) {
            return new File("database", fileName);
        }
        File frontendDir = new File(appRoot);
        File projectDir = frontendDir.getParentFile();
        return new File(new File(projectDir, "database"), fileName);
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("loggedInUser");
        return user != null && "admin".equals(user.getRole());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        File vehicleFile = getDatabaseFile("vehicles.txt");
        List<Vehicle> vehicles = VehicleService.getAllVehicles(vehicleFile);
        String path = request.getServletPath();

        if ("/addVehicle".equals(path)) {
            String vehicleId = VehicleService.generateVehicleId(vehicles);
            vehicles.add(readVehicle(request, vehicleId));
        } else if ("/updateVehicle".equals(path)) {
            String vehicleId = request.getParameter("vehicleId");
            for (Vehicle vehicle : vehicles) {
                if (vehicle.getVehicleId().equals(vehicleId)) {
                    Vehicle updated = readVehicle(request, vehicleId);
                    vehicle.setName(updated.getName());
                    vehicle.setType(updated.getType());
                    vehicle.setBrand(updated.getBrand());
                    vehicle.setDailyRate(updated.getDailyRate());
                    vehicle.setAvailability(updated.getAvailability());
                    vehicle.setAddedDate(updated.getAddedDate());
                    break;
                }
            }
        } else if ("/deleteVehicle".equals(path)) {
            String vehicleId = request.getParameter("vehicleId");
            vehicles.removeIf(vehicle -> vehicle.getVehicleId().equals(vehicleId));
        }

        VehicleService.saveAllVehicles(vehicles, vehicleFile);
        response.sendRedirect("admin.jsp");
    }

    private Vehicle readVehicle(HttpServletRequest request, String vehicleId) {
        return new Vehicle(
                vehicleId,
                request.getParameter("name"),
                request.getParameter("type"),
                request.getParameter("brand"),
                Double.parseDouble(request.getParameter("dailyRate")),
                request.getParameter("availability"),
                request.getParameter("addedDate")
        );
    }
}
