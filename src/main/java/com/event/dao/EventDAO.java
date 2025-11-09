package com.event.dao;

import com.event.model.Event;
import com.event.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Event operations
 */
public class EventDAO {

    /**
     * Create new event with image support
     */
    public int createEvent(Event event) {
        String sql = "INSERT INTO events (name, description, image_url, venue, event_date, " +
                    "registration_deadline, eligibility, fee, capacity, created_by, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // CORRECTED ORDER TO MATCH SQL STATEMENT
            pstmt.setString(1, event.getName());                         // name
            pstmt.setString(2, event.getDescription());                  // description
            pstmt.setString(3, event.getEventImage());                   // image_url
            pstmt.setString(4, event.getVenue());                        // venue
            pstmt.setTimestamp(5, event.getEventDate());                 // event_date
            pstmt.setTimestamp(6, event.getRegistrationDeadline());      // registration_deadline
            pstmt.setString(7, event.getEligibility());                  // eligibility
            pstmt.setBigDecimal(8, event.getFee());                      // fee
            pstmt.setInt(9, event.getCapacity());                        // capacity
            pstmt.setInt(10, event.getCreatedBy());                      // created_by
            pstmt.setString(11, event.getStatus());                      // status
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int eventId = rs.getInt(1);
                    System.out.println("✓ Event created with ID: " + eventId);
                    return eventId;
                }
            }
        } catch (SQLException e) {
            System.err.println("✗ Error creating event: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Get event by ID
     */
    public Event getEventById(int eventId) {
        String sql = "SELECT * FROM events WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractEventFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("✗ Error fetching event by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all events (for admin panel)
     */
    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
            
            System.out.println("✓ Fetched " + events.size() + " total events");
            
        } catch (SQLException e) {
            System.err.println("✗ Error fetching all events: " + e.getMessage());
            e.printStackTrace();
        }
        
        return events;
    }

    /**
     * Get active events (for participant dashboard)
     */
    public List<Event> getActiveEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE status = 'active' ORDER BY event_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Event event = extractEventFromResultSet(rs);
                events.add(event);
            }
            
            System.out.println("✓ Found " + events.size() + " active events");
            for (Event event : events) {
                System.out.println("  - " + event.getName() + " | Date: " + event.getEventDate() + " | Image: " + event.getEventImage());
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error fetching active events: " + e.getMessage());
            e.printStackTrace();
        }
        
        return events;
    }

    /**
     * Get upcoming future events only (next 30 days)
     */
    public List<Event> getUpcomingEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE status = 'active' " +
                     "AND event_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 30 DAY) " +
                     "ORDER BY event_date ASC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
            
            System.out.println("✓ Found " + events.size() + " upcoming events");
            
        } catch (SQLException e) {
            System.err.println("✗ Error fetching upcoming events: " + e.getMessage());
            e.printStackTrace();
        }
        
        return events;
    }

    /**
     * Get events by creator (for organizer dashboard)
     */
    public List<Event> getEventsByCreator(int creatorId) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE created_by = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, creatorId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("✗ Error fetching events by creator: " + e.getMessage());
            e.printStackTrace();
        }
        
        return events;
    }

    /**
     * Update event details
     */
    public boolean updateEvent(Event event) {
        String sql = "UPDATE events SET name = ?, description = ?, venue = ?, event_date = ?, " +
                     "registration_deadline = ?, eligibility = ?, fee = ?, capacity = ?, status = ?, image_url = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, event.getName());
            pstmt.setString(2, event.getDescription());
            pstmt.setString(3, event.getVenue());
            pstmt.setTimestamp(4, event.getEventDate());
            pstmt.setTimestamp(5, event.getRegistrationDeadline());
            pstmt.setString(6, event.getEligibility());
            pstmt.setBigDecimal(7, event.getFee());
            pstmt.setInt(8, event.getCapacity());
            pstmt.setString(9, event.getStatus());
            pstmt.setString(10, event.getEventImage());
            pstmt.setInt(11, event.getId());
            
            boolean result = pstmt.executeUpdate() > 0;
            
            if (result) {
                System.out.println("✓ Event updated: " + event.getId());
            }
            
            return result;
            
        } catch (SQLException e) {
            System.err.println("✗ Error updating event: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update event status only
     */
    public boolean updateEventStatus(int eventId, String status) {
        String sql = "UPDATE events SET status = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, eventId);
            
            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                System.out.println("✓ Event status updated: " + eventId + " -> " + status);
            }
            
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("✗ Error updating event status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update event image only
     */
    public boolean updateEventImage(int eventId, String imagePath) {
        String sql = "UPDATE events SET image_url = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, imagePath);
            pstmt.setInt(2, eventId);
            
            boolean result = pstmt.executeUpdate() > 0;
            
            if (result) {
                System.out.println("✓ Event image updated for event: " + eventId);
            }
            return result;
            
        } catch (SQLException e) {
            System.err.println("✗ Error updating event image: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get event image path
     */
    public String getEventImage(int eventId) {
        String sql = "SELECT image_url FROM events WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("image_url");
            }
        } catch (SQLException e) {
            System.err.println("✗ Error fetching event image: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Delete event
     */
    public boolean deleteEvent(int eventId) {
        String sql = "DELETE FROM events WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                System.out.println("✓ Event deleted: " + eventId);
            }
            
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("✗ Error deleting event: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get registration count for an event
     */
    public int getRegistrationCount(int eventId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE event_id = ? AND status = 'approved'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, eventId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("✗ Error fetching registration count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if event capacity is full
     */
    public boolean isCapacityFull(int eventId) {
        Event event = getEventById(eventId);
        if (event == null) return true;
        
        int registeredCount = getRegistrationCount(eventId);
        return registeredCount >= event.getCapacity();
    }
    

    /**
     * Search events by keyword
     */
    public List<Event> searchEvents(String keyword) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE status = 'active' " +
                     "AND (name LIKE ? OR description LIKE ?) " +
                     "ORDER BY event_date ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                events.add(extractEventFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("✗ Error searching events: " + e.getMessage());
            e.printStackTrace();
        }
        
        return events;
    }

    /**
     * Extract Event object from ResultSet
     */
    private Event extractEventFromResultSet(ResultSet rs) throws SQLException {
        Event event = new Event();
        
        // Required fields
        event.setId(rs.getInt("id"));
        event.setName(rs.getString("name"));
        event.setDescription(rs.getString("description"));
        event.setVenue(rs.getString("venue"));
        event.setEventDate(rs.getTimestamp("event_date"));
        
        // Add registration deadline
        try {
            event.setRegistrationDeadline(rs.getTimestamp("registration_deadline"));
        } catch (SQLException e) {
            event.setRegistrationDeadline(null);
        }
        
        event.setEligibility(rs.getString("eligibility"));
        event.setFee(rs.getBigDecimal("fee"));
        event.setCapacity(rs.getInt("capacity"));
        event.setCreatedBy(rs.getInt("created_by"));
        event.setStatus(rs.getString("status"));
        event.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Optional fields with error handling
        try {
            event.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) {
            event.setUpdatedAt(null);
        }
        
        try {
            String imagePath = rs.getString("image_url");
            event.setEventImage(imagePath);
        } catch (SQLException e) {
            event.setEventImage(null);
        }
        
        return event;
    }
}
