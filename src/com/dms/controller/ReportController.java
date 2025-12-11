package com.dms.controller;

import com.dms.dao.ReportDAO;
import com.dms.model.Report;
import java.util.List;

public class ReportController {
    private final ReportDAO dao = new ReportDAO();

    public boolean addReport(Report r) {
        // could validate the appointment exists
        return dao.addReport(r);
    }

    public List<Report> getAllReports() {
        return dao.getAllReports();
    }

    public Report getReportByAppointment(int appointmentId) {
        return dao.getReportByAppointment(appointmentId);
    }

    public boolean deleteReport(int id) {
        return dao.deleteReport(id);
    }
    
    public boolean shareReport(int appointmentId) {
        return dao.shareReport(appointmentId);
    }

}
