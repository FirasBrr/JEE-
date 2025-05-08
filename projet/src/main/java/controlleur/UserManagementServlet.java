package controlleur;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAO.UserDAO;
import models.User;

@WebServlet("/userManagement")
public class UserManagementServlet extends HttpServlet {
    private UserDAO userDao;

    @Override
    public void init() {
        userDao = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            // Retrieve all users and forward to users.jsp
            request.setAttribute("users", userDao.getAllUsers());
            request.getRequestDispatcher("/users.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors du chargement des utilisateurs");
            response.sendRedirect("admin/users.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        Integer currentUserId = (Integer) session.getAttribute("userId");

        try {
            if ("add".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");
                User newUser = new User(0, username, password, role);
                if (userDao.register(newUser)) {
                    session.setAttribute("message", "Utilisateur ajouté avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de l'ajout de l'utilisateur");
                }
            } else if ("edit".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");
                if (userDao.updateUser(userId, username, password, role)) {
                    session.setAttribute("message", "Utilisateur mis à jour avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la mise à jour de l'utilisateur");
                }
            } else if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                if (userId == currentUserId) {
                    session.setAttribute("error", "Vous ne pouvez pas supprimer votre propre compte");
                } else if (userDao.deleteUser(userId)) {
                    session.setAttribute("message", "Utilisateur supprimé avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la suppression de l'utilisateur");
                }
            } else {
                session.setAttribute("error", "Action non reconnue");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors du traitement de la requête");
        }

        response.sendRedirect("admin/users.jsp");
    }
}