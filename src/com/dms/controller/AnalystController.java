package com.dms.controller;

import com.dms.dao.AnalystDAO;
import com.dms.model.Analyst;
import com.dms.util.HashUtil;

public class AnalystController {
    private final AnalystDAO dao = new AnalystDAO();

    public boolean register(Analyst a) {
        if (a == null) return false;
        if (a.getEmail() == null || a.getPassword() == null) return false;
        a.setPassword(HashUtil.sha256(a.getPassword()));
        return dao.addAnalyst(a);
    }

    public Analyst login(String email, String rawPassword) {
        if (email == null || rawPassword == null) return null;
        String hashed = HashUtil.sha256(rawPassword);
        return dao.validateAnalyst(email, hashed);
    }
}
