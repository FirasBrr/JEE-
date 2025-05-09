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
        String sql = "SELECT id, car_name, car_description, price_per_day, car_type, image_url, fuel_type, seats, transmission FROM biens WHERE agent_id = ?";
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
    <title>Car Inventory</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/listCars.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .car-actions {
            margin-top: 10px;
        }
        .car-actions a, .car-actions button {
            display: inline-block;
            padding: 8px 16px;
            margin-right: 10px;
            text-decoration: none;
            color: white;
            border-radius: 4px;
            font-size: 14px;
            border: none;
            cursor: pointer;
        }
        .edit-btn {
            background-color: #007bff;
        }
        .edit-btn:hover {
            background-color: #0056b3;
        }
        .delete-btn {
            background-color: #dc3545;
        }
        .delete-btn:hover {
            background-color: #b02a37;
        }
        .message, .error {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .message {
            background-color: #d4edda;
            color: #155724;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
        }
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow: auto;
        }
        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .modal-content h2 {
            margin-top: 0;
        }
        .modal-content label {
            display: block;
            margin: 10px 0 5px;
        }
        .modal-content input, .modal-content textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .modal-content textarea {
            height: 100px;
            resize: vertical;
        }
        .modal-content button {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .modal-content button[type="submit"] {
            background-color: #28a745;
            color: white;
        }
        .modal-content button[type="submit"]:hover {
            background-color: #218838;
        }
        .modal-content button.close-btn {
            background-color: #6c757d;
            color: white;
        }
        .modal-content button.close-btn:hover {
            background-color: #5a6268;
        }
    </style>
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
            
            <!-- Display messages or errors -->
            <% if (session.getAttribute("message") != null) { %>
                <div class="message"><%= session.getAttribute("message") %></div>
                <% session.removeAttribute("message"); %>
            <% } %>
            <% if (session.getAttribute("error") != null) { %>
                <div class="error"><%= session.getAttribute("error") %></div>
                <% session.removeAttribute("error"); %>
            <% } %>
            
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
                            <div class="car-actions">
                                <button class="edit-btn" 
                                        onclick="openEditModal(
                                            '<%= car.getId() %>',
                                            '<%= car.getCarName().replace("'", "\\'") %>',
                                            '<%= car.getCarDescription().replace("'", "\\'") %>',
                                            '<%= car.getPricePerDay() %>',
                                            '<%= car.getCarType().replace("'", "\\'") %>',
                                            '<%= car.getImageUrl().replace("'", "\\'") %>',
                                            '<%= car.getFuelType() != null ? car.getFuelType().replace("'", "\\'") : "" %>',
                                            '<%= car.getSeats() %>',
                                            '<%= car.getTransmission() != null ? car.getTransmission().replace("'", "\\'") : "" %>'
                                        )">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <a href="${pageContext.request.contextPath}/carManagement?action=delete&carId=<%= car.getId() %>" 
                                   class="delete-btn" 
                                   onclick="return confirm('Are you sure you want to delete <%= car.getCarName().replace("'", "\\'") %>?');">
                                   <i class="fas fa-trash"></i> Delete
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <% if (cars.isEmpty()) { %>
                    <p>No cars available.</p>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Edit Car Modal -->
    <div id="editCarModal" class="modal">
        <div class="modal-content">
            <h2>Edit Car</h2>
            <form action="${pageContext.request.contextPath}/carManagement" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" id="carId" name="carId">
                
                <label for="carName">Car Name:</label>
                <input type="text" id="carName" name="carName" required>
                
                <label for="carDescription">Description:</label>
                <textarea id="carDescription" name="carDescription" required></textarea>
                
                <label for="pricePerDay">Price per Day (€):</label>
                <input type="number" id="pricePerDay" name="pricePerDay" step="0.01" required>
                
                <label for="carType">Car Type:</label>
                <input type="text" id="carType" name="carType" required>
                
                <label for="imageUrl">Image URL:</label>
                <input type="text" id="imageUrl" name="imageUrl" required>
                
                <label for="fuelType">Fuel Type:</label>
                <input type="text" id="fuelType" name="fuelType" required>
                
                <label for="seats">Seats:</label>
                <input type="number" id="seats" name="seats" required>
                
                <label for="transmission">Transmission:</label>
                <input type="text" id="transmission" name="transmission" required>
                
                <button type="submit">Save Changes</button>
                <button type="button" class="close-btn" onclick="closeEditModal()">Cancel</button>
            </form>
        </div>
    </div>

    <script>
        function openEditModal(id, name, description, price, type, imageUrl, fuelType, seats, transmission) {
            document.getElementById('carId').value = id;
            document.getElementById('carName').value = name;
            document.getElementById('carDescription').value = description;
            document.getElementById('pricePerDay').value = price;
            document.getElementById('carType').value = type;
            document.getElementById('imageUrl').value = imageUrl;
            document.getElementById('fuelType').value = fuelType;
            document.getElementById('seats').value = seats;
            document.getElementById('transmission').value = transmission;
            document.getElementById('editCarModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editCarModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('editCarModal');
            if (event.target == modal) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>