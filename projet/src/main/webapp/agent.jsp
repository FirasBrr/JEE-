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

    int agentId = user.getId();
    int totalCars = 0;
    double totalRevenue = 0.0;

    Connection connection = DBConnection.getConnection();
    if (connection != null) {
        try {
            // Query to get the count of cars added by this agent
            String countCarsQuery = "SELECT COUNT(*) FROM biens WHERE agent_id = ?";
            PreparedStatement countCarsStmt = connection.prepareStatement(countCarsQuery);
            countCarsStmt.setInt(1, agentId);
            ResultSet countCarsResult = countCarsStmt.executeQuery();
            if (countCarsResult.next()) {
                totalCars = countCarsResult.getInt(1);
            }

            // NEW: Query to get the total revenue from CONFIRMED reservations
            String totalRevenueQuery = "SELECT COALESCE(SUM(r.montant_total), 0) " +
                                     "FROM reservations r " +
                                     "JOIN biens b ON r.id_bien = b.id " +
                                     "WHERE b.agent_id = ? AND r.statut = 'confirmée'";
            PreparedStatement totalRevenueStmt = connection.prepareStatement(totalRevenueQuery);
            totalRevenueStmt.setInt(1, agentId);
            ResultSet totalRevenueResult = totalRevenueStmt.executeQuery();
            if (totalRevenueResult.next()) {
                totalRevenue = totalRevenueResult.getDouble(1);
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Agent Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/agentdash.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
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
                    <li class="active"><a href="agent.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="addCar.jsp"><i class="fas fa-car"></i> Add Car</a></li>
                     <li><a href="listCars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>       
                    <li><a href="reservation.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <header class="agent-header">
                <h1>Welcome to your Agent Dashboard</h1>
            </header>

            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-icon" style="background-color: #4e73df;">
                        <i class="fas fa-car"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Cars</h3>
                        <p><%= totalCars %></p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon" style="background-color: #36b9cc;">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Revenue</h3>
                        <p><%= totalRevenue %> €</p> <!-- Assuming the currency is in Euros -->
                    </div>
                </div>
            </div>
            <div class="chart-section">
    <h2>Total Cars and Total Revenue</h2>
    <canvas id="agentChart" width="400" height="140"></canvas>
</div>
            
        </div>
    </div>
<script>
    // Prepare data from your server
    const totalCars = <%= totalCars %>;
    const totalRevenue = <%= totalRevenue %>;

    // Create separate y-axes for each dataset
    var ctx = document.getElementById('agentChart').getContext('2d');
    var agentChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Total Cars', 'Total Revenue'],
            datasets: [
                {
                    label: 'Total Cars',
                    data: [totalCars, null], // Only show in first bar
                    backgroundColor: '#4e73df',
                    borderColor: '#4e73df',
                    borderWidth: 1,
                    yAxisID: 'y-axis-cars'
                },
                {
                    label: 'Total Revenue (€)',
                    data: [null, totalRevenue], // Only show in second bar
                    backgroundColor: '#1cc88a',
                    borderColor: '#1cc88a',
                    borderWidth: 1,
                    yAxisID: 'y-axis-revenue'
                }
            ]
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    stacked: false
                },
                'y-axis-cars': {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    title: {
                        display: true,
                        text: 'Number of Cars'
                    },
                    ticks: {
                        beginAtZero: true,
                        stepSize: 1 // Ensures whole numbers for car count
                    }
                },
                'y-axis-revenue': {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    title: {
                        display: true,
                        text: 'Revenue (€)'
                    },
                    grid: {
                        drawOnChartArea: false // only show the grid for left axis
                    },
                    ticks: {
                        beginAtZero: true,
                        callback: function(value) {
                            return '€' + value.toLocaleString(); // Format as currency
                        }
                    }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            if (context.datasetIndex === 0) {
                                label += context.raw; // Cars - just show number
                            } else {
                                label += '€' + context.raw.toLocaleString(); // Revenue - format as currency
                            }
                            return label;
                        }
                    }
                },
                legend: {
                    position: 'top',
                }
            }
        }
    });
</script>

    <script src="${pageContext.request.contextPath}/resources/script/admindash.js"></script>
</body>
</html>
