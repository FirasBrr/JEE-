<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.Reservation" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in as agent
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"agent".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int agentId = user.getId();
    List<Reservation> pendingReservations = new ArrayList<>();
    List<String> carNames = new ArrayList<>();
    List<String> clientNames = new ArrayList<>();
    List<String> carImages = new ArrayList<>();

    // Fetch pending reservations for agent's cars
    Connection connection = DBConnection.getConnection();
    if (connection != null) {
        try {
            String query = "SELECT r.*, b.car_name, b.image_url, u.username as client_name " +
                         "FROM reservations r " +
                         "JOIN biens b ON r.id_bien = b.id " +
                         "JOIN users u ON r.id_utilisateur = u.id " +
                         "WHERE b.agent_id = ? AND r.statut = 'en_attente' " +
                         "ORDER BY r.date_debut ASC";
            
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, agentId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getInt("id"));
                reservation.setCarId(rs.getInt("id_bien"));
                reservation.setUserId(rs.getInt("id_utilisateur"));
                reservation.setDateDebut(rs.getDate("date_debut"));
                reservation.setDateFin(rs.getDate("date_fin"));
                reservation.setStatut(rs.getString("statut"));
                reservation.setMontantTotal(rs.getDouble("montant_total"));
                
                pendingReservations.add(reservation);
                carNames.add(rs.getString("car_name"));
                clientNames.add(rs.getString("client_name"));
                carImages.add(rs.getString("image_url"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Reservations | Agent Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agentdash.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #3498db;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
            --border-radius: 8px;
            --box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
        }
        
        .agent-container {
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            padding: 20px 0;
        }
        
        .agent-profile {
            text-align: center;
            padding: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .agent-nav ul {
            list-style: none;
            padding: 0;
        }
        
        .agent-nav li a {
            display: block;
            padding: 12px 20px;
            color: #555;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .agent-nav li a:hover, .agent-nav li.active a {
            background-color: var(--light-gray);
            color: var(--primary-color);
        }
        
        .agent-nav li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .main-content {
            flex: 1;
            padding: 30px;
        }
        
        .agent-header {
            margin-bottom: 30px;
        }
        
        .agent-header h1 {
            color: var(--dark-gray);
            margin-bottom: 10px;
        }
        
        .reservations-container {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 25px;
        }
        
        .reservation-card {
            display: flex;
            border: 1px solid #e0e0e0;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .reservation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .car-image-container {
            width: 200px;
            background: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .car-image {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        
        .reservation-details {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }
        
        .reservation-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            align-items: center;
        }
        
        .reservation-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark-gray);
        }
        
        .reservation-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background-color: var(--warning-color);
            color: #856404;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .detail-item {
            margin-bottom: 10px;
        }
        
        .detail-label {
            font-size: 12px;
            color: #6c757d;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .detail-value {
            font-size: 14px;
            font-weight: 600;
            color: var(--dark-gray);
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: auto;
            justify-content: flex-end;
        }
        
        .btn {
            padding: 8px 16px;
            border-radius: var(--border-radius);
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
        }
        
        .btn i {
            margin-right: 5px;
        }
        
        .btn-confirm {
            background: var(--success-color);
            color: white;
        }
        
        .btn-confirm:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        
        .btn-reject {
            background: var(--danger-color);
            color: white;
        }
        
        .btn-reject:hover {
            background: #c82333;
            transform: translateY(-2px);
        }
        
        .no-reservations {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .no-reservations i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #adb5bd;
        }
        
        @media (max-width: 768px) {
            .agent-container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
            }
            
            .reservation-card {
                flex-direction: column;
            }
            
            .car-image-container {
                width: 100%;
                height: 150px;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
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
                    <li><a href="listCars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>       
                    <li class="active"><a href="reservation.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <header class="agent-header">
                <h1>Pending Reservations</h1>
            </header>

            <div class="reservations-container">
                <% if (pendingReservations.isEmpty()) { %>
                    <div class="no-reservations">
                        <i class="fas fa-calendar-check"></i>
                        <h3>No pending reservations</h3>
                        <p>You currently have no reservation requests waiting for approval.</p>
                    </div>
                <% } else { %>
                    <% for (int i = 0; i < pendingReservations.size(); i++) { 
                        Reservation reservation = pendingReservations.get(i);
                        String carName = carNames.get(i);
                        String clientName = clientNames.get(i);
                        String carImage = carImages.get(i);
                    %>
                        <div class="reservation-card">
                            <div class="car-image-container">
                                <img src="<%= carImage != null ? carImage : "https://via.placeholder.com/200x150?text=No+Image" %>" 
                                     alt="<%= carName %>" class="car-image">
                            </div>
                            <div class="reservation-details">
                                <div class="reservation-header">
                                    <div class="reservation-title">
                                        <%= carName %>
                                    </div>
                                    <div class="reservation-status">
                                        <%= reservation.getStatut() %>
                                    </div>
                                </div>
                                
                                <div class="detail-grid">
                                    <div class="detail-item">
                                        <div class="detail-label">Client</div>
                                        <div class="detail-value"><%= clientName %></div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Reservation Dates</div>
                                        <div class="detail-value">
                                            <%= reservation.getDateDebut() %> to <%= reservation.getDateFin() %>
                                        </div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Total Amount</div>
                                        <div class="detail-value">
                                            <%= String.format("%.2f", reservation.getMontantTotal()) %> €
                                        </div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Reservation ID</div>
                                        <div class="detail-value">#<%= reservation.getId() %></div>
                                    </div>
                                </div>
                                
                                <div class="action-buttons">
                                    <form action="ConfirmReservationServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="reservationId" value="<%= reservation.getId() %>">
                                        <button type="submit" class="btn btn-confirm">
                                            <i class="fas fa-check"></i> Confirm
                                        </button>
                                    </form>
                                    <form action="RejectReservationServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="reservationId" value="<%= reservation.getId() %>">
                                        <button type="submit" class="btn btn-reject">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>