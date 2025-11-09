package com.event.model;

import java.sql.Timestamp;

public class Registration {
    private int id;
    private int userId;
    private int eventId;
    private String status;
    private String qrCode;
    private String qrCodeImage;
    private String paymentStatus;
    private Timestamp registrationDate;
    private Timestamp approvalDate;

    // Additional fields for display
    private String userName;
    private String eventName;
    private String userEmail;
    
    // ✅ NEW: Attendance tracking fields
    private boolean attendanceMarked;
    private Timestamp attendanceTime;

    // Constructors
    public Registration() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getQrCode() { return qrCode; }
    public void setQrCode(String qrCode) { this.qrCode = qrCode; }

    public String getQrCodeImage() { return qrCodeImage; }
    public void setQrCodeImage(String qrCodeImage) { this.qrCodeImage = qrCodeImage; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Timestamp registrationDate) { 
        this.registrationDate = registrationDate; 
    }

    public Timestamp getApprovalDate() { return approvalDate; }
    public void setApprovalDate(Timestamp approvalDate) { 
        this.approvalDate = approvalDate; 
    }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    
    // ✅ NEW: Attendance getters and setters
    public boolean isAttendanceMarked() { 
        return attendanceMarked; 
    }
    
    public void setAttendanceMarked(boolean attendanceMarked) { 
        this.attendanceMarked = attendanceMarked; 
    }
    
    public Timestamp getAttendanceTime() { 
        return attendanceTime; 
    }
    
    public void setAttendanceTime(Timestamp attendanceTime) { 
        this.attendanceTime = attendanceTime; 
    }
}
