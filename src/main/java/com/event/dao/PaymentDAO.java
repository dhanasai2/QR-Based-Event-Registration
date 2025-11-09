package com.event.dao;

import com.event.model.Payment;
import com.event.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    // Create new payment record (updated for manual payment)
    public int createPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO payments (registration_id, payment_gateway_tx_id, amount, status, " +
                     "payment_method, payment_status, utr_number, payment_proof, upi_id, payer_name) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, payment.getRegistrationId());
            pstmt.setString(2, payment.getPaymentGatewayTxId());
            pstmt.setBigDecimal(3, payment.getAmount());
            pstmt.setString(4, payment.getStatus() != null ? payment.getStatus() : "PENDING");
            pstmt.setString(5, payment.getPaymentMethod());
            pstmt.setString(6, payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "PENDING_PROOF");
            pstmt.setString(7, payment.getUtrNumber());
            pstmt.setString(8, payment.getPaymentProof());
            pstmt.setString(9, payment.getUpiId());
            pstmt.setString(10, payment.getPayerName());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    // ✅ NEW: Save payment proof submitted by user
    public boolean savePaymentProof(int paymentId, String utrNumber, String paymentProof, 
                                    String upiId, String payerName) throws SQLException {
        String sql = "UPDATE payments SET utr_number = ?, payment_proof = ?, upi_id = ?, " +
                     "payer_name = ?, payment_status = 'PROOF_SUBMITTED', proof_submitted_at = NOW() " +
                     "WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, utrNumber);
            pstmt.setString(2, paymentProof);
            pstmt.setString(3, upiId);
            pstmt.setString(4, payerName);
            pstmt.setInt(5, paymentId);
            
            int rows = pstmt.executeUpdate();
            System.out.println("✓ Payment proof saved for payment ID: " + paymentId);
            return rows > 0;
        }
    }

    // ✅ NEW: Save payment proof by registration ID
    public boolean savePaymentProofByRegistrationId(int registrationId, String utrNumber, 
                                                     String paymentProof, String upiId, 
                                                     String payerName) throws SQLException {
        String sql = "UPDATE payments SET utr_number = ?, payment_proof = ?, upi_id = ?, " +
                     "payer_name = ?, payment_status = 'PROOF_SUBMITTED', proof_submitted_at = NOW() " +
                     "WHERE registration_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, utrNumber);
            pstmt.setString(2, paymentProof);
            pstmt.setString(3, upiId);
            pstmt.setString(4, payerName);
            pstmt.setInt(5, registrationId);
            
            int rows = pstmt.executeUpdate();
            System.out.println("✓ Payment proof saved for registration ID: " + registrationId);
            return rows > 0;
        }
    }

    // ✅ NEW: Verify payment (Admin approval)
    public boolean verifyPayment(int paymentId, int adminUserId, String remarks) throws SQLException {
        String sql = "UPDATE payments SET payment_status = 'VERIFIED', status = 'COMPLETED', " +
                     "verified_by = ?, verified_at = NOW(), admin_remarks = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminUserId);
            pstmt.setString(2, remarks);
            pstmt.setInt(3, paymentId);
            
            int rows = pstmt.executeUpdate();
            System.out.println("✓ Payment verified by admin ID: " + adminUserId);
            return rows > 0;
        }
    }

    // ✅ NEW: Reject payment (Admin rejection)
    public boolean rejectPayment(int paymentId, int adminUserId, String remarks) throws SQLException {
        String sql = "UPDATE payments SET payment_status = 'REJECTED', status = 'FAILED', " +
                     "verified_by = ?, verified_at = NOW(), admin_remarks = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminUserId);
            pstmt.setString(2, remarks);
            pstmt.setInt(3, paymentId);
            
            int rows = pstmt.executeUpdate();
            System.out.println("⚠ Payment rejected by admin ID: " + adminUserId);
            return rows > 0;
        }
    }

    // ✅ NEW: Get all pending payments (for admin verification)
    public List<Payment> getPendingPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, r.user_id, u.name as user_name, u.email, e.name as event_name " +
                     "FROM payments p " +
                     "JOIN registrations r ON p.registration_id = r.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE p.payment_status = 'PROOF_SUBMITTED' " +
                     "ORDER BY p.proof_submitted_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Payment payment = extractPaymentFromResultSet(rs);
                // You can add user and event details to payment object if needed
                payments.add(payment);
            }
        }
        return payments;
    }

    // ✅ NEW: Get payments awaiting proof submission
    public List<Payment> getPaymentsAwaitingProof() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE payment_status = 'PENDING_PROOF' " +
                     "ORDER BY transaction_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
        }
        return payments;
    }

    // ✅ NEW: Get verified payments
    public List<Payment> getVerifiedPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE payment_status = 'VERIFIED' " +
                     "ORDER BY verified_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
        }
        return payments;
    }

    // Get payment by ID
    public Payment getPaymentById(int paymentId) throws SQLException {
        String sql = "SELECT * FROM payments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, paymentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractPaymentFromResultSet(rs);
            }
        }
        return null;
    }

    // Get payment by registration ID
    public Payment getPaymentByRegistrationId(int registrationId) throws SQLException {
        String sql = "SELECT * FROM payments WHERE registration_id = ? ORDER BY transaction_date DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, registrationId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractPaymentFromResultSet(rs);
            }
        }
        return null;
    }

    // Update payment status (3 parameters - backward compatibility)
    public boolean updatePaymentStatus(String orderId, String status, String paymentId) throws SQLException {
        String sql = "UPDATE payments SET status = ?, payment_gateway_tx_id = ? WHERE payment_gateway_tx_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setString(2, paymentId);
            pstmt.setString(3, orderId);
            
            int rows = pstmt.executeUpdate();
            return rows > 0;
        }
    }

    // Update payment status (2 parameters)
    public void updatePaymentStatus(String orderId, String status) throws SQLException {
        String sql = "UPDATE payments SET status = ? WHERE payment_gateway_tx_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setString(2, orderId);
            
            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                System.out.println("✓ Payment status updated: " + orderId + " -> " + status);
            } else {
                System.err.println("⚠ No payment found with order ID: " + orderId);
            }
        }
    }

    // ✅ NEW: Update payment status by ID
    public boolean updatePaymentStatusById(int paymentId, String status) throws SQLException {
        String sql = "UPDATE payments SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, paymentId);
            
            return pstmt.executeUpdate() > 0;
        }
    }

    // Get registration ID by order ID
    public int getRegistrationIdByOrderId(String orderId) throws SQLException {
        String sql = "SELECT registration_id FROM payments WHERE payment_gateway_tx_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, orderId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int regId = rs.getInt("registration_id");
                    System.out.println("✓ Found registration ID: " + regId + " for order: " + orderId);
                    return regId;
                }
            }
        }
        
        throw new SQLException("No registration found for order ID: " + orderId);
    }

    // Get all payments
    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY transaction_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
        }
        return payments;
    }

    // ✅ UPDATED: Extract payment object from result set with new fields
    private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setId(rs.getInt("id"));
        payment.setRegistrationId(rs.getInt("registration_id"));
        payment.setPaymentGatewayTxId(rs.getString("payment_gateway_tx_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setStatus(rs.getString("status"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setTransactionDate(rs.getTimestamp("transaction_date"));
        
        // New fields (with null checks)
        try {
            payment.setUtrNumber(rs.getString("utr_number"));
            payment.setPaymentProof(rs.getString("payment_proof"));
            payment.setPaymentStatus(rs.getString("payment_status"));
            payment.setAdminRemarks(rs.getString("admin_remarks"));
            
            int verifiedBy = rs.getInt("verified_by");
            payment.setVerifiedBy(rs.wasNull() ? null : verifiedBy);
            
            payment.setVerifiedAt(rs.getTimestamp("verified_at"));
            payment.setProofSubmittedAt(rs.getTimestamp("proof_submitted_at"));
            payment.setUpiId(rs.getString("upi_id"));
            payment.setPayerName(rs.getString("payer_name"));
        } catch (SQLException e) {
            // Columns might not exist in old database schema
            System.err.println("⚠ Some payment columns not found: " + e.getMessage());
        }
        
        return payment;
    }

    // ✅ NEW: Check if UTR number already exists (prevent duplicate submissions)
    public boolean isUtrNumberExists(String utrNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM payments WHERE utr_number = ? AND payment_status IN ('PROOF_SUBMITTED', 'VERIFIED')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, utrNumber);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // ✅ NEW: Get payment statistics for admin dashboard
    public PaymentStats getPaymentStatistics() throws SQLException {
        String sql = "SELECT " +
                     "COUNT(CASE WHEN payment_status = 'PENDING_PROOF' THEN 1 END) as pending_proof, " +
                     "COUNT(CASE WHEN payment_status = 'PROOF_SUBMITTED' THEN 1 END) as awaiting_verification, " +
                     "COUNT(CASE WHEN payment_status = 'VERIFIED' THEN 1 END) as verified, " +
                     "COUNT(CASE WHEN payment_status = 'REJECTED' THEN 1 END) as rejected, " +
                     "SUM(CASE WHEN payment_status = 'VERIFIED' THEN amount ELSE 0 END) as total_verified_amount " +
                     "FROM payments";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return new PaymentStats(
                    rs.getInt("pending_proof"),
                    rs.getInt("awaiting_verification"),
                    rs.getInt("verified"),
                    rs.getInt("rejected"),
                    rs.getBigDecimal("total_verified_amount")
                );
            }
        }
        return null;
    }

    // Inner class for payment statistics
    public static class PaymentStats {
        public int pendingProof;
        public int awaitingVerification;
        public int verified;
        public int rejected;
        public java.math.BigDecimal totalVerifiedAmount;

        public PaymentStats(int pendingProof, int awaitingVerification, int verified, 
                           int rejected, java.math.BigDecimal totalVerifiedAmount) {
            this.pendingProof = pendingProof;
            this.awaitingVerification = awaitingVerification;
            this.verified = verified;
            this.rejected = rejected;
            this.totalVerifiedAmount = totalVerifiedAmount;
        }
    }
}
