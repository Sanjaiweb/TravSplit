<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TRAVSPLIT - Login</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-container {
            margin-top: 100px;
            max-width: 400px;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .btn-custom {
            background-color: #007bff;
            color: white;
        }
        .btn-custom:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="login-container mx-auto">
            <h2 class="text-center mb-4">Login to TRAVSPLIT</h2>
            <form action="index.jsp" method="POST">
                <div class="form-group">
                    <label for="email">Email address</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Enter email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                </div>
                <button type="submit" class="btn btn-custom btn-block">Login</button>
                <div class="text-center mt-3">
                    <a href="register.jsp">Create an account</a> | <a href="forgotpassword.jsp">Forgot password?</a>
                </div>
            </form>

            <%
                // Only handle POST requests
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");

                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        // Load the MySQL JDBC driver
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        // Connect to the database
                        String dbURL = "jdbc:mysql://localhost:3306/travsplit_db";
                        String dbUser = "sanjai";
                        String dbPassword = "sa07nj12ai04";
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        // Prepare and execute SQL query
                        String query = "SELECT * FROM users WHERE email = ? AND password = ?";
                        stmt = conn.prepareStatement(query);
                        stmt.setString(1, email);
                        stmt.setString(2, password); // In production, use hashed passwords

                        rs = stmt.executeQuery();

                        if (rs.next()) {
                            // Login successful
                           
                            session.setAttribute("user", email);
                            response.sendRedirect("dashboard.jsp");
                        } else {
                            // Login failed
                            out.println("<div class='alert alert-danger mt-3'>Invalid email or password.</div>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<div class='alert alert-danger mt-3'>An error occurred. Please try again later.</div>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            %>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
