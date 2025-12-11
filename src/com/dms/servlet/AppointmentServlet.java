package com.dms.servlet;

import com.dms.controller.AppointmentController;
import com.dms.model.Appointment;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AppointmentServlet extends HttpServlet {
    private final AppointmentController controller = new AppointmentController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("book".equalsIgnoreCase(action)) {
            handleBook(req, resp);
        } else if ("updateStatus".equalsIgnoreCase(action)) {
            handleUpdateStatus(req, resp);
        }else if ("assignAnalyst".equalsIgnoreCase(action)) {
            handleAssignAnalyst(req, resp);
        }
        else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // example: list all appointments
        List<Appointment> list = controller.getAllAppointments();
        req.setAttribute("appointments", list);
        req.getRequestDispatcher("/view_appointments.jsp").forward(req, resp);
    }

    private void handleBook(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Appointment a = new Appointment();
        try { a.setPatientId(Integer.parseInt(req.getParameter("patientId"))); } catch (Exception e) {}
        try { a.setTestId(Integer.parseInt(req.getParameter("testId"))); } catch (Exception e) {}

        // analyst may not be assigned yet
        String analystParam = req.getParameter("analystId");
        if (analystParam != null && !analystParam.trim().isEmpty()) {
            try { a.setAnalystId(Integer.parseInt(analystParam)); } catch (Exception e) { a.setAnalystId(0); }
        } else {
            a.setAnalystId(0); // will become NULL in DAO
        }

        a.setAppointmentDate(req.getParameter("appointmentDate"));
        a.setAppointmentTime(req.getParameter("appointmentTime"));
        a.setStatus("Pending");
        a.setRemarks(req.getParameter("remarks"));

        boolean ok = controller.addAppointment(a);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/book_appointment.jsp?msg=booked");
        } else {
            req.setAttribute("error", "Booking failed. Please try again.");
            req.getRequestDispatcher("/book_appointment.jsp").forward(req, resp);
        }

    }

    private void handleAssignAnalyst(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));
        int analystId = Integer.parseInt(req.getParameter("analystId"));

        boolean ok = controller.assignAnalyst(appointmentId, analystId);

        if (ok)
            resp.sendRedirect("manage_appointments.jsp?msg=assigned");
        else
            resp.sendRedirect("manage_appointments.jsp?msg=failed");
    }


    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int id = Integer.parseInt(req.getParameter("appointmentId"));
        String status = req.getParameter("status");
        String remarks = req.getParameter("remarks");
        boolean ok = controller.updateStatus(id, status, remarks);
        if (ok) resp.sendRedirect(req.getContextPath() + "/view_appointments.jsp?msg=updated");
        else { req.setAttribute("error", "Update failed"); req.getRequestDispatcher("/view_appointments.jsp").forward(req, resp); }
    }
}
