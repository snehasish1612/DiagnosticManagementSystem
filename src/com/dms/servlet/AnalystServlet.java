package com.dms.servlet;

import com.dms.controller.AnalystController;
import com.dms.model.Analyst;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AnalystServlet extends HttpServlet {
    private final AnalystController controller = new AnalystController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("register".equalsIgnoreCase(action)) {
            handleRegister(req, resp);
        } else if ("login".equalsIgnoreCase(action)) {
            handleLogin(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Analyst a = new Analyst();
        a.setName(req.getParameter("name"));
        a.setEmail(req.getParameter("email"));
        a.setPassword(req.getParameter("password"));
        a.setSpecialization(req.getParameter("specialization"));
        a.setPhone(req.getParameter("phone"));

        boolean ok = controller.register(a);
        if (ok) resp.sendRedirect(req.getContextPath() + "/analyst_login.jsp?msg=registered");
        else { req.setAttribute("error", "Registration failed"); req.getRequestDispatcher("/analyst_register.jsp").forward(req, resp); }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        Analyst a = controller.login(email, password);
        if (a != null) {
            // kill any previous session
            HttpSession old = req.getSession(false);
            if (old != null) old.invalidate();

            HttpSession session = req.getSession(true);
            session.setAttribute("role", "ANALYST");
            session.setAttribute("analyst", a);
            session.setAttribute("analystName", a.getName());
            session.setAttribute("analystId", a.getAnalystId());   // 🔹 add this

            resp.sendRedirect(req.getContextPath() + "/dashboard_analyst.jsp");
        } else {
            req.setAttribute("error", "Invalid credentials");
            req.getRequestDispatcher("/analyst_login.jsp").forward(req, resp);
        }
    }


}
