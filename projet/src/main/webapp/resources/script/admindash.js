document.addEventListener('DOMContentLoaded', function() {
    // Sidebar active link highlighting
    const currentPage = window.location.pathname.split('/').pop();
    const navLinks = document.querySelectorAll('.admin-nav a');
    
    navLinks.forEach(link => {
        const linkHref = link.getAttribute('href');
        if (linkHref === currentPage) {
            link.parentElement.classList.add('active');
        } else {
            link.parentElement.classList.remove('active');
        }
    });
    
    // Notification badge click
    const notificationBadge = document.querySelector('.notification-badge');
    if (notificationBadge) {
        notificationBadge.addEventListener('click', function() {
            alert('You have 3 new notifications');
        });
    }
    
    // Dynamic date display
    function updateCurrentDate() {
        const dateElement = document.querySelector('.current-date');
        if (dateElement) {
            const now = new Date();
            const options = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            };
            dateElement.textContent = now.toLocaleDateString('en-US', options);
        }
    }
    
    updateCurrentDate();
    setInterval(updateCurrentDate, 60000); // Update every minute
    
    // Card hover effects
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.boxShadow = '0 5px 15px rgba(0, 0, 0, 0.1)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.boxShadow = '0 0 10px rgba(0, 0, 0, 0.05)';
        });
    });
    
    // Quick action button effects
    const actionButtons = document.querySelectorAll('.action-btn');
    actionButtons.forEach(button => {
        button.addEventListener('mouseenter', function() {
            const icon = this.querySelector('i');
            icon.style.transform = 'scale(1.2)';
        });
        
        button.addEventListener('mouseleave', function() {
            const icon = this.querySelector('i');
            icon.style.transform = 'scale(1)';
        });
    });
});