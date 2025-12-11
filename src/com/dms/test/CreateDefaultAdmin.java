package com.dms.test;

import com.dms.controller.AdminController;
import com.dms.model.Admin;

public class CreateDefaultAdmin {
    public static void main(String[] args) {
        Admin admin = new Admin();
        admin.setName("Super Admin");
        admin.setEmail("admin@dms.com");
        admin.setPassword("admin123"); // plain here – controller will hash

        AdminController controller = new AdminController();
        boolean ok = controller.addAdmin(admin);
        System.out.println("Admin created: " + ok);
    }
}
