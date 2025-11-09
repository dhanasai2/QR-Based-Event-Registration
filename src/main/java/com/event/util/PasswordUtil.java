package com.event.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    // Hash a plain password
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }
    
    // Check if plain password matches hashed password
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        try {
            boolean result = BCrypt.checkpw(plainPassword, hashedPassword);
            System.out.println("BCrypt check: plain=" + plainPassword + ", result=" + result);
            return result;
        } catch (Exception e) {
            System.err.println("BCrypt error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
