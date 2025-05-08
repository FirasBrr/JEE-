<%@ page import="java.sql.*, models.Car, utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int carId = Integer.parseInt(request.getParameter("carId"));
    Car car = null;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM biens WHERE id = ?")) {
        ps.setInt(1, carId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            car = new Car();
            car.setId(carId);
            car.setCarName(rs.getString("car_name"));
            car.setPricePerDay(rs.getDouble("price_per_day"));
            car.setImageUrl(rs.getString("image_url"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    if (car == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservation - <%= car.getCarName() %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --accent-color: #e74c3c;
            --light-color: #ecf0f1;
            --dark-color: #2c3e50;
            --success-color: #2ecc71;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        .reservation-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .reservation-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .car-image {
            width: 120px;
            height: 90px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .reservation-title {
            font-size: 24px;
            color: var(--dark-color);
            margin-bottom: 5px;
        }

        .daily-price {
            font-size: 18px;
            color: var(--primary-color);
            font-weight: 600;
        }

        .reservation-form {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark-color);
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }

        .price-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .total-price {
            font-size: 18px;
            font-weight: bold;
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 10px;
        }

        .btn {
            display: inline-block;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .btn-block {
            display: block;
            width: 100%;
        }

        @media (max-width: 768px) {
            .reservation-container {
                margin: 20px;
                padding: 20px;
            }

            .reservation-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .car-image {
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="reservation-container">
        <div class="reservation-header">
            <% if (car.getImageUrl() != null) { %>
                <img src="<%= car.getImageUrl() %>" alt="<%= car.getCarName() %>" class="car-image">
            <% } %>
            <div>
                <h1 class="reservation-title">Réservation: <%= car.getCarName() %></h1>
                <p class="daily-price"><%= String.format("%.2f", car.getPricePerDay()) %> € / jour</p>
            </div>
        </div>

        <form method="post" action="ReservationServlet" class="reservation-form">
            <input type="hidden" name="carId" value="<%= carId %>">
            <input type="hidden" name="pricePerDay" value="<%= car.getPricePerDay() %>">
            <input type="hidden" name="userId" value="<%= userId %>">

            <div class="form-group">
                <label for="dateDebut">Date de début</label>
                <input type="date" id="dateDebut" name="dateDebut" class="form-control" required>
            </div>

            <div class="form-group">
                <label for="dateFin">Date de fin</label>
                <input type="date" id="dateFin" name="dateFin" class="form-control" required>
            </div>

            <div class="price-summary">
                <div class="price-row">
                    <span>Prix par jour:</span>
                    <span id="dailyPrice"><%= String.format("%.2f", car.getPricePerDay()) %> €</span>
                </div>
                <div class="price-row">
                    <span>Nombre de jours:</span>
                    <span id="daysCount">0</span>
                </div>
                <div class="price-row total-price">
                    <span>Total:</span>
                    <span id="totalPrice">0.00 €</span>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block">Confirmer la réservation</button>
        </form>
    </div>

    <script>
        // Calculate price based on dates
        function calculatePrice() {
            const startDate = new Date(document.getElementById('dateDebut').value);
            const endDate = new Date(document.getElementById('dateFin').value);
            
            if (startDate && endDate && startDate <= endDate) {
                const timeDiff = endDate.getTime() - startDate.getTime();
                const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24)) + 1;
                const dailyPrice = <%= car.getPricePerDay() %>;
                const totalPrice = daysDiff * dailyPrice;
                
                document.getElementById('daysCount').textContent = daysDiff;
                document.getElementById('totalPrice').textContent = totalPrice.toFixed(2) + ' €';
            }
        }
        
        // Set minimum date for date inputs to today
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('dateDebut').min = today;
            
            // Add event listeners
            document.getElementById('dateDebut').addEventListener('change', function() {
                document.getElementById('dateFin').min = this.value;
                calculatePrice();
            });
            
            document.getElementById('dateFin').addEventListener('change', calculatePrice);
        });
    </script>
</body>
</html>