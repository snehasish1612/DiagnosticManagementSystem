<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.TestDAO" %>
<%@ page import="com.dms.model.Test" %>
<%@ page import="com.dms.model.Patient" %>

<%
    Patient loggedPatient = (Patient) session.getAttribute("patient");
    if (loggedPatient == null) {
        response.sendRedirect("patient_login.jsp");
        return;
    }

    TestDAO testDao = new TestDAO();
    List<Test> tests = testDao.getAllTests();

    String error = (String) request.getAttribute("error");
    String msg   = request.getParameter("msg");   // e.g., ?msg=booked
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book Appointment</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Shared style.css (if you are using it globally) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-light">

<%@ include file="components/header.jspf" %>

<div class="container mt-5" style="max-width: 720px;">

    <h3 class="page-title text-primary">
        Book Test Appointment
    </h3>
    <p class="page-subtitle">
        Choose a test, pick your preferred date & time, and submit your slot request.
    </p>
    <hr>

    <!-- ✅ Success message (after redirect with ?msg=booked) -->
    <% if ("booked".equalsIgnoreCase(msg)) { %>
        <div class="alert alert-success">
            ✅ Your appointment has been booked successfully!
        </div>
    <% } %>

    <!-- ❌ Error message (set by servlet using request.setAttribute("error", "...")) -->
    <% if (error != null) { %>
        <div class="alert alert-danger">
            <%= error %>
        </div>
    <% } %>

    <form action="AppointmentServlet" method="post" class="p-4 bg-white rounded shadow form-card">
        <input type="hidden" name="action" value="book">
        <input type="hidden" name="patientId" value="<%= loggedPatient.getPatientId() %>">

        <!-- Test Selection -->
        <div class="mb-3">
            <label class="form-label fw-semibold">Select Test</label>
            <select name="testId" class="form-select" required>
                <option value="">-- Select --</option>
                <% for (Test t : tests) { %>
                   <option value="<%= t.getTestId() %>">
                       <%= t.getTestName() %> (₹<%= t.getPrice() %>)
                   </option>
                <% } %>
            </select>
        </div>

        <!-- Date & Time -->
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label fw-semibold">Preferred Date</label>
                <input type="date" name="appointmentDate" class="form-control" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label fw-semibold">Preferred Time</label>
                <input type="time" name="appointmentTime" class="form-control" required>
            </div>
        </div>

        <!-- Remarks -->
        <div class="mb-3">
            <label class="form-label fw-semibold">Remarks (optional)</label>
            <textarea name="remarks" class="form-control" rows="2" placeholder="Any special notes for the lab (e.g., fasting, previous conditions)"></textarea>
        </div>

        <button type="submit" class="btn btn-primary w-100">
            Book Slot
        </button>
    </form>
</div>

<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
