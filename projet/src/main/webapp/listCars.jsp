<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="models.Car" %>

<%
    // Get the current logged-in user (agent)
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"agent".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Initialize the database connection and query for the cars
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    List<Car> cars = new ArrayList<>();
    
    try {
        connection = DBConnection.getConnection();
        String sql = "SELECT id, car_name, car_description, price_per_day, car_type, image_url FROM biens WHERE agent_id = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, user.getId());
        resultSet = preparedStatement.executeQuery();
        
        // Loop through the result set and create Car objects
        while (resultSet.next()) {
            Car car = new Car();
            car.setId(resultSet.getInt("id"));
            car.setCarName(resultSet.getString("car_name"));
            car.setCarDescription(resultSet.getString("car_description"));
            car.setPricePerDay(resultSet.getDouble("price_per_day"));
            car.setCarType(resultSet.getString("car_type"));
            car.setImageUrl(resultSet.getString("image_url"));
            cars.add(car);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Car Inventory</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/listCars.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="agent-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="agent-profile">
                <h3><%= user.getUsername() %></h3>
                <p>Agent</p>
            </div>
            <nav class="agent-nav">
                <ul>
                    <li><a href="agent.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="addCar.jsp"><i class="fas fa-car"></i> Add Car</a></li>
                    <li class="active"><a href="listCars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>       
                    <li><a href="reservation.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <h2>Your Car Inventory</h2>
            
            <!-- Display the list of cars -->
            <div class="car-list">
                <% for (Car car : cars) { %>
                    <div class="car-item">
                        <img src="<%= car.getImageUrl() %>" alt="<%= car.getCarName() %>" class="car-image">
                        <div class="car-details">
                            <h3><%= car.getCarName() %></h3>
                            <p><%= car.getCarDescription() %></p>
                            <p>Type: <%= car.getCarType() %></p>
                            <p>Price per day: €<%= car.getPricePerDay() %></p>
                            
                        </div>
                    </div>
                <% } %>
                
                <% if (cars.isEmpty()) { %>
                    <p>No cars available.</p>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
