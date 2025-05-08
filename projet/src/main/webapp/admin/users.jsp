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
        .users-table-container {
            overflow-x: auto;
            margin-top: 20px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        .users-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }
        .users-table th {
            background-color: #4e73df;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        .users-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }
        .users-table tr:last-child td {
            border-bottom: none;
        }
        .users-table tr:hover {
            background-color: #f8f9fa;
        }
        .users-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .users-table tr:nth-child(even):hover {
            background-color: #f1f1f1;
        }
        .btn {
            padding: 8px 15px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .btn-sm {
            padding: 5px 10px;
            font-size: 13px;
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
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .action-form {
            margin: 0;
        }
        .role-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: capitalize;
        }
        .role-admin {
            background-color: #f0e6ff;
            color: #6f42c1;
        }
        .role-agent {
            background-color: #e6f7ff;
            color: #17a2b8;
        }
        .role-visiteur {
            background-color: #fff2e6;
            color: #fd7e14;
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
            padding: 25px;
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
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .modal-header h2 {
            margin: 0;
            font-size: 1.5em;
            color: #333;
        }
        .modal-close {
            font-size: 1.5em;
            color: #6c757d;
            cursor: pointer;
            background: none;
            border: none;
        }
        .modal-close:hover {
            color: #e74a3b;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #eee;
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
        @media (max-width: 768px) {
            .users-table td, .users-table th {
                padding: 10px;
            }
            .action-buttons {
                flex-direction: column;
                gap: 5px;
            }
            .modal-content {
                margin: 20% auto;
                width: 95%;
                padding: 15px;
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
                    <i class="fas fa-check-circle"></i> <%= message %>
                </div>
                <% session.removeAttribute("message"); %>
            <%
                }
                if (error != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
                <% session.removeAttribute("error"); %>
            <%
                }
            %>

            <!-- Add User Button -->
            <div class="form-section">
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Add New User
                </button>
            </div>

            <!-- Add User Modal -->
            <div id="addUserModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Add New User</h2>
                        <button class="modal-close" onclick="closeAddModal()">&times;</button>
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
                            <button type="button" class="btn btn-secondary" onclick="closeAddModal()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Add User</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Edit User Modal -->
            <div id="editUserModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Edit User</h2>
                        <button class="modal-close" onclick="closeEditModal()">&times;</button>
                    </div>
                    <form action="${pageContext.request.contextPath}/userManagement" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" id="editUserId" name="userId">
                        <div class="form-group">
                            <label for="editUsername">Username</label>
                            <input type="text" id="editUsername" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="editPassword">Password (leave blank to keep current)</label>
                            <input type="password" id="editPassword" name="password" placeholder="New Password">
                        </div>
                        <div class="form-group">
                            <label for="editRole">Role</label>
                            <select id="editRole" name="role" required>
                                <option value="admin">Admin</option>
                                <option value="agent">Agent</option>
                                <option value="visiteur">Visiteur</option>
                            </select>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Users Table -->
            <div class="users-table-container">
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
                                <td colspan="4" style="text-align: center;">No users found</td>
                            </tr>
                        <%
                            } else {
                                for (User user : users) {
                        %>
                        <tr>
                            <td><%= user.getId() %></td>
                            <td><%= user.getUsername() %></td>
                            <td>
                                <span class="role-badge role-<%= user.getRole() %>">
                                    <i class="fas fa-<%= 
                                        "admin".equals(user.getRole()) ? "user-shield" : 
                                        "agent".equals(user.getRole()) ? "user-tie" : "user" 
                                    %>"></i> <%= user.getRole() %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn btn-primary btn-sm" onclick="openEditModal(<%= user.getId() %>, '<%= user.getUsername() %>', '<%= user.getRole() %>')">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <form action="${pageContext.request.contextPath}/userManagement" method="post" class="action-form">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="<%= user.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this user?');">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </div>
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
    </div>

    <script>
        // Add User Modal Functions
        function openAddModal() {
            document.getElementById('addUserModal').style.display = "block";
        }

        function closeAddModal() {
            document.getElementById('addUserModal').style.display = "none";
            document.querySelector("#addUserModal form").reset();
        }

        // Edit User Modal Functions
        function openEditModal(userId, username, role) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editUsername').value = username;
            document.getElementById('editRole').value = role;
            document.getElementById('editUserModal').style.display = "block";
        }

        function closeEditModal() {
            document.getElementById('editUserModal').style.display = "none";
            document.querySelector("#editUserModal form").reset();
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            if (event.target == document.getElementById('addUserModal')) {
                closeAddModal();
            }
            if (event.target == document.getElementById('editUserModal')) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>