package com.event.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String phone;
    private String profilePhoto;  // ✅ ADDED - Must be declared here
    private String role;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default Constructor
    public User() {
        this.status = "pending";
    }

    // Constructor with basic fields
    public User(String username, String password, String email, String phone, String role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = "pending";
    }

    // Constructor with status
    public User(String username, String password, String email, String phone, String role, String status) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = status;
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }
    
    public String getProfilePhoto() {
        return profilePhoto;
    }

    public String getRole() {
        return role;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public void setProfilePhoto(String profilePhoto) {
        this.profilePhoto = profilePhoto;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Utility methods
    public boolean isPending() {
        return "pending".equals(this.status);
    }

    public boolean isApproved() {
        return "approved".equals(this.status);
    }

    public boolean isRejected() {
        return "rejected".equals(this.status);
    }

    public String getStatusBadge() {
        if (isApproved()) {
            return "<span class='badge bg-success'>Approved</span>";
        } else if (isPending()) {
            return "<span class='badge bg-warning'>Pending</span>";
        } else if (isRejected()) {
            return "<span class='badge bg-danger'>Rejected</span>";
        }
        return "<span class='badge bg-secondary'>Unknown</span>";
    }

    public String getRoleBadge() {
        switch (this.role) {
            case "admin":
                return "<span class='badge bg-danger'>Admin</span>";
            case "organizer":
                return "<span class='badge bg-primary'>Organizer</span>";
            case "participant":
                return "<span class='badge bg-info'>Participant</span>";
            default:
                return "<span class='badge bg-secondary'>" + this.role + "</span>";
        }
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", profilePhoto='" + profilePhoto + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
