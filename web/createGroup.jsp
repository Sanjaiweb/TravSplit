<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Group - TRAVSPLIT</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2 class="mt-5">Create Group</h2>
        <form method="post" action="createGroup.jsp">
            <div class="form-group">
                <label for="groupName">Group Name</label>
                <input type="text" class="form-control" id="groupName" name="groupName" required>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea class="form-control" id="description" name="description" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Create Group</button>
            <a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
        </form>

        <%
            // Handle group creation
            if (request.getMethod().equalsIgnoreCase("post")) {
                String groupName = request.getParameter("groupName");
                String description = request.getParameter("description");
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

                    String sql = "INSERT INTO groups (user_id, group_name, description) VALUES (?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, userId);
                    pstmt.setString(2, groupName);
                    pstmt.setString(3, description);

                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("<div class='alert alert-success mt-3'>Group created successfully!</div>");
                    } else {
                        out.println("<div class='alert alert-danger mt-3'>Failed to create group.</div>");
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
