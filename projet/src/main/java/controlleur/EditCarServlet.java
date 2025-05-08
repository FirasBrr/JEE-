package controlleur;

import DAO.CarDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import models.Car;
import models.User;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "EditCarServlet", urlPatterns = {"/EditCarServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class EditCarServlet extends HttpServlet {
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
                session.setAttribute("error", "You don't have permission to edit this car.");
                response.sendRedirect(request.getContextPath() + "/listCars.jsp");
                return;
            }

            String imageUrl = request.getParameter("imageUrl");
            Part filePart = request.getPart("imageFile");
            
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + File.separator + fileName);
                imageUrl = request.getContextPath() + "/uploads/" + fileName;
            }

            Car car = new Car();
            car.setId(carId);
            car.setCarName(request.getParameter("carName"));
            car.setCarDescription(request.getParameter("carDescription"));
            car.setPricePerDay(Double.parseDouble(request.getParameter("pricePerDay")));
            car.setCarType(request.getParameter("carType"));
            car.setFuelType(request.getParameter("fuelType"));
            car.setSeats(Integer.parseInt(request.getParameter("seats")));
            car.setTransmission(request.getParameter("transmission"));
            car.setImageUrl(imageUrl);

            if (carDao.updateCar(car)) {
                session.setAttribute("message", "Car updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update car. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error updating car: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/listCars.jsp");
    }
}