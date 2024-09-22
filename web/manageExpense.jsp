<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Expenses - TRAVSPLIT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles.css"> <!-- Link to your custom CSS file -->
</head>
<body>
    <header class="bg-primary text-white p-3 mb-4">
        <div class="container">
            <h1 class="text-center">Manage Expenses</h1>
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <a class="navbar-brand" href="dashboard.jsp">Home</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav ms-auto">
                            <li class="nav-item">
                                <a class="nav-link" href="manageExpense.jsp">Manage Expenses</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="userProfile.jsp">Profile</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="logout.jsp">Logout</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </div>
    </header>

    <div class="container">
        <button class="btn btn-success mb-3" onclick="window.location.href='addExpense.jsp'">Add New Expense</button>
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Description</th>
                    <th>Amount</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");
                    String query = "SELECT * FROM expenses WHERE user_id = ?";
                    pstmt = conn.prepareStatement(query);
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
                    pstmt.setInt(1, userId);

                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getDate("date") %></td>
                        <td><%= rs.getString("description") %></td>
                        <td>$<%= rs.getDouble("amount") %></td>
                        <td>
                            <a href="editExpense.jsp?expenseId=<%= rs.getInt("id") %>" class="btn btn-primary">Edit</a>
                            <a href="deleteExpense.jsp?expenseId=<%= rs.getInt("id") %>" class="btn btn-danger">Delete</a>
                        </td>
                    </tr>
                <% 
                    }
                } catch (Exception e) {
                    out.println("Database connection problem: " + e.getMessage());
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
                %>
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
