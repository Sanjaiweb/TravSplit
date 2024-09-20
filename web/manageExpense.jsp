<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Expense - TRAVSPLIT</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2 class="mt-5">Manage Expense</h2>
        <form method="post" action="manageExpense.jsp">
            <div class="form-group">
                <label for="groupId">Group ID</label>
                <input type="text" class="form-control" id="groupId" name="groupId" required>
            </div>
            <div class="form-group">
                <label for="description">Expense Description</label>
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
            // Handle expense addition
            if (request.getMethod().equalsIgnoreCase("post")) {
                String groupId = request.getParameter("groupId");
                String description = request.getParameter("description");
                double amount = Double.parseDouble(request.getParameter("amount"));
                String date = request.getParameter("date");
                
                Connection conn = null;
                PreparedStatement pstmt = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

                    String sql = "INSERT INTO expenses (group_id, description, amount, date) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(groupId));
                    pstmt.setString(2, description);
                    pstmt.setDouble(3, amount);
                    pstmt.setDate(4, java.sql.Date.valueOf(date));

                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("<div class='alert alert-success mt-3'>Expense added successfully!</div>");
                    } else {
                        out.println("<div class='alert alert-danger mt-3'>Failed to add expense.</div>");
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
