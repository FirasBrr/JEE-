<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Réservation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            max-width: 600px;
            margin: 0 auto;
        }
        h2 {
            color: #333;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        form input, form select, form button {
            display: block;
            margin: 10px 0;
            padding: 10px;
            width: 100%;
            box-sizing: border-box;
        }
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .vehicle-info {
            background-color: #f5f5f5;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <h2>Réserver un véhicule</h2>
    
    <%-- Display selected vehicle info --%>
    <div class="vehicle-info">
        <%
        String vehicleType = request.getParameter("vehicle");
        String vehicleName = "";
        
        if ("economique".equals(vehicleType)) {
            vehicleName = "Voiture Économique";
        } else if ("suv".equals(vehicleType)) {
            vehicleName = "SUV Familial";
        } else if ("luxe".equals(vehicleType)) {
            vehicleName = "Voiture de Luxe";
        }
        %>
        <h3>Vous réservez : <%= vehicleName %></h3>
    </div>
    
    <form action="ReserverServlet" method="post">
        <%-- Add hidden field for vehicle type --%>
        <input type="hidden" name="vehicleType" value="<%= vehicleType %>">
        
        <label>Nom :</label>
        <input type="text" name="nom" required>
        
        <label>Email :</label>
        <input type="email" name="email" required>
        
        <label>Date de début :</label>
        <input type="date" name="dateDebut" required>
        
        <label>Date de fin :</label>
        <input type="date" name="dateFin" required>
        
        <button type="submit">Confirmer la réservation</button>
    </form>
    
    <p><a href="javascript:history.back()">← Retour à la sélection</a></p>
</body>
</html>