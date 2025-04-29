package DAO;
import models.User;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
}



