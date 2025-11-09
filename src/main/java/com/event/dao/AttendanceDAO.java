package com.event.dao;

import com.event.model.Attendance;
import com.event.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    public boolean markAttendance(int registrationId, int scannedBy) throws SQLException {
        String sql = "INSERT INTO attendance (registration_id, scanned_by) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, registrationId);
            pstmt.setInt(2, scannedBy);
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean isAlreadyScanned(int registrationId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM attendance WHERE registration_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, registrationId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public List<Attendance> getAttendanceByEventId(int eventId) throws SQLException {
        List<Attendance> attendanceList = new ArrayList<>();
        String sql = "SELECT a.*, u.username, e.name as event_name " +
                     "FROM attendance a " +
                     "JOIN registrations r ON a.registration_id = r.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN events e ON r.event_id = e.id " +
                     "WHERE r.event_id = ? ORDER BY a.scan_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                attendanceList.add(extractAttendanceFromResultSet(rs));
            }
        }
        return attendanceList;
    }

    public int getAttendanceCount(int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM attendance a " +
                     "JOIN registrations r ON a.registration_id = r.id " +
                     "WHERE r.event_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private Attendance extractAttendanceFromResultSet(ResultSet rs) throws SQLException {
        Attendance attendance = new Attendance();
        attendance.setId(rs.getInt("id"));
        attendance.setRegistrationId(rs.getInt("registration_id"));
        attendance.setScanTime(rs.getTimestamp("scan_time"));
        attendance.setScannedBy(rs.getInt("scanned_by"));
        return attendance;
    }
}
