package com.event.test;

import org.mindrot.jbcrypt.BCrypt;
import com.event.util.DBConnection;
import java.sql.*;

public class TestPasswordHash {
    public static void main(String[] args) {
        String plainPassword = "admin123";
        
        System.out.println("=".repeat(70));
        System.out.println("PASSWORD HASH DIAGNOSTIC TEST");
        System.out.println("=".repeat(70));
        
        // Test 1: Check if BCrypt library is working
        System.out.println("\n[TEST 1] BCrypt Library Check:");
        try {
            String freshHash = BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
            System.out.println("✓ BCrypt library is working!");
            System.out.println("  Fresh hash: " + freshHash);
            System.out.println("  Length: " + freshHash.length());
            boolean freshTest = BCrypt.checkpw(plainPassword, freshHash);
            System.out.println("  Fresh hash test: " + freshTest);
            
            if (!freshTest) {
                System.err.println("✗ ERROR: BCrypt can't verify its own hash!");
                return;
            }
        } catch (Exception e) {
            System.err.println("✗ ERROR: BCrypt library not working!");
            e.printStackTrace();
            return;
        }
        
        // Test 2: Test the known good hash
        System.out.println("\n[TEST 2] Known Good Hash Test:");
        String knownGoodHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
        System.out.println("  Hash: " + knownGoodHash);
        System.out.println("  Length: " + knownGoodHash.length());
        try {
            boolean knownGoodTest = BCrypt.checkpw(plainPassword, knownGoodHash);
            System.out.println("  Test result: " + knownGoodTest);
            
            if (!knownGoodTest) {
                System.err.println("✗ ERROR: Known good hash doesn't match!");
                System.err.println("  This means BCrypt library has a problem");
            } else {
                System.out.println("✓ Known good hash works!");
            }
        } catch (Exception e) {
            System.err.println("✗ ERROR testing known good hash: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Test 3: Read hash from database
        System.out.println("\n[TEST 3] Database Hash Test:");
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("✓ Database connected");
            
            String sql = "SELECT username, password, LENGTH(password) as pwd_length FROM users WHERE username = 'admin'";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                
                if (rs.next()) {
                    String username = rs.getString("username");
                    String dbHash = rs.getString("password");
                    int dbHashLength = rs.getInt("pwd_length");
                    
                    System.out.println("  Username: " + username);
                    System.out.println("  Hash from DB: " + dbHash);
                    System.out.println("  Java string length: " + dbHash.length());
                    System.out.println("  MySQL length: " + dbHashLength);
                    
                    if (dbHash.length() != 60) {
                        System.err.println("✗ ERROR: Hash length is " + dbHash.length() + ", should be 60!");
                        System.err.println("  Java is reading truncated hash from database!");
                    } else {
                        System.out.println("✓ Hash length is correct (60 characters)");
                    }
                    
                    // Compare with known good hash
                    System.out.println("\n  Comparing with known good hash:");
                    System.out.println("  DB Hash:   " + dbHash);
                    System.out.println("  Good Hash: " + knownGoodHash);
                    System.out.println("  Hashes match: " + dbHash.equals(knownGoodHash));
                    
                    if (!dbHash.equals(knownGoodHash)) {
                        System.err.println("\n✗ ERROR: Database has WRONG hash!");
                        System.err.println("  Even though length is 60, the content is incorrect");
                        
                        // Show character-by-character comparison
                        System.out.println("\n  Character-by-character comparison (first difference):");
                        for (int i = 0; i < Math.min(dbHash.length(), knownGoodHash.length()); i++) {
                            if (dbHash.charAt(i) != knownGoodHash.charAt(i)) {
                                System.out.println("  Position " + i + ":");
                                System.out.println("    DB:   '" + dbHash.charAt(i) + "' (code: " + (int)dbHash.charAt(i) + ")");
                                System.out.println("    Good: '" + knownGoodHash.charAt(i) + "' (code: " + (int)knownGoodHash.charAt(i) + ")");
                                break;
                            }
                        }
                    }
                    
                    // Test the database hash
                    System.out.println("\n  Testing database hash:");
                    try {
                        boolean dbTest = BCrypt.checkpw(plainPassword, dbHash);
                        System.out.println("  BCrypt test result: " + dbTest);
                        
                        if (!dbTest) {
                            System.err.println("✗ Database hash does NOT match password 'admin123'");
                        } else {
                            System.out.println("✓ Database hash MATCHES password 'admin123'");
                        }
                    } catch (Exception e) {
                        System.err.println("✗ ERROR testing database hash: " + e.getMessage());
                        e.printStackTrace();
                    }
                    
                } else {
                    System.err.println("✗ ERROR: No user 'admin' found in database!");
                }
            }
        } catch (Exception e) {
            System.err.println("✗ ERROR accessing database: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Test 4: Check MySQL column definition
        System.out.println("\n[TEST 4] MySQL Column Definition:");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SHOW COLUMNS FROM users LIKE 'password'");
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                String field = rs.getString("Field");
                String type = rs.getString("Type");
                String nullable = rs.getString("Null");
                
                System.out.println("  Field: " + field);
                System.out.println("  Type: " + type);
                System.out.println("  Nullable: " + nullable);
                
                if (!type.toLowerCase().contains("varchar(255)") && !type.toLowerCase().contains("text")) {
                    System.err.println("✗ WARNING: Column type should be VARCHAR(255) or TEXT");
                }
            }
        } catch (Exception e) {
            System.err.println("✗ ERROR checking column: " + e.getMessage());
        }
        
        System.out.println("\n" + "=".repeat(70));
        System.out.println("DIAGNOSIS COMPLETE");
        System.out.println("=".repeat(70));
        
        System.out.println("\nFIX COMMAND:");
        System.out.println("UPDATE users SET password = '" + knownGoodHash + "' WHERE username = 'admin';");
        System.out.println("=".repeat(70));
    }
}
