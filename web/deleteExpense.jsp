<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Expense</title>
</head>
<body>
    <%
        String expenseId = request.getParameter("expense_id");
        if (expenseId == null || expenseId.isEmpty()) {
            out.println("<div class='alert alert-danger'>Invalid expense ID.</div>");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/travsplit_db", "sanjai", "sa07nj12ai04");

            String query = "DELETE FROM expenses WHERE expense_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(expenseId));

            int result = pstmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("manageExpense.jsp");
            } else {
                out.println("<div class='alert alert-danger'>Failed to delete expense.</div>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</body>
</html>
