package com.dms.dao;

import com.dms.model.Admin;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    // 🔹 Insert a new admin
    public boolean addAdmin(Admin a) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO admin (name, email, password) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, a.getName());
            ps.setString(2, a.getEmail());
            ps.setString(3, a.getPassword());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🔹 Retrieve all admins
    public List<Admin> getAllAdmins() {
        List<Admin> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM admin";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Admin a = new Admin();
                a.setAdminId(rs.getInt("admin_id"));
                a.setName(rs.getString("name"));
                a.setEmail(rs.getString("email"));
                a.setPassword(rs.getString("password"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Delete admin by ID
    public boolean deleteAdmin(int id) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM admin WHERE admin_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🔹 Validate login (for admin login functionality)
    public Admin validateAdmin(String email, String password) {
        Admin a = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM admin WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                a = new Admin();
                a.setAdminId(rs.getInt("admin_id"));
                a.setName(rs.getString("name"));
                a.setEmail(rs.getString("email"));
                a.setPassword(rs.getString("password"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return a;
    }
}
