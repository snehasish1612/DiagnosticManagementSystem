package com.dms.servlet;

import com.dms.controller.PatientController;
import com.dms.model.Patient;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class PatientServlet extends HttpServlet {
    private final PatientController controller = new PatientController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	
    	System.out.println("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    	
        String action = req.getParameter("action");
        if ("register".equalsIgnoreCase(action)) {
        	
        	System.out.println("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
        	
            handleRegister(req, resp);
        } else if ("login".equalsIgnoreCase(action)) {
            handleLogin(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Patient p = new Patient();
        p.setName(req.getParameter("name"));
        p.setEmail(req.getParameter("email"));
        p.setPassword(req.getParameter("password")); // controller will hash
        p.setPhone(req.getParameter("phone"));
        p.setGender(req.getParameter("gender"));
        try { p.setAge(Integer.parseInt(req.getParameter("age"))); } catch (Exception e) { p.setAge(0); }
        p.setAddress(req.getParameter("address"));

        boolean ok = controller.register(p);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/patient_login.jsp?msg=registered");
        } else {
            req.setAttribute("error", "Registration failed. Try again.");
            req.getRequestDispatcher("/patient_register.jsp").forward(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        Patient p = controller.login(email, password);
        if (p != null) {
            HttpSession old = req.getSession(false);
            if (old != null) old.invalidate();

            HttpSession session = req.getSession(true);
            session.setAttribute("role", "PATIENT");
            session.setAttribute("patient", p);
            session.setAttribute("patientName", p.getName());

            resp.sendRedirect(req.getContextPath() + "/dashboard_patient.jsp");
        } else {
            req.setAttribute("error", "Invalid credentials");
            req.getRequestDispatcher("/patient_login.jsp").forward(req, resp);
        }
    }

}
