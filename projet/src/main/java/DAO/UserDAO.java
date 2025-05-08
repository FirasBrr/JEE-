	package DAO;
	
	import models.User;
	import utils.DBConnection;
	
	import java.sql.Connection;
	import java.sql.PreparedStatement;
	import java.sql.ResultSet;
	import java.sql.SQLException;
	import java.sql.Statement;
	import java.util.ArrayList;
	import java.util.List;
	
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
	            stmt.setString(3, user.getRole());
	
	            return stmt.executeUpdate() > 0;
	
	        } catch (SQLException e) {
	            System.out.println("Erreur lors de l'enregistrement de l'utilisateur.");
	            e.printStackTrace();
	            return false;
	        }
	    }
	
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
	
	    public int getAdminCount() throws SQLException {
	        return getUsersByRole("admin");
	    }
	
	    public int getAgentCount() throws SQLException {
	        return getUsersByRole("agent");
	    }
	
	    public int getVisiteurCount() throws SQLException {
	        return getUsersByRole("visiteur");
	    }
	
	    public User getUserById(int userId) throws SQLException {
	        String sql = "SELECT * FROM users WHERE id = ?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {
	            stmt.setInt(1, userId);
	            try (ResultSet rs = stmt.executeQuery()) {
	                if (rs.next()) {
	                    return new User(
	                        rs.getInt("id"),
	                        rs.getString("username"),
	                        rs.getString("password"),
	                        rs.getString("role")
	                    );
	                }
	            }
	        }
	        return null;
	    }
	
	    public boolean updatePassword(int userId, String currentPassword, String newPassword) throws SQLException {
	        String verifySql = "SELECT id FROM users WHERE id = ? AND password = ?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement verifyStmt = conn.prepareStatement(verifySql)) {
	            verifyStmt.setInt(1, userId);
	            verifyStmt.setString(2, currentPassword);
	            try (ResultSet rs = verifyStmt.executeQuery()) {
	                if (!rs.next()) {
	                    return false;
	                }
	            }
	        }
	        String updateSql = "UPDATE users SET password = ? WHERE id = ?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
	            updateStmt.setString(1, newPassword);
	            updateStmt.setInt(2, userId);
	            return updateStmt.executeUpdate() > 0;
	        }
	    }
	
	    public String getCreationDate(int userId) throws SQLException {
	        String sql = "SELECT created_at FROM users WHERE id = ?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {
	            stmt.setInt(1, userId);
	            try (ResultSet rs = stmt.executeQuery()) {
	                if (rs.next()) {
	                    return rs.getTimestamp("created_at").toString();
	                }
	            }
	        }
	        return null;
	    }
	
	    // New method to get all users
	    public List<User> getAllUsers() throws SQLException {
	        List<User> users = new ArrayList<>();
	        String sql = "SELECT * FROM users";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql);
	             ResultSet rs = stmt.executeQuery()) {
	            while (rs.next()) {
	                users.add(new User(
	                    rs.getInt("id"),
	                    rs.getString("username"),
	                    rs.getString("password"),
	                    rs.getString("role")
	                ));
	            }
	        }
	        return users;
	    }
	
	    // New method to update user details
	    public boolean updateUser(int userId, String username, String password, String role) throws SQLException {
	        String sql = password.isEmpty() ?
	            "UPDATE users SET username = ?, role = ? WHERE id = ?" :
	            "UPDATE users SET username = ?, password = ?, role = ? WHERE id = ?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {
	            stmt.setString(1, username);
	            if (password.isEmpty()) {
	                stmt.setString(2, role);
	                stmt.setInt(3, userId);
	            } else {
	                stmt.setString(2, password);
	                stmt.setString(3, role);
	                stmt.setInt(4, userId);
	            }
	            return stmt.executeUpdate() > 0;
	        }
	    }
	
	    // New method to delete a user
	    public boolean deleteUser(int userId) throws SQLException {
	        String sql = "DELETE FROM users WHERE id = ?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {
	            stmt.setInt(1, userId);
	            return stmt.executeUpdate() > 0;
	        }
	    }
	}