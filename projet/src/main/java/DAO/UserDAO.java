package DAO;
import models.User;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserDAO {

	@SuppressWarnings("unused")
	public boolean register(User user) {
		String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
		try (
		    Connection conn = DBConnection.getConnection();
		    PreparedStatement stmt = conn.prepareStatement(sql)
		) {
		    if (conn == null) {
		        System.out.println("Erreur : Connexion à la base de données échouée.");
		        return false;
		    }

		    stmt.setString(1, user.getUsername());
		    stmt.setString(2, user.getPassword());
		    stmt.setString(3, user.getRole()); // ✅ Maintenant c’est correct

		    return stmt.executeUpdate() > 0;

		} catch (SQLException e) {
		    System.out.println("Erreur lors de l'enregistrement de l'utilisateur.");
		    e.printStackTrace();
		    return false;
		}

    }

    // Connexion d'un utilisateur existant
    @SuppressWarnings("unused")
	public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            if (conn == null) {
                System.out.println("Erreur : Connexion à la base de données échouée.");
                return null;
            }

            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                // Assure-toi que le constructeur User(int, String, String, String) existe
                return new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role")
                );
            }

        } catch (SQLException e) {
            System.out.println("Erreur lors de la connexion de l'utilisateur.");
            e.printStackTrace();
        }

        return null;
    }
    public int getTotalUsers() throws SQLException {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        }
        return count;
    }


    public int getUsersByRole(String role) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // Add this if you want to display users by role in dashboard
    public int getAdminCount() throws SQLException {
        return getUsersByRole("admin");
    }

    public int getAgentCount() throws SQLException {
        return getUsersByRole("agent");
    }

    public int getVisiteurCount() throws SQLException {
        return getUsersByRole("visiteur");
    }
}



