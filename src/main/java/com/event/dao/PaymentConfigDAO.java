package com.event.dao;

import com.event.util.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

/**
 * DAO for Payment Configuration Management
 */
public class PaymentConfigDAO {
    
    /**
     * Get all payment configuration from database
     */
    public Map<String, String> getPaymentConfig() {
        Map<String, String> config = new HashMap<>();
        
        // Default values in case database fetch fails
        config.put("upi_id", "9573614202@ybl");
        config.put("upi_name", "GUNDUMOGULA SATYA VENI");
        config.put("account_number", "82580100008545");
        config.put("ifsc_code", "BARB0VJIPOL");
        config.put("bank_name", "Bank Of Baroda");
        config.put("account_holder", "GUNDUMOGULA SATYA VENI");
        
        String sql = "SELECT config_key, config_value FROM payment_config WHERE is_active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                config.put(rs.getString("config_key"), rs.getString("config_value"));
            }
            
            System.out.println("✓ Payment configuration loaded from database");
            
        } catch (SQLException e) {
            System.err.println("⚠ Could not load payment config from DB, using defaults: " + e.getMessage());
        }
        
        return config;
    }
    
    /**
     * Update payment configuration
     */
    public boolean updatePaymentConfig(String key, String value) {
        String sql = "UPDATE payment_config SET config_value = ?, updated_at = CURRENT_TIMESTAMP WHERE config_key = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, value);
            pstmt.setString(2, key);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("✗ Error updating payment config: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get single config value
     */
    public String getConfigValue(String key) {
        String sql = "SELECT config_value FROM payment_config WHERE config_key = ? AND is_active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, key);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("config_value");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error getting config value: " + e.getMessage());
        }
        
        return null;
    }
}
