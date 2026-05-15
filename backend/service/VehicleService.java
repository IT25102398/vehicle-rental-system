package com.vehiclerental.service;

import com.vehiclerental.model.Vehicle;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleService {
    public static List<Vehicle> getAllVehicles(File file) throws IOException {
        List<Vehicle> vehicles = new ArrayList<>();
        if (!file.exists()) {
            return vehicles;
        }
        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (!line.trim().isEmpty()) {
                Vehicle vehicle = Vehicle.fromFileString(line);
                if (vehicle != null) {
                    vehicles.add(vehicle);
                }
            }
        }
        reader.close();
        return vehicles;
    }

    public static void saveAllVehicles(List<Vehicle> vehicles, File file) throws IOException {
        File parent = file.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }
        BufferedWriter writer = new BufferedWriter(new FileWriter(file, false));
        for (Vehicle vehicle : vehicles) {
            writer.write(vehicle.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    public static String generateVehicleId(List<Vehicle> vehicles) {
        int max = 0;
        for (Vehicle vehicle : vehicles) {
            try {
                max = Math.max(max, Integer.parseInt(vehicle.getVehicleId().replace("V", "")));
            } catch (Exception ignored) {}
        }
        return String.format("V%03d", max + 1);
    }

    public static Vehicle findById(List<Vehicle> vehicles, String vehicleId) {
        for (Vehicle vehicle : vehicles) {
            if (vehicle.getVehicleId().equals(vehicleId)) {
                return vehicle;
            }
        }
        return null;
    }

    public static void updateAvailability(String vehicleId, String availability, File file) throws IOException {
        List<Vehicle> vehicles = getAllVehicles(file);
        for (Vehicle vehicle : vehicles) {
            if (vehicle.getVehicleId().equals(vehicleId)) {
                vehicle.setAvailability(availability);
                break;
            }
        }
        saveAllVehicles(vehicles, file);
    }
}
