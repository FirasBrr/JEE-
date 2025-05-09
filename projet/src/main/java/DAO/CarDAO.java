package DAO;

import models.Car;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {
    // Method to check if a car belongs to a specific agent
    public boolean isCarOwnedByAgent(int carId, int agentId) throws SQLException {
        String sql = "SELECT id FROM biens WHERE id = ? AND agent_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setInt(2, agentId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Method to check if a car has reservations
    public boolean hasReservations(int carId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE id_bien = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // Method to delete a car
    public boolean deleteCar(int carId) throws SQLException {
        if (hasReservations(carId)) {
            throw new SQLException("Cannot delete car: it has active reservations.");
        }

        String sql = "DELETE FROM biens WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Method to update a car
    public boolean updateCar(Car car) throws SQLException {
        String sql = "UPDATE biens SET car_name = ?, car_description = ?, price_per_day = ?, " +
                     "car_type = ?, image_url = ?, fuel_type = ?, seats = ?, transmission = ? " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, car.getCarName());
            stmt.setString(2, car.getCarDescription());
            stmt.setDouble(3, car.getPricePerDay());
            stmt.setString(4, car.getCarType());
            stmt.setString(5, car.getImageUrl());
            stmt.setString(6, car.getFuelType());
            stmt.setInt(7, car.getSeats());
            stmt.setString(8, car.getTransmission());
            stmt.setInt(9, car.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Method to get all cars for an agent
    public List<Car> getCarsByAgent(int agentId) throws SQLException {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT id, car_name, car_description, price_per_day, car_type, image_url, " +
                     "fuel_type, seats, transmission FROM biens WHERE agent_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, agentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Car car = new Car();
                    car.setId(rs.getInt("id"));
                    car.setCarName(rs.getString("car_name"));
                    car.setCarDescription(rs.getString("car_description"));
                    car.setPricePerDay(rs.getDouble("price_per_day"));
                    car.setCarType(rs.getString("car_type"));
                    car.setImageUrl(rs.getString("image_url"));
                    car.setFuelType(rs.getString("fuel_type"));
                    car.setSeats(rs.getInt("seats"));
                    car.setTransmission(rs.getString("transmission"));
                    cars.add(car);
                }
            }
        }
        return cars;
    }

    // Method to add a new car
    public boolean addCar(Car car, int agentId) throws SQLException {
        String sql = "INSERT INTO biens (car_name, car_description, price_per_day, car_type, " +
                     "image_url, fuel_type, seats, transmission, agent_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, car.getCarName());
            stmt.setString(2, car.getCarDescription());
            stmt.setDouble(3, car.getPricePerDay());
            stmt.setString(4, car.getCarType());
            stmt.setString(5, car.getImageUrl());
            stmt.setString(6, car.getFuelType());
            stmt.setInt(7, car.getSeats());
            stmt.setString(8, car.getTransmission());
            stmt.setInt(9, agentId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Method to get a single car by ID
    public Car getCarById(int carId) throws SQLException {
        String sql = "SELECT id, car_name, car_description, price_per_day, car_type, image_url, " +
                     "fuel_type, seats, transmission, agent_id FROM biens WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Car car = new Car();
                    car.setId(rs.getInt("id"));
                    car.setCarName(rs.getString("car_name"));
                    car.setCarDescription(rs.getString("car_description"));
                    car.setPricePerDay(rs.getDouble("price_per_day"));
                    car.setCarType(rs.getString("car_type"));
                    car.setImageUrl(rs.getString("image_url"));
                    car.setFuelType(rs.getString("fuel_type"));
                    car.setSeats(rs.getInt("seats"));
                    car.setTransmission(rs.getString("transmission"));
                    return car;
                }
            }
        }
        return null;
    }
}