package com.dms.controller;

import com.dms.dao.PaymentDAO;
import com.dms.model.Payment;
import java.util.List;

public class PaymentController {
    private final PaymentDAO dao = new PaymentDAO();

    public boolean addPayment(Payment p) {
        return dao.addPayment(p);
    }

    public Payment getPaymentByAppointment(int appointmentId) {
        return dao.getPaymentByAppointment(appointmentId);
    }

    public List<Payment> getAllPayments() {
        return dao.getAllPayments();
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        return dao.updatePaymentStatus(paymentId, status);
    }
}
