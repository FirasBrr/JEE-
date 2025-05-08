package controlleur;

import DAO.ReservationDAO;
import models.Reservation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int carId = Integer.parseInt(request.getParameter("carId"));
            double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
            String dateDebutStr = request.getParameter("dateDebut");
            String dateFinStr = request.getParameter("dateFin");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateDebut = sdf.parse(dateDebutStr);
            Date dateFin = sdf.parse(dateFinStr);

            long diff = (dateFin.getTime() - dateDebut.getTime()) / (1000 * 60 * 60 * 24);
            double montantTotal = pricePerDay * diff;

            int userId = (int) request.getSession().getAttribute("userId");

            Reservation reservation = new Reservation();
            reservation.setUserId(userId);
            reservation.setCarId(carId);
            reservation.setDateDebut(dateDebut);
            reservation.setDateFin(dateFin);
            reservation.setMontantTotal(montantTotal);
            reservation.setStatut("en_attente");

            ReservationDAO dao = new ReservationDAO();
            dao.insertReservation(reservation);

            response.sendRedirect("confirmation.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
