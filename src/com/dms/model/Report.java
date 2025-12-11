package com.dms.model;

public class Report {
    private int reportId;
    private int appointmentId;
    private String filePath;
    private String uploadedAt;
    private String comments;
    private boolean shared;

    // Getters and Setters
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public String getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(String uploadedAt) { this.uploadedAt = uploadedAt; }

    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }
    
    public boolean isShared() { return shared; }
    public void setShared(boolean shared) { this.shared = shared; }
}
