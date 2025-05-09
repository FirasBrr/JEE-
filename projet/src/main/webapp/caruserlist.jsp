<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Car" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
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
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>AutoLoc - Liste des Voitures</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background-color: #f0f2f5;
        }

        .car-list {
            margin-top: 70px;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 30px;
            padding: 60px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            box-sizing: border-box;
        }

        .car-item {
            background: #ffffff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.07);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .car-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 14px 32px rgba(0, 0, 0, 0.12);
        }

        .car-image {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-bottom: 1px solid #ddd;
        }

        .car-details {
            padding: 20px;
        }

        .car-details h3 {
            margin-top: 0;
            font-size: 22px;
            color: #2c3e50;
        }

        .car-details p {
            margin: 8px 0;
            font-size: 15px;
            color: #555;
            line-height: 1.4;
        }

        .btn-secondary {
            display: inline-block;
            margin-top: 12px;
            padding: 10px 18px;
            font-size: 14px;
            color: white;
background-color: #007bff;            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .btn-secondary:hover {
background-color: #0056b3;        }

        .btn-login-prompt {
            display: inline-block;
            margin-top: 12px;
            padding: 10px 18px;
            font-size: 14px;
            color: white;
            background-color: #007bff;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .btn-login-prompt:hover {
            background-color: #0056b3;
        }

        @media (max-width: 500px) {
            .car-list {
                padding: 20px;
                grid-template-columns: 1fr;
            }
        }

        .car-specs {
            display: flex;
            gap: 15px;
            font-size: 14px;
            color: #444;
            margin-top: 10px;
        }

        .car-specs i {
            margin-right: 5px;
            color: #555;
        }

        .nav-dropdown {
            position: relative;
            margin-left: 20px;
        }

        .nav-dropdown-trigger {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            color: var(--dark-color);
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-dropdown-trigger:hover {
            color: var(--primary-color);
        }

        .nav-dropdown-trigger .fa-angle-down {
            font-size: 0.9em;
            transition: transform 0.2s;
        }

        .nav-dropdown-menu {
            position: absolute;
            right: 0;
            top: 100%;
            background: white;
            border-radius: 6px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            width: 200px;
            padding: 8px 0;
            opacity: 0;
            visibility: hidden;
            transform: translateY(15px);
            transition: all 0.2s ease;
            z-index: 1000;
            list-style: none;
        }

        .nav-dropdown:hover .nav-dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(5px);
        }

        .nav-dropdown:hover .fa-angle-down {
            transform: rotate(180deg);
        }

        .nav-dropdown-menu li a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 20px;
            color: var(--dark-color);
            text-decoration: none;
            font-size: 0.95em;
            transition: all 0.2s;
        }

        .nav-dropdown-menu li a:hover {
            background: #f8f9fa;
            color: var(--primary-color);
        }

        .nav-dropdown-menu li a i {
            width: 18px;
            text-align: center;
        }

        .dropdown-divider {
            height: 1px;
            background: #eee;
            margin: 8px 0;
        }

        .logout-link {
            color: var(--danger-color) !important;
        }

        .logout-link:hover {
            color: #c0392b !important;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <a href="#" class="logo">Auto<span>Loc</span></a>
            <ul class="nav-links">
                <li><a href="home.jsp">Home</a></li>
                <li><a href="#vehicles" class="active">Our Cars</a></li>
                <% String username = (String) session.getAttribute("username");
                if (username != null) { %>
                    <li class="nav-dropdown">
                        <div class="nav-dropdown-trigger">
                            <span class="btn-user">Welcome, <%= username %></span>
                            <i class="fas fa-angle-down"></i>
                        </div>
                        <ul class="nav-dropdown-menu">
                            <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                            <li><a href="userreservation.jsp"><i class="fas fa-calendar-alt"></i> Reservations</a></li>
                            <li class="dropdown-divider"></li>
                            <li><a href="${pageContext.request.contextPath}/logout" class="logout-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li><a href="${pageContext.request.contextPath}/login.jsp" class="btn-login">Login</a></li>
                <% } %>
            </ul>
            <div class="hamburger">
                <i class="fas fa-bars"></i>
            </div>
        </div>
    </nav>
    <div class="car-list">
        <% for (Car car : cars) { %>
            <div class="car-item">
                <img src="<%= car.getImageUrl() %>" alt="<%= car.getCarName() %>" class="car-image">
                <div class="car-details">
                    <div class="car-specs">
                        <span><i class="fas fa-gas-pump"></i> <%= car.getFuelType() %></span>
                        <span><i class="fas fa-users"></i> <%= car.getSeats() %> places</span>
                        <span><i class="fas fa-cogs"></i> <%= car.getTransmission() %></span>
                    </div>
                    <h3><%= car.getCarName() %></h3>
                    <p><%= car.getCarDescription() %></p>
                    <p>Type: <%= car.getCarType() %></p>
                    <p class="price">Price per day: <%= car.getPricePerDay() %> €</p>
                    <% if (username != null) { %>
                        <a href="reserver.jsp?carId=<%= car.getId() %>" class="btn-secondary">Book Now</a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn-login-prompt">Login to Book</a>
                    <% } %>
                </div>
            </div>
        <% } %>
       ,
        <% if (cars.isEmpty()) { %>
            <p style="text-align:center;">No Car available right now.</p>
        <% } %>
    </div>
</body>
</html>