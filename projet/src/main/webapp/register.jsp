<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/auth.css">
</head>
<body>

<div class="form-container">
    <h2>Register</h2>
    <form method="post" action="authe">
    <input type="hidden" name="action" value="register">
    
    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    
    <select name="role" required>
    <option value="visiteur">Visiteur</option>
    <option value="agent">Agent</option>
    <option value="admin">Admin</option>
	</select>
    
    <button type="submit">Register</button>
</form>

    <a href="login.jsp">Already have an account? Login here</a>
</div>

</body>
</html>


