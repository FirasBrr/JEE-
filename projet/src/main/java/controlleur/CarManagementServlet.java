package controlleur;

import DAO.CarDAO;
import models.Car;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/carManagement")
public class CarManagementServlet extends HttpServlet {
    private CarDAO carDao;

    @Override
    public void init() {
        carDao = new CarDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer agentId = (Integer) session.getAttribute("userId");

        try {
            List<Car> cars = carDao.getCarsByAgent(agentId);
            request.setAttribute("cars", cars);
            request.getRequestDispatcher("/agent/cars.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors du chargement des voitures");
            response.sendRedirect("agent/cars.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        Integer agentId = (Integer) session.getAttribute("userId");

        try {
            if ("add".equals(action)) {
                Car newCar = new Car();
                newCar.setCarName(request.getParameter("car_name"));
                newCar.setCarDescription(request.getParameter("car_description"));
                newCar.setPricePerDay(Double.parseDouble(request.getParameter("price_per_day")));
                newCar.setCarType(request.getParameter("car_type"));
                newCar.setImageUrl(request.getParameter("image_url"));
                newCar.setFuelType(request.getParameter("fuel_type"));
                newCar.setSeats(Integer.parseInt(request.getParameter("seats")));
                newCar.setTransmission(request.getParameter("transmission"));

                if (carDao.addCar(newCar, agentId)) {
                    session.setAttribute("message", "Voiture ajoutée avec succès");
                } else {
                    session.setAttribute("error", "Erreur lors de l'ajout de la voiture");
                }

            } else if ("edit".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("car_id"));
                if (carDao.isCarOwnedByAgent(carId, agentId)) {
                    Car updatedCar = new Car();
                    updatedCar.setId(carId);
                    updatedCar.setCarName(request.getParameter("car_name"));
                    updatedCar.setCarDescription(request.getParameter("car_description"));
                    updatedCar.setPricePerDay(Double.parseDouble(request.getParameter("price_per_day")));
                    updatedCar.setCarType(request.getParameter("car_type"));
                    updatedCar.setImageUrl(request.getParameter("image_url"));
                    updatedCar.setFuelType(request.getParameter("fuel_type"));
                    updatedCar.setSeats(Integer.parseInt(request.getParameter("seats")));
                    updatedCar.setTransmission(request.getParameter("transmission"));

                    if (carDao.updateCar(updatedCar)) {
                        session.setAttribute("message", "Voiture mise à jour avec succès");
                    } else {
                        session.setAttribute("error", "Erreur lors de la mise à jour");
                    }
                } else {
                    session.setAttribute("error", "Action non autorisée sur cette voiture");
                }

            } else if ("delete".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("car_id"));
                if (carDao.isCarOwnedByAgent(carId, agentId)) {
                    if (carDao.deleteCar(carId)) {
                        session.setAttribute("message", "Voiture supprimée avec succès");
                    } else {
                        session.setAttribute("error", "Erreur lors de la suppression");
                    }
                } else {
                    session.setAttribute("error", "Vous ne pouvez supprimer que vos propres voitures");
                }

            } else {
                session.setAttribute("error", "Action non reconnue");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors du traitement de la requête");
        }

        response.sendRedirect("listCars.jsp");
    }
}
