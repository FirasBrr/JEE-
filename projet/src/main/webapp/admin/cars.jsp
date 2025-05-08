<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, models.Car, java.util.List, java.util.ArrayList, java.sql.*, utils.DBConnection" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Car> cars = new ArrayList<>();
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        connection = DBConnection.getConnection();
  String sql = "SELECT id, car_name, car_description, price_per_day, car_type, image_url, fuel_type, seats, transmission FROM biens";
        preparedStatement = connection.prepareStatement(sql);
        resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            Car car = new Car();
            car.setId(resultSet.getInt("id"));
            car.setCarName(resultSet.getString("car_name"));
            car.setCarDescription(resultSet.getString("car_description"));
            car.setPricePerDay(resultSet.getDouble("price_per_day"));
            car.setCarType(resultSet.getString("car_type"));
            car.setImageUrl(resultSet.getString("image_url"));
            car.setFuelType(resultSet.getString("fuel_type"));
            car.setSeats(resultSet.getInt("seats"));
            car.setTransmission(resultSet.getString("transmission"));

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
    <title>Car Inventory - AutoLoc</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admindash.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/listCars.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="admin-profile">
                <h3><%= currentUser.getUsername() %></h3>
                <p>Administrator</p>
            </div>
            <nav class="admin-nav">
                <ul>
                    <li><a href="admin.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="users.jsp"><i class="fas fa-users"></i> User Management</a></li>
                    <li class="active"><a href="cars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>
                    <li><a href="reservations.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h2>Car Inventory</h2>
            
            <!-- Success/Error Messages -->
            <%
                String message = (String) session.getAttribute("message");
                String error = (String) session.getAttribute("error");
                if (message != null) {
            %>
                <div class="alert alert-success">
                    <%= message %>
                </div>
                <% session.removeAttribute("message"); %>
            <%
                }
                if (error != null) {
            %>
                <div class="alert alert-error">
                    <%= error %>
                </div>
                <% session.removeAttribute("error"); %>
            <%
                }
            %>

            <!-- Display the list of cars -->
            <div class="car-list">
                <% for (Car car : cars) { %>
                    <div class="car-item">
                <img src="<%= car.getImageUrl() %>" alt="<%= car.getCarName() %>" class="car-image">
                        <div class="car-details">
                            <h3><%= car.getCarName() %></h3>
                            <p><%= car.getCarDescription() %></p>
                            <p>Type: <%= car.getCarType() %></p>
                            <p>Price per day: $<%= car.getPricePerDay() %></p>
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