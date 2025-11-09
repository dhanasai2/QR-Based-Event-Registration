package com.event.dao;

import com.event.model.Registration;
import com.event.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Registration operations
 */
public class RegistrationDAO {

    /**
     * Create new registration
     */
    public int createRegistration(Registration registration) throws SQLException {
        String sql = "INSERT INTO registrations (user_id, event_id, status, payment_status) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, registration.getUserId());
            pstmt.setInt(2, registration.getEventId());
            pstmt.setString(3, registration.getStatus());
            pstmt.setString(4, registration.getPaymentStatus());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int registrationId = rs.getInt(1);
                    System.out.println("✓ Registration created with ID: " + registrationId);
                    return registrationId;
                }
            }
        }
        return -1;
    }

    /**
     * Get registration by ID WITH user and event details
     */
    public Registration getRegistrationById(int registrationId) throws SQLException {
        String sql = "SELECT r.*, u.username, u.email, e.name as event_name, e.event_date, e.venue " +
                     "FROM registrations r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE r.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, registrationId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractRegistrationWithDetailsFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Get registrations by user ID (for participant's my-registrations page)
     */
    public List<Registration> getRegistrationsByUserId(int userId) throws SQLException {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, u.username, u.email, e.name as event_name, e.event_date, e.venue, e.fee " +
                     "FROM registrations r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE r.user_id = ? ORDER BY r.registration_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                registrations.add(extractRegistrationWithDetailsFromResultSet(rs));
            }
            
            System.out.println("✓ Found " + registrations.size() + " registrations for user: " + userId);
        }
        return registrations;
    }

    /**
     * Alias method for consistency
     */
    public List<Registration> getRegistrationsByUser(int userId) throws SQLException {
        return getRegistrationsByUserId(userId);
    }

    /**
     * Get registrations by event ID
     */
    public List<Registration> getRegistrationsByEventId(int eventId) throws SQLException {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, u.username, u.email, e.name as event_name, e.event_date, e.venue " +
                     "FROM registrations r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE r.event_id = ? ORDER BY r.registration_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                registrations.add(extractRegistrationWithDetailsFromResultSet(rs));
            }
        }
        return registrations;
    }

    /**
     * NEW: Get attended registrations for an event (for attendance page)
     */
    public List<Registration> getAttendedRegistrations(int eventId) throws SQLException {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, u.username, u.email, e.name as event_name, e.event_date, e.venue " +
                     "FROM registrations r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE r.event_id = ? AND r.attendance_status = 'attended' " +
                     "ORDER BY r.attended_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                registrations.add(extractRegistrationWithDetailsFromResultSet(rs));
            }
            
            System.out.println("✓ Found " + registrations.size() + " attended registrations for event: " + eventId);
        }
        return registrations;
    }

    /**
     * NEW: Get attendance count for an event
     */
    public int getAttendanceCount(int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM registrations WHERE event_id = ? AND attendance_status = 'attended'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("✓ Attendance count for event " + eventId + ": " + count);
                return count;
            }
        }
        return 0;
    }

    /**
     * Get pending registrations (for admin approval)
     */
    public List<Registration> getPendingRegistrations() throws SQLException {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.*, u.username, u.email, e.name as event_name, e.event_date, e.venue " +
                     "FROM registrations r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE r.status = 'pending' " +
                     "ORDER BY r.registration_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                registrations.add(extractRegistrationWithDetailsFromResultSet(rs));
            }
            
            System.out.println("✓ Found " + registrations.size() + " pending registrations");
        }
        return registrations;
    }

    /**
     * Approve registration with QR code
     */
    public boolean approveRegistration(int registrationId, String qrCode, String qrCodeImage) throws SQLException {
        String sql = "UPDATE registrations SET status = 'approved', qr_code = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, qrCode);
            pstmt.setInt(2, registrationId);
            
            boolean result = pstmt.executeUpdate() > 0;
            
            if (result) {
                System.out.println("✓ Registration approved: " + registrationId);
            }
            return result;
        }
    }

    /**
     * Reject registration
     */
    public boolean rejectRegistration(int registrationId) throws SQLException {
        String sql = "UPDATE registrations SET status = 'rejected' WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, registrationId);
            boolean result = pstmt.executeUpdate() > 0;
            
            if (result) {
                System.out.println("✓ Registration rejected: " + registrationId);
            }
            return result;
        }
    }
    
    /**
     * Update registration status
     */
    public boolean updateRegistrationStatus(int regId, String status) {
        String sql = "UPDATE registrations SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, regId);
            
            boolean result = pstmt.executeUpdate() > 0;
            
            if (result) {
                System.out.println("✓ Registration status updated: " + regId + " -> " + status);
            }
            
            return result;
            
        } catch (SQLException e) {
            System.err.println("✗ Error updating registration status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update QR code for registration
     */
    public boolean updateQRCode(int registrationId, String qrCode) throws SQLException {
        String sql = "UPDATE registrations SET qr_code = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, qrCode);
            pstmt.setInt(2, registrationId);
            
            boolean result = pstmt.executeUpdate() > 0;
            
            if (result) {
                System.out.println("✓ QR code updated for registration: " + registrationId);
            }
            return result;
        }
    }

    /**
     * Update payment status
     */
    public boolean updatePaymentStatus(int registrationId, String paymentStatus) throws SQLException {
        String sql = "UPDATE registrations SET payment_status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, paymentStatus);
            pstmt.setInt(2, registrationId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Mark attendance for a registration WITH DEBUG LOGS
     */
    public boolean markAttendance(int registrationId) throws SQLException {
        System.out.println("=== MARKING ATTENDANCE ===");
        System.out.println("Registration ID: " + registrationId);
        
        String sql = "UPDATE registrations SET attendance_status = 'attended', attended_at = NOW() WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, registrationId);
            int rowsAffected = pstmt.executeUpdate();
            
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("✓ Attendance marked successfully for registration ID: " + registrationId);
                return true;
            } else {
                System.err.println("✗ No rows updated - registration ID might not exist: " + registrationId);
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("✗ SQL Error marking attendance: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Check if attendance is already marked
     */
    public boolean isAttendanceMarked(int registrationId) throws SQLException {
        String sql = "SELECT attendance_status FROM registrations WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, registrationId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("attendance_status");
                boolean isMarked = "attended".equals(status);
                System.out.println("✓ Attendance status for reg " + registrationId + ": " + status + " (marked: " + isMarked + ")");
                return isMarked;
            }
        }
        return false;
    }

    /**
     * Check if user is already registered for an event
     */
    public boolean isAlreadyRegistered(int userId, int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM registrations WHERE user_id = ? AND event_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /**
     * Alias for isAlreadyRegistered
     */
    public boolean isUserRegistered(int userId, int eventId) throws SQLException {
        return isAlreadyRegistered(userId, eventId);
    }

    /**
     * Get registration by QR code
     */
    public Registration getRegistrationByQRCode(String qrCode) throws SQLException {
        System.out.println("=== SEARCHING FOR QR CODE ===");
        System.out.println("QR Code: " + qrCode);
        
        String sql = "SELECT r.*, u.username, u.email, e.name as event_name, e.event_date, e.venue " +
                     "FROM registrations r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE r.qr_code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, qrCode);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Registration reg = extractRegistrationWithDetailsFromResultSet(rs);
                System.out.println("✓ Found registration ID: " + reg.getId() + " for QR code");
                return reg;
            } else {
                System.err.println("✗ No registration found for QR code: " + qrCode);
            }
        }
        return null;
    }

    /**
     * Extract Registration WITH user and event details
     */
    private Registration extractRegistrationWithDetailsFromResultSet(ResultSet rs) throws SQLException {
        Registration registration = new Registration();
        
        // Basic registration fields
        registration.setId(rs.getInt("id"));
        registration.setUserId(rs.getInt("user_id"));
        registration.setEventId(rs.getInt("event_id"));
        registration.setRegistrationDate(rs.getTimestamp("registration_date"));
        registration.setStatus(rs.getString("status"));
        registration.setPaymentStatus(rs.getString("payment_status"));
        
        // User details from JOIN
        try {
            registration.setUserName(rs.getString("username"));
            registration.setUserEmail(rs.getString("email"));
        } catch (SQLException e) {
            // If model doesn't have setUserName/setUserEmail, skip
        }
        
        // Event details from JOIN
        try {
            registration.setEventName(rs.getString("event_name"));
        } catch (SQLException e) {
            // If model doesn't have setEventName, skip
        }
        
        // Optional QR code
        try {
            registration.setQrCode(rs.getString("qr_code"));
        } catch (SQLException e) {
            registration.setQrCode(null);
        }
        
        return registration;
    }

    /**
     * Simple extractor without JOIN details (for internal use only)
     */
    private Registration extractRegistrationFromResultSet(ResultSet rs) throws SQLException {
        Registration registration = new Registration();
        
        registration.setId(rs.getInt("id"));
        registration.setUserId(rs.getInt("user_id"));
        registration.setEventId(rs.getInt("event_id"));
        registration.setRegistrationDate(rs.getTimestamp("registration_date"));
        registration.setStatus(rs.getString("status"));
        registration.setPaymentStatus(rs.getString("payment_status"));
        
        try {
            registration.setQrCode(rs.getString("qr_code"));
        } catch (SQLException e) {
            registration.setQrCode(null);
        }
        
        return registration;
    }
}
