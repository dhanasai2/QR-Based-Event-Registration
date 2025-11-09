package com.event.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 🔌 Database Connection Utility for Event Registration System
 * Connects to MySQL database with manual payment verification support
 */
public class DBConnection {
    
    // ===== DATABASE CONFIGURATION =====
    // Updated to match the new database created from SQL schema
    private static final String DB_HOST = "localhost";
    private static final String DB_PORT = "3306";
    private static final String DB_NAME = "event_registration";  // ✅ UPDATED DATABASE NAME
    private static final String DB_USER = "root";                // XAMPP default username
    private static final String DB_PASSWORD = "";                // XAMPP default password (empty)
    
    // Complete JDBC URL with parameters
    private static final String JDBC_URL = String.format(
        "jdbc:mysql://%s:%s/%s?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8",
        DB_HOST, DB_PORT, DB_NAME
    );
    
    // MySQL Driver class name
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // Static initializer to load MySQL driver
    static {
        try {
            Class.forName(JDBC_DRIVER);
            System.out.println("✓ MySQL JDBC Driver loaded successfully!");
            System.out.println("📊 Database: " + DB_NAME);
        } catch (ClassNotFoundException e) {
            System.err.println("✗ MySQL JDBC Driver not found!");
            System.err.println("⚠ Make sure mysql-connector-java is in your classpath");
            throw new RuntimeException("Failed to load MySQL Driver", e);
        }
    }
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
            System.out.println("✓ Database connection established successfully!");
            return conn;
        } catch (SQLException e) {
            System.err.println("✗ Database connection failed!");
            System.err.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            System.err.println("Database: " + DB_NAME);
            System.err.println("Host: " + DB_HOST + ":" + DB_PORT);
            System.err.println("User: " + DB_USER);
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Message: " + e.getMessage());
            System.err.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            System.err.println("\n🔧 Troubleshooting:");
            System.err.println("1. Make sure MySQL/XAMPP is running");
            System.err.println("2. Verify database '" + DB_NAME + "' exists");
            System.err.println("3. Check username and password are correct");
            System.err.println("4. Ensure port " + DB_PORT + " is not blocked");
            throw e;
        }
    }
    
    /**
     * Close database connection safely
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                    System.out.println("✓ Database connection closed successfully.");
                }
            } catch (SQLException e) {
                System.err.println("⚠ Error closing database connection: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Test database connection
     * Run this method to verify database connectivity
     */
    public static boolean testConnection() {
        System.out.println("╔════════════════════════════════════════╗");
        System.out.println("║   DATABASE CONNECTION TEST             ║");
        System.out.println("╚════════════════════════════════════════╝");
        System.out.println();
        
        try {
            System.out.println("📡 Testing connection to: " + DB_NAME);
            System.out.println("🔗 JDBC URL: " + JDBC_URL);
            System.out.println();
            
            Connection conn = getConnection();
            
            if (conn != null && !conn.isClosed()) {
                System.out.println();
                System.out.println("╔════════════════════════════════════════╗");
                System.out.println("║  ✅ CONNECTION TEST SUCCESSFUL!        ║");
                System.out.println("╚════════════════════════════════════════╝");
                System.out.println("Database Name: " + conn.getCatalog());
                System.out.println("Database Version: " + conn.getMetaData().getDatabaseProductVersion());
                System.out.println("JDBC Driver: " + conn.getMetaData().getDriverName());
                System.out.println("Driver Version: " + conn.getMetaData().getDriverVersion());
                
                closeConnection(conn);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println();
            System.err.println("╔════════════════════════════════════════╗");
            System.err.println("║  ❌ CONNECTION TEST FAILED!            ║");
            System.err.println("╚════════════════════════════════════════╝");
            e.printStackTrace();
            return false;
        }
        
        return false;
    }
    
    /**
     * Get database configuration info (for debugging)
     */
    public static void printConfig() {
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("DATABASE CONFIGURATION");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("Database: " + DB_NAME);
        System.out.println("Host: " + DB_HOST);
        System.out.println("Port: " + DB_PORT);
        System.out.println("Username: " + DB_USER);
        System.out.println("Password: " + (DB_PASSWORD.isEmpty() ? "(empty)" : "********"));
        System.out.println("JDBC URL: " + JDBC_URL);
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    }
    
    /**
     * Main method for testing connection
     */
    public static void main(String[] args) {
        System.out.println("\n🚀 Starting Database Connection Test...\n");
        
        // Print configuration
        printConfig();
        System.out.println();
        
        // Test connection
        boolean success = testConnection();
        
        System.out.println();
        if (success) {
            System.out.println("✅ All tests passed! Database is ready to use.");
            System.out.println("🎉 Your Event Registration System database is connected!");
        } else {
            System.out.println("❌ Connection test failed. Please check the errors above.");
            System.out.println("💡 Make sure XAMPP MySQL is running and database exists.");
        }
        System.out.println();
    }
}
