<%@ page import="java.util.*" %>
<%@ page import="com.dms.dao.*" %>
<%@ page import="com.dms.model.*" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    AppointmentDAO apDao = new AppointmentDAO();
    PaymentDAO payDao = new PaymentDAO();
    ReportDAO repDao = new ReportDAO();

    List<Appointment> appts = apDao.getAllAppointments();
%>

<!DOCTYPE html>
<html>
<head>
<title>Generate Reports</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<%@ include file="components/header.jspf" %>
<div class="container mt-4">
<h3 class="text-danger">Generate & View Reports</h3>
<hr>

<table class="table table-bordered">
<tr>
    <th>ID</th><th>Patient</th><th>Test</th><th>Payment</th><th>Report</th><th>Action</th>
</tr>

<%
    for (Appointment a : appts) {
        boolean paid = payDao.isPaymentDone(a.getAppointmentId());
        boolean uploaded = repDao.isReportUploaded(a.getAppointmentId());
        boolean shared = repDao.isShared(a.getAppointmentId());
%>

<tr>
    <td><%= a.getAppointmentId() %></td>
    <td><%= a.getPatientId() %></td>
    <td><%= a.getTestId() %></td>

    <td><span class="badge <%= paid ? "bg-success" : "bg-danger" %>">
        <%= paid ? "Paid" : "Not Paid" %>
    </span></td>

    <td><span class="badge <%= uploaded ? "bg-info" : "bg-warning" %>">
        <%= uploaded ? "Uploaded" : "Pending" %>
    </span></td>

    <td>
        <% if (!paid) { %>
            <button class="btn btn-secondary btn-sm" disabled>Awaiting Payment</button>
        <% } else if (!uploaded) { %>
            <button class="btn btn-warning btn-sm" disabled>Waiting Upload</button>
        <% } else if (shared) { %>
            <span class="badge bg-success">Shared</span>
        <% } else { %>
            <form action="ReportServlet" method="post">
                <input type="hidden" name="action" value="share">
                <input type="hidden" name="appointmentId" value="<%=a.getAppointmentId()%>">
                <button class="btn btn-primary btn-sm">Send to Patient</button>
            </form>
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
