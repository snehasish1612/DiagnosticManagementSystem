package com.dms.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/diagnostic_db";
    private static final String USER = "root";
    private static final String PASSWORD = "Snehasish@1612";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL Driver loaded");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        // 👇 each call returns a FRESH connection
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
