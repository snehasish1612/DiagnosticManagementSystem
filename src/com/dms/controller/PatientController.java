package com.dms.controller;

import com.dms.dao.PatientDAO;
import com.dms.model.Patient;
import com.dms.util.HashUtil;

public class PatientController {
    private final PatientDAO dao = new PatientDAO();

    public boolean register(Patient p) {
        if (p == null) return false;
        if (p.getEmail() == null || p.getPassword() == null) return false;
        // hash password
        p.setPassword(HashUtil.sha256(p.getPassword()));
        return dao.addPatient(p);
    }

    public Patient login(String email, String rawPassword) {
        if (email == null || rawPassword == null) return null;
        String hashed = HashUtil.sha256(rawPassword);
        return dao.validatePatient(email, hashed);
    }
}
