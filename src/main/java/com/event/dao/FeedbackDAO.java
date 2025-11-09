package com.event.dao;

import com.event.model.Feedback;
import com.event.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean submitFeedback(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO feedback (registration_id, rating, comments) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, feedback.getRegistrationId());
            pstmt.setInt(2, feedback.getRating());
            pstmt.setString(3, feedback.getComments());
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<Feedback> getFeedbackByEventId(int eventId) throws SQLException {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.* FROM feedback f " +
                     "JOIN registrations r ON f.registration_id = r.id " +
                     "WHERE r.event_id = ? ORDER BY f.submitted_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                feedbackList.add(extractFeedbackFromResultSet(rs));
            }
        }
        return feedbackList;
    }

    public double getAverageRating(int eventId) throws SQLException {
        String sql = "SELECT AVG(f.rating) FROM feedback f " +
                     "JOIN registrations r ON f.registration_id = r.id " +
                     "WHERE r.event_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    private Feedback extractFeedbackFromResultSet(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("id"));
        feedback.setRegistrationId(rs.getInt("registration_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setComments(rs.getString("comments"));
        feedback.setSubmittedAt(rs.getTimestamp("submitted_at"));
        return feedback;
    }
}
