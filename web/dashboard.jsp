<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TRAVSPLIT Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles.css"> <!-- Link to your custom CSS file -->
</head>
<body>
    <header class="bg-primary text-white p-3 mb-4">
        <div class="container">
            <h1 class="text-center">TRAVSPLIT Dashboard</h1>
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
        <section class="mb-4">
            <div class="card">
                <div class="card-body">
                    <h2>Welcome, <%= session.getAttribute("username") %>!</h2>
                    <p>Your Information:</p>
                    <ul>
                        <li><strong>ID:</strong> <%= session.getAttribute("user_id") %></li>
                        <li><strong>Name:</strong> <%= session.getAttribute("username") %></li>
                        <li><strong>Email:</strong> <%= session.getAttribute("email") %></li>
                    </ul>
                </div>
            </div>
        </section>

        <section class="mb-4">
            <div class="row">
                <!-- Expense Overview Card -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h3>Expense Overview</h3>
                        </div>
                        <div class="card-body">
                            <%
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;
                                double totalExpenses = 0.0;
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "username", "password");

                                    // Get total expenses for this user
                                    String expenseQuery = "SELECT SUM(amount) FROM expenses WHERE user_id = ?";
                                    pstmt = conn.prepareStatement(expenseQuery);
                                    pstmt.setInt(1, (Integer) session.getAttribute("user_id"));
                                    rs = pstmt.executeQuery();
                                    if (rs.next()) {
                                        totalExpenses = rs.getDouble(1);
                                    }
                            %>
                            <p><strong>Total Expenses:</strong> $<%= totalExpenses %></p>
                            <% 
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) rs.close();
                                    if (pstmt != null) pstmt.close();
                                    if (conn != null) conn.close();
                                }
                            %>
                        </div>
                    </div>
                </div>

                <!-- Trip Statistics Card -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h3>Trip Statistics</h3>
                        </div>
                        <div class="card-body">
                            <%
                                Connection conn2 = null;
                                PreparedStatement pstmt2 = null;
                                ResultSet rs2 = null;
                                int totalTrips = 0;
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "username", "password");

                                    // Get total trips for this user
                                    String tripQuery = "SELECT COUNT(*) FROM trips WHERE user_id = ?";
                                    pstmt2 = conn2.prepareStatement(tripQuery);
                                    pstmt2.setInt(1, (Integer) session.getAttribute("user_id"));
                                    rs2 = pstmt2.executeQuery();
                                    if (rs2.next()) {
                                        totalTrips = rs2.getInt(1);
                                    }
                            %>
                            <p><strong>Total Trips:</strong> <%= totalTrips %></p>
                            <% 
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs2 != null) rs2.close();
                                    if (pstmt2 != null) pstmt2.close();
                                    if (conn2 != null) conn2.close();
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="mb-4">
            <div class="card">
                <div class="card-header">
                    <h3>Recent Transactions</h3>
                </div>
                <div class="card-body">
                    <%
                        Connection conn3 = null;
                        PreparedStatement pstmt3 = null;
                        ResultSet rs3 = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn3 = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "username", "password");

                            // Get recent transactions for this user
                            String transactionQuery = "SELECT * FROM expenses WHERE user_id = ? ORDER BY date DESC LIMIT 5";
                            pstmt3 = conn3.prepareStatement(transactionQuery);
                            pstmt3.setInt(1, (Integer) session.getAttribute("user_id"));
                            rs3 = pstmt3.executeQuery();
                    %>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% while (rs3.next()) { %>
                            <tr>
                                <td><%= rs3.getDate("date") %></td>
                                <td><%= rs3.getString("description") %></td>
                                <td>$<%= rs3.getDouble("amount") %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% 
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs3 != null) rs3.close();
                            if (pstmt3 != null) pstmt3.close();
                            if (conn3 != null) conn3.close();
                        }
                    %>
                </div>
            </div>
        </section>
  
        <section class="mb-4">
            <div class="card">
                <div class="card-body text-center">
                    <button class="btn btn-success" onclick="location.href='addExpense.jsp'">Add Expense</button>
                    <button class="btn btn-primary" onclick="location.href='createGroup.jsp'">Create New Trip</button>
                </div>
            </div>
        </section>
    </div>

    <!-- Footer -->


    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
