package com.dms.controller;

import com.dms.dao.AppointmentDAO;
import com.dms.model.Appointment;
import java.util.List;

public class AppointmentController {
    private final AppointmentDAO dao = new AppointmentDAO();

    public boolean addAppointment(Appointment a) {
        if (a == null) return false;
        if (a.getPatientId() <= 0 || a.getTestId() <= 0) return false;
        if (a.getAppointmentDate() == null || a.getAppointmentTime() == null) return false;

        // check availability
        if (!dao.isSlotAvailable(a.getTestId(), a.getAppointmentDate(), a.getAppointmentTime())) {
            return false;
        }
        return dao.addAppointment(a);
    }


    public List<Appointment> getAllAppointments() {
        return dao.getAllAppointments();
    }

    public List<Appointment> getAppointmentsByPatient(int patientId) {
        return dao.getAppointmentsByPatient(patientId);
    }

    public boolean updateStatus(int appointmentId, String status, String remarks) {
        return dao.updateAppointmentStatus(appointmentId, status, remarks);
    }

    public boolean assignAnalyst(int appointmentId, int analystId) {
        if (appointmentId <= 0 || analystId <= 0) return false;
        return dao.assignAnalyst(appointmentId, analystId);
    }

    
    public boolean deleteAppointment(int id) {
        return dao.deleteAppointment(id);
    }
}
