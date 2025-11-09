package com.event.model;

import java.sql.Timestamp;

public class Attendance {
    private int id;
    private int registrationId;
    private Timestamp scanTime;
    private int scannedBy;

    // Constructors
    public Attendance() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRegistrationId() { return registrationId; }
    public void setRegistrationId(int registrationId) { this.registrationId = registrationId; }

    public Timestamp getScanTime() { return scanTime; }
    public void setScanTime(Timestamp scanTime) { this.scanTime = scanTime; }

    public int getScannedBy() { return scannedBy; }
    public void setScannedBy(int scannedBy) { this.scannedBy = scannedBy; }
}
