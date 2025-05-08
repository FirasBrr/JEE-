package DAO;
import java.sql.*;
import models.Reservation;
import utils.DBConnection;

public class ReservationDAO {

    public void insertReservation(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO reservations (id_utilisateur, id_bien, date_debut, date_fin, statut, montant_total) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, reservation.getUserId());
            stmt.setInt(2, reservation.getCarId());
            stmt.setDate(3, new java.sql.Date(reservation.getDateDebut().getTime()));
            stmt.setDate(4, new java.sql.Date(reservation.getDateFin().getTime()));
            stmt.setString(5, reservation.getStatut());
            stmt.setDouble(6, reservation.getMontantTotal());

            stmt.executeUpdate();
        }
    }
}
