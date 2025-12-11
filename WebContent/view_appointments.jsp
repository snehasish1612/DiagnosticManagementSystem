<%@ page import="java.util.List" %>
<%@ page import="com.dms.dao.AppointmentDAO" %>
<%@ page import="com.dms.dao.ReportDAO" %>
<%@ page import="com.dms.model.Appointment" %>
<%@ page import="com.dms.model.Analyst" %>
<%@ page import="com.dms.model.Report" %>

<%
    Analyst analyst = (Analyst) session.getAttribute("analyst");
    if (analyst == null) {
        response.sendRedirect("analyst_login.jsp");
        return;
    }

    int analystId = analyst.getAnalystId();

    AppointmentDAO dao = new AppointmentDAO();
    List<Appointment> list = dao.getAppointmentsForAnalyst(analystId);

    ReportDAO rdao = new ReportDAO();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Appointments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<%@ include file="components/header.jspf" %>
<div class="container mt-4">
    <h3 class="text-success fw-bold">Assigned Tests</h3>
    <hr>

    <% String msg = request.getParameter("msg");
     if ("uploaded".equals(msg)) { %>
      <div class="alert alert-success">Report uploaded successfully.</div>
  	<% } %>

    <table class="table table-bordered table-striped text-center">
        <tr class="table-primary">
            <th>ID</th>
            <th>Patient</th>
            <th>Test</th>
            <th>Date</th>
            <th>Time</th>
            <th>Status</th>
            <th>Update Status</th>
            <th>Report</th>
        </tr>

        <% for (Appointment a : list) { 
            Report report = rdao.getReportByAppointment(a.getAppointmentId());    
        %>
        <tr>
            <td><%= a.getAppointmentId() %></td>
            <td><%= a.getPatientId() %></td>
            <td><%= a.getTestId() %></td>
            <td><%= a.getAppointmentDate() %></td>
            <td><%= a.getAppointmentTime() %></td>

            <td>
                <span class="badge 
                    <%= ("Completed".equals(a.getStatus()) ? "bg-success" : 
                    "Rejected".equals(a.getStatus()) ? "bg-danger" : 
                    "In-progress".equals(a.getStatus()) ? "bg-warning text-dark" : "bg-secondary") %>">
                    <%= a.getStatus() %>
                </span>
            </td>

            <!-- Update Status -->
            <td>
                <form action="AppointmentServlet" method="post" class="d-flex">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="appointmentId" value="<%= a.getAppointmentId() %>">

                    <select name="status" class="form-select form-select-sm me-2">
                        <option value="In-progress" <%= "In-progress".equals(a.getStatus()) ? "selected" : "" %>>In-progress</option>
                        <option value="Completed" <%= "Completed".equals(a.getStatus()) ? "selected" : "" %>>Completed</option>
                        <option value="Rejected" <%= "Rejected".equals(a.getStatus()) ? "selected" : "" %>>Rejected</option>
                    </select>

                    <input type="text" name="remarks" class="form-control form-control-sm me-2"
                           value="<%= a.getRemarks() != null ? a.getRemarks() : "" %>"
                           placeholder="Remarks">

                    <button class="btn btn-success btn-sm">Save</button>
                </form>
            </td>

            <!-- Upload or Status -->
            <td>
                <% if (report == null) { %>
                    <a href="upload_report.jsp?appointmentId=<%=a.getAppointmentId()%>" 
                       class="btn btn-primary btn-sm">
                        Upload Report
                    </a>
                <% } else { %>
                    <span class="badge bg-success">Uploaded</span>
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
