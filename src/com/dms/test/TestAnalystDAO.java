package com.dms.test;

import com.dms.dao.AnalystDAO;
import com.dms.model.Analyst;

public class TestAnalystDAO {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		AnalystDAO dao = new AnalystDAO();
//		
//		Analyst a = new Analyst();
//		
//		a.setName("Manisha");
//		a.setEmail("manisha@gmail.com");
//		a.setPassword("123456");
//		a.setSpecialization("Chest");
//		a.setPhone("893720102");
//		
//		boolean result = dao.addAnalyst(a);
//		
//		if (result)
//            System.out.println("✅ Analyst added successfully!");
//        else
//            System.out.println("❌ Failed to add analyst!");
		
		dao.deleteAnalyst(1);
		
		
		
	}

}
