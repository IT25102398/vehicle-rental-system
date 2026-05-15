package com.vehiclerental.model;

public class Vehicle {
    private String vehicleId;
    private String name;
    private String type;
    private String brand;
    private double dailyRate;
    private String availability;
    private String addedDate;

    public Vehicle(String vehicleId, String name, String type, String brand, double dailyRate, String availability) {
        this(vehicleId, name, type, brand, dailyRate, availability, "");
    }

    public Vehicle(String vehicleId, String name, String type, String brand, double dailyRate, String availability, String addedDate) {
        this.vehicleId = vehicleId;
        this.name = name;
        this.type = type;
        this.brand = brand;
        this.dailyRate = dailyRate;
        this.availability = availability;
        this.addedDate = addedDate;
    }

    public boolean isAvailable() {
        return "available".equalsIgnoreCase(availability);
    }

    public String toFileString() {
        return vehicleId + "," + name + "," + type + "," + brand + "," + dailyRate + "," + availability + "," + addedDate;
    }

    public static Vehicle fromFileString(String line) {
        String[] parts = line.split(",", -1);
        if (parts.length < 6) {
            return null;
        }
        String addedDate = parts.length >= 7 ? parts[6] : "";
        return new Vehicle(parts[0], parts[1], parts[2], parts[3], Double.parseDouble(parts[4]), parts[5], addedDate);
    }

    public String getVehicleId() { return vehicleId; }
    public String getName() { return name; }
    public String getType() { return type; }
    public String getBrand() { return brand; }
    public double getDailyRate() { return dailyRate; }
    public String getAvailability() { return availability; }
    public String getAddedDate() { return addedDate; }

    public void setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }
    public void setName(String name) { this.name = name; }
    public void setType(String type) { this.type = type; }
    public void setBrand(String brand) { this.brand = brand; }
    public void setDailyRate(double dailyRate) { this.dailyRate = dailyRate; }
    public void setAvailability(String availability) { this.availability = availability; }
    public void setAddedDate(String addedDate) { this.addedDate = addedDate; }
}
