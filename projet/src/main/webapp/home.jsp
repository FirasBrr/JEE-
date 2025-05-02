<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoLoc - Location de Voitures</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container">
            <a href="#" class="logo">Auto<span>Loc</span></a>
            <ul class="nav-links">
                <li><a href="#home" class="active">Accueil</a></li>
                <li><a href="#vehicles">Nos Véhicules</a></li>
                <li><a href="#services">Services</a></li>
                <li><a href="#about">À Propos</a></li>
                <li><a href="#contact">Contact</a></li>
                <li><a href="login.jsp" class="btn-login">Connexion</a></li>
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
            <h1 class="animate-text">Louez la voiture de vos rêves</h1>
            <p class="animate-text" data-delay="0.2s">Découvrez notre large sélection de véhicules à des prix compétitifs</p>
            <a href="#vehicles" class="btn-primary animate-pop" data-delay="0.4s">Voir nos véhicules</a>
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
            <h2 class="section-title">Nos Véhicules</h2>
            <div class="vehicle-grid">
                <div class="vehicle-card">
                    <img src="resources/img/Suzuki-Celerio.jpg" alt="Voiture Économique">
                    <h3>Voiture Économique</h3>
                    <div class="vehicle-info">
                        <span><i class="fas fa-gas-pump"></i> Essence</span>
                        <span><i class="fas fa-users"></i> 5 places</span>
                        <span><i class="fas fa-cogs"></i> Manuel</span>
                    </div>
                    <p class="price">À partir de 35€/jour</p>
                    <a href="#" class="btn-secondary">Réserver</a>
                </div>
                
                <div class="vehicle-card">
                    <img src="resources/img/Skoda Kodiaq.jpg" alt="SUV Familial">
                    <h3>SUV Familial</h3>
                    <div class="vehicle-info">
                        <span><i class="fas fa-gas-pump"></i> Diesel</span>
                        <span><i class="fas fa-users"></i> 7 places</span>
                        <span><i class="fas fa-cogs"></i> Automatique</span>
                    </div>
                    <p class="price">À partir de 65€/jour</p>
                    <a href="#" class="btn-secondary">Réserver</a>
                </div>
                
                <div class="vehicle-card">
                    <img src="resources/img/Ferrari F8 Spider.jpg" alt="Voiture de Luxe">
                    <h3>Voiture de Luxe</h3>
                    <div class="vehicle-info">
                        <span><i class="fas fa-gas-pump"></i> Essence</span>
                        <span><i class="fas fa-users"></i> 2 places</span>
                        <span><i class="fas fa-cogs"></i> Automatique</span>
                    </div>
                    <p class="price">À partir de 120€/jour</p>
                    <a href="#" class="btn-secondary">Réserver</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section class="services" id="services">
        <div class="container">
            <h2 class="section-title">Nos Services</h2>
            <div class="service-grid">
                <div class="service-card">
                    <i class="fas fa-shield-alt"></i>
                    <h3>Assurance Complète</h3>
                    <p>Protection maximale pour votre tranquillité d'esprit</p>
                </div>
                <div class="service-card">
                    <i class="fas fa-road"></i>
                    <h3>Kilométrage Illimité</h3>
                    <p>Conduisez sans vous soucier des kilomètres parcourus</p>
                </div>
                <div class="service-card">
                    <i class="fas fa-clock"></i>
                    <h3>Service 24/7</h3>
                    <p>Assistance disponible à tout moment</p>
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
                    <p>Votre partenaire de confiance pour la location de véhicules depuis 2010.</p>
                </div>
                <div class="footer-section">
                    <h3>Liens Rapides</h3>
                    <ul>
                        <li><a href="#home">Accueil</a></li>
                        <li><a href="#vehicles">Véhicules</a></li>
                        <li><a href="#services">Services</a></li>
                        <li><a href="#contact">Contact</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contactez-nous</h3>
                    <p><i class="fas fa-map-marker-alt"></i> 123 Rue de la Location, Paris</p>
                    <p><i class="fas fa-phone"></i> +33 1 23 45 67 89</p>
                    <p><i class="fas fa-envelope"></i> contact@autoloc.fr</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2023 AutoLoc. Tous droits réservés.</p>
            </div>
        </div>
    </footer>

    <script src="resources/script/home.js"></script>
</body>
</html>