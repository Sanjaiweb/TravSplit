<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TRAVSPLIT Dashboard</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to your CSS file -->
</head>
<body>
    <header>
        <h1>TRAVSPLIT Dashboard</h1>
        <nav>
            <ul>
                <li><a href="dashboard.jsp">Home</a></li>
                <li><a href="manageExpenses.jsp">Manage Expenses</a></li>
                <li><a href="userProfile.jsp">Profile</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <div class="dashboard-container">
            <section class="welcome">
                <h2>Welcome, <%= session.getAttribute("username") %>!</h2>
                <div class="user-info">
                    <h3>Your Information:</h3>
                    <p><strong>ID:</strong> <%= session.getAttribute("user_id") %></p>
                    <p><strong>Name:</strong> <%= session.getAttribute("username") %></p>
                    <p><strong>Email:</strong> <%= session.getAttribute("email") %></p>
                </div>
            </section>

            <section class="expense-overview">
                <h3>Expense Overview</h3>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

                        // Calculate total expenses
                        String expenseQuery = "SELECT SUM(amount) FROM expenses WHERE user_id = ?";
                        pstmt = conn.prepareStatement(expenseQuery);
                        pstmt.setInt(1, (Integer) session.getAttribute("user_id"));
                        rs = pstmt.executeQuery();
                        double totalExpenses = 0.0;
                        if (rs.next()) {
                            totalExpenses = rs.getDouble(1);
                        }
                %>
                <p><strong>Total Expenses:</strong> $<%= totalExpenses %></p>
                <% 
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </section>

            <section class="trip-statistics">
                <h3>Trip Statistics</h3>
                <%
                    Connection conn2 = null;
                    PreparedStatement pstmt2 = null;
                    ResultSet rs2 = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                         conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

                        // Get total trips
                        String tripQuery = "SELECT COUNT(*) FROM trips WHERE user_id = ?";
                        pstmt2 = conn2.prepareStatement(tripQuery);
                        pstmt2.setInt(1, (Integer) session.getAttribute("user_id"));
                        rs2 = pstmt2.executeQuery();
                        int totalTrips = 0;
                        if (rs2.next()) {
                            totalTrips = rs2.getInt(1);
                        }
                %>
                <p><strong>Total Trips:</strong> <%= totalTrips %></p>
                <% 
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs2 != null) try { rs2.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt2 != null) try { pstmt2.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn2 != null) try { conn2.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </section>

            <section class="recent-transactions">
                <h3>Recent Transactions</h3>
                <%
                    Connection conn3 = null;
                    PreparedStatement pstmt3 = null;
                    ResultSet rs3 = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                         conn3 = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");
                        // Fetch recent transactions
                        String transactionQuery = "SELECT * FROM expenses WHERE user_id = ? ORDER BY date DESC LIMIT 5";
                        pstmt3 = conn3.prepareStatement(transactionQuery);
                        pstmt3.setInt(1, (Integer) session.getAttribute("user_id"));
                        rs3 = pstmt3.executeQuery();
                %>
                <table>
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
                        if (rs3 != null) try { rs3.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt3 != null) try { pstmt3.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn3 != null) try { conn3.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </section>

            <section class="quick-actions">
                <h3>Quick Actions</h3>
                <button onclick="location.href='addExpense.jsp'">Add Expense</button>
                <button onclick="location.href='createTrip.jsp'">Create New Trip</button>
            </section>

            <!-- Optional: Summary Charts Section -->
            <section class="summary-charts">
                <h3>Expense Trends</h3>
                <!-- Include charts or graphs here if available -->
            </section>
        </div>
    </main>

    <footer>
        <p>&copy; 2024 TRAVSPLIT. All rights reserved.</p>
    </footer>
</body>
</html>
