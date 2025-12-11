package com.dms.dao;

import com.dms.model.Test;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TestDAO {

    // 🔹 Insert a new test
    public boolean addTest(Test t) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO tests (test_name, description, price, duration) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getTestName());
            ps.setString(2, t.getDescription());
            ps.setDouble(3, t.getPrice());
            ps.setString(4, t.getDuration());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🔹 Retrieve all tests
    public List<Test> getAllTests() {
        List<Test> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM tests";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Test t = new Test();
                t.setTestId(rs.getInt("test_id"));
                t.setTestName(rs.getString("test_name"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getDouble("price"));
                t.setDuration(rs.getString("duration"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Delete test by ID
    public boolean deleteTest(int id) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM tests WHERE test_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🔹 Update test details
    public boolean updateTest(Test t) {
        boolean success = false;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE tests SET test_name=?, description=?, price=?, duration=? WHERE test_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, t.getTestName());
            ps.setString(2, t.getDescription());
            ps.setDouble(3, t.getPrice());
            ps.setString(4, t.getDuration());
            ps.setInt(5, t.getTestId());
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
    
    // 🔹 Get a single test by ID
    public Test getTestById(int id) {
        Test t = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM tests WHERE test_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                t = new Test();
                t.setTestId(rs.getInt("test_id"));
                t.setTestName(rs.getString("test_name"));
                t.setDescription(rs.getString("description"));
                t.setPrice(rs.getDouble("price"));
                t.setDuration(rs.getString("duration"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return t;
    }

}
