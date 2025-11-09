package com.event.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class QRCodeGenerator {
    
    private static final int QR_CODE_SIZE = 350;
    private static final int TICKET_WIDTH = 800;
    private static final int TICKET_HEIGHT = 400;
    private static final Color PRIMARY_COLOR = new Color(102, 126, 234);
    private static final Color SECONDARY_COLOR = new Color(118, 75, 162);
    private static final Color SUCCESS_COLOR = new Color(40, 167, 69);
    
    /**
     * ✅ ADD THIS SIMPLE METHOD FOR THE SERVLET
     * Generate QR code and return as Base64 string (simple version for ApproveRegistrationServlet)
     */
    public static String generateQRCode(String data) throws WriterException, IOException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.MARGIN, 1);
        
        BitMatrix bitMatrix = qrCodeWriter.encode(data, BarcodeFormat.QR_CODE, 300, 300, hints);
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos);
        byte[] qrBytes = baos.toByteArray();
        
        return Base64.getEncoder().encodeToString(qrBytes);
    }
    
    /**
     * Generate professional event ticket with user photo, details, and QR code
     */
    public static String generateEventTicket(String userName, String userId, String regId,
                                             String eventName, String eventDate, String venue,
                                             String userPhotoPath, int registrationId, 
                                             int eventId, String email) 
            throws WriterException, IOException {
        
        // Create ticket image
        BufferedImage ticket = new BufferedImage(TICKET_WIDTH, TICKET_HEIGHT, 
                                                  BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = ticket.createGraphics();
        
        // Enable anti-aliasing for smooth text and shapes
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        
        // ===== BACKGROUND GRADIENT =====
        GradientPaint gradient = new GradientPaint(0, 0, PRIMARY_COLOR, 
                                                   TICKET_WIDTH, TICKET_HEIGHT, SECONDARY_COLOR);
        g2d.setPaint(gradient);
        g2d.fillRect(0, 0, TICKET_WIDTH, TICKET_HEIGHT);
        
        // ===== LEFT SECTION: USER DETAILS =====
        int leftSectionWidth = TICKET_WIDTH - QR_CODE_SIZE - 50;
        
        // White info card
        g2d.setColor(Color.WHITE);
        g2d.fillRoundRect(20, 20, leftSectionWidth - 40, TICKET_HEIGHT - 40, 20, 20);
        
        // Header bar
        g2d.setColor(PRIMARY_COLOR);
        g2d.fillRoundRect(20, 20, leftSectionWidth - 40, 60, 20, 20);
        
        // University logo/icon
        g2d.setColor(Color.WHITE);
        g2d.setFont(new Font("Arial", Font.BOLD, 32));
        g2d.drawString("🎓", 35, 60);
        
        // Event title
        g2d.setFont(new Font("Arial", Font.BOLD, 22));
        g2d.drawString("EVENT TICKET", 85, 60);
        
        // User photo placeholder (if provided)
        int photoSize = 100;
        int photoX = 40;
        int photoY = 100;
        
        g2d.setColor(new Color(240, 240, 240));
        g2d.fillOval(photoX, photoY, photoSize, photoSize);
        
        // Try to load user photo
        if (userPhotoPath != null && !userPhotoPath.isEmpty()) {
            try {
                File photoFile = new File(userPhotoPath);
                if (photoFile.exists()) {
                    BufferedImage userPhoto = ImageIO.read(photoFile);
                    // Create circular clip
                    g2d.setClip(new java.awt.geom.Ellipse2D.Float(photoX, photoY, photoSize, photoSize));
                    g2d.drawImage(userPhoto, photoX, photoY, photoSize, photoSize, null);
                    g2d.setClip(null);
                } else {
                    // Default avatar
                    g2d.setColor(PRIMARY_COLOR);
                    g2d.setFont(new Font("Arial", Font.BOLD, 40));
                    g2d.drawString("👤", photoX + 25, photoY + 65);
                }
            } catch (Exception e) {
                System.err.println("⚠ Could not load user photo: " + e.getMessage());
                // Draw default avatar
                g2d.setColor(PRIMARY_COLOR);
                g2d.setFont(new Font("Arial", Font.BOLD, 40));
                g2d.drawString("👤", photoX + 25, photoY + 65);
            }
        } else {
            // Default avatar
            g2d.setColor(PRIMARY_COLOR);
            g2d.setFont(new Font("Arial", Font.BOLD, 40));
            g2d.drawString("👤", photoX + 25, photoY + 65);
        }
        
        // User details section
        int detailsX = photoX + photoSize + 30;
        int detailsY = 110;
        int lineHeight = 30;
        
        // Name
        g2d.setColor(new Color(44, 62, 80));
        g2d.setFont(new Font("Arial", Font.BOLD, 20));
        g2d.drawString(truncateString(userName, 20), detailsX, detailsY);
        
        // User ID
        g2d.setFont(new Font("Arial", Font.PLAIN, 14));
        g2d.setColor(new Color(108, 117, 125));
        g2d.drawString("User ID: " + userId, detailsX, detailsY + lineHeight);
        
        // Registration ID with badge
        g2d.setColor(SUCCESS_COLOR);
        g2d.fillRoundRect(detailsX, detailsY + lineHeight + 10, 150, 30, 15, 15);
        g2d.setColor(Color.WHITE);
        g2d.setFont(new Font("Arial", Font.BOLD, 14));
        g2d.drawString("REG-" + regId, detailsX + 10, detailsY + lineHeight + 30);
        
        // Divider line
        g2d.setColor(new Color(220, 220, 220));
        g2d.fillRect(40, 230, leftSectionWidth - 80, 2);
        
        // Event information
        int eventInfoY = 260;
        g2d.setColor(new Color(44, 62, 80));
        g2d.setFont(new Font("Arial", Font.BOLD, 16));
        g2d.drawString("📅 Event Details", 40, eventInfoY);
        
        g2d.setFont(new Font("Arial", Font.PLAIN, 14));
        g2d.setColor(new Color(52, 73, 94));
        
        // Event name
        String truncatedEvent = truncateString(eventName, 35);
        g2d.drawString("Event: " + truncatedEvent, 40, eventInfoY + 30);
        
        // Date and venue
        g2d.drawString("Date: " + eventDate, 40, eventInfoY + 55);
        g2d.drawString("Venue: " + truncateString(venue, 30), 40, eventInfoY + 80);
        
        // Status badge
        g2d.setColor(new Color(40, 167, 69));
        g2d.fillRoundRect(40, eventInfoY + 95, 100, 25, 12, 12);
        g2d.setColor(Color.WHITE);
        g2d.setFont(new Font("Arial", Font.BOLD, 12));
        g2d.drawString("✓ APPROVED", 50, eventInfoY + 112);
        
        // ===== RIGHT SECTION: QR CODE =====
        // Generate QR code data
        String qrData = generateQRData(registrationId, eventId, email);
        
        // Generate QR code
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(EncodeHintType.MARGIN, 1);
        
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(qrData, BarcodeFormat.QR_CODE, 
                                                   QR_CODE_SIZE, QR_CODE_SIZE, hints);
        
        BufferedImage qrImage = MatrixToImageWriter.toBufferedImage(bitMatrix);
        
        // Draw QR code section background
        int qrX = leftSectionWidth + 10;
        int qrY = 20;
        
        g2d.setColor(Color.WHITE);
        g2d.fillRoundRect(qrX, qrY, QR_CODE_SIZE + 20, TICKET_HEIGHT - 40, 20, 20);
        
        // QR code label
        g2d.setColor(PRIMARY_COLOR);
        g2d.setFont(new Font("Arial", Font.BOLD, 14));
        String qrLabel = "SCAN FOR ENTRY";
        int qrLabelWidth = g2d.getFontMetrics().stringWidth(qrLabel);
        g2d.drawString(qrLabel, qrX + (QR_CODE_SIZE + 20 - qrLabelWidth) / 2, qrY + 25);
        
        // Draw QR code
        g2d.drawImage(qrImage, qrX + 10, qrY + 35, QR_CODE_SIZE, QR_CODE_SIZE, null);
        
        // Footer text
        g2d.setFont(new Font("Arial", Font.PLAIN, 10));
        g2d.setColor(new Color(108, 117, 125));
        String footer = "Present at venue";
        int footerWidth = g2d.getFontMetrics().stringWidth(footer);
        g2d.drawString(footer, qrX + (QR_CODE_SIZE + 20 - footerWidth) / 2, 
                      qrY + QR_CODE_SIZE + 50);
        
        g2d.dispose();
        
        // Convert to Base64
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(ticket, "PNG", baos);
        byte[] imageBytes = baos.toByteArray();
        
        return Base64.getEncoder().encodeToString(imageBytes);
    }
    
    /**
     * Generate simple QR code with details (backwards compatible)
     */
    public static String generateQRCodeWithDetails(String qrData, String name, 
                                                    String regId, String eventName) 
            throws WriterException, IOException {
        
        return generateEventTicket(name, "N/A", regId, eventName, 
                                  new SimpleDateFormat("dd-MM-yyyy").format(new Date()), 
                                  "University Campus", null, 
                                  Integer.parseInt(regId), 0, "");
    }
    
    /**
     * Save QR Code image to file system
     */
    public static String saveQRCodeImage(String qrData, String filePath) 
            throws WriterException, IOException {
        
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.MARGIN, 1);
        
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(qrData, BarcodeFormat.QR_CODE, 
                                                   QR_CODE_SIZE, QR_CODE_SIZE, hints);
        
        Path path = FileSystems.getDefault().getPath(filePath);
        MatrixToImageWriter.writeToPath(bitMatrix, "PNG", path);
        
        return filePath;
    }
    
    /**
     * Generate QR code as Base64 (alias for generateQRCode)
     */
    public static String generateQRCodeBase64(String qrData) 
            throws WriterException, IOException {
        return generateQRCode(qrData);
    }
    
    /**
     * Generate unique QR data string with encryption-like format
     */
    public static String generateQRData(int registrationId, int eventId, String email) {
        long timestamp = System.currentTimeMillis();
        String hash = String.valueOf((registrationId + eventId + timestamp) % 99999);
        
        return String.format("UNIV-EVENT|REG:%d|EVT:%d|USR:%s|TS:%d|HASH:%s|VER:1.0", 
                           registrationId, eventId, email, timestamp, hash);
    }
    
    /**
     * Truncate string to specified length
     */
    private static String truncateString(String str, int maxLength) {
        if (str == null) return "";
        if (str.length() <= maxLength) return str;
        return str.substring(0, maxLength - 3) + "...";
    }
    
    /**
     * Verify QR code data (for scanning at venue)
     */
    public static boolean verifyQRData(String qrData) {
        return qrData != null && qrData.startsWith("UNIV-EVENT|") && qrData.contains("VER:1.0");
    }
    
    /**
     * Extract registration ID from QR data
     */
    public static int extractRegistrationId(String qrData) {
        try {
            String[] parts = qrData.split("\\|");
            for (String part : parts) {
                if (part.startsWith("REG:")) {
                    return Integer.parseInt(part.substring(4));
                }
            }
        } catch (Exception e) {
            System.err.println("⚠ Could not extract registration ID: " + e.getMessage());
        }
        return -1;
    }
}
