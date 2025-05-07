document.addEventListener('DOMContentLoaded', function() {
    // ======================
    // 1. Hero Section Animations
    // ======================
    const initHeroSlideshow = () => {
        const slides = document.querySelectorAll('.hero .slide');
        let currentSlide = 0;
        
        // Show first slide immediately
        slides[currentSlide].classList.add('active');
        
        // Auto-rotate slides every 5 seconds
        const slideInterval = setInterval(() => {
            slides[currentSlide].classList.remove('active');
            currentSlide = (currentSlide + 1) % slides.length;
            slides[currentSlide].classList.add('active');
        }, 5000);
        
        // Pause on hover
        
    };

    // Floating car animations
    const initFloatingCars = () => {
        const cars = document.querySelectorAll('.float-car');
        
        cars.forEach(car => {
            // Hover effects
            car.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-15px) scale(1.1)';
                this.style.filter = 'drop-shadow(0 20px 25px rgba(0,0,0,0.5)) brightness(1.2)';
                this.style.transition = 'all 0.3s ease-out';
            });
            
            car.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
                this.style.filter = 'drop-shadow(0 10px 15px rgba(0,0,0,0.3))';
                this.style.transition = 'all 0.5s ease-in';
            });
            
            // Click effects
            car.addEventListener('click', function() {
                const carType = this.alt.toLowerCase().replace(' ', '-');
                document.querySelector(`#vehicles`).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    };

    // ======================
    // 2. Navigation Effects
    // ======================
    const initNavigation = () => {
        const navLinks = document.querySelectorAll('.nav-links a');
        
        // Smooth scrolling for navigation
        navLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                const targetId = this.getAttribute('href');
                
                if (targetId.startsWith('#')) {
                    const targetSection = document.querySelector(targetId);
                    if (targetSection) {
                        targetSection.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                        
                        // Update URL without page reload
                        history.pushState(null, null, targetId);
                        
                        // Update active nav item
                        navLinks.forEach(item => item.classList.remove('active'));
                        this.classList.add('active');
                    }
                }
            });
        });
        
        // Highlight current section in nav
        window.addEventListener('scroll', () => {
            const scrollPosition = window.scrollY + 100;
            
            document.querySelectorAll('section').forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;
                
                if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                    const id = section.getAttribute('id');
                    navLinks.forEach(link => {
                        link.classList.remove('active');
                        if (link.getAttribute('href') === `#${id}`) {
                            link.classList.add('active');
                        }
                    });
                }
            });
        });
    };

    // ======================
    // 3. Scroll Animations
    // ======================
    const initScrollAnimations = () => {
        const animateOnScroll = () => {
            const elements = document.querySelectorAll('.vehicle-card, .service-card, .animate-on-scroll');
            
            elements.forEach(element => {
                const elementPosition = element.getBoundingClientRect().top;
                const screenPosition = window.innerHeight / 1.2;
                
                if (elementPosition < screenPosition) {
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }
            });
        };
        
        // Set initial state
        document.querySelectorAll('.vehicle-card, .service-card, .animate-on-scroll').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'all 0.6s ease';
        });
        
        window.addEventListener('scroll', animateOnScroll);
        animateOnScroll(); // Run once on load
    };

    // ======================
    // 4. Vehicle Card Effects
    // ======================
    const initVehicleCards = () => {
        const cards = document.querySelectorAll('.vehicle-card');
        
        cards.forEach(card => {
            // Hover effect
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-10px) scale(1.02)';
                this.querySelector('img').style.transform = 'scale(1.05)';
                this.querySelector('.btn-secondary').style.backgroundColor = 'var(--primary-color)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
                this.querySelector('img').style.transform = 'scale(1)';
                this.querySelector('.btn-secondary').style.backgroundColor = 'var(--dark-color)';
            });
            
            // Click effect
            card.addEventListener('click', function(e) {
                if (!e.target.classList.contains('btn-secondary')) {
                    this.querySelector('.btn-secondary').click();
                }
            });
        });
    };

    // ======================
    // 5. Booking Form Validation
    // ======================
    const initForms = () => {
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                this.querySelectorAll('[required]').forEach(input => {
                    if (!input.value.trim()) {
                        input.classList.add('error');
                        isValid = false;
                    } else {
                        input.classList.remove('error');
                    }
                });
                
                if (!isValid) {
                    e.preventDefault();
                    const errorMessage = document.createElement('div');
                    errorMessage.className = 'form-error-message';
                    errorMessage.textContent = 'Veuillez remplir tous les champs obligatoires';
                    errorMessage.style.color = 'var(--danger-color)';
                    errorMessage.style.marginTop = '10px';
                    
                    const existingError = this.querySelector('.form-error-message');
                    if (existingError) {
                        existingError.remove();
                    }
                    
                    this.appendChild(errorMessage);
                }
            });
            
            // Real-time validation
            form.querySelectorAll('input, select, textarea').forEach(input => {
                input.addEventListener('input', function() {
                    if (this.value.trim()) {
                        this.classList.remove('error');
                    }
                });
            });
        });
    };

    // ======================
    // 6. Scroll Down Indicator
    // ======================
    const initScrollIndicator = () => {
        const scrollDown = document.querySelector('.scroll-down');
        if (scrollDown) {
            scrollDown.addEventListener('click', () => {
                window.scrollTo({
                    top: window.innerHeight,
                    behavior: 'smooth'
                });
            });
            
            // Hide when scrolled
            window.addEventListener('scroll', () => {
                if (window.scrollY > 100) {
                    scrollDown.style.opacity = '0';
                    scrollDown.style.visibility = 'hidden';
                } else {
                    scrollDown.style.opacity = '1';
                    scrollDown.style.visibility = 'visible';
                }
            });
        }
    };

    // ======================
    // Initialize All Functions
    // ======================
    initHeroSlideshow();
    initFloatingCars();
    initNavigation();
    initScrollAnimations();
    initVehicleCards();
    initForms();
    initScrollIndicator();

    // ======================
    // Utility Functions
    // ======================
    // Debounce function for scroll events
    function debounce(func, wait = 10, immediate = true) {
        let timeout;
        return function() {
            const context = this, args = arguments;
            const later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            const callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    }
});