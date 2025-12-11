package com.dms.servlet;

import com.dms.controller.TestController;
import com.dms.model.Test;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class TestServlet extends HttpServlet {
    private final TestController controller = new TestController();

    // GET -> list tests or show single test (if id param present)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("testId");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                Test t = controller.getTestById(id);
                req.setAttribute("test", t);
                // forward to a form for edit
                req.getRequestDispatcher("/test_form.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid testId");
            }
        } else {
            // list all tests
            List<Test> list = controller.getAllTests();
            req.setAttribute("tests", list);
            req.getRequestDispatcher("/manage_tests.jsp").forward(req, resp);
        }
    }

    // POST -> add / update / delete based on action param
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action required");
            return;
        }

        switch (action) {
            case "add":
                handleAdd(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            case "delete":
                handleDelete(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Test t = new Test();
        t.setTestName(req.getParameter("testName"));
        t.setDescription(req.getParameter("description"));
        try { t.setPrice(Double.parseDouble(req.getParameter("price"))); } catch (Exception e) { t.setPrice(0.0); }
        t.setDuration(req.getParameter("duration"));

        boolean ok = controller.addTest(t);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/TestServlet?msg=added");
        } else {
            req.setAttribute("error", "Failed to add test");
            req.getRequestDispatcher("/test_form.jsp").forward(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Test t = new Test();
        try { t.setTestId(Integer.parseInt(req.getParameter("testId"))); } catch (Exception e) { t.setTestId(0); }
        t.setTestName(req.getParameter("testName"));
        t.setDescription(req.getParameter("description"));
        try { t.setPrice(Double.parseDouble(req.getParameter("price"))); } catch (Exception e) { t.setPrice(0.0); }
        t.setDuration(req.getParameter("duration"));

        boolean ok = controller.updateTest(t);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/TestServlet?msg=updated");
        } else {
            req.setAttribute("error", "Failed to update test");
            req.setAttribute("test", t);
            req.getRequestDispatcher("/test_form.jsp").forward(req, resp);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("testId");
        int id = 0;
        try { id = Integer.parseInt(idParam); } catch (Exception e) { /* ignore */ }
        boolean ok = controller.deleteTest(id);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/TestServlet?msg=deleted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/TestServlet?msg=delete_failed");
        }
    }
}
