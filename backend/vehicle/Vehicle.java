package vehicle;

public class Vehicle {
    private String vehicleId;
    private String brand;

    public Vehicle(String vehicleId, String brand) {
        this.vehicleId = vehicleId;
        this.brand = brand;
    }

    public String getVehicleId() {
        return vehicleId;
    }

    public String getBrand() {
        return brand;
    }

    @Override
    public String toString() {
        return "Vehicle ID: " + vehicleId + ", Brand: " + brand;
    }
}