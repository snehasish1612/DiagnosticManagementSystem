# 🧬 Diagnostic Management System

A Java (JSP + Servlet) web application for managing diagnostic tests, appointments, payments and reports.

---

## 🔧 Quick overview

**Stack**
- Java (JSP + Servlets)
- MySQL
- Bootstrap (frontend)
- Apache Tomcat 9
- Eclipse IDE
- Git & GitHub

**Main modules**
- Patient — register/login, book tests, make payments, view reports
- Analyst — view assigned tests, update status, upload reports
- Admin — manage patients, analysts, tests, view payments, approve appointments

---

## 📁 Project structure

DiagnosticManagementSystem/
├── src/
│ ├── com.dms.controller/ # Controllers (servlets)
│ ├── com.dms.dao/ # DAO (DB access)
│ ├── com.dms.model/ # POJOs / models
│ ├── com.dms.servlet/ # Servlets (alternate package name)
│ ├── com.dms.util/ # HashUtil
│
├── WebContent/
│ ├── css/
│ ├── components/ # header.jspf, footer.jspf, back_button.jspf
│ ├── reports/ # uploaded reports (served statically)
│ ├── *.jsp # JSP pages
│ └── WEB-INF/
│ └── web.xml
│
├── .gitignore
└── README.md


---

## 🗄 Database schema (MySQL)

Run the following SQL to create the database and tables:

```sql
CREATE DATABASE diagnostic_db;

USE diagnostic_db;

CREATE TABLE patients (
	patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    phone VARCHAR(15),
    gender VARCHAR(10),
    age INT,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE analysts (
    analyst_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    specialization VARCHAR(100),
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE admin (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100)
);

CREATE TABLE tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2),
    duration VARCHAR(50)
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    test_id INT,
    analyst_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status ENUM('Pending','Approved','Rejected','In-progress','Completed') DEFAULT 'Pending',
    remarks TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (test_id) REFERENCES tests(test_id),
    FOREIGN KEY (analyst_id) REFERENCES analysts(analyst_id)
);

CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    file_path VARCHAR(255),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comments TEXT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    amount DECIMAL(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending','Paid','Failed') DEFAULT 'Pending',
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

INSERT INTO tests (test_name, description, price, duration) VALUES
('Complete Blood Count (CBC)', 'General blood health test', 500.00, '1 day'),
('Lipid Profile', 'Cholesterol and triglyceride levels', 900.00, '1 day'),
('Liver Function Test (LFT)', 'Checks liver health', 800.00, '1 day'),
('Thyroid Profile', 'T3, T4, TSH levels', 700.00, '1 day');



ALTER TABLE reports ADD COLUMN is_shared BOOLEAN DEFAULT FALSE;
```
## ▶ Run locally (quick)

- Import the project into Eclipse: File → Import → Existing Projects into Workspace.
- Configure DBConnection in src/com/dms/util/DBConnection.java (URL, username, password).
- Create diagnostic_db and tables (use the SQL above).
- Start Tomcat server in Eclipse and run the project on server.
- Open http://localhost:8080/<your-app-context>/ in browser.
