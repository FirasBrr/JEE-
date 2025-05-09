<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
    int totalUsers = 0;
    int agentCount = 0;
    int availableCars = 0;
    int activeReservations = 0;

    try (Connection conn = DBConnection.getConnection()) {
        // Total users
        String totalUsersQuery = "SELECT COUNT(*) FROM users";
        try (PreparedStatement ps = conn.prepareStatement(totalUsersQuery);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalUsers = rs.getInt(1);
        }

        // Agent count
        String agentQuery = "SELECT COUNT(*) FROM users WHERE role = 'agent'";
        try (PreparedStatement ps = conn.prepareStatement(agentQuery);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) agentCount = rs.getInt(1);
        }

        // Available cars/biens
        String biensQuery = "SELECT COUNT(*) FROM biens WHERE disponibilite = 1";
        try (PreparedStatement ps = conn.prepareStatement(biensQuery);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) availableCars = rs.getInt(1);
        }

        // Active reservations (assuming "confirmée" means active)
        String reservationsQuery = "SELECT COUNT(*) FROM reservations WHERE statut = 'confirmée'";
        try (PreparedStatement ps = conn.prepareStatement(reservationsQuery);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) activeReservations = rs.getInt(1);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
%>


<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admindash.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
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
                    <li class="active"><a href="admin.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="users.jsp"><i class="fas fa-users"></i> User Management</a></li>
                    <li><a href="cars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>
                    <li><a href="reservations.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <header class="admin-header">
                <h1>Admin Dashboard</h1>
                <div class="header-actions">
                    <span class="current-date"><%= new java.util.Date() %></span>
                </div>
            </header>
            
            <div class="dashboard-stats">
                <div class="stat-card">
    <div class="stat-icon" style="background-color: #4e73df;">
        <i class="fas fa-users"></i>
    </div>
    <div class="stat-info">
        <h3>Total Users</h3>
        <p><%= totalUsers %></p>
    </div>
</div>

<div class="stat-card">
    <div class="stat-icon" style="background-color: #36b9cc;">
        <i class="fas fa-user-tie"></i>
    </div>
    <div class="stat-info">
        <h3>Agents</h3>
        <p><%= agentCount %></p>
    </div>
</div>

<div class="stat-card">
    <div class="stat-icon" style="background-color: #1cc88a;">
        <i class="fas fa-car"></i>
    </div>
    <div class="stat-info">
        <h3>Available Cars</h3>
        <p><%= availableCars %></p>
    </div>
</div>

   
                
                
            </div>
            
            <div>
                
              <div class="chart-section">
    <h2>System Overview</h2>
    <canvas id="dashboardChart" width="400" height="140"></canvas>
</div>
              
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/resources/script/admindash.js"></script>
    <script>
    const ctx = document.getElementById('dashboardChart').getContext('2d');
    const dashboardChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Total Users', 'Agents', 'Available Cars'],
            datasets: [{
                label: 'Counts',
                data: [<%= totalUsers %>, <%= agentCount %>, <%= availableCars %>],
                backgroundColor: ['#4e73df', '#36b9cc', '#1cc88a'],
                borderColor: ['#4e73df', '#36b9cc', '#1cc88a'],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            }
        }
    });
</script>
    
</body>
</html>