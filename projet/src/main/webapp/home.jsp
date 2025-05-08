<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AutoLoc - Car Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>/* Minimal User Dropdown */
/* User Dropdown - Matches Nav Style */
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
}</style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="#" class="logo">Auto<span>Loc</span></a>
            <ul class="nav-links">
    <li><a href="home.jsp" class="active">Home</a></li>
    <li><a href="#vehicles">Our Cars</a></li>
    <li><a href="#services">Services</a></li>
                 <% String username = (String) session.getAttribute("username");
    if (username != null) { %>



     <li class="nav-dropdown">
    <div class="nav-dropdown-trigger">
        <span class="btn-user">Welcome, <%= username %></span>
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
<li><a href="${pageContext.request.contextPath}/login.jsp" class="btn-login">Login</a></li>

<%
    }
%>

            </ul>
            <div class="hamburger">
                <i class="fas fa-bars"></i>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero" id="home">
    <!-- Background Slideshow -->
    <div class="hero-slideshow">
        <div class="slide active" style="background-image: url('resources/img/bg2.avif');"></div>
        <div class="slide" style="background-image: url('resources/img/bg4.webp');"></div>
    </div>
    
    <div class="container">
        <div class="hero-content">
            <h1 class="animate-text">Rent your dream car</h1>
            <p class="animate-text" data-delay="0.2s">Discover our wide selection of vehicles at competitive prices</p>
            <a href="#vehicles" class="btn-primary animate-pop" data-delay="0.4s">View our vehicles</a>
        </div>
        
        <!-- Featured Cars Floating Animation -->
        <div class="featured-cars">
            <img src="resources/img/carousel-1.png" class="float-car car-1" alt="Luxury Car">
            <img src="resources/img/carousel-2.png" class="float-car car-2" alt="SUV">
        </div>
    </div>
    
    <!-- Scroll Down Indicator -->
    <div class="scroll-down">
        <span></span>
        <span></span>
        <span></span>
    </div>
</section>

    <!-- Vehicle Showcase -->
    <section class="vehicles" id="vehicles">
        <div class="container">
            <h2 class="section-title">Our Cars</h2>
            <div class="vehicle-grid">
                <div class="vehicle-card">
                    <img src="resources/img/Suzuki-Celerio.jpg" alt="Voiture Économique">
                    <h3>Economy Car</h3>
                    <div class="vehicle-info">
                        <span><i class="fas fa-gas-pump"></i> Gasoline</span>
                        <span><i class="fas fa-users"></i> 5 seats</span>
                        <span><i class="fas fa-cogs"></i> Manual</span>
                    </div>
                    <p class="price">From 35€/day</p>
    <a href="caruserlist.jsp?vehicle=economique" class="btn-secondary">Book Now</a>
                </div>
                
                <div class="vehicle-card">
                    <img src="resources/img/Skoda Kodiaq.jpg" alt="SUV Familial">
                    <h3>Family SUV</h3>
                    <div class="vehicle-info">
                        <span><i class="fas fa-gas-pump"></i> Diesel</span>
                        <span><i class="fas fa-users"></i> 7 seats</span>
                        <span><i class="fas fa-cogs"></i> Automatic</span>
                    </div>
                    <p class="price">From 65€/day</p>
                    <a href="caruserlist.jsp?vehicle=economique" class="btn-secondary">Book Now</a>
                </div>
                
                <div class="vehicle-card">
                    <img src="resources/img/Ferrari F8 Spider.jpg" alt="Voiture de Luxe">
                    <h3>Luxury Car</h3>
                    <div class="vehicle-info">
                        <span><i class="fas fa-gas-pump"></i> Gasoline</span>
                        <span><i class="fas fa-users"></i> 2 seats</span>
                        <span><i class="fas fa-cogs"></i> Automatic</span>
                    </div>
                    <p class="price">From 120€/day</p>
                    <a href="caruserlist.jsp" class="btn-secondary">Book Now</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section class="services" id="services">
        <div class="container">
            <h2 class="section-title">Our Services</h2>
<div class="service-grid">
    <div class="service-card">
        <i class="fas fa-shield-alt"></i>
        <h3>Full Insurance</h3>
        <p>Maximum protection for your peace of mind</p>
    </div>
    <div class="service-card">
        <i class="fas fa-road"></i>
        <h3>Unlimited Mileage</h3>
        <p>Drive without worrying about distance</p>
    </div>
    <div class="service-card">
        <i class="fas fa-clock"></i>
        <h3>24/7 Service</h3>
        <p>Assistance available anytime</p>
    </div>
</div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
    <h3>AutoLoc</h3>
    <p>Your trusted partner for car rental since 2010.</p>
</div>
<div class="footer-section">
    <h3>Quick Links</h3>
    <ul>
        <li><a href="home.jsp">Home</a></li>
        <li><a href="#vehicles">Vehicles</a></li>
        <li><a href="#services">Services</a></li>

    </ul>
</div>
<div class="footer-section">
    <h3>Contact Us</h3>
    <p><i class="fas fa-map-marker-alt"></i> 123 Rental Street, Tunisia</p>
    <p><i class="fas fa-phone"></i> +216 55 555 555</p>
    <p><i class="fas fa-envelope"></i> contact@autoloc.tn</p>
</div>
<div class="footer-bottom">
    <p>&copy; 2025 AutoLoc. All rights reserved.</p>
</div>
        </div>
</div>    </footer>
<script>
document.querySelectorAll('.reserve-btn').forEach(btn => {
    btn.addEventListener('click', function(e) {
        e.preventDefault();
        const vehicleType = this.getAttribute('data-vehicle');
        
        // Load the reservation form via AJAX
        fetch(`reserver.jsp?vehicle=${vehicleType}`)
            .then(response => response.text())
            .then(html => {
                document.getElementById('reservationContainer').innerHTML = html;
                // Scroll to the form
                document.getElementById('reservationContainer').scrollIntoView({
                    behavior: 'smooth'
                });
            });
    });
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
<script src="resources/script/home.js"></script>
    
</body>
</html>