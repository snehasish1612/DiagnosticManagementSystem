<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.PatientDAO" %>
<%@ page import="com.dms.model.Patient" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    PatientDAO dao = new PatientDAO();
    List<Patient> patients = dao.getAllPatients();
%>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>Manage Patients</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="components/header.jspf" %>

<div class="container mt-4">
  <h3>Patients</h3>
  <hr>

  <% String msg = request.getParameter("msg");
     if ("deleted".equals(msg)) { %>
      <div class="alert alert-success">Patient removed successfully.</div>
  <% } %>

  <table class="table table-bordered table-striped">
    <thead>
      <tr>
        <th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
    <% for (Patient p : patients) { %>
      <tr>
        <td><%= p.getPatientId() %></td>
        <td><%= p.getName() %></td>
        <td><%= p.getEmail() %></td>
        <td><%= p.getPhone() %></td>
        <td>
          	<form action="AdminActionsServlet" method="post" onsubmit="return confirm('Delete patient and all their data? This cannot be undone.');">
    			<input type="hidden" name="action" value="removePatient" />
    			<input type="hidden" name="patientId" value="<%= p.getPatientId() %>" />
    			<button class="btn btn-danger btn-sm">Delete</button>
			</form>

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
