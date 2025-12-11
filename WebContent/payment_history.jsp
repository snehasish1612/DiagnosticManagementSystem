<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.PaymentDAO" %>
<%@ page import="com.dms.model.Payment" %>
<%@ page import="com.dms.model.Patient" %>

<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("patient_login.jsp");
        return;
    }
    int patientId = patient.getPatientId();

    PaymentDAO dao = new PaymentDAO();
    List<Payment> payments = dao.getPaymentsByPatient(patientId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<%@ include file="components/header.jspf" %>

<div class="container mt-4">
    <h3 class="text-primary">My Payment History</h3>
    <hr>

    <table class="table table-bordered table-striped">
        <thead>
        <tr>
            <th>Payment ID</th>
            <th>Appointment ID</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Date</th>
        </tr>
        </thead>
        <tbody>
        <% for (Payment p : payments) { %>
            <tr>
                <td><%= p.getPaymentId() %></td>
                <td><%= p.getAppointmentId() %></td>
                <td>₹<%= p.getAmount() %></td>
                <td><%= p.getStatus() %></td>
                <td><%= p.getPaymentDate() %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
