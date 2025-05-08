package controlleur;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import models.Car; // You need to create a Car model class if it doesn't exist
import utils.DBConnection;

public class ShowCarsServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch all cars from the database
        List<Car> cars = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "SELECT * FROM biens";
            preparedStatement = connection.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();
            
            while (resultSet.next()) {
                Car car = new Car();
                car.setId(resultSet.getInt("id"));
                car.setCarType(resultSet.getString("type"));
                car.setCarDescription(resultSet.getString("description"));
                car.setPricePerDay(resultSet.getDouble("prix_par_jour"));
                car.setAvailability(resultSet.getBoolean("disponibilite"));
                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load cars. Please try again.");
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        request.setAttribute("cars", cars);
        
        // Forward to the JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/listCars.jsp");
        dispatcher.forward(request, response);
        
    }
}
