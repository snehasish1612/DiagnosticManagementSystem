<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.PaymentDAO" %>
<%@ page import="com.dms.model.Payment" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    PaymentDAO dao = new PaymentDAO();
    List<Payment> payments = dao.getAllPayments();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Payments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<%@ include file="components/header.jspf" %>
<div class="container mt-4">
    <h3 class="text-danger">All Payments</h3>
    <hr>
    <table class="table table-bordered table-striped">
        <tr>
            <th>Payment ID</th><th>Appointment ID</th><th>Amount</th><th>Status</th><th>Date</th>
        </tr>
        <% for (Payment p : payments) { %>
        <tr>
            <td><%= p.getPaymentId() %></td>
            <td><%= p.getAppointmentId() %></td>
            <td>Rs.<%= p.getAmount() %></td>
            <td><%= p.getStatus() %></td>
            <td><%= p.getPaymentDate() %></td>
        </tr>
        <% } %>
    </table>
</div>
<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
