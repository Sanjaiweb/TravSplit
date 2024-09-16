<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
</head>
<body>
    <h2>Reset Password</h2>
    <form action="forgotpassword.jsp" method="POST">
        Email: <input type="email" name="email" required><br><br>
        New Password: <input type="password" name="new_password" required><br><br>
        <input type="submit" value="Reset Password">
    </form>
</body>
</html>

<%
  String dbURL = "jdbc:mysql://localhost:3306/travsplit_db"; // Your DB URL
                        String dbUser = "sanjai"; // Your DB user
                        String dbPassword = "sa07nj12ai04";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("new_password");

        try {
            // Hash the new password
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedPassword = md.digest(newPassword.getBytes());

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String query = "UPDATE users SET password=? WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, new String(hashedPassword)); // Save hashed new password
            ps.setString(2, email);

            int row = ps.executeUpdate();
            if (row > 0) {
                out.println("Password reset successful!");
                response.sendRedirect("index.jsp");
            } else {
                out.println("Error: User with this email not found.");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error during password reset: " + e.getMessage());
        }
    }
%>
