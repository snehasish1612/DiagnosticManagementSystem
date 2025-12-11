package com.dms.dao;

import com.dms.model.Analyst;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnalystDAO {

    // ➕ Add Analyst
    public boolean addAnalyst(Analyst a) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO analysts (name, email, password, specialization, phone) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, a.getName());
            ps.setString(2, a.getEmail());
            ps.setString(3, a.getPassword());
            ps.setString(4, a.getSpecialization());
            ps.setString(5, a.getPhone());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🔍 Fetch all analysts
    public List<Analyst> getAllAnalysts() {
        List<Analyst> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM analysts";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Analyst a = new Analyst();
                a.setAnalystId(rs.getInt("analyst_id"));
                a.setName(rs.getString("name"));
                a.setEmail(rs.getString("email"));
                a.setPassword(rs.getString("password"));
                a.setSpecialization(rs.getString("specialization"));
                a.setPhone(rs.getString("phone"));
                a.setCreatedAt(rs.getString("created_at"));
                list.add(a);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ❌ Delete Analyst
 // 🔹 Delete Analyst (and unassign from appointments)
    public boolean deleteAnalyst(int id) {
        boolean success = false;

        try (Connection con = DBConnection.getConnection()) {

            // Use a transaction
            con.setAutoCommit(false);

            try {
                // 1️⃣ Remove this analyst from all appointments
                String sqlUnassign = "UPDATE appointments SET analyst_id = NULL WHERE analyst_id = ?";
                try (PreparedStatement ps1 = con.prepareStatement(sqlUnassign)) {
                    ps1.setInt(1, id);
                    ps1.executeUpdate();   // we don't care how many rows, just do it
                }

                // 2️⃣ Now delete the analyst
                String sqlDelete = "DELETE FROM analysts WHERE analyst_id = ?";
                try (PreparedStatement ps2 = con.prepareStatement(sqlDelete)) {
                    ps2.setInt(1, id);
                    int rows = ps2.executeUpdate();
                    success = rows > 0;
                }

                con.commit();
            } catch (SQLException e) {
                con.rollback();
                e.printStackTrace();
            } finally {
                con.setAutoCommit(true);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return success;
    }


    // 🔐 Validate Analyst Login
    public Analyst validateAnalyst(String email, String password) {
        Analyst a = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM analysts WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a = new Analyst();
                a.setAnalystId(rs.getInt("analyst_id"));
                a.setName(rs.getString("name"));
                a.setEmail(rs.getString("email"));
                a.setSpecialization(rs.getString("specialization"));
                a.setPhone(rs.getString("phone"));
                a.setCreatedAt(rs.getString("created_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return a;
    }
}
