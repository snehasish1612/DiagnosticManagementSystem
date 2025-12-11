package com.dms.test;

import java.util.List;

import com.dms.dao.PatientDAO;
import com.dms.model.Patient;

public class TestPatientDAO {
    public static void main(String[] args) {
        // Create DAO object
        PatientDAO dao = new PatientDAO();

        // Create a new Patient object
//        Patient p = new Patient();
//        p.setName("Tanushree Dhar");
//        p.setEmail("tanushree2004@gmail.com");
//        p.setPassword("test123");
//        p.setPhone("8954786234");
//        p.setGender("Female");
//        p.setAge(19);
//        p.setAddress("Kolkata, West Bengal");
//
//        // Try to add patient
//        boolean result1 = dao.addPatient(p);
//
//        if (result1)
//            System.out.println("✅ Patient added successfully!");
//        else
//            System.out.println("❌ Failed to add patient!");
    	
//          dao.deletePatient(1);
        
        List<Patient> pList = dao.getAllPatients();
        
        for(int i = 0; i < pList.size(); i++) {
        	System.out.println(pList.get(i).getPatientId());
        	System.out.println(pList.get(i).getName());
        	System.out.println(pList.get(i).getEmail());
        	System.out.println(pList.get(i).getPassword());
        	System.out.println(pList.get(i).getPhone());
        	System.out.println(pList.get(i).getGender());
        	System.out.println(pList.get(i).getAge());
        	System.out.println(pList.get(i).getAddress());
        	System.out.println(pList.get(i).getCreatedAt());
        	System.out.println();
        	
        }

        

    }
}
