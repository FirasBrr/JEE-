package controlleur;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import utils.DBConnection;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ConfirmReservationServlet")
public class ConfirmReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("currentUser");
        if (user == null || !"agent".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        int agentId = user.getId();
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            
            // First verify this reservation is for a car belonging to this agent
            String verifySql = "SELECT r.montant_total, b.agent_id " +
                             "FROM reservations r " +
                             "JOIN biens b ON r.id_bien = b.id " +
                             "WHERE r.id = ? AND b.agent_id = ?";
            stmt = conn.prepareStatement(verifySql);
            stmt.setInt(1, reservationId);
            stmt.setInt(2, agentId);
            ResultSet rs = stmt.executeQuery();
            
            if (!rs.next()) {
                session.setAttribute("errorMessage", "Unauthorized action or reservation not found");
                response.sendRedirect("reservation.jsp");
                return;
            }

            // Get the reservation amount
            double reservationAmount = rs.getDouble("montant_total");
            
            // Update the reservation status
            String updateSql = "UPDATE reservations SET statut = 'confirmée' WHERE id = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setInt(1, reservationId);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Update the agent's revenue in a separate table (you'll need to create this)
                String updateRevenueSql = "UPDATE agent_stats SET total_revenue = total_revenue + ? WHERE agent_id = ?";
                stmt = conn.prepareStatement(updateRevenueSql);
                stmt.setDouble(1, reservationAmount);
                stmt.setInt(2, agentId);
                stmt.executeUpdate();
                
                session.setAttribute("successMessage", "Reservation confirmed successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to confirm reservation");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("reservation.jsp");
    }
}