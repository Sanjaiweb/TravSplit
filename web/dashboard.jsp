<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TRAVSPLIT Dashboard</title>
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

        <!-- Existing Trips/Groups Section -->
        <section class="mb-4">
            <div class="card">
                <div class="card-header">
                    <h3>Your Trips/Groups</h3>
                </div>
                <div class="card-body">
                    <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

                            // Get trips/groups for this user
                            String tripListQuery = "SELECT group_name, description, created_at FROM groups WHERE user_id = ?";
                            pstmt = conn.prepareStatement(tripListQuery);
                            pstmt.setInt(1, (Integer) session.getAttribute("user_id"));
                             session.setAttribute("username", rs.getString("username"));// Ensure user_id is an Integer
                            rs = pstmt.executeQuery();
                    %>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Group Name</th>
                                <th>Description</th>
                                <th>Date Created</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (!rs.isBeforeFirst()) { // Check if there are no results
                                %>
                                <tr>
                                    <td colspan="3" class="text-center">No groups found.</td>
                                </tr>
                                <%
                            } else {
                                while (rs.next()) { 
                                %>
                                <tr>
                                    <td><%= rs.getString("group_name") %></td>
                                    <td><%= rs.getString("description") %></td>
                                    <td><%= rs.getDate("created_at") %></td>
                                </tr>
                                <% 
                                } 
                            }
                            %>
                        </tbody>
                    </table>
                    <% 
                        } catch (Exception e) {
                            e.printStackTrace(); // Print the stack trace for debugging
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) {}
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                            if (conn != null) try { conn.close(); } catch (SQLException e) {}
                        }
                    %>
                </div>
            </div>
        </section>

        <section class="mb-4">
            <div class="card">
                <div class="card-body text-center">
                    <button class="btn btn-success" onclick="location.href='addExpense.jsp'">Add Expense</button>
                    <button class="btn btn-primary" onclick="location.href='createGroup.jsp'">Create New Group</button>
                </div>
            </div>
        </section>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
