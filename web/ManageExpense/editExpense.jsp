<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Expense</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Edit Expense</h2>
        <%
            String expenseId = request.getParameter("expense_id"); // Changed to use expense_id
            if (expenseId == null || expenseId.isEmpty()) {
                out.println("<div class='alert alert-danger'>Invalid expense ID.</div>");
                return;
            }

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

                String query = "SELECT * FROM expenses WHERE expense_id = ?"; // Changed to use expense_id
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, Integer.parseInt(expenseId));
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    // Render the form with existing expense data
                    %>
                    <form method="post" action="editExpense.jsp?expense_id=<%= expenseId %>"> <!-- Changed to use expense_id -->
                        <div class="form-group">
                            <label for="expenseName">Expense Name</label>
                            <input type="text" id="expenseName" name="description" value="<%= rs.getString("description") %>" required class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="amount">Amount</label>
                            <input type="number" id="amount" name="amount" value="<%= rs.getDouble("amount") %>" required class="form-control">
                        </div>
                        <button type="submit" class="btn btn-primary">Update Expense</button>
                    </form>
                    <%
                } else {
                    out.println("<div class='alert alert-danger'>Expense not found.</div>");
                }

                // Handle form submission
                if (request.getMethod().equalsIgnoreCase("post")) {
                    String expenseName = request.getParameter("description");
                    String amount = request.getParameter("amount");

                    String updateQuery = "UPDATE expenses SET description = ?, amount = ? WHERE expense_id = ?"; // Changed to use expense_id
                    pstmt = conn.prepareStatement(updateQuery);
                    pstmt.setString(1, expenseName);
                    pstmt.setDouble(2, Double.parseDouble(amount));
                    pstmt.setInt(3, Integer.parseInt(expenseId)); // Changed to use expense_id

                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
                        response.sendRedirect("manageExpense.jsp");
                    } else {
                        out.println("<div class='alert alert-danger'>Failed to update expense.</div>");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        %>
    </div>
</body>
</html>
