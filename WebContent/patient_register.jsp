<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Registration</title>

    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Shared Custom Styles -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="index.jsp">🧬 Diagnostic System</a>
    <a href="index.jsp" class="btn btn-light btn-sm">Back</a>
  </div>
</nav>


<div class="container mt-5">

    <h2 class="text-center fw-bold text-primary mb-4">📝 Patient Registration</h2>

    <!-- Error Message Display (optional) -->
    <% if(request.getParameter("error") != null) { %>
        <div class="alert alert-danger text-center">
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <div class="form-card p-4 shadow rounded bg-white">
        <form action="PatientServlet" method="post">
            <input type="hidden" name="action" value="register">

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">👤 Full Name</label>
                    <input type="text" class="form-control" name="name" placeholder="Enter full name" required>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">📧 Email</label>
                    <input type="email" class="form-control" name="email" placeholder="example@mail.com" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">🔑 Password</label>
                    <input type="password" class="form-control" name="password" placeholder="Create password" required>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">📞 Phone</label>
                    <input type="text" class="form-control" name="phone" placeholder="9876543210" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">⚧ Gender</label>
                    <select class="form-select" name="gender" required>
                        <option disabled selected>Select gender...</option>
                        <option>Male</option>
                        <option>Female</option>
                        <option>Other</option>
                    </select>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">🎂 Age</label>
                    <input type="number" class="form-control" name="age" min="1" max="120" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">📍 Address</label>
                <textarea class="form-control" name="address" rows="2" placeholder="Enter full address" required></textarea>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-lg">Register</button>
        </form>
    </div>

    <p class="text-center mt-3">
        Already have an account? <a href="patient_login.jsp">Login here</a>
    </p>

</div>

<%@ include file="components/footer.jspf" %>

</body>
</html>
