package com.dms.servlet;

import com.dms.controller.PaymentController;
import com.dms.model.Payment;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class PaymentServlet extends HttpServlet {
    private final PaymentController controller = new PaymentController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("pay".equalsIgnoreCase(action)) {
            handlePay(req, resp);
        } else if ("updateStatus".equalsIgnoreCase(action)) {
            handleUpdateStatus(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    private void handlePay(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Payment p = new Payment();
        try { p.setAppointmentId(Integer.parseInt(req.getParameter("appointmentId"))); } catch (Exception e) {}
        try { p.setAmount(Double.parseDouble(req.getParameter("amount"))); } catch (Exception e) { p.setAmount(0.0); }
        p.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "Pending");

        boolean ok = controller.addPayment(p);
        if (ok) resp.sendRedirect(req.getContextPath() + "/patient_appointments.jsp?msg=paid");
        else { req.setAttribute("error", "Payment failed"); 
        req.getRequestDispatcher("/payment_page.jsp").forward(req, resp); 
        }
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int paymentId = Integer.parseInt(req.getParameter("paymentId"));
        String status = req.getParameter("status");
        boolean ok = controller.updatePaymentStatus(paymentId, status);
        if (ok) resp.sendRedirect(req.getContextPath() + "/view_payments.jsp?msg=updated");
        else resp.sendRedirect(req.getContextPath() + "/view_payments.jsp?msg=failed");
    }
}
