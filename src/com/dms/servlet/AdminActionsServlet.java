package com.dms.servlet;

import com.dms.dao.PatientDAO;
import com.dms.dao.AnalystDAO;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.File;
import java.util.List;

public class AdminActionsServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();
    private final AnalystDAO analystDAO = new AnalystDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);

        // simple admin check
        if (session == null || session.getAttribute("admin") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin_login.jsp");
            return;
        }

        if ("removePatient".equalsIgnoreCase(action)) {
        	handleDeletePatient(req, resp);
        } else if ("removeAnalyst".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(req.getParameter("analystId"));
            analystDAO.deleteAnalyst(id);
            resp.sendRedirect(req.getContextPath() + "/manage_analysts.jsp?msg=removed");
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown admin action");
        }
    }
    
    private void handleDeletePatient(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int patientId = 0;
        try { patientId = Integer.parseInt(req.getParameter("patientId")); } catch (Exception e) {}

        if (patientId <= 0) {
            resp.sendRedirect("manage_patients.jsp?msg=invalid_id");
            return;
        }

        // DB transaction: delete and collect report file paths
        List<String> reportPaths = patientDAO.deletePatientAndCollectReportPaths(patientId);

        if (reportPaths == null) {
            // DB delete failed
            resp.sendRedirect("manage_patients.jsp?msg=delete_failed");
            return;
        }

     // === Delete report files from disk (best-effort) ===
        if (reportPaths != null && !reportPaths.isEmpty()) {

            String appRealPath = getServletContext().getRealPath("");
            if (appRealPath == null) {
                System.err.println("Warning: getRealPath() returned NULL. Skipping file deletion.");
            } else {
                Path basePath = Paths.get(appRealPath).toAbsolutePath().normalize();

                for (String relPath : reportPaths) {
                    if (relPath == null || relPath.trim().isEmpty()) continue;

                    try {
                        Path filePath = basePath.resolve(relPath).normalize();

                        // prevent path traversal attack
                        if (!filePath.startsWith(basePath)) {
                            System.err.println("Skipping suspicious path: " + relPath);
                            continue;
                        }

                        Files.deleteIfExists(filePath);
                    } catch (Exception ex) {
                        System.err.println("Could not delete report file: " + relPath);
                        ex.printStackTrace();
                    }
                }
            }
        }


        resp.sendRedirect("manage_patients.jsp?msg=deleted");
    }
}
