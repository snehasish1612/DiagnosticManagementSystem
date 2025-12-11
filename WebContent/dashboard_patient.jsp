<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"PATIENT".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/patient_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Patient Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="#">🏥 Patient Dashboard</a>
    <div>
      <a href="LogoutServlet" class="btn btn-light btn-sm logout-btn">Logout</a>
    </div>
  </div>
</nav>

<div class="container mt-5">
  <h3 class="text-primary page-title">Welcome, ${sessionScope.patientName} 👋</h3>
  <p class="page-subtitle">Manage your tests, appointments, payments and reports from here.</p>
  <hr>

  <div class="row g-4 mt-3">

    <div class="col-md-3">
      <a href="book_appointment.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">📅</div>
          <h5>Book Appointment</h5>
          <p class="text-muted small">Schedule a new diagnostic test</p>
        </div>
      </a>
    </div>

    <div class="col-md-3">
      <a href="view_reports.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">📄</div>
          <h5>View Reports</h5>
          <p class="text-muted small">Download completed test results</p>
        </div>
      </a>
    </div>

    <div class="col-md-3">
      <a href="patient_appointments.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">📝</div>
          <h5>My Appointments</h5>
          <p class="text-muted small">Track test progress and status</p>
        </div>
      </a>
    </div>

    <div class="col-md-3">
      <a href="payment_history.jsp" class="card-link-clean">
        <div class="dashboard-card">
          <div class="dashboard-icon">💳</div>
          <h5>Payment History</h5>
          <p class="text-muted small">View and verify your payments</p>
        </div>
      </a>
    </div>

  </div>
</div>

<%@ include file="components/footer.jspf" %>

</body>
</html>
