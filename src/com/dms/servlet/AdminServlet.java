package com.dms.servlet;

import com.dms.controller.AdminController;
import com.dms.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminServlet extends HttpServlet {
    private final AdminController controller = new AdminController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if ("login".equalsIgnoreCase(action)) {

            String email = req.getParameter("email");
            String password = req.getParameter("password");
            Admin a = controller.login(email, password);

            if (a != null) {
                // 🔴 destroy any previous session (patient / analyst / admin)
                HttpSession old = req.getSession(false);
                if (old != null) old.invalidate();

                // 🔵 create fresh session and set role
                HttpSession session = req.getSession(true);
                session.setAttribute("role", "ADMIN");
                session.setAttribute("admin", a);
                session.setAttribute("adminName", a.getName());

                resp.sendRedirect(req.getContextPath() + "/dashboard_admin.jsp");
            } else {
                req.setAttribute("error", "Invalid credentials");
                req.getRequestDispatcher("/admin_login.jsp").forward(req, resp);
            }
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported action");
        }
    }
}

