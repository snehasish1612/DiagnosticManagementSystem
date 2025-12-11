<%@ page import="com.dms.dao.PaymentDAO" %>
<%@ page import="com.dms.dao.ReportDAO" %>
<%@ page import="com.dms.dao.AppointmentDAO" %>
<%@ page import="com.dms.dao.TestDAO" %>
<%@ page import="com.dms.model.Appointment" %>
<%@ page import="com.dms.model.Test" %>
<%@ page import="com.dms.model.Report" %>

<%
    // Guard: only logged-in analyst
    if (session.getAttribute("analyst") == null) {
        response.sendRedirect("analyst_login.jsp");
        return;
    }

    int appointmentId = 0;
    try { appointmentId = Integer.parseInt(request.getParameter("appointmentId")); } catch (Exception e) { }

    if (appointmentId <= 0) {
        // invalid id
        response.sendRedirect("view_appointments.jsp?msg=invalid_appointment");
        return;
    }

    AppointmentDAO apDao = new AppointmentDAO();
    Appointment appt = apDao.getAppointmentById(appointmentId);
    if (appt == null) {
        response.sendRedirect("view_appointments.jsp?msg=not_found");
        return;
    }

    TestDAO testDao = new TestDAO();
    Test test = testDao.getTestById(appt.getTestId());

    PaymentDAO payDao = new PaymentDAO();
    ReportDAO repDao = new ReportDAO();

    boolean isPaid = payDao.isPaymentDone(appointmentId);
    boolean reportExists = repDao.isReportUploaded(appointmentId);
    Report existingReport = reportExists ? repDao.getReportByAppointment(appointmentId) : null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Report — Appointment #<%= appointmentId %></title>

    <!-- Bootstrap + your shared stylesheet -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-light">

<%@ include file="components/header.jspf" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- Appointment card -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h5 class="card-title mb-1">Upload Report</h5>
                            <small class="text-muted">Appointment #<strong><%= appointmentId %></strong></small>
                        </div>
                        <div>
                            <a href="<%= request.getContextPath() %>/view_appointments.jsp" class="btn btn-outline-secondary btn-sm">Back</a>
                        </div>
                    </div>

                    <hr/>

                    <div class="row g-2">
                        <div class="col-md-6">
                            <p class="mb-1"><strong>Test</strong></p>
                            <p class="text-muted mb-0"><%= (test != null ? test.getTestName() : "—") %></p>
                        </div>
                        <div class="col-md-3">
                            <p class="mb-1"><strong>Date</strong></p>
                            <p class="text-muted mb-0"><%= appt.getAppointmentDate() %></p>
                        </div>
                        <div class="col-md-3">
                            <p class="mb-1"><strong>Time</strong></p>
                            <p class="text-muted mb-0"><%= appt.getAppointmentTime() %></p>
                        </div>
                    </div>

                    <div class="row g-2 mt-3">
                        <div class="col-md-6">
                            <p class="mb-1"><strong>Status</strong></p>
                            <p class="mb-0">
                                <span class="badge bg-info"><%= appt.getStatus() %></span>
                                <% if (!isPaid) { %>
                                    <span class="badge bg-warning text-dark ms-2">Unpaid</span>
                                <% } else { %>
                                    <span class="badge bg-success ms-2">Paid</span>
                                <% } %>
                            </p>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <p class="mb-1"><strong>Amount</strong></p>
                            <p class="text-muted mb-0">Rs. <%= (test != null ? String.format("%.2f", test.getPrice()) : "0.00") %></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Upload card -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <h6 class="card-subtitle mb-3 text-muted">Report upload</h6>

                    <% if (!isPaid) { %>
                        <div class="alert alert-danger">
                            <strong>Payment required</strong> — patient has not completed payment for this appointment.
                            Upload is disabled until payment is confirmed.
                        </div>

                        <!-- show a disabled form to indicate behaviour -->
                        <form class="p-3 bg-light rounded">
                            <div class="mb-3">
                                <label class="form-label">Report (PDF)</label>
                                <input type="file" class="form-control" disabled>
                            </div>
                            <button class="btn btn-primary w-100" disabled>Upload (payment required)</button>
                        </form>

                    <% } else if (reportExists && existingReport != null) { %>

                        <div class="alert alert-success">
                            <strong>Report uploaded</strong> — file stored on: <code><%= existingReport.getFilePath() %></code>
                        </div>

                        <div class="d-grid gap-2">
                            <a href="<%= request.getContextPath() + "/" + existingReport.getFilePath() %>" 
                               class="btn btn-outline-success" target="_blank">
                                View / Download Report
                            </a>
                        </div>

                    <% } else { %>

                        <form action="ReportServlet" method="post" enctype="multipart/form-data" class="p-3 bg-light rounded">
                            <input type="hidden" name="action" value="upload">
                            <input type="hidden" name="appointmentId" value="<%= appointmentId %>">

                            <div class="mb-3">
                                <label class="form-label">Select PDF file (max 10MB)</label>
                                <input type="file" name="reportFile" class="form-control" accept="application/pdf" required>
                                <div class="form-text">Allowed: PDF only. File will be stored securely.</div>
                            </div>

                            <button class="btn btn-primary w-100">Upload Report</button>
                        </form>

                    <% } %>

                </div>
            </div>

            <!-- small note -->
            <div class="text-center mt-3 text-muted small">
                Reports are visible to patients only after they are uploaded. Keep filenames meaningful.
            </div>

        </div>
    </div>
</div>

<%@ include file="components/back_button.jspf" %>
<%@ include file="components/footer.jspf" %>

</body>
</html>
