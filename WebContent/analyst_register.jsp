<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Analyst Registration</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Your shared CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body class="bg-light">

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="index.jsp">🔬 Diagnostic System</a>
    <a href="index.jsp" class="btn btn-light btn-sm">Back</a>
  </div>
</nav>


<div class="container mt-5">

    <h2 class="text-center fw-bold text-success mb-4">🧑‍🔬 Analyst Registration</h2>

    <!-- Error Message (if exists) -->
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger text-center">
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <div class="form-card bg-white p-4 shadow rounded">
        <form action="AnalystServlet" method="post">
            <input type="hidden" name="action" value="register">

            <div class="mb-3">
                <label class="form-label fw-semibold">👤 Full Name</label>
                <input type="text" class="form-control" name="name" placeholder="Enter full name" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">📧 Email</label>
                <input type="email" class="form-control" name="email" placeholder="example@mail.com" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">🔑 Password</label>
                <input type="password" class="form-control" name="password" placeholder="Create password" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">🧪 Specialization</label>
                <input type="text" class="form-control" name="specialization" placeholder="Example: Pathology, Radiology">
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">📞 Phone</label>
                <input type="text" class="form-control" name="phone" placeholder="9876543210">
            </div>

            <button type="submit" class="btn btn-success w-100 btn-lg">Register</button>
        </form>
    </div>

    <p class="text-center mt-3">
        Already registered? <a href="analyst_login.jsp">Login here</a>
    </p>

</div>

<%@ include file="components/footer.jspf" %>
</body>
</html>
