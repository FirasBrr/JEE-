package controlleur;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import DAO.UserDAO;
import models.User;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/updateProfile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDao;

    @Override
    public void init() {
        userDao = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");

        if (userId == null || username == null) {
            session.setAttribute("error", "Veuillez vous connecter pour accéder à votre profil.");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            User user = userDao.getUserById(userId);
            String creationDate = userDao.getCreationDate(userId);

            session.setAttribute("currentUser", user); // Use session to store user
            session.setAttribute("creationDate", creationDate);

            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors du chargement du profil");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            session.setAttribute("error", "Veuillez vous connecter pour modifier votre profil.");
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("updatePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate passwords
            if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "Les nouveaux mots de passe ne correspondent pas.");
                response.sendRedirect("profile.jsp");
                return;
            }

            try {
                boolean success = userDao.updatePassword(userId, currentPassword, newPassword);
                if (success) {
                    session.setAttribute("message", "Mot de passe mis à jour avec succès.");
                } else {
                    session.setAttribute("error", "Mot de passe actuel incorrect.");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                session.setAttribute("error", "Erreur lors de la mise à jour du mot de passe.");
            }
        } else {
            session.setAttribute("error", "Action non reconnue.");
        }

        response.sendRedirect("login.jsp"); // Redirect to profile.jsp to show messages
    }
}