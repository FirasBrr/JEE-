package controlleur;

import DAO.CarDAO;
import models.Car;
import models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/carManagement")
public class CarManagementServlet extends HttpServlet {
    private CarDAO carDAO;

    @Override
    public void init() {
        carDAO = new CarDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null || !"agent".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int carId = Integer.parseInt(request.getParameter("carId"));
                if (!carDAO.isCarOwnedByAgent(carId, user.getId())) {
                    session.setAttribute("error", "Vous ne pouvez supprimer que vos propres voitures");
                    response.sendRedirect("listCars.jsp");
                    return;
                }

                boolean success = carDAO.deleteCar(carId);
                session.setAttribute("message", "Voiture supprimée avec succès");
                response.sendRedirect("listCars.jsp");
            } catch (SQLException e) {
                String errorMessage = e.getMessage().contains("active reservations") ?
                    "Cannot delete car: it has active reservations." :
                    "Erreur lors de la suppression: " + e.getMessage();
                session.setAttribute("error", errorMessage);
                response.sendRedirect("listCars.jsp");
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid car ID.");
                response.sendRedirect("listCars.jsp");
            }
        } else {
            try {
                List<Car> cars = carDAO.getCarsByAgent(user.getId());
                request.setAttribute("cars", cars);
                request.getRequestDispatcher("listCars.jsp").forward(request, response);
            } catch (SQLException e) {
                session.setAttribute("error", "Erreur lors du chargement des voitures");
                response.sendRedirect("listCars.jsp");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null || !"agent".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                Car newCar = new Car();
                newCar.setCarName(request.getParameter("carName"));
                newCar.setCarDescription(request.getParameter("carDescription"));
                newCar.setPricePerDay(Double.parseDouble(request.getParameter("pricePerDay")));
                newCar.setCarType(request.getParameter("carType"));
                newCar.setImageUrl(request.getParameter("imageUrl"));
                newCar.setFuelType(request.getParameter("fuelType"));
                newCar.setSeats(Integer.parseInt(request.getParameter("seats")));
                newCar.setTransmission(request.getParameter("transmission"));

                if (carDAO.addCar(newCar, user.getId())) {
                    session.setAttribute("message", "Voiture ajoutée avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de l'ajout de la voiture");
                }
            } else if ("edit".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("carId"));
                if (!carDAO.isCarOwnedByAgent(carId, user.getId())) {
                    session.setAttribute("error", "Action non autorisée sur cette voiture");
                    response.sendRedirect("listCars.jsp");
                    return;
                }

                Car updatedCar = new Car();
                updatedCar.setId(carId);
                updatedCar.setCarName(request.getParameter("carName"));
                updatedCar.setCarDescription(request.getParameter("carDescription"));
                updatedCar.setPricePerDay(Double.parseDouble(request.getParameter("pricePerDay")));
                updatedCar.setCarType(request.getParameter("carType"));
                updatedCar.setImageUrl(request.getParameter("imageUrl"));
                updatedCar.setFuelType(request.getParameter("fuelType"));
                updatedCar.setSeats(Integer.parseInt(request.getParameter("seats")));
                updatedCar.setTransmission(request.getParameter("transmission"));

                if (carDAO.updateCar(updatedCar)) {
                    session.setAttribute("message", "Voiture mise à jour avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de la mise à jour");
                }
            } else {
                session.setAttribute("error", "Action non reconnue");
            }
        } catch (SQLException e) {
            session.setAttribute("error", "Erreur lors du traitement: " + e.getMessage());
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Format de données invalide");
        }

        response.sendRedirect("listCars.jsp");
    }
}