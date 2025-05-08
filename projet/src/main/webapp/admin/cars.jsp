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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .main-content {
            padding: 20px;
        }
        .car-inventory-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .car-inventory-header h2 {
            margin: 0;
            font-size: 24px;
            color: #2c3e50;
        }
        .add-car-btn {
            padding: 10px 20px;
            background-color: #4e73df;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        .add-car-btn:hover {
            background-color: #2e59d9;
        }
        .car-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        .car-card {
            background: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .car-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }
        .car-image-container {
            height: 200px;
            overflow: hidden;
            position: relative;
            border-bottom: 1px solid #eee;
            background-color: #f5f5f5; /* Fallback background */
        }
        .car-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .car-card:hover .car-image {
            transform: scale(1.05);
        }
        .car-details {
            padding: 20px;
        }
        .car-title {
            margin: 0 0 10px 0;
            font-size: 18px;
            color: #2c3e50;
        }
        .car-specs {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin: 10px 0;
            font-size: 14px;
            color: #555;
        }
        .car-spec {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .car-spec i {
            color: #4e73df;
        }
        .car-price {
            font-size: 18px;
            font-weight: 600;
            color: #28a745;
            margin: 15px 0;
        }
        .car-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        .action-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .edit-btn {
            background-color: #f8f9fa;
            color: #4e73df;
            border: 1px solid #ddd;
        }
        .edit-btn:hover {
            background-color: #e9ecef;
        }
        .delete-btn {
            background-color: #f8f9fa;
            color: #e74a3b;
            border: 1px solid #ddd;
        }
        .delete-btn:hover {
            background-color: #f1e8e8;
        }
        .no-cars {
            grid-column: 1 / -1;
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-size: 16px;
        }
        
        /* Alert styles */
        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        @media (max-width: 768px) {
            .car-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
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
            <div class="car-inventory-header">
                <h2>Car Inventory</h2>
                
            </div>
            
            <!-- Success/Error Messages -->
            <%
                String message = (String) session.getAttribute("message");
                String error = (String) session.getAttribute("error");
                if (message != null) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= message %>
                </div>
                <% session.removeAttribute("message"); %>
            <%
                }
                if (error != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
                <% session.removeAttribute("error"); %>
            <%
                }
            %>

            <!-- Display the list of cars -->
            <div class="car-grid">
                <% if (cars.isEmpty()) { %>
                    <div class="no-cars">
                        <i class="fas fa-car" style="font-size: 40px; margin-bottom: 15px;"></i>
                        <p>No cars available in inventory.</p>
                    </div>
                <% } else { 
                    for (Car car : cars) { 
                        // Handle image URL - prepend context path if it's a relative path
                        String imageUrl = car.getImageUrl();
                        if (imageUrl != null && !imageUrl.startsWith("http") && !imageUrl.startsWith("/")) {
                            imageUrl = request.getContextPath() + "/" + imageUrl;
                        }
                %>
                    <div class="car-card">
                        <div class="car-image-container">
                            <img src="<%= imageUrl != null ? imageUrl : "${pageContext.request.contextPath}/resources/images/default-car.jpg" %>" 
                                 alt="<%= car.getCarName() %>" 
                                 class="car-image"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/resources/images/default-car.jpg'">
                        </div>
                        <div class="car-details">
                            <h3 class="car-title"><%= car.getCarName() %></h3>
                            <p><%= car.getCarDescription() %></p>
                            
                            <div class="car-specs">
                                <div class="car-spec">
                                    <i class="fas fa-gas-pump"></i>
                                    <span><%= car.getFuelType() %></span>
                                </div>
                                <div class="car-spec">
                                    <i class="fas fa-users"></i>
                                    <span><%= car.getSeats() %> seats</span>
                                </div>
                                <div class="car-spec">
                                    <i class="fas fa-cogs"></i>
                                    <span><%= car.getTransmission() %></span>
                                </div>
                                <div class="car-spec">
                                    <i class="fas fa-tag"></i>
                                    <span><%= car.getCarType() %></span>
                                </div>
                            </div>
                            
                            <div class="car-price">€<%= String.format("%.2f", car.getPricePerDay()) %>/day</div>
                            
                            
                        </div>
                    </div>
                <% } 
                } %>
            </div>
        </div>
    </div>

    <script>
        // Enhanced image error handling
        document.addEventListener('DOMContentLoaded', function() {
            const images = document.querySelectorAll('.car-image');
            images.forEach(img => {
                // Check if image loaded successfully
                if (img.complete && img.naturalHeight === 0) {
                    img.src = '${pageContext.request.contextPath}/resources/images/default-car.jpg';
                }
                
                // Prevent infinite loop if default image also fails
                img.onerror = function() {
                    this.onerror = null;
                    this.src = '${pageContext.request.contextPath}/resources/images/default-car.jpg';
                };
            });
        });
    </script>
</body>
</html>