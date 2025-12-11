<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Diagnostic Management System</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Shared custom styles -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-light">

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="index.jsp">🧬 Diagnostic Management System</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-end" id="mainNav">
      <div class="d-flex">
        <a href="patient_login.jsp" class="btn btn-light btn-sm mx-1">Patient Login</a>
        <a href="analyst_login.jsp" class="btn btn-light btn-sm mx-1">Analyst Login</a>
        <a href="admin_login.jsp" class="btn btn-outline-light btn-sm mx-1">Admin Login</a>
      </div>
    </div>
  </div>
</nav>

<!-- HERO SECTION -->
<div class="container mt-5">
  <div class="row align-items-center gy-4">

    <!-- Left: Text -->
    <div class="col-md-6">
      <h1 class="fw-bold text-primary page-title">
        Smarter Diagnostic Management, <br/>All in One Place.
      </h1>
      <p class="lead text-muted mt-3">
        Book lab tests, track appointments, upload reports, and manage payments
        through a unified online platform for patients, analysts, and admins.
      </p>

      <div class="mt-4">
        <a href="patient_register.jsp" class="btn btn-primary btn-lg me-2">
          Register as Patient
        </a>
        <a href="patient_login.jsp" class="btn btn-outline-primary btn-lg">
          Patient Login
        </a>
      </div>

      <p class="mt-3 small text-muted">
        New analyst? <a href="analyst_register.jsp">Register here</a>
      </p>
    </div>

    <!-- Right: Illustration-style cards -->
    <div class="col-md-6">
      <div class="row g-3">

        <div class="col-12">
          <div class="dashboard-card">
            <div class="dashboard-icon">👤</div>
            <h5>For Patients</h5>
            <p class="text-muted small mb-1">
              Book tests, download reports, and view your payment history.
            </p>
            <a href="patient_login.jsp" class="small fw-semibold">Go to Patient Portal →</a>
          </div>
        </div>

        <div class="col-md-6">
          <div class="dashboard-card">
            <div class="dashboard-icon">🧪</div>
            <h5>For Analysts</h5>
            <p class="text-muted small mb-1">
              View assigned tests, update status, and upload reports.
            </p>
            <a href="analyst_login.jsp" class="small fw-semibold">Analyst Login →</a>
          </div>
        </div>

        <div class="col-md-6">
          <div class="dashboard-card">
            <div class="dashboard-icon">🛠</div>
            <h5>For Admins</h5>
            <p class="text-muted small mb-1">
              Manage users, appointments, tests, and payments.
            </p>
            <a href="admin_login.jsp" class="small fw-semibold">Admin Login →</a>
          </div>
        </div>

      </div>
    </div>

  </div>
</div>

<%@ include file="components/footer.jspf" %>

<!-- Bootstrap JS (optional, for navbar toggler) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
