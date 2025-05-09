<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/auth.css">
</head>
<body>

<div class="form-container">
    <h2>Login</h2>

<form method="post" action="${pageContext.request.contextPath}/login">
    <input type="hidden" name="action" value="login">
    
    <input type="text" name="username" placeholder="Username" required /><br>
    <input type="password" name="password" placeholder="Password" required /><br>
    
    <button type="submit">Login</button>
</form>


    <%-- Message d'erreur sans JSTL --%>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    <a href="register.jsp">Create new account, Register here</a>
   
</div>

</body>
</html>

