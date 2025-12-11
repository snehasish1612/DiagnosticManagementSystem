<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dms.dao.AppointmentDAO" %>
<%@ page import="com.dms.dao.TestDAO" %>
<%@ page import="com.dms.model.Appointment" %>
<%@ page import="com.dms.model.Test" %>
<%@ page import="com.dms.model.Patient" %>

<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("patient_login.jsp");
        return;
    }

    String apptIdParam = request.getParameter("appointmentId");
    int apptId = 0;
    try { apptId = Integer.parseInt(apptIdParam); } catch (Exception e) {}

    AppointmentDAO apDao = new AppointmentDAO();
    Appointment appt = apDao.getAppointmentById(apptId);

    if (appt == null || appt.getPatientId() != patient.getPatientId()) {
        out.println("<div class='container mt-5'><div class='alert alert-danger'>Invalid appointment.</div></div>");
        return;
    }

    TestDAO testDao = new TestDAO();
    Test t = testDao.getTestById(appt.getTestId());
    double amount = (t != null) ? t.getPrice() : 0.0;

    // optional messages (if servlet forwarded or redirected with ?msg= or setAttribute("error"))
    String infoMsg = request.getParameter("msg");
    String error = (String) request.getAttribute("error");
%>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>Payment — Appointment #<%= apptId %></title>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <!-- your shared stylesheet (optional) -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    /* small page-specific tweaks to keep it standalone-friendly */
    .payment-card { max-width:820px; margin:24px auto; }
    .test-meta { font-size:0.95rem; color:#555; }
    .amount-badge { font-size:1.25rem; font-weight:700; }
    .field-label { font-weight:600; color:#333; }
    .confirm-note { font-size:0.9rem; color:#666; }
  </style>
  <script>
    function confirmPayment(evt) {
      evt.preventDefault();
      const amt = document.getElementById('amountInput').value;
      if (!confirm('Confirm payment of ₹' + amt + ' ?')) return;
      // show small disabled state while submitting
      const btn = document.getElementById('payBtn');
      btn.disabled = true;
      btn.innerText = 'Processing…';
      // submit the form
      document.getElementById('paymentForm').submit();
    }
  </script>
</head>
<body class="bg-light">

  <%-- header include if you have --%>
  <%@ include file="components/header.jspf" %>

  <div class="payment-card">
    <% if (infoMsg != null) { %>
      <div class="alert alert-success"><%= infoMsg %></div>
    <% } %>
    <% if (error != null) { %>
      <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <div class="card shadow-sm">
      <div class="card-body p-4">
        <div class="d-flex justify-content-between align-items-start mb-3">
          <div>
            <h4 class="mb-1">Payment</h4>
            <div class="text-muted small">Appointment #<strong><%= apptId %></strong></div>
          </div>
          <div class="text-end">
            <a href="<%= request.getContextPath() %>/patient_appointments.jsp" class="btn btn-outline-secondary btn-sm">
              ← Back to My Appointments
            </a>
          </div>
        </div>

        <div class="row g-3 mb-4">
          <div class="col-md-8">
            <div class="card p-3 bg-white border">
              <div class="row">
                <div class="col-12 mb-2">
                  <div class="field-label">Test</div>
                  <% if (t != null) { %>
                    <div class="fw-semibold"><%= t.getTestName() %></div>
                    <div class="test-meta"><%= t.getDescription() == null ? "" : t.getDescription() %></div>
                  <% } else { %>
                    <div class="text-muted">Test not found (id: <%= appt.getTestId() %>)</div>
                  <% } %>
                </div>

                <div class="col-sm-6">
                  <div class="field-label">Date</div>
                  <div class="test-meta"><%= appt.getAppointmentDate() %></div>
                </div>
                <div class="col-sm-6">
                  <div class="field-label">Time</div>
                  <div class="test-meta"><%= appt.getAppointmentTime() %></div>
                </div>
              </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class="card p-3 bg-light border-0">
              <div class="mb-2 field-label">Amount to pay</div>
              <div class="d-flex align-items-center mb-3">
                <span class="badge bg-success amount-badge me-3">₹ <%= String.format("%.2f", amount) %></span>
                <div class="text-muted small">Test Fee</div>
              </div>

              <div class="confirm-note mb-2">
                Payment will mark the appointment as <strong>Paid</strong>.
              </div>
              <div class="text-muted small">We currently simulate payment — no card details are stored.</div>
            </div>
          </div>
        </div>

        <form id="paymentForm" action="PaymentServlet" method="post" class="p-0" onsubmit="confirmPayment(event)">
          <input type="hidden" name="action" value="pay">
          <input type="hidden" name="appointmentId" value="<%= apptId %>">
          <input type="hidden" name="status" value="Paid">

          <div class="row g-3">
            <div class="col-12 col-md-6">
              <label class="form-label field-label">Amount (₹)</label>
              <input id="amountInput" type="text" name="amount" class="form-control" value="<%= String.format("%.2f", amount) %>" readonly>
            </div>

            <!-- If you ever add UPI/CC simulation fields, they can go here -->
            <div class="col-12 col-md-6 d-flex align-items-end justify-content-end">
              <button id="payBtn" type="submit" class="btn btn-success btn-lg w-100">
                Confirm Payment
              </button>
            </div>
          </div>

        </form>

      </div>
    </div>
  </div>

  <%@ include file="components/back_button.jspf" %>
  <%@ include file="components/footer.jspf" %>
</body>
</html>
