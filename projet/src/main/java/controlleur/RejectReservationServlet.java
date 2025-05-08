package controlleur;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import utils.DBConnection;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RejectReservationServlet")
public class RejectReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in as agent
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("currentUser");
        if (user == null || !"agent".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        int agentId = user.getId();

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            
            // First verify this reservation is for a car belonging to this agent
            String verifySql = "SELECT b.id FROM reservations r " +
                             "JOIN biens b ON r.id_bien = b.id " +
                             "WHERE r.id = ? AND b.agent_id = ?";
            ps = conn.prepareStatement(verifySql);
            ps.setInt(1, reservationId);
            ps.setInt(2, agentId);
            ResultSet rs = ps.executeQuery();
            
            if (!rs.next()) {
                // Not authorized or reservation doesn't exist
                session.setAttribute("errorMessage", "Unauthorized action or reservation not found");
                response.sendRedirect("reservation.jsp");
                return;
            }

            // Update the reservation status
            String updateSql = "UPDATE reservations SET statut = 'annulée' WHERE id = ?";
            ps = conn.prepareStatement(updateSql);
            ps.setInt(1, reservationId);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                session.setAttribute("successMessage", "Reservation rejected successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to reject reservation");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("reservation.jsp");
    }
}