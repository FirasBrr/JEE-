<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="models.Reservation" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int userId = user.getId();
    List<Reservation> userReservations = new ArrayList<>();
    List<String> carNames = new ArrayList<>();
    List<String> carImages = new ArrayList<>();

    // Fetch user's reservations
    Connection connection = DBConnection.getConnection();
    if (connection != null) {
        try {
            String query = "SELECT r.*, b.car_name, b.image_url " +
                         "FROM reservations r " +
                         "JOIN biens b ON r.id_bien = b.id " +
                         "WHERE r.id_utilisateur = ? " +
                         "ORDER BY r.date_debut DESC";
            
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getInt("id"));
                reservation.setCarId(rs.getInt("id_bien"));
                reservation.setDateDebut(rs.getDate("date_debut"));
                reservation.setDateFin(rs.getDate("date_fin"));
                reservation.setStatut(rs.getString("statut"));
                reservation.setMontantTotal(rs.getDouble("montant_total"));
                
                userReservations.add(reservation);
                carNames.add(rs.getString("car_name"));
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
    <title>Mes Réservations</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
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

/* Mobile Adaptation */
@media (max-width: 768px) {
    .nav-dropdown {
        margin-left: 0;
        margin-top: 15px;
    }
    
    .nav-dropdown-menu {
        position: static;
        box-shadow: none;
        border: 1px solid #eee;
        margin-top: 10px;
        opacity: 1;
        visibility: visible;
        transform: none;
        width: 100%;
    }
}
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --success-color: #2ecc71;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --light-color: #ecf0f1;
            --dark-color: #2c3e50;
        }
        
        .reservations-container {
    max-width: 1000px;
    margin: 100px auto 30px; /* Even more space at the top */
    padding: 20px;
}
        .page-title {
            text-align: center;
            margin-bottom: 30px;
            color: var(--dark-color);
        }
        
        .reservation-card {
            display: flex;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .reservation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .car-image-container {
            width: 200px;
            min-height: 150px;
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
        }
        
        .car-name {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .reservation-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-confirmed {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .detail-item {
            margin-bottom: 5px;
        }
        
        .detail-label {
            font-size: 0.8rem;
            color: #6c757d;
            margin-bottom: 3px;
        }
        
        .detail-value {
            font-size: 0.95rem;
            font-weight: 500;
        }
        
        .no-reservations {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }
        
        .no-reservations i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #adb5bd;
        }
        
        @media (max-width: 768px) {
            .reservation-card {
                flex-direction: column;
            }
            
            .car-image-container {
                width: 100%;
                height: 200px;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="#" class="logo">Auto<span>Loc</span></a>
            <ul class="nav-links">
               <li><a href="home.jsp" class="active">Home</a></li>
    <li><a href="#vehicles">Our Cars</a></li>
               <% String username = (String) session.getAttribute("username");
    if (username != null) { %>



     <li class="nav-dropdown">
    <div class="nav-dropdown-trigger">
        <span class="btn-user">Bienvenue, <%= username %></span>
        <i class="fas fa-angle-down"></i>
    </div>
    <ul class="nav-dropdown-menu">
        <li><a href="profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
        <li><a href="userreservation.jsp"><i class="fas fa-calendar-alt"></i> Reservations</a></li>
        <li class="dropdown-divider"></li>
        <li><a href="${pageContext.request.contextPath}/logout" class="logout-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</li>
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
    <div class="reservations-container">
<h1 class="page-title">My Reservations</h1>        
        <% if (userReservations.isEmpty()) { %>
            <div class="no-reservations">
    <i class="fas fa-calendar-times"></i>
    <h3>No reservations found</h3>
    <p>You haven't made any reservations yet.</p>
    <a href="home.jsp" class="btn-primary">Book now</a>
</div>
        <% } else { %>
            <% for (int i = 0; i < userReservations.size(); i++) { 
                Reservation reservation = userReservations.get(i);
                String statusClass = "";
                switch(reservation.getStatut()) {
                    case "en_attente":
                        statusClass = "status-pending";
                        break;
                    case "confirmée":
                        statusClass = "status-confirmed";
                        break;
                    case "annulée":
                        statusClass = "status-cancelled";
                        break;
                }
            %>
                <div class="reservation-card">
                    <div class="car-image-container">
                        <img src="<%= carImages.get(i) != null ? carImages.get(i) : "https://via.placeholder.com/300x200?text=No+Image" %>" 
                             alt="<%= carNames.get(i) %>" class="car-image">
                    </div>
                    <div class="reservation-details">
                        <div class="reservation-header">
                            <h3 class="car-name"><%= carNames.get(i) %></h3>
                            <span class="reservation-status <%= statusClass %>">
    <% 
        String statusText = "";
        switch(reservation.getStatut()) {
            case "en_attente":
                statusText = "Pending";
                break;
            case "confirmée":
                statusText = "Confirmed";
                break;
            case "annulée":
                statusText = "Cancelled";
                break;
            default:
                statusText = reservation.getStatut();
        }
    %>
    <%= statusText %>
</span>
                        </div>
                        
                        <div class="detail-grid">
                            <div class="detail-item">
                                <div class="detail-label">Dates de location</div>
                                <div class="detail-value">
                                    <%= reservation.getDateDebut() %> au <%= reservation.getDateFin() %>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Montant total</div>
                                <div class="detail-value">
                                    <%= String.format("%.2f", reservation.getMontantTotal()) %> €
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Numéro de réservation</div>
                                <div class="detail-value">
                                    #<%= reservation.getId() %>
                                </div>
                            </div>
                        </div>
                        
                        <% if (reservation.getStatut().equals("en_attente")) { %>
                            <div style="margin-top: auto; text-align: right;">
                                <form action="CancelReservationServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="reservationId" value="<%= reservation.getId() %>">
                                   
                                </form>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>


    <script>
        // Add any necessary JavaScript here
    </script>
</body>
</html>