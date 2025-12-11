package com.dms.dao;

import com.dms.model.Appointment;
import java.sql.*;
import java.util.*;

public class AppointmentDAO {

    // ➕ Add new appointment
    public boolean addAppointment(Appointment appt) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO appointments " +
                    "(patient_id, test_id, analyst_id, appointment_date, appointment_time, status, remarks) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            // patient & test MUST exist
            ps.setInt(1, appt.getPatientId());
            ps.setInt(2, appt.getTestId());

            // 🔴 CRITICAL PART: analyst_id may be NULL
            int analystId = appt.getAnalystId();
            System.out.println("DEBUG analystId = " + analystId); // just to see in console
            if (analystId <= 0) {
                ps.setNull(3, Types.INTEGER);         // 👉 this is what avoids the FK error
            } else {
                ps.setInt(3, analystId);
            }

            ps.setString(4, appt.getAppointmentDate());
            ps.setString(5, appt.getAppointmentTime());
            ps.setString(6, appt.getStatus());
            ps.setString(7, appt.getRemarks());

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 📋 Get all appointments
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM appointments";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setTestId(rs.getInt("test_id"));
                a.setAnalystId(rs.getInt("analyst_id"));    // will be 0 if NULL
                a.setAppointmentDate(rs.getString("appointment_date"));
                a.setAppointmentTime(rs.getString("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setRemarks(rs.getString("remarks"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✏️ Update appointment status or remarks
    public boolean updateAppointmentStatus(int appointmentId, String status, String remarks) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE appointments SET status=?, remarks=? WHERE appointment_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setInt(3, appointmentId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🔍 Get appointments for a specific patient
    public List<Appointment> getAppointmentsByPatient(int patientId) {
        List<Appointment> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM appointments WHERE patient_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setTestId(rs.getInt("test_id"));
                a.setAnalystId(rs.getInt("analyst_id"));
                a.setAppointmentDate(rs.getString("appointment_date"));
                a.setAppointmentTime(rs.getString("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setRemarks(rs.getString("remarks"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

 // ✅ Check whether a slot is free for a test at a particular date+time
    public boolean isSlotAvailable(int testId, String date, String time) {
        String sql = "SELECT COUNT(*) FROM appointments " +
                     "WHERE test_id=? AND appointment_date=? AND appointment_time=? " +
                     "AND status IN ('Pending','Approved','In-progress')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ps.setString(2, date);
            ps.setString(3, time);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;   // true = free
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;   // if error, treat as not available
    }
    
 // 🔍 Get a single appointment by ID
    public Appointment getAppointmentById(int appointmentId) {
        Appointment appt = null;
        String sql = "SELECT * FROM appointments WHERE appointment_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                appt = new Appointment();
                appt.setAppointmentId(rs.getInt("appointment_id"));
                appt.setPatientId(rs.getInt("patient_id"));
                appt.setTestId(rs.getInt("test_id"));

                // analyst_id may be NULL → map to 0
                int analystId = rs.getInt("analyst_id");
                if (rs.wasNull()) {
                    analystId = 0;
                }
                appt.setAnalystId(analystId);

                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setAppointmentTime(rs.getString("appointment_time"));
                appt.setStatus(rs.getString("status"));
                appt.setRemarks(rs.getString("remarks"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return appt;
    }

 // 🔹 Assign an analyst to appointment
    public boolean assignAnalyst(int appointmentId, int analystId) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE appointments SET analyst_id=?, status='Approved' WHERE appointment_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, analystId);
            ps.setInt(2, appointmentId);

            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    
 // 🔍 Get appointments assigned to a specific analyst
    public List<Appointment> getAppointmentsForAnalyst(int analystId) {
        List<Appointment> list = new ArrayList<>();

        String sql = "SELECT * FROM appointments WHERE analyst_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, analystId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setTestId(rs.getInt("test_id"));

                int aid = rs.getInt("analyst_id");
                if (rs.wasNull()) {
                    a.setAnalystId(0);
                } else {
                    a.setAnalystId(aid);
                }

                a.setAppointmentDate(rs.getString("appointment_date"));
                a.setAppointmentTime(rs.getString("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setRemarks(rs.getString("remarks"));

                list.add(a);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    
    // ❌ Delete appointment
    public boolean deleteAppointment(int appointmentId) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM appointments WHERE appointment_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
}
