<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Utilisateur - AutoLoc</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Navigation Dropdown Styles */
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
        
        /* Profile Page Styles */
        .profile-container {
   		margin-top: 50px; /* Reduced from 50px to bring it closer to the navbar */
   		 padding: 40px 0;
    	max-width: 800px;
  		  margin-left: auto;
  		  margin-right: auto;
		}
        
        .profile-header {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .user-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .avatar {
            font-size: 60px;
            color: var(--primary-color);
            margin-bottom: 15px;
            text-align: center;
        }
        
        .profile-section {
            margin-top: 30px;
        }
        
        .profile-section h2 {
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .profile-section h2 i {
            width: 30px;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1em;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 25px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .btn-primary {
            background: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background: var(--primary-dark);
        }
        
        .btn-secondary {
            background: #f1f1f1;
            color: var(--dark-color);
        }
        
        .btn-secondary:hover {
            background: #e1e1e1;
        }
        
        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        
        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }
        
        /* Mobile Adaptation */
        @media (max-width: 768px) {
            .profile-container {
                padding: 20px 15px;
            }
            
            .nav-dropdown {
                margin-left: 0;
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
                <li><a href="home.jsp" >Home</a></li>
    <li><a href="#vehicles">Our Cars</a></li>
                <% String username = (String) session.getAttribute("username");
                if (username != null) { %>
                <li class="nav-dropdown">
                    <div class="nav-dropdown-trigger">
                        <span class="btn-user">Bienvenue, <%= username %></span>
                        <i class="fas fa-angle-down"></i>
                    </div>
                    <ul class="nav-dropdown-menu">
                        <li><a href="profile.jsp" class="active"><i class="fas fa-user"></i> Profile</a></li>
                        <li><a href="userreservation.jsp"><i class="fas fa-calendar-alt"></i> Reservations</a></li>
                        <li class="dropdown-divider"></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="logout-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </li>
                <% } else { %>
                <li><a href="${pageContext.request.contextPath}/login.jsp" class="btn-login">Connexion</a></li>
                <% } %>
            </ul>
            <div class="hamburger">
                <i class="fas fa-bars"></i>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="profile-container">
        <div class="profile-header">
            <h1>Profile</h1>
            <p class="welcome-message">Welcome to you profile, <%= username %>.</p>
        </div>

        <div class="user-card">
            <div class="avatar">
                <i class="fas fa-user-circle"></i>
            </div>
            
            <% 
            User user = (User) session.getAttribute("currentUser");
            if (user != null) { 
            %>
<form action="${pageContext.request.contextPath}/updateProfile" method="post" class="profile-form">
    <input type="hidden" name="action" value="updatePassword"> <!-- Add this -->
    <div class="profile-section">
        <h2><i class="fas fa-user"></i> Account information</h2>
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" value="<%= user.getUsername() %>" >
        </div>
    </div>
    <div class="profile-section">
        <h2><i class="fas fa-lock"></i> Account Security</h2>
        <div class="form-group">
            <label for="currentPassword">Actual password</label>
            <input type="password" id="currentPassword" name="currentPassword" required>
        </div>
        <div class="form-group">
            <label for="newPassword">New password</label>
            <input type="password" id="newPassword" name="newPassword" required>
        </div>
        <div class="form-group">
            <label for="confirmPassword">Confirm new password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <div class="form-actions">
            <button type="submit" class="btn btn-primary">Update your password</button>
        </div>
    </div>
</form>
            <% } else { %>
                <div class="alert alert-warning">
                    <p>.</p>
                </div>
            <% } %>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>AutoLoc</h3>
    <p>Your trusted partner for car rental since 2010.</p>
                </div>
                <div class="footer-section">
                    <h3>Liens rapides</h3>
                    <ul>
                        <li><a href="home.jsp">Accueil</a></li>
                        <li><a href="#vehicles">Véhicules</a></li>
                        <li><a href="#services">Services</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <p>123 Rental Street, Tunisia</p>
                    <p>contact@autoloc.tn</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 AutoLoc. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        // Mobile dropdown toggle
        document.addEventListener('DOMContentLoaded', function() {
            const dropdown = document.querySelector('.nav-dropdown');
            const trigger = dropdown.querySelector('.nav-dropdown-trigger');
            
            trigger.addEventListener('click', function(e) {
                if (window.innerWidth <= 768) {
                    const menu = dropdown.querySelector('.nav-dropdown-menu');
                    const isHidden = getComputedStyle(menu).visibility === 'hidden';
                    
                    if (isHidden) {
                        menu.style.opacity = '1';
                        menu.style.visibility = 'visible';
                        menu.style.transform = 'translateY(5px)';
                    } else {
                        menu.style.opacity = '0';
                        menu.style.visibility = 'hidden';
                        menu.style.transform = 'translateY(15px)';
                    }
                }
            });
            
            // Password validation
            document.querySelector('form').addEventListener('submit', function(e) {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert('Les mots de passe ne correspondent pas!');
                }
            });
        });
    </script>
</body>
</html>