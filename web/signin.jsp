<%-- 
    Document   : signin.jsp
    Created on : 16-Sept-2024, 11:37:55?am
    Author     : PREVEEN S
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sign In</title>
    </head>
    <body>
        <h1>Sign In Processing</h1>
        <%
            // Get email and password from the form
            String userEmail = request.getParameter("email");
            String userPassword = request.getParameter("password");

            // Database connection details
             String dbURL = "jdbc:mysql://localhost:3306/travsplit_db"; // Your DB URL
                        String dbUser = "sanjai"; // Your DB user
                        String dbPassword = "sa07nj12ai04";

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                // Ensure email and password are not null
                if (userEmail != null && userPassword != null) {
                    // Load PostgreSQL JDBC driver
                 Class.forName("com.mysql.cj.jdbc.Driver");

                    // Establish a connection to the database
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // SQL query to check if user exists with the provided email and password
                    String query = "SELECT * FROM users WHERE email = ? AND password = ?";

                    // Prepare the statement to avoid SQL injection
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, userEmail);
                    stmt.setString(2, userPassword);

                    // Execute the query
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        // If a record is found, display success message
                        out.println("<script>alert(\"Login successful! Welcome\")</script>");
                        out.println("<script>window.location.href=\"dashboard.jsp\"</script>");
                    } else {
                        // If no record is found, display failure message
                        out.println("<script>alert(\"Login failed. Invalid email or password.\")</script>");
                        out.println("<script>window.location.href=\"index.jsp\"</script>");
                    }
                } else {
                    out.println("Email and password are required.");
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                // Close resources
                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) {
                        out.println("Error closing ResultSet: " + e.getMessage());
                    }
                }
                if (stmt != null) {
                    try {
                        stmt.close();
                    } catch (SQLException e) {
                        out.println("Error closing PreparedStatement: " + e.getMessage());
                    }
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        out.println("Error closing Connection: " + e.getMessage());
                    }
                }
            }
        %>
    </body>
</html>
