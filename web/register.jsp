<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register New User</title>
</head>
<body>
    <h2>Register New User</h2>
    <form action="register.jsp" method="POST">
        Username: <input type="text" name="username" required><br><br>
        Email: <input type="email" name="email" required><br><br>
        Password: <input type="password" name="password" required><br><br>
        <input type="submit" value="Register">
    </form>
</body>
</html>

<%
    String dbURL = "jdbc:mysql://localhost:3306/travsplit_db"; // Your DB URL
                        String dbUser = "sanjai"; // Your DB user
                        String dbPassword = "sa07nj12ai04";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Hashing the password for security
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedPassword = md.digest(password.getBytes());

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String query = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, new String()); // Save hashed password

            int row = ps.executeUpdate();
            if (row > 0) {
                out.println("Registration successful!");
                response.sendRedirect("index.jsp");
            } else {
                out.println("Registration failed.");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error occurred during registration: " + e.getMessage());
        }
    }
%>
