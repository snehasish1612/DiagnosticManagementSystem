package com.dms.controller;

import com.dms.dao.TestDAO;
import com.dms.model.Test;

import java.util.List;

public class TestController {
    private final TestDAO dao = new TestDAO();

    // Add a new test
    public boolean addTest(Test t) {
        if (t == null) return false;
        if (t.getTestName() == null || t.getTestName().trim().isEmpty()) return false;
        return dao.addTest(t);
    }

    // Get all tests
    public List<Test> getAllTests() {
        return dao.getAllTests();
    }

    // Get by id
    public Test getTestById(int id) {
        try {
            return dao.getTestById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Update test
    public boolean updateTest(Test t) {
        if (t == null) return false;
        if (t.getTestId() <= 0) return false;
        return dao.updateTest(t);
    }

    // Delete test
    public boolean deleteTest(int id) {
        if (id <= 0) return false;
        return dao.deleteTest(id);
    }
}
