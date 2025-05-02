package controlleur;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import DAO.UserDAO;
import DAO.DashboardDAO;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private UserDAO userDAO;
    private DashboardDAO dashboardDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        dashboardDAO = new DashboardDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all statistics
            request.setAttribute("totalUsers", userDAO.getTotalUsers());
            request.setAttribute("adminCount", userDAO.getAdminCount());
            request.setAttribute("agentCount", userDAO.getAgentCount());
            request.setAttribute("visiteurCount", userDAO.getVisiteurCount());
            request.setAttribute("availableCars", dashboardDAO.getAvailableCarsCount());
            request.setAttribute("activeReservations", dashboardDAO.getActiveReservationsCount());
            request.setAttribute("todaysRevenue", dashboardDAO.getTodaysRevenue());
            
            // Forward to dashboard JSP
            request.getRequestDispatcher("/admin/admin.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}