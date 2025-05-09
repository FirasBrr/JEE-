<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
    // Get the current logged-in user (agent)
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"agent".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Car</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/addCar.css">
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
                    <li class="active"><a href="addCar.jsp"><i class="fas fa-car"></i> Add Car</a></li>
                    <li><a href="listCars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>       
                    
                    <li><a href="reservation.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <header class="agent-header">
                <h1>Add a New Car</h1>
            </header>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/addCarServlet" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="carName">Car Name</label>
                        <input type="text" id="carName" name="carName" required>
                    </div>
                    <div class="form-group">
                        <label for="carDescription">Car Description</label>
                        <textarea id="carDescription" name="carDescription" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="pricePerDay">Price per Day (€)</label>
                        <input type="number" id="pricePerDay" name="pricePerDay" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label for="carType">Car Type</label>
                        <select id="carType" name="carType" required>
                            <option value="SUV">SUV</option>
                            <option value="Sedan">Sedan</option>
                            <option value="Convertible">Convertible</option>
                            <!-- Add other types as needed -->
                        </select>
                    </div>
                    <!-- Additional Information (dropdowns) -->
                    <div class="form-group">
                        <label for="fuelType">Fuel Type</label>
                        <select id="fuelType" name="fuelType" required>
                            <option value="Essence">Essence</option>
                            <option value="Diesel">Diesel</option>
                            <option value="Electric">Electric</option>
                            <option value="Hybrid">Hybrid</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="seats">Seats</label>
                        <select id="seats" name="seats" required>
                            <option value="2">2</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="7">7</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="transmission">Transmission</label>
                        <select id="transmission" name="transmission" required>
                            <option value="Manual">Manual</option>
                            <option value="Automatic">Automatic</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="image">Car Image </label>
                        <input type="file" id="image" name="image" required>
                    </div>
                    <button type="submit" class="btn-submit">Add Car</button>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/script/admindash.js"></script>
</body>
</html>
