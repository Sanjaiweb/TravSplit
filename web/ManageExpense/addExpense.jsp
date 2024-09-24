<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Expense - Travsplit</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to your CSS file -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"> <!-- Bootstrap CSS -->
</head>
<body>
    <div class="container">
        <h2 class="mt-5">Add Expense</h2>
        <form method="post" action=".Manage Expense/addExpense.jsp">
            <div class="form-group">
                <label for="description">Description</label>
                <input type="text" class="form-control" id="description" name="description" required>
            </div>
            <div class="form-group">
                <label for="amount">Amount</label>
                <input type="number" class="form-control" id="amount" name="amount" required>
            </div>
            <div class="form-group">
                <label for="date">Date</label>
                <input type="date" class="form-control" id="date" name="date" required>
            </div>
            <button type="submit" class="btn btn-primary">Add Expense</button>
            <a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
        </form>

        <%
            // Backend Logic for handling form submission
            if (request.getMethod().equalsIgnoreCase("post")) {
                String description = request.getParameter("description");
                double amount = Double.parseDouble(request.getParameter("amount"));
                String date = request.getParameter("date");
                
                // Retrieve user ID from session as String
                String userIdString = (String) session.getAttribute("user_id");
                if (userIdString == null) {
                    out.println("<div class='alert alert-danger mt-3'>User ID is missing. Please log in again.</div>");
                    return; // Exit if userId is null
                }
                
                int userId;
                try {
                    userId = Integer.parseInt(userIdString); // Parse string to int
                } catch (NumberFormatException e) {
                    out.println("<div class='alert alert-danger mt-3'>Invalid User ID format.</div>");
                    return; // Exit if parsing fails
                }

                Connection conn = null;
                PreparedStatement pstmt = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

                    // SQL Insert statement
                    String sql = "INSERT INTO expenses (user_id, description, amount, date) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, userId);
                    pstmt.setString(2, description);
                    pstmt.setDouble(3, amount);
                    pstmt.setDate(4, java.sql.Date.valueOf(date));

                    // Execute the update
                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("<div class='alert alert-success mt-3'>Expense added successfully!</div>");
                         response.sendRedirect("manageExpense.jsp");
                    } else {
                        out.println("<div class='alert alert-danger mt-3'>Failed to add expense. Please try again.</div>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        %>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
