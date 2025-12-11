<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.AppointmentDAO" %>
<%@ page import="com.dms.dao.PaymentDAO" %>
<%@ page import="com.dms.model.Appointment" %>
<%@ page import="com.dms.model.Payment" %>
<%@ page import="com.dms.model.Patient" %>

<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("patient_login.jsp");
        return;
    }
    int patientId = patient.getPatientId();

    AppointmentDAO apDao = new AppointmentDAO();
    PaymentDAO payDao = new PaymentDAO();

    List<Appointment> appts = apDao.getAppointmentsByPatient(patientId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Appointments & Payments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<%@ include file="components/header.jspf" %>
<%
   String msg = request.getParameter("msg");
%>
<% if ("paid".equalsIgnoreCase(msg)) { %>
  <div class="container mt-3">
    <div class="alert alert-success text-center">✅ Payment successful — appointment confirmed.</div>
  </div>
<% } %>

<div class="container mt-4">
    <h3 class="text-primary">My Appointments & Payments</h3>
    <hr>

    <table class="table table-bordered table-striped">
        <thead>
        <tr>
            <th>Appt ID</th>
            <th>Test ID</th>
            <th>Date</th>
            <th>Time</th>
            <th>Status</th>
            <th>Payment</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Appointment a : appts) {
                Payment payment = payDao.getPaymentByAppointment(a.getAppointmentId());
        %>
        <tr>
            <td><%= a.getAppointmentId() %></td>
            <td><%= a.getTestId() %></td>
            <td><%= a.getAppointmentDate() %></td>
            <td><%= a.getAppointmentTime() %></td>
            <td><span class="badge bg-info"><%= a.getStatus() %></span></td>
            <td>
                <% if (payment != null && "Paid".equalsIgnoreCase(payment.getStatus())) { %>
                    <span class="badge bg-success">Paid</span><br/>
                    <small>₹<%= payment.getAmount() %></small>
                <% } else { %>
                    <span class="badge bg-warning text-dark">Not Paid</span>
                <% } %>
            </td>
            <td>
                <% if (payment == null || !"Paid".equalsIgnoreCase(payment.getStatus())) { %>
                    <!-- Pay now only if not paid -->
                    <a href="payment_page.jsp?appointmentId=<%= a.getAppointmentId() %>" 
                       class="btn btn-sm btn-primary">Pay Now</a>
                <% } else { %>
                    <small>No action</small>
                <% } %>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
