package com.event.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int id;
    private int registrationId;
    private String paymentGatewayTxId; // Can be repurposed for UTR number
    private BigDecimal amount;
    private String status; // FREE, PENDING, VERIFIED, REJECTED, COMPLETED
    private String paymentMethod; // UPI, BANK_TRANSFER, CASH, etc.
    private Timestamp transactionDate;
    
    // New fields for manual payment verification
    private String utrNumber; // Transaction reference number
    private String paymentProof; // Filename of uploaded screenshot
    private String paymentStatus; // PENDING_PROOF, PROOF_SUBMITTED, VERIFIED, REJECTED
    private String adminRemarks; // Admin comments during verification
    private Integer verifiedBy; // Admin user ID who verified
    private Timestamp verifiedAt; // Verification timestamp
    private Timestamp proofSubmittedAt; // When user submitted proof
    
    // UPI payment details
    private String upiId; // User's UPI ID used for payment
    private String payerName; // Name of the person who paid

    // Constructors
    public Payment() {}

    public Payment(int registrationId, BigDecimal amount, String paymentMethod) {
        this.registrationId = registrationId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = "PENDING";
        this.paymentStatus = "PENDING_PROOF";
    }

    // Existing Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRegistrationId() { return registrationId; }
    public void setRegistrationId(int registrationId) { this.registrationId = registrationId; }

    public String getPaymentGatewayTxId() { return paymentGatewayTxId; }
    public void setPaymentGatewayTxId(String paymentGatewayTxId) { 
        this.paymentGatewayTxId = paymentGatewayTxId; 
    }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public Timestamp getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Timestamp transactionDate) { 
        this.transactionDate = transactionDate; 
    }

    // New Getters and Setters
    public String getUtrNumber() { return utrNumber; }
    public void setUtrNumber(String utrNumber) { this.utrNumber = utrNumber; }

    public String getPaymentProof() { return paymentProof; }
    public void setPaymentProof(String paymentProof) { this.paymentProof = paymentProof; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getAdminRemarks() { return adminRemarks; }
    public void setAdminRemarks(String adminRemarks) { this.adminRemarks = adminRemarks; }

    public Integer getVerifiedBy() { return verifiedBy; }
    public void setVerifiedBy(Integer verifiedBy) { this.verifiedBy = verifiedBy; }

    public Timestamp getVerifiedAt() { return verifiedAt; }
    public void setVerifiedAt(Timestamp verifiedAt) { this.verifiedAt = verifiedAt; }

    public Timestamp getProofSubmittedAt() { return proofSubmittedAt; }
    public void setProofSubmittedAt(Timestamp proofSubmittedAt) { 
        this.proofSubmittedAt = proofSubmittedAt; 
    }

    public String getUpiId() { return upiId; }
    public void setUpiId(String upiId) { this.upiId = upiId; }

    public String getPayerName() { return payerName; }
    public void setPayerName(String payerName) { this.payerName = payerName; }

    // Helper methods
    public boolean isPending() {
        return "PENDING".equals(status) || "PENDING_PROOF".equals(paymentStatus);
    }

    public boolean isVerified() {
        return "VERIFIED".equals(paymentStatus) || "COMPLETED".equals(status);
    }

    public boolean isRejected() {
        return "REJECTED".equals(paymentStatus);
    }

    public boolean isFree() {
        return "FREE".equals(status);
    }

    public boolean needsProof() {
        return "PENDING_PROOF".equals(paymentStatus);
    }

    public boolean hasProofSubmitted() {
        return "PROOF_SUBMITTED".equals(paymentStatus);
    }

    @Override
    public String toString() {
        return "Payment{" +
                "id=" + id +
                ", registrationId=" + registrationId +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", utrNumber='" + utrNumber + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", transactionDate=" + transactionDate +
                '}';
    }
}
