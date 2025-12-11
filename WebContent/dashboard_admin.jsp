<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/admin_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Shared styles -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-danger">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="#">🛠 Admin Dashboard</a>
    <div>
      <!-- use LogoutServlet so session is properly cleared -->
      <a href="LogoutServlet" class="btn btn-light btn-sm logout-btn">Logout</a>
    </div>
  </div>
</nav>

<div class="container mt-5">

  <h3 class="text-danger page-title">Welcome, ${sessionScope.adminName} 👋</h3>
  <p class="page-subtitle">Manage users, tests, appointments, payments and reports.</p>
  <hr>

  <!-- Cards Row 1 -->
  <div class="row g-4 mt-2">

    <div class="col-md-4">
      <a href="manage_patients.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">👥</div>
          <h5>Manage Patients</h5>
          <p class="text-muted small">View, add or delete patient records</p>
        </div>
      </a>
    </div>

    <div class="col-md-4">
      <a href="manage_analysts.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">🧑‍🔬</div>
          <h5>Manage Analysts</h5>
          <p class="text-muted small">Assign analysts & maintain staff list</p>
        </div>
      </a>
    </div>

    <div class="col-md-4">
      <a href="manage_tests.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">🧪</div>
          <h5>Manage Tests</h5>
          <p class="text-muted small">Create or update diagnostic tests</p>
        </div>
      </a>
    </div>

  </div>

  <!-- Cards Row 2 -->
  <div class="row g-4 mt-2">

    <div class="col-md-4">
      <a href="manage_appointments.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">📅</div>
          <h5>Approve Appointments</h5>
          <p class="text-muted small">Assign analysts & manage slots</p>
        </div>
      </a>
    </div>

    <div class="col-md-4">
      <a href="view_payments.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">💳</div>
          <h5>View Payments</h5>
          <p class="text-muted small">Track paid & pending transactions</p>
        </div>
      </a>
    </div>

    <div class="col-md-4">
      <a href="generate_reports.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">📊</div>
          <h5>Generate Reports</h5>
          <p class="text-muted small">Review uploaded reports & access logs</p>
        </div>
      </a>
    </div>

  </div>

</div>

<%@ include file="components/footer.jspf" %>

</body>
</html>
