package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Paramètres de connexion à la base de données
	private static final String URL = "jdbc:mysql://localhost:3308/location_db";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Mets ton mot de passe MySQL si tu en as un

    public static Connection getConnection() {
        try {
            // Chargement du driver JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Établissement de la connexion
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("Erreur : Driver JDBC non trouvé !");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Erreur : Impossible de se connecter à la base de données !");
            e.printStackTrace();
        }
        return null;
    }
}
