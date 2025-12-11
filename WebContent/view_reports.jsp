<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.ReportDAO" %>
<%@ page import="com.dms.model.Report" %>
<%@ page import="com.dms.dao.AppointmentDAO" %>
<%@ page import="com.dms.model.Appointment" %>

<%
    if (session.getAttribute("patient") == null) {
        response.sendRedirect("patient_login.jsp");
        return;
    }

    int pid = ((com.dms.model.Patient) session.getAttribute("patient")).getPatientId();

    AppointmentDAO apDao = new AppointmentDAO();
    List<Appointment> appts = apDao.getAppointmentsByPatient(pid);

    ReportDAO rDao = new ReportDAO();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="components/header.jspf" %>
<div class="container mt-4">
    <h3 class="text-primary">My Test Reports</h3>
    <hr>

<table class="table table-bordered table-striped text-center">
<tr class="bg-primary text-white">
    <th>Appointment</th>
    <th>Test Status</th>
    <th>Report Status</th>
    <th>Action</th>
</tr>

<% for (Appointment a : appts) {
     Report r = rDao.getReportByAppointment(a.getAppointmentId());
%>
<tr>
<td>#<%= a.getAppointmentId() %></td>
<td><span class="badge bg-info"><%= a.getStatus() %></span></td>

<td>
<% if (r == null) { %>
    <span class="badge bg-warning">Pending Upload</span>

<% } else if (!r.isShared()) { %>
    <span class="badge bg-secondary">Awaiting Approval</span>

<% } else { %>
    <span class="badge bg-success">Ready</span>
<% } %>
</td>

<td>
<% if (r != null && r.isShared()) { %>
    <a href="ReportServlet?action=download&appointmentId=<%= a.getAppointmentId() %>" class="btn btn-success btn-sm">Download</a>

<% } else { %>
    <button class="btn btn-outline-secondary btn-sm" disabled>Not Available</button>
<% } %>
</td>

</tr>
<% } %>
</table>
</div>

<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
