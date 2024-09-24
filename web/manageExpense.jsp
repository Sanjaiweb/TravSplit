<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Expenses - TRAVSPLIT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <header class="bg-primary text-white p-3 mb-4">
        <div class="container">
            <h1 class="text-center">Manage Expenses</h1>
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <a class="navbar-brand" href="dashboard.jsp">Home</a>
                    <div class="collapse navbar-collapse">
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
        <button class="btn btn-success mb-3" onclick="window.location.href='ManageExpense/addExpense.jsp'">Add New Expense</button>
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

                    String userIdString = (String) session.getAttribute("user_id");
                    if (userIdString == null) {
                        out.println("<div class='alert alert-danger mt-3'>User ID is missing. Please log in again.</div>");
                    } else {
                        try {
                            int userId = Integer.parseInt(userIdString);
                            String query = "SELECT * FROM expenses WHERE user_id = ?";
                            pstmt = conn.prepareStatement(query);
                            pstmt.setInt(1, userId);
                            rs = pstmt.executeQuery();

                            boolean hasExpenses = false;
                            while (rs.next()) {
                                hasExpenses = true;
                %>
                                <tr>
                                    <td><%= rs.getDate("date") %></td>
                                    <td><%= rs.getString("description") %></td>
                                    <td>$ <%= rs.getDouble("amount") %></td>
                                    <td>
                                        <a href="ManageExpense/editExpense.jsp?expense_id=<%= rs.getInt("expense_id") %>" class="btn btn-primary">Edit</a>
                                        <a href="ManageExpense/deleteExpense.jsp?expense_id=<%= rs.getInt("expense_id") %>" class="btn btn-danger">Delete</a>
                                    </td>
                                </tr>
                <%
                            }
                            if (!hasExpenses) {
                                out.println("<tr><td colspan='4' class='text-center'>No expenses found for this user.</td></tr>");
                            }
                        } catch (NumberFormatException e) {
                            out.println("<div class='alert alert-danger mt-3'>Invalid User ID format.</div>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger mt-3'>Database connection problem: " + e.getMessage() + "</div>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
