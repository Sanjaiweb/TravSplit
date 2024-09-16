<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>
    <h2>Welcome, <%= session.getAttribute("user") %>!</h2>
    <p>This is your dashboard.</p>
    <a href="logout.jsp">Logout</a>
</body>
</html>
