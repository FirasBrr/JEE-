package controlleur;


import DAO.CarDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import java.io.IOException;

@WebServlet(name = "DeleteCarServlet", urlPatterns = {"/DeleteCarServlet"})
public class DeleteCarServlet extends HttpServlet {
    private CarDAO carDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.carDao = new CarDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null || !"agent".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int carId = Integer.parseInt(request.getParameter("carId"));
            
            if (!carDao.isCarOwnedByAgent(carId, currentUser.getId())) {
                session.setAttribute("error", "You don't have permission to delete this car.");
                response.sendRedirect(request.getContextPath() + "/listCars.jsp");
                return;
            }

            if (carDao.deleteCar(carId)) {
                session.setAttribute("message", "Car deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete car. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error deleting car: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/listCars.jsp");
    }
}