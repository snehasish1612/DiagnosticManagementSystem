package com.dms.dao;

import com.dms.model.Payment;
import java.sql.*;
import java.util.*;

public class PaymentDAO {

    // ➕ Add new payment record
    public boolean addPayment(Payment p) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO payments (appointment_id, amount, status) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, p.getAppointmentId());
            ps.setDouble(2, p.getAmount());
            ps.setString(3, p.getStatus());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 📋 Get all payments
    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM payments";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setAppointmentId(rs.getInt("appointment_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentDate(rs.getString("payment_date"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔍 Get payment by appointment ID
    public Payment getPaymentByAppointment(int appointmentId) {
        Payment p = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM payments WHERE appointment_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setAppointmentId(rs.getInt("appointment_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentDate(rs.getString("payment_date"));
                p.setStatus(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    // 🧾 Update payment status
    public boolean updatePaymentStatus(int paymentId, String status) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE payments SET status=? WHERE payment_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, paymentId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🗑️ Delete payment record
    public boolean deletePayment(int paymentId) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM payments WHERE payment_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, paymentId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
    
 // 🔍 Get all payments for a given patient (via appointments)
    public List<Payment> getPaymentsByPatient(int patientId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.* FROM payments p " +
                     "JOIN appointments a ON p.appointment_id = a.appointment_id " +
                     "WHERE a.patient_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setAppointmentId(rs.getInt("appointment_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentDate(rs.getString("payment_date"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean isPaymentDone(int appointmentId) {
        boolean status = false;

        String sql = "SELECT COUNT(*) FROM payments WHERE appointment_id=? AND status='Paid'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                status = true;
            }

        } catch (Exception e) { e.printStackTrace(); }

        return status;
    }


}
