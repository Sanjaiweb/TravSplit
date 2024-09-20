<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*, java.security.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - TRAVSPLIT</title>
    <link rel="stylesheet" href="login.css"> <!-- CSS file for styling -->
</head>
<body>
    <div class="login-container">
        <h2>Login to TRAVSPLIT</h2>
        <form  method="post">
            <div class="input-group">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" required>
            </div>
            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" required>
            </div>
            <div class="input-group">
                <button type="submit">Login</button>
            </div>
            <div class="extra-links">
                <a href="register.jsp">Don't have an account? Register here</a>
            </div>
        </form>

        <%
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email != null && password != null) {
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    // Load the MySQL driver
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

                    String query = "SELECT * FROM users WHERE email = ?";
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, email);
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        String dbPassword = rs.getString("password");
                        if (dbPassword.equals(password)) {
                         session.setAttribute("user_id", rs.getString("user_id"));
                            session.setAttribute("username", rs.getString("username"));
                             session.setAttribute("email", rs.getString("email"));
                           
                            response.sendRedirect("dashboard.jsp"); // Redirect to dashboard on successful login
                        } else {
                            out.println("<div class='error'>Invalid credentials. Try again.</div>");
                        }
                    } else {
                        out.println("<div class='error'>User does not exist.</div>");
                    }
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            }
        %>
    </div>
</body>
</html>
