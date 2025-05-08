package controlleur;

import java.io.*;
import java.nio.file.Path;
import java.sql.*;
import java.util.*;

import DAO.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import models.User;
import utils.DBConnection;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Part;
@WebServlet("/profile")
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
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            User user = userDao.getUserById(userId);
            String creationDate = userDao.getCreationDate(userId);
            
            request.setAttribute("user", user);
            session.setAttribute("creationDate", creationDate);
            
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du profil");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if ("updatePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            
            try {
                boolean success = UserDAO.updatePassword(userId, currentPassword, newPassword);
                if (success) {
                    session.setAttribute("message", "Mot de passe mis à jour avec succès");
                } else {
                    session.setAttribute("error", "Mot de passe actuel incorrect");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                session.setAttribute("error", "Erreur lors de la mise à jour du mot de passe");
            }
        }
        
        response.sendRedirect("profile.jsp");
    }
}