package com.event.util;

import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

public class FileUploadUtil {
    
    // Allowed file extensions
    private static final String[] ALLOWED_IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif"};
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    /**
     * Upload user profile photo
     */
    public static String uploadUserPhoto(Part filePart, String uploadPath) throws IOException {
        return uploadFile(filePart, uploadPath, "user");
    }
    
    /**
     * Upload event image
     */
    public static String uploadEventImage(Part filePart, String uploadPath) throws IOException {
        return uploadFile(filePart, uploadPath, "event");
    }
    
    /**
     * Generic file upload method
     */
    private static String uploadFile(Part filePart, String uploadPath, String prefix) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        // Validate file size
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IOException("File size exceeds 5MB limit");
        }
        
        // Get original filename
        String originalFileName = getFileName(filePart);
        
        // Validate file extension
        if (!isValidImageFile(originalFileName)) {
            throw new IOException("Invalid file type. Only JPG, PNG, GIF allowed");
        }
        
        // Generate unique filename
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String uniqueID = UUID.randomUUID().toString().substring(0, 8);
        String newFileName = prefix + "_" + timestamp + "_" + uniqueID + fileExtension;
        
        // Create upload directory if not exists
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save file
        String filePath = uploadPath + File.separator + newFileName;
        Files.copy(filePart.getInputStream(), Paths.get(filePath), 
                   StandardCopyOption.REPLACE_EXISTING);
        
        System.out.println("✓ File uploaded: " + filePath);
        
        // Return relative path for database storage
        return "uploads/" + getRelativePath(uploadPath) + "/" + newFileName;
    }
    
    /**
     * Extract filename from Part header
     */
    private static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    /**
     * Validate if file is an allowed image type
     */
    private static boolean isValidImageFile(String fileName) {
        String lowerFileName = fileName.toLowerCase();
        for (String ext : ALLOWED_IMAGE_EXTENSIONS) {
            if (lowerFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Get relative path for database storage
     */
    private static String getRelativePath(String uploadPath) {
        if (uploadPath.contains("users")) return "users";
        if (uploadPath.contains("events")) return "events";
        if (uploadPath.contains("qr")) return "qr";
        if (uploadPath.contains("tickets")) return "tickets";
        return "";
    }
    
    /**
     * Delete file from filesystem
     */
    public static boolean deleteFile(String filePath) {
        try {
            File file = new File(filePath);
            if (file.exists()) {
                return file.delete();
            }
        } catch (Exception e) {
            System.err.println("⚠ Could not delete file: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Get full file path from relative path
     */
    public static String getFullPath(String relativePath, String contextPath) {
        return contextPath + File.separator + "uploads" + File.separator + relativePath;
    }
}
