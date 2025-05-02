<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>

<%
    // Check if user is logged in and is admin
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admindash.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="admin-profile">
                <img src="${pageContext.request.contextPath}/resources/images/admin-avatar.png" alt="Admin Avatar">
                <h3><%= user.getUsername() %></h3>
                <p>Administrator</p>
            </div>
            
            <nav class="admin-nav">
                <ul>
                    <li class="active"><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="users.jsp"><i class="fas fa-users"></i> User Management</a></li>
                    <li><a href="cars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>
                    <li><a href="reservations.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="#"><i class="fas fa-cog"></i> Settings</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
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
<%= request.getAttribute("totalUsers") %>
       				 </div>
                </div>
                
    
    				<div class="stat-card">
      			  <div class="stat-icon" style="background-color: #36b9cc;">
      			      <i class="fas fa-user-tie"></i>
      			  </div>
      				  <div class="stat-info">
      				      <h3>Agents</h3>
      			      <p>${agentCount}</p>
      				  </div>
    				</div>
    
    				
                
                <div class="stat-card">
                    <div class="stat-icon" style="background-color: #1cc88a;">
                        <i class="fas fa-car"></i>
                    </div>
                      <div class="stat-info">
       				     <h3>Available Cars</h3>
         			   <p>${availableCars}</p>
        			</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="background-color: #f6c23e;">
                        <i class="fas fa-calendar"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Active Reservations</h3>
                        <p>28</p>
                    </div>
                </div>
                
                
            </div>
            
            <div class="dashboard-content">
                <div class="recent-activity">
                    <h2>Recent Activity</h2>
                    <div class="activity-list">
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-user-plus text-success"></i>
                            </div>
                            <div class="activity-details">
                                <p>New user registered - John Doe</p>
                                <small>10 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-car text-primary"></i>
                            </div>
                            <div class="activity-details">
                                <p>New car added - BMW X5</p>
                                <small>1 hour ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-calendar-check text-info"></i>
                            </div>
                            <div class="activity-details">
                                <p>New reservation created</p>
                                <small>2 hours ago</small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="quick-actions">
                    <h2>Quick Actions</h2>
                    <div class="action-buttons">
                        <a href="users.jsp?action=add" class="action-btn">
                            <i class="fas fa-user-plus"></i>
                            <span>Add User</span>
                        </a>
                        <a href="cars.jsp?action=add" class="action-btn">
                            <i class="fas fa-car"></i>
                            <span>Add Car</span>
                        </a>
                        <a href="reservations.jsp?action=add" class="action-btn">
                            <i class="fas fa-calendar-plus"></i>
                            <span>Create Reservation</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/resources/script/admindash.js"></script>
</body>
</html>