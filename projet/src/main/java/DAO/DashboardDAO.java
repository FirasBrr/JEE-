package DAO;

import utils.DBConnection;
import java.sql.*;

public class DashboardDAO {
    
    public int getAvailableCarsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM cars WHERE status = 'available'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getActiveReservationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE " +
                    "start_date <= CURRENT_DATE AND end_date >= CURRENT_DATE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public double getTodaysRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM reservations " +
                    "WHERE payment_date = CURRENT_DATE AND status = 'paid'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }
}