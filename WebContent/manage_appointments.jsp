<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.AppointmentDAO" %>
<%@ page import="com.dms.model.Appointment" %>
<%@ page import="com.dms.dao.AnalystDAO" %>
<%@ page import="com.dms.model.Analyst" %>

<%
    // Only admin can access
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    // load all analysts (for dropdown)
    AnalystDAO analystDao = new AnalystDAO();
    List<Analyst> analysts = analystDao.getAllAnalysts();

    // load all appointments
    AppointmentDAO dao = new AppointmentDAO();
    List<Appointment> list = dao.getAllAppointments();
%>

<!DOCTYPE html>
<html>

<head>
    <title>Manage Appointments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<%@ include file="components/header.jspf" %>
<div class="container mt-4">
    <h3 class="text-danger">Manage Appointments</h3>
    <hr>

    <% if (request.getParameter("msg") != null) { %>
        <div class="alert alert-info"><%= request.getParameter("msg") %></div>
    <% } %>

    <table class="table table-bordered table-striped align-middle">
        <tr>
            <th>ID</th>
            <th>Patient</th>
            <th>Test</th>
            <th>Date</th>
            <th>Time</th>
            <th>Status</th>
            <th>Assigned Analyst</th>
            <th>Action</th>
        </tr>

        <% for (Appointment a : list) { 
               // find current analyst name (if any)
               String analystName = "-";
               String analystSpec = "";
               for (Analyst an : analysts) {
                   if (an.getAnalystId() == a.getAnalystId()) {
                       analystName = an.getName();
                       analystSpec = an.getSpecialization();
                       break;
                   }
               }
        %>
        <tr>
            <td><%= a.getAppointmentId() %></td>
            <td><%= a.getPatientId() %></td>
            <td><%= a.getTestId() %></td>
            <td><%= a.getAppointmentDate() %></td>
            <td><%= a.getAppointmentTime() %></td>
            <td><span class="badge bg-info"><%= a.getStatus() %></span></td>

            <!-- shows currently assigned analyst -->
            <td>
                <% if (!"-".equals(analystName)) { %>
                    <strong><%= analystName %></strong><br/>
                    <small><%= analystSpec %></small>
                <% } else { %>
                    <span class="text-muted">Not assigned</span>
                <% } %>
            </td>

            <!-- form to ASSIGN / CHANGE analyst -->
            <td>
    			<% if (a.getAnalystId() == 0) { %>
        		<!-- Show form ONLY when no analyst assigned -->
        		<form action="AppointmentServlet" method="post" class="d-flex">
            		<input type="hidden" name="action" value="assignAnalyst">
            		<input type="hidden" name="appointmentId" value="<%= a.getAppointmentId() %>">

            		<select name="analystId" class="form-select form-select-sm me-2" required>
                		<option value="">-- Select Analyst --</option>
               			 <% for (Analyst an : analysts) { %>
                    		<option value="<%= an.getAnalystId() %>">
                        		<%= an.getName() %> - <%= an.getSpecialization() %>
                    		</option>
                		<% } %>
            		</select>

           	 		<button class="btn btn-primary btn-sm">Assign</button>
        		</form>
   				 <% } else { %>
       	 			<!-- Show assigned badge when already assigned -->
        			<button class="btn btn-success btn-sm" disabled>Assigned</button>
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
