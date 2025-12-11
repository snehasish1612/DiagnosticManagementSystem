package com.dms.model;

public class Analyst {
    private int analystId;
    private String name;
    private String email;
    private String password;
    private String specialization;
    private String phone;
    private String createdAt;

    // Getters and Setters
    public int getAnalystId() { return analystId; }
    public void setAnalystId(int analystId) { this.analystId = analystId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
