package com.dms.controller;

import com.dms.dao.AdminDAO;
import com.dms.model.Admin;
import com.dms.util.HashUtil;

public class AdminController {
    private final AdminDAO dao = new AdminDAO();

    public Admin login(String email, String rawPassword) {
        if (email == null || rawPassword == null) return null;
        String hashed = HashUtil.sha256(rawPassword);
        return dao.validateAdmin(email, hashed);
    }

    // optional helper to create initial admin
    public boolean addAdmin(Admin a) {
        if (a == null) return false;
        a.setPassword(HashUtil.sha256(a.getPassword()));
        return dao.addAdmin(a);
    }
}
