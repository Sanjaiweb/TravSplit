<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Expense</title>
</head>
<body>
    <%
        String expenseId = request.getParameter("expenseId");
        String description = request.getParameter("description");
        String amountStr = request.getParameter("amount");
        String dateStr = request.getParameter("date");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
             conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

            // Update the expense in the database
            String query = "UPDATE expenses SET description = ?, amount = ?, date = ? WHERE id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, description);
            pstmt.setDouble(2, Double.parseDouble(amountStr));
            pstmt.setDate(3, java.sql.Date.valueOf(dateStr));
            pstmt.setInt(4, Integer.parseInt(expenseId));

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                out.println("<p>Expense updated successfully!</p>");
            } else {
                out.println("<p>Failed to update expense.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

        // Redirect back to manageExpense.jsp
        response.sendRedirect("manageExpense.jsp");
    %>
</body>
</html>
