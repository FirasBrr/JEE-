package your.package.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import your.package.models.User;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String loginURI = httpRequest.getContextPath() + "/login.jsp";
        String accessDeniedURI = httpRequest.getContextPath() + "/access-denied.jsp";
        
        boolean loggedIn = session != null && session.getAttribute("currentUser") != null;
        boolean isAdmin = false;
        
        if (loggedIn) {
            User user = (User) session.getAttribute("currentUser");
            isAdmin = "admin".equals(user.getRole());
        }

        if (!loggedIn) {
            // Redirect to login page if not logged in
            httpResponse.sendRedirect(loginURI);
        } else if (!isAdmin) {
            // Redirect to access denied if not admin
            httpResponse.sendRedirect(accessDeniedURI);
        } else {
            // User is admin, continue request
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}