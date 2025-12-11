package com.dms.servlet;

import com.dms.controller.ReportController;
import com.dms.model.Report;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024,           // 10MB
        maxRequestSize = 20 * 1024 * 1024)        // 20MB
public class ReportServlet extends HttpServlet {
    private final ReportController controller = new ReportController();

    // Note: no @WebServlet; register in web.xml
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("upload".equalsIgnoreCase(action)) {
            handleUpload(req, resp);
        }else if ("share".equalsIgnoreCase(action)) {
            handleShare(req, resp);
        }
        else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        if ("download".equalsIgnoreCase(action)) {
            handleDownload(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid GET request");
        }
    }


    private void handleUpload(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // form fields: appointmentId, comments, file (input name="reportFile")
        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));
        String comments = req.getParameter("comments");
        Part filePart = req.getPart("reportFile");

        if (filePart == null || filePart.getSize() == 0) {
            req.setAttribute("error", "No file uploaded");
            req.getRequestDispatcher("/upload_report.jsp").forward(req, resp);
            return;
        }

        // choose a folder to save reports inside the webapp (e.g., WebContent/reports/)
        String applicationPath = getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + "reports";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // store relative path to DB (so that web can serve /reports/<fileName>)
        String relativePath = "reports/" + fileName;

        Report r = new Report();
        r.setAppointmentId(appointmentId);
        r.setFilePath(relativePath);
        r.setComments(comments);

        boolean ok = controller.addReport(r);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/view_appointments.jsp?msg=uploaded");
        } else {
            req.setAttribute("error", "Upload/DB save failed");
            req.getRequestDispatcher("/upload_report.jsp").forward(req, resp);
        }
    }
    
    private void handleShare(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));

        boolean ok = controller.shareReport(appointmentId); // ✔ use controller

        String ctx = req.getContextPath();
        if (ok)
            resp.sendRedirect(ctx + "/generate_reports.jsp?msg=Report shared with patient");
        else
            resp.sendRedirect(ctx + "/generate_reports.jsp?msg=Failed to share");
    }

    
    private void handleDownload(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));

        // get report from DB
        Report r = controller.getReportByAppointment(appointmentId);

        if (r == null) {
            resp.getWriter().write("Report not available.");
            return;
        }

        String filePath = getServletContext().getRealPath("") + File.separator + r.getFilePath();

        File file = new File(filePath);
        if (!file.exists()) {
            resp.getWriter().write("File not found.");
            return;
        }

        // Set browser response to download
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

        java.nio.file.Files.copy(file.toPath(), resp.getOutputStream());
    }


}
