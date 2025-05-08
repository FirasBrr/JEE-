<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.User, java.util.List, java.util.ArrayList, DAO.UserDAO" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Initialize UserDAO and fetch all users
    UserDAO userDao = new UserDAO();
    List<User> users = new ArrayList<>();
    try {
        users = userDao.getAllUsers();
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Erreur lors du chargement des utilisateurs: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management - AutoLoc</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admindash.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .main-content {
            padding: 20px;
        }
        .users-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .users-table th, .users-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        .users-table th {
            background-color: #4e73df;
            color: white;
        }
        .users-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #4e73df;
            color: white;
        }
        .btn-primary:hover {
            background: #2e59d9;
        }
        .btn-danger {
            background: #e74a3b;
            color: white;
        }
        .btn-danger:hover {
            background: #c6392b;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .action-form input[type="text"], .action-form select {
            width: 150px;
            margin-right: 5px;
        }
        .action-form input[type="password"] {
            width: 150px;
            margin-right: 5px;
        }
        .action-form {
            display: inline-block;
        }
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow: auto;
        }
        .modal-content {
            background: white;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.3);
            width: 90%;
            max-width: 500px;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .modal-header h2 {
            margin: 0;
            font-size: 1.5em;
        }
        .modal-close {
            font-size: 1.5em;
            color: #6c757d;
            cursor: pointer;
        }
        .modal-close:hover {
            color: #e74a3b;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        @media (max-width: 768px) {
            .users-table {
                display: block;
                overflow-x: auto;
            }
            .modal-content {
                margin: 20% auto;
                width: 95%;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="admin-profile">
                <h3><%= currentUser.getUsername() %></h3>
                <p>Administrator</p>
            </div>
            <nav class="admin-nav">
                <ul>
                    <li><a href="admin.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li class="active"><a href="users.jsp"><i class="fas fa-users"></i> User Management</a></li>
                    <li><a href="cars.jsp"><i class="fas fa-car"></i> Car Inventory</a></li>
                    <li><a href="reservations.jsp"><i class="fas fa-calendar-check"></i> Reservations</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <header class="admin-header">
                <h1>User Management</h1>
                <div class="header-actions">
                    <span class="current-date"><%= new java.util.Date() %></span>
                </div>
            </header>

            <!-- Success/Error Messages -->
            <%
                String message = (String) session.getAttribute("message");
                String error = (String) session.getAttribute("error");
                if (message != null) {
            %>
                <div class="alert alert-success">
                    <%= message %>
                </div>
                <% session.removeAttribute("message"); %>
            <%
                }
                if (error != null) {
            %>
                <div class="alert alert-error">
                    <%= error %>
                </div>
                <% session.removeAttribute("error"); %>
            <%
                }
            %>

            <!-- Add User Button -->
            <div class="form-section">
                <button class="btn btn-primary" onclick="openModal()">Add New User</button>
            </div>

            <!-- Add User Modal -->
            <div id="addUserModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Add New User</h2>
                        <span class="modal-close" onclick="closeModal()">&times;</span>
                    </div>
                    <form action="${pageContext.request.contextPath}/userManagement" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required>
                        </div>
                        <div class="form-group">
                            <label for="role">Role</label>
                            <select id="role" name="role" required>
                                <option value="admin">Admin</option>
                                <option value="agent">Agent</option>
                                <option value="visiteur">Visiteur</option>
                            </select>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Add User</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Users Table -->
            <table class="users-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (users == null || users.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="4">Aucun utilisateur trouvé.</td>
                        </tr>
                    <%
                        } else {
                            for (User user : users) {
                    %>
                    <tr>
                        <td><%= user.getId() %></td>
                        <td><%= user.getUsername() %></td>
                        <td><%= user.getRole() %></td>
                        <td>
                            <!-- Edit Form -->
                            <form action="${pageContext.request.contextPath}/userManagement" method="post" class="action-form">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="userId" value="<%= user.getId() %>">
                                <input type="text" name="username" value="<%= user.getUsername() %>" required>
                                <input type="password" name="password" placeholder="New Password">
                                <select name="role" required>
                                    <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                                    <option value="agent" <%= "agent".equals(user.getRole()) ? "selected" : "" %>>Agent</option>
                                    <option value="visiteur" <%= "visiteur".equals(user.getRole()) ? "selected" : "" %>>Visiteur</option>
                                </select>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-edit"></i> Update</button>
                            </form>
                            <!-- Delete Form -->
                            <form action="${pageContext.request.contextPath}/userManagement" method="post" class="action-form">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="userId" value="<%= user.getId() %>">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this user?');"><i class="fas fa-trash"></i> Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Get modal element
        const modal = document.getElementById("addUserModal");

        // Open modal
        function openModal() {
            modal.style.display = "block";
        }

        // Close modal
        function closeModal() {
            modal.style.display = "none";
            // Reset form fields
            document.querySelector("#addUserModal form").reset();
        }

        // Close modal if clicking outside
        window.onclick = function(event) {
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>