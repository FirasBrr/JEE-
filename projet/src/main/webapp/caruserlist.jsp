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
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 0;
    background-color: #f0f2f5;
}

.car-list {
    margin-top: 70px; /* Push content down from the top navbar */
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
    background-color: #28a745;
    border-radius: 8px;
    text-decoration: none;
    transition: background-color 0.3s ease;
}

.btn-secondary:hover {
    background-color: #218838;
}

/* Responsive fix for very small devices */
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

</style>

    <meta charset="UTF-8">
    <title>AutoLoc - Liste des Voitures</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
   <nav class="navbar">
        <div class="container">
            <a href="#" class="logo">Auto<span>Loc</span></a>
            <ul class="nav-links">
                <li><a href="home.jsp" class="active">Accueil</a></li>
                <li><a href="#vehicles">Nos Véhicules</a></li>
                <li><a href="#services">Services</a></li>
                <li><a href="#about">À Propos</a></li>
                <li><a href="#contact">Contact</a></li>
               <% String username = (String) session.getAttribute("username");
    if (username != null) { %>



     <li><span class="btn-user">Bienvenue, <%= username %></span></li>
<li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a></li>
<%
    } else {
%>
<li><a href="${pageContext.request.contextPath}/login.jsp" class="btn-login">Connexion</a></li>

<%
    }
%>

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
                    <p class="price">Prix par jour: <%= car.getPricePerDay() %> €</p>
                    <a href="reserver.jsp?carId=<%= car.getId() %>" class="btn-secondary">Réserver</a>
                </div>
            </div>
        <% } %>

        <% if (cars.isEmpty()) { %>
            <p style="text-align:center;">Aucun véhicule disponible pour le moment.</p>
        <% } %>
    </div>
    
    
    
    

</body>
</html>
