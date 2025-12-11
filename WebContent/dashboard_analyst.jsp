<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.AppointmentDAO" %>
<%@ page import="com.dms.dao.ReportDAO" %>
<%@ page import="com.dms.model.Appointment" %>

<%
    // session guard
    String role = (String) session.getAttribute("role");
    if (role == null || !"ANALYST".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/analyst_login.jsp");
        return;
    }

    Integer analystIdObj = (Integer) session.getAttribute("analystId");
    if (analystIdObj == null) {
        response.sendRedirect(request.getContextPath() + "/analyst_login.jsp");
        return;
    }
    int analystId = analystIdObj;

    AppointmentDAO apDao = new AppointmentDAO();
    ReportDAO repDao = new ReportDAO();

    List<Appointment> assigned = apDao.getAppointmentsForAnalyst(analystId);

    int pending = 0;
    int completed = 0;
    int reportsPending = 0;

    for (Appointment a : assigned) {
        if ("Completed".equalsIgnoreCase(a.getStatus())) {
            completed++;
        } else {
            pending++;
        }

        // count appointments where report not uploaded
        boolean uploaded = false;
        try {
            uploaded = repDao.isReportUploaded(a.getAppointmentId());
        } catch (Throwable t) {
            // fallback: if method not available, try fetching the report object
            try {
                uploaded = (repDao.getReportByAppointment(a.getAppointmentId()) != null);
            } catch (Throwable ignored) { /* ignore */ }
        }
        if (!uploaded) reportsPending++;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Analyst Dashboard</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Shared style.css (optional) -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    /* small safe styles if you don't have style.css yet */
    .stat-card { background:#fff; border-radius:10px; padding:18px; box-shadow:0 6px 18px rgba(0,0,0,0.04); text-align:center; }
    .stat-number { font-size:32px; font-weight:700; color:#0d6efd; }
    .stat-label { color:#6c757d; margin-top:6px; }
    .dashboard-card { background:#fff; border-radius:10px; padding:20px; box-shadow:0 6px 18px rgba(0,0,0,0.04); }
    .dashboard-icon { font-size:32px; margin-bottom:8px; }
    .card-link-clean { text-decoration:none; color:inherit; display:block; }
  </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-success">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="#">🔬 Analyst Dashboard</a>
    <div>
      <a href="LogoutServlet" class="btn btn-light btn-sm logout-btn">Logout</a>
    </div>
  </div>
</nav>

<div class="container mt-5">

  <h3 class="text-success page-title">Welcome, <%= session.getAttribute("analystName") %> 👋</h3>
  <p class="page-subtitle">Manage assigned tests — update status and upload reports.</p>
  <hr>

  <!-- 📊 Stats Row: 3 boxes -->
  <div class="row g-4 mt-2">
    <div class="col-md-4">
      <div class="stat-card">
        <div class="stat-number"><%= pending %></div>
        <div class="stat-label">Pending / Assigned Appointments</div>
      </div>
    </div>

    <div class="col-md-4">
      <div class="stat-card">
        <div class="stat-number"><%= completed %></div>
        <div class="stat-label">Completed Tests</div>
      </div>
    </div>

    <div class="col-md-4">
      <div class="stat-card">
        <div class="stat-number"><%= reportsPending %></div>
        <div class="stat-label">Reports to upload</div>
      </div>
    </div>
  </div>

  <!-- 🧾 Operations (centered) -->
  <div class="row g-4 mt-4 justify-content-center">
    <div class="col-md-4">
      <a href="view_appointments.jsp" class="card-link-clean">
        <div class="dashboard-card text-center">
          <div class="dashboard-icon">📄</div>
          <h5>View Assigned Appointments</h5>
          <p class="text-muted small">Update status & upload reports</p>
        </div>
      </a>
    </div>
  </div>

</div>

<%@ include file="components/footer.jspf" %>

</body>
</html>
