<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.User" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Utilisateur - AutoLoc</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
        /* Add profile-specific styles here */
        .profile-container {
            padding: 40px 0;
        }
        
        .profile-header {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .profile-content {
            display: flex;
            gap: 30px;
        }
        
        .profile-sidebar {
            flex: 0 0 250px;
        }
        
        .profile-details {
            flex: 1;
        }
        
        .user-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            text-align: center;
            margin-bottom: 20px;
        }
        
        .avatar {
            font-size: 60px;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        
        .member-since {
            color: #666;
            font-size: 0.9em;
        }
        
        .profile-menu ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .profile-menu li a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 15px;
            color: var(--dark-color);
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.2s;
        }
        
        .profile-menu li a:hover, 
        .profile-menu li.active a {
            background: var(--primary-light);
            color: var(--primary-color);
        }
        
        .profile-menu li a i {
            width: 20px;
            text-align: center;
        }
        
        .profile-section {
            background: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        
        .profile-form .form-group {
            margin-bottom: 20px;
        }
        
        .profile-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .profile-form input,
        .profile-form textarea {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1em;
        }
        
        .profile-form textarea {
            min-height: 100px;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 25px;
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
        
        @media (max-width: 768px) {
            .profile-content {
                flex-direction: column;
            }
            
            .profile-sidebar {
                flex: 1;
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
                <li><a href="#home">Accueil</a></li>
                <li><a href="#vehicles">Nos Véhicules</a></li>
                <li><a href="#services">Services</a></li>
                <li><a href="#about">À Propos</a></li>
                <li><a href="#contact">Contact</a></li>
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
        <div class="container">
            <div class="profile-header">
                <h1>Mon Profil</h1>
                <p class="welcome-message">Bienvenue dans votre espace personnel, <%= username %>.</p>
            </div>

            <div class="profile-content">
                <!-- Profile Sidebar -->
                <aside class="profile-sidebar">
                    <div class="user-card">
                        <div class="avatar">
                            <i class="fas fa-user-circle"></i>
                        </div>
                        <h3><%= username %></h3>
                      
                    </div>

                    <nav class="profile-menu">
                        <ul>
                            <li class="active"><a href="#account-info"><i class="fas fa-user"></i> Informations du Compte</a></li>
                            <li><a href="#security"><i class="fas fa-lock"></i> Sécurité</a></li>
                        </ul>
                    </nav>
                </aside>

                <!-- Profile Details -->
                <div class="profile-details">
                    <section id="account-info" class="profile-section">
                        <h2><i class="fas fa-user"></i> Informations du Compte</h2>
                        
                        <% 
                        User user = (User) session.getAttribute("user");
                        if (user != null) { 
                        %>
                        <form action="${pageContext.request.contextPath}/updateProfile" method="post" class="profile-form">
                            <div class="form-group">
                                <label for="username">Nom d'utilisateur</label>
                                <input type="text" id="username" name="username" value="<%= user.getUsername() %>" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="role">Rôle</label>
                                <input type="text" id="role" name="role" value="<%= user.getRole() %>" readonly>
                            </div>
                            
                            <div class="form-actions">
                                <button type="button" class="btn btn-primary" onclick="showEditForm()">Modifier le mot de passe</button>
                            </div>
                        </form>
                        <% }  %>
                    </section>

                    <section id="security" class="profile-section" style="display: none;">
                        <h2><i class="fas fa-lock"></i> Changer le mot de passe</h2>
                        <form action="${pageContext.request.contextPath}/updatePassword" method="post" class="profile-form">
                            <div class="form-group">
                                <label for="currentPassword">Mot de passe actuel</label>
                                <input type="password" id="currentPassword" name="currentPassword" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="newPassword">Nouveau mot de passe</label>
                                <input type="password" id="newPassword" name="newPassword" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="confirmPassword">Confirmer le nouveau mot de passe</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">Mettre à jour</button>
                                <button type="button" class="btn btn-secondary" onclick="hideEditForm()">Annuler</button>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>AutoLoc</h3>
                    <p>Location de voitures pour tous vos besoins de voyage.</p>
                </div>
                <div class="footer-section">
                    <h3>Liens rapides</h3>
                    <ul>
                        <li><a href="#home">Accueil</a></li>
                        <li><a href="#vehicles">Véhicules</a></li>
                        <li><a href="#services">Services</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact</h3>
                    <p>Email: contact@autoloc.com</p>
                    <p>Téléphone: +33 1 23 45 67 89</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2023 AutoLoc. Tous droits réservés.</p>
            </div>
        </div>
    </footer>

    <script>
        function showEditForm() {
            document.getElementById('account-info').style.display = 'none';
            document.getElementById('security').style.display = 'block';
        }
        
        function hideEditForm() {
            document.getElementById('security').style.display = 'none';
            document.getElementById('account-info').style.display = 'block';
        }
        
        // Simple password match validation
        document.querySelector('form[action*="updatePassword"]').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Les mots de passe ne correspondent pas!');
            }
        });
    </script>
    <script>
document.addEventListener('DOMContentLoaded', function() {
    const dropdown = document.querySelector('.nav-dropdown');
    const trigger = dropdown.querySelector('.nav-dropdown-trigger');
    
    // Toggle on click for mobile
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
    
    // Close when clicking outside
    document.addEventListener('click', function(e) {
        if (!dropdown.contains(e.target)) {
            const menu = dropdown.querySelector('.nav-dropdown-menu');
            menu.style.opacity = '0';
            menu.style.visibility = 'hidden';
            menu.style.transform = 'translateY(15px)';
        }
    });
});
</script>
</body>
</html>