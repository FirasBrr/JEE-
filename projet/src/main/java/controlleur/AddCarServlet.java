package controlleur;

import java.io.*;
import java.nio.file.Path;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import models.User;
import utils.DBConnection;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@MultipartConfig
public class AddCarServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the user is logged in and has the "agent" role
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"agent".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Forward to the Add Car page (addCar.jsp)
        RequestDispatcher dispatcher = request.getRequestDispatcher("/addCar.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the current user from the session
        User user = (User) request.getSession().getAttribute("currentUser");

        // Check if the user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get form fields and file upload
        String carName = request.getParameter("carName");
        String carDescription = request.getParameter("carDescription");
        String carType = request.getParameter("carType");
        String priceString = request.getParameter("pricePerDay");
        double pricePerDay = 0;
        String imageUrl = null;
        String fuelType = request.getParameter("fuelType");  // Added fuel type
        String seatsString = request.getParameter("seats");  // Added seats
        int seats = 5;  // Default value for seats if not provided
        String transmission = request.getParameter("transmission");  // Added transmission

        try {
            // Parse the pricePerDay field
            if (priceString != null && !priceString.trim().isEmpty()) {
                pricePerDay = Double.parseDouble(priceString.trim());
            }

            // Parse seats
            if (seatsString != null && !seatsString.trim().isEmpty()) {
                seats = Integer.parseInt(seatsString.trim());
            }
        } catch (NumberFormatException e) {
            // Handle invalid number format
            request.setAttribute("errorMessage", "Invalid price or seats format. Please enter valid numbers.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/addCar.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Process the uploaded file (image)
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = Path.of(imagePart.getSubmittedFileName()).getFileName().toString();
            
            // Determine the directory to save images
            String appPath = getServletContext().getRealPath("");
            String imageDir = appPath + File.separator + "images"; // "images" folder in the root of the project

            // Ensure the directory exists, if not create it
            File dir = new File(imageDir);
            if (!dir.exists()) {
                dir.mkdir();  // Create the directory if it does not exist
            }

            // Set the path where the image will be saved
            String filePath = imageDir + File.separator + fileName;
            File file = new File(filePath);
            imagePart.write(file.getAbsolutePath());
            imageUrl = "resources/img/" + fileName;  // Path relative to the web context
        }

        // Get the agent's ID from the user object
        int agentId = user.getId();

        // Database connection and insertion logic
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        try {
            connection = DBConnection.getConnection();
            String sql = "INSERT INTO biens (agent_id, car_name, car_description, price_per_day, car_type, fuel_type, seats, transmission, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, agentId);
            preparedStatement.setString(2, carName);
            preparedStatement.setString(3, carDescription);
            preparedStatement.setDouble(4, pricePerDay);
            preparedStatement.setString(5, carType);
            preparedStatement.setString(6, fuelType);  // Setting fuel type
            preparedStatement.setInt(7, seats);  // Setting seats
            preparedStatement.setString(8, transmission);  // Setting transmission
            preparedStatement.setString(9, imageUrl);

            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect(request.getContextPath() + "/agent.jsp");
            } else {
                request.setAttribute("errorMessage", "Failed to add the car. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/addCar.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/addCar.jsp");
            dispatcher.forward(request, response);
        } finally {
            if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }


}
