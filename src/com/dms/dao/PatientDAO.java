package com.dms.dao;

import com.dms.model.Patient;
import com.dms.util.HashUtil; 
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import java.sql.SQLIntegrityConstraintViolationException;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class PatientDAO {

    // Insert a new patient
	public boolean addPatient(Patient p) {
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "INSERT INTO patients (name, email, password, phone, gender, age, address) "
	                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, p.getName());
	        ps.setString(2, p.getEmail());
	        ps.setString(3, p.getPassword());
	        ps.setString(4, p.getPhone());
	        ps.setString(5, p.getGender());
	        ps.setInt(6, p.getAge());
	        ps.setString(7, p.getAddress());

	        return ps.executeUpdate() > 0;

	    } catch (SQLIntegrityConstraintViolationException e) {
	        // email already exists (unique key violation)
	        System.out.println("❗ Email already exists: " + p.getEmail());
	        return false;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}


    // Retrieve all patients
    public List<Patient> getAllPatients() {
        List<Patient> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM patients";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Patient p = new Patient();
                p.setPatientId(rs.getInt("patient_id"));
                p.setName(rs.getString("name"));
                p.setEmail(rs.getString("email"));
                p.setPassword(rs.getString("password"));  
                p.setPhone(rs.getString("phone"));
                p.setGender(rs.getString("gender"));
                p.setAge(rs.getInt("age"));
                p.setAddress(rs.getString("address"));
                p.setCreatedAt(rs.getString("created_at")); 
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> deletePatientAndCollectReportPaths(int patientId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<String> reportPaths = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // begin transaction

            // 1) Collect appointment ids for this patient
            List<Integer> appointmentIds = new ArrayList<>();
            String sqlAppointments = "SELECT appointment_id FROM appointments WHERE patient_id = ?";
            ps = con.prepareStatement(sqlAppointments);
            ps.setInt(1, patientId);
            rs = ps.executeQuery();
            while (rs.next()) {
                appointmentIds.add(rs.getInt("appointment_id"));
            }
            rs.close();
            ps.close();

            // 2) Collect report file paths for those appointments (if any)
            if (!appointmentIds.isEmpty()) {
                String selectReportSql = "SELECT file_path FROM reports WHERE appointment_id = ?";
                PreparedStatement selReport = con.prepareStatement(selectReportSql);
                for (Integer apId : appointmentIds) {
                    selReport.setInt(1, apId);
                    rs = selReport.executeQuery();
                    while (rs.next()) {
                        String fp = rs.getString("file_path");
                        if (fp != null && !fp.trim().isEmpty()) reportPaths.add(fp);
                    }
                    rs.close();
                }
                selReport.close();
            }

            // 3) Delete reports rows that belong to these appointments
            if (!appointmentIds.isEmpty()) {
                StringBuilder inClause = new StringBuilder("(");
                for (int i = 0; i < appointmentIds.size(); i++) {
                    inClause.append("?");
                    if (i < appointmentIds.size() - 1) inClause.append(",");
                }
                inClause.append(")");
                String deleteReportsSql = "DELETE FROM reports WHERE appointment_id IN " + inClause.toString();
                PreparedStatement delReports = con.prepareStatement(deleteReportsSql);
                for (int i = 0; i < appointmentIds.size(); i++) delReports.setInt(i + 1, appointmentIds.get(i));
                delReports.executeUpdate();
                delReports.close();
            }

            // 4) Delete payments associated to those appointments (if payments reference appointment_id)
            if (!appointmentIds.isEmpty()) {
                StringBuilder inClause = new StringBuilder("(");
                for (int i = 0; i < appointmentIds.size(); i++) {
                    inClause.append("?");
                    if (i < appointmentIds.size() - 1) inClause.append(",");
                }
                inClause.append(")");
                String deletePaymentsByAppt = "DELETE FROM payments WHERE appointment_id IN " + inClause.toString();
                PreparedStatement delPayByAppt = con.prepareStatement(deletePaymentsByAppt);
                for (int i = 0; i < appointmentIds.size(); i++) delPayByAppt.setInt(i + 1, appointmentIds.get(i));
                delPayByAppt.executeUpdate();
                delPayByAppt.close();
            }

            // 5) Conditionally delete payments by patient if that column exists in payments table
            //    (some schemas don't have payments.patient_id)
            DatabaseMetaData md = con.getMetaData();
            ResultSet cols = md.getColumns(null, null, "payments", "patient_id");
            boolean paymentsHasPatientId = cols.next();
            cols.close();

            if (paymentsHasPatientId) {
                String deletePaymentsByPatient = "DELETE FROM payments WHERE patient_id = ?";
                ps = con.prepareStatement(deletePaymentsByPatient);
                ps.setInt(1, patientId);
                ps.executeUpdate();
                ps.close();
            } else {
                // no patient_id column — skip. (payments already cleaned by appointment_id)
            }

            // 6) Delete appointments for this patient
            String deleteAppointmentsSql = "DELETE FROM appointments WHERE patient_id = ?";
            ps = con.prepareStatement(deleteAppointmentsSql);
            ps.setInt(1, patientId);
            ps.executeUpdate();
            ps.close();

            // 7) Finally delete patient
            String deletePatientSql = "DELETE FROM patients WHERE patient_id = ?";
            ps = con.prepareStatement(deletePatientSql);
            ps.setInt(1, patientId);
            int rows = ps.executeUpdate();
            ps.close();

            if (rows > 0) {
                con.commit();
                return reportPaths;
            } else {
                con.rollback();
                return null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return null;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (Exception e) {}
        }
    }

    
    /**
     * Convenience wrapper that deletes the patient and attempts to delete files (caller may do file deletion).
     * Returns true if DB delete succeeded; false otherwise.
     */
    public boolean deletePatient(int patientId) {
        List<String> paths = deletePatientAndCollectReportPaths(patientId);
        return paths != null; // caller can request paths by using deletePatientAndCollectReportPaths directly
    }

 // 🔹 Validate login (for patient login functionality)
    public Patient validatePatient(String email, String password) {
        Patient p = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM patients WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);   // ✅ this is already hashed by controller
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                p = new Patient();
                p.setPatientId(rs.getInt("patient_id"));
                p.setName(rs.getString("name"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setGender(rs.getString("gender"));
                p.setAge(rs.getInt("age"));
                p.setAddress(rs.getString("address"));
                p.setCreatedAt(rs.getString("created_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

}
