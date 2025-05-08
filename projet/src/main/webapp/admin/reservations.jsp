<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.Reservation" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in as admin
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Reservation> allReservations = new ArrayList<>();
    List<String> carNames = new ArrayList<>();
    List<String> clientNames = new ArrayList<>();
    List<String> agentNames = new ArrayList<>();
    List<String> carImages = new ArrayList<>();

    // Fetch all reservations for admin view
    Connection connection = DBConnection.getConnection();
    if (connection != null) {
        try {
            String query = "SELECT r.*, b.car_name, b.image_url, " +
                         "u.username as client_name, a.username as agent_name " +
                         "FROM reservations r " +
                         "JOIN biens b ON r.id_bien = b.id " +
                         "JOIN users u ON r.id_utilisateur = u.id " +
                         "JOIN users a ON b.agent_id = a.id " +
                         "ORDER BY r.date_debut DESC";
            
            PreparedStatement stmt = connection.prepareStatement(query);
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
                
                allReservations.add(reservation);
                carNames.add(rs.getString("car_name"));
                clientNames.add(rs.getString("client_name"));
                agentNames.add(rs.getString("agent_name"));
                String imageUrl = rs.getString("image_url");
                if (imageUrl != null && !imageUrl.startsWith("http") && !imageUrl.startsWith("/")) {
                    imageUrl = request.getContextPath() + "/" + imageUrl;
                }
                carImages.add(imageUrl);            }
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
    <title>All Reservations | Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admindash.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
    /* Add this with your other status styles */
.status-cancelled {
    background-color: #6c757d;
    color: #ffffff;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}
        :root {
            --primary-color: #3498db;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
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
        
        .admin-container {
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            padding: 20px 0;
        }
        
        .admin-profile {
            text-align: center;
            padding: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .admin-nav ul {
            list-style: none;
            padding: 0;
        }
        
        .admin-nav li a {
            display: block;
            padding: 12px 20px;
            color: #555;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .admin-nav li a:hover, .admin-nav li.active a {
            background-color: var(--light-gray);
            color: var(--primary-color);
        }
        
        .admin-nav li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .main-content {
            flex: 1;
            padding: 30px;
        }
        
        .admin-header {
            margin-bottom: 30px;
        }
        
        .admin-header h1 {
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
        }
        
        .status-pending {
            background-color: var(--warning-color);
            color: #856404;
        }
        
        .status-confirmed {
            background-color: var(--success-color);
            color: #155724;
        }
        
        .status-rejected {
            background-color: var(--danger-color);
            color: #721c24;
        }
        
        .status-completed {
            background-color: var(--info-color);
            color: #0c5460;
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
        
        .btn-complete {
            background: var(--info-color);
            color: white;
        }
        
        .btn-complete:hover {
            background: #138496;
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
        
        .filter-controls {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .filter-select {
            padding: 8px 12px;
            border-radius: var(--border-radius);
            border: 1px solid #ddd;
            background-color: white;
        }
        
        @media (max-width: 768px) {
            .admin-container {
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
            
            .filter-controls {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="admin-profile">
                <h3><%= user.getUsername() %></h3>
                <p>Administrator</p>
            </div>
            <nav class="admin-nav">
                <ul>
                    <li><a href="admin.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="users.jsp"><i class="fas fa-users"></i> User Management</a></li>
                    <li><a href="cars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>
                    <li class="active"><a href="reservations.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <header class="admin-header">
                <h1>All Reservations</h1>
            </header>

            <div class="reservations-container">
                <div class="filter-controls">
                    <select id="statusFilter" class="filter-select" onchange="filterReservations()">
    <option value="all">All Statuses</option>
    <option value="en_attente">Pending</option>
    <option value="confirmée">Confirmed</option>
    <option value="rejetée">Rejected</option>
    <option value="terminée">Completed</option>
    <option value="annulée">Cancelled</option>
</select>
                    
                    <select id="timeFilter" class="filter-select" onchange="filterReservations()">
    <option value="all">All Time</option>
    <option value="upcoming">Upcoming</option>
    <option value="current">Current</option>
    <option value="past">Past</option>
</select>
                </div>
                
                <% if (allReservations.isEmpty()) { %>
                    <div class="no-reservations">
                        <i class="fas fa-calendar-check"></i>
                        <h3>No reservations found</h3>
                        <p>There are currently no reservations in the system.</p>
                    </div>
                <% } else { %>
                    <% for (int i = 0; i < allReservations.size(); i++) { 
                        Reservation reservation = allReservations.get(i);
                        String carName = carNames.get(i);
                        String clientName = clientNames.get(i);
                        String agentName = agentNames.get(i);
                        String carImage = carImages.get(i);
                        String statusClass = "";
                        
                        switch(reservation.getStatut()) {
                            case "en_attente":
                                statusClass = "status-pending";
                                break;
                            case "confirmée":
                                statusClass = "status-confirmed";
                                break;
                            case "rejetée":
                                statusClass = "status-rejected";
                                break;
                            case "terminée":
                                statusClass = "status-completed";
                                break;
                            case "annulée":
                                statusClass = "status-cancelled";
                                break;
                        }
                    %>
                        <div class="reservation-card" data-status="<%= reservation.getStatut() %>" 
                             data-start="<%= reservation.getDateDebut() %>" data-end="<%= reservation.getDateFin() %>">
                            <div class="car-image-container">
                                <img src="<%= carImage != null ? carImage : "https://via.placeholder.com/200x150?text=No+Image" %>" 
                                     alt="<%= carName %>" class="car-image">
                            </div>
                            <div class="reservation-details">
                                <div class="reservation-header">
                                    <div class="reservation-title">
                                        <%= carName %>
                                    </div>
                                    <div class="reservation-status <%= statusClass %>">
    <% 
        String statusText = "";
        switch(reservation.getStatut()) {
            case "en_attente":
                statusText = "Pending";
                break;
            case "confirmée":
                statusText = "Confirmed";
                break;
            case "rejetée":
                statusText = "Rejected";
                break;
            case "terminée":
                statusText = "Completed";
                break;
            case "annulée":
                statusText = "Cancelled";
                break;
            default:
                statusText = reservation.getStatut();
        }
    %>
    <%= statusText %>
</div>
                                </div>
                                
                                <div class="detail-grid">
                                    <div class="detail-item">
                                        <div class="detail-label">Client</div>
                                        <div class="detail-value"><%= clientName %></div>
                                    </div>
                                    <div class="detail-item">
                                        <div class="detail-label">Agent</div>
                                        <div class="detail-value"><%= agentName %></div>
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
                                    <% if ("en_attente".equals(reservation.getStatut())) { %>
                                        
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>

     <script>
        function filterReservations() {
            const statusFilter = document.getElementById('statusFilter').value;
            const timeFilter = document.getElementById('timeFilter').value;
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            document.querySelectorAll('.reservation-card').forEach(card => {
                const status = card.getAttribute('data-status');
                const startDate = new Date(card.getAttribute('data-start'));
                const endDate = new Date(card.getAttribute('data-end'));
                
                let statusMatch = statusFilter === 'all' || status === statusFilter;
                let timeMatch = true;
                
                if (timeFilter !== 'all') {
                    if (timeFilter === 'upcoming') {
                        timeMatch = startDate > today;
                    } else if (timeFilter === 'current') {
                        timeMatch = startDate <= today && endDate >= today;
                    } else if (timeFilter === 'past') {
                        timeMatch = endDate < today;
                    }
                }
                
                if (statusMatch && timeMatch) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        // Initialize with all reservations showing
        document.addEventListener('DOMContentLoaded', function() {
            filterReservations();
            
            // Enhanced image error handling
            document.querySelectorAll('.car-image').forEach(img => {
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