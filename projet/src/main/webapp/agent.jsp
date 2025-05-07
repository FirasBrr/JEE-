<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User" %>
<%@ page import="utils.DBConnection" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"agent".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Agent Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admindash.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="agent-container">
        <div class="sidebar">
            <div class="agent-profile">
                <h3><%= user.getUsername() %></h3>
                <p>Agent</p>
            </div>
            <nav class="agent-nav">
                <ul>
                    <li><a href="agent_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="add_bien.jsp"><i class="fas fa-car"></i> Add Car</a></li>
                    <li><a href="reservations.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>
        
        <div class="main-content">
            <header class="agent-header">
                <h1>Welcome to your Agent Dashboard</h1>
            </header>

            <div class="add-bien-section">
                <h2>Add a New Car</h2>
                <form action="add_bien.jsp" method="post">
                    <label for="type">Car Type:</label>
                    <input type="text" id="type" name="type" required>

                    <label for="description">Description:</label>
                    <textarea id="description" name="description" required></textarea>

                    <label for="prix">Price Per Day:</label>
                    <input type="number" id="prix" name="prix_par_jour" required>

                    <label for="disponibilite">Availability:</label>
                    <select id="disponibilite" name="disponibilite" required>
                        <option value="1">Available</option>
                        <option value="0">Not Available</option>
                    </select>

                    <button type="submit" name="addBien">Add Car</button>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/script/admindash.js"></script>
</body>
</html>
