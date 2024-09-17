<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*,java.security.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - TRAVSPLIT</title>
    <link rel="stylesheet" href="styles.css"> <!-- CSS file for styling -->
</head>
<body>
    <div class="login-container">
        <h2>Register for TRAVSPLIT</h2>
        <form  method="post">
            <div class="input-group">
                <label for="username">Username</label>
                <input type="text" name="username" id="username" required>
            </div>
            <div class="input-group">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" required>
            </div>
            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" required>
            </div>
            <div class="input-group">
                <label for="phone">Phone Number (Optional)</label>
                <input type="text" name="phone" id="phone">
            </div>
            <div class="input-group">
                <button type="submit">Register</button>
            </div>
            <div class="extra-links">
                <a href="index.jsp">Already have an account? Login here</a>
            </div>
        </form>

        <%
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");

            if (username != null && email != null && password != null) {
                Connection conn = null;
                PreparedStatement stmt = null;

                try {
                    // Load the MySQL driver
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

                    String query = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, username);
                    stmt.setString(2, email);
                    stmt.setString(3, password);  // For simplicity, password is stored as plain text (hashing recommended)
                    int result = stmt.executeUpdate();
                    if (result > 0) {
                        response.sendRedirect("index.jsp");  // Redirect to login page after successful registration
                    } else {
                        out.println("<div class='error'>Registration failed. Try again.</div>");
                    }
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            }
        %>
    </div>
</body>
</html>
