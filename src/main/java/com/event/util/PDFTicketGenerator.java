package com.event.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;

/**
 * Premium Professional PDF Event Ticket Generator
 * Creates high-quality ID card style tickets with modern design
 */
public class PDFTicketGenerator {
    
    // Premium color scheme - Professional corporate colors
    private static final BaseColor BRAND_BLUE = new BaseColor(41, 98, 255);      // Vibrant blue
    private static final BaseColor ACCENT_TEAL = new BaseColor(16, 185, 129);    // Modern teal
    private static final BaseColor GOLD_ACCENT = new BaseColor(251, 191, 36);    // Premium gold
    private static final BaseColor TEXT_WHITE = BaseColor.WHITE;
    private static final BaseColor LIGHT_GRAY = new BaseColor(243, 244, 246);
    private static final BaseColor TEXT_DARK = new BaseColor(31, 41, 55);
    
    /**
     * Generate professional ID card style PDF ticket
     */
    public static String generateTicketPDF(String userName, String userId, String regId,
                                          String eventName, String eventDate, String eventTime,
                                          String venue, String userEmail, String userPhone,
                                          String qrCodeBase64, String outputPath) 
            throws DocumentException, IOException {
        
        return generateTicketPDF(userName, userId, regId, eventName, eventDate, eventTime,
                               venue, userEmail, userPhone, qrCodeBase64, null, null, outputPath);
    }
    
    /**
     * Generate premium ID card with all features
     */
    public static String generateTicketPDF(String userName, String userId, String regId,
                                          String eventName, String eventDate, String eventTime,
                                          String venue, String userEmail, String userPhone,
                                          String qrCodeBase64, String userPhotoBase64, 
                                          String eventImageBase64, String outputPath) 
            throws DocumentException, IOException {
        
        // ID card size - Credit card dimensions (3.375" x 2.125" at 150 DPI)
        Document document = new Document(new Rectangle(506, 319), 0, 0, 0, 0);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = PdfWriter.getInstance(document, baos);
        
        if (outputPath != null && !outputPath.isEmpty()) {
            PdfWriter.getInstance(document, new FileOutputStream(outputPath));
        }
        
        document.open();
        
        // ===== FRONT SIDE - User Details =====
        addPremiumFrontSide(document, writer, userName, userId, regId, eventName, 
                           eventDate, eventTime, venue, userEmail, userPhone, userPhotoBase64);
        
        // ===== BACK SIDE - QR Code & Instructions =====
        document.newPage();
        addPremiumBackSide(document, writer, eventName, eventDate, eventTime, venue, qrCodeBase64);
        
        document.close();
        
        byte[] pdfBytes = baos.toByteArray();
        return Base64.getEncoder().encodeToString(pdfBytes);
    }
    
    /**
     * FRONT SIDE - Premium corporate design with photo
     */
    private static void addPremiumFrontSide(Document document, PdfWriter writer,
                                           String userName, String userId, String regId,
                                           String eventName, String eventDate, String eventTime,
                                           String venue, String userEmail, String userPhone,
                                           String userPhotoBase64) 
            throws DocumentException, IOException {
        
        PdfContentByte canvas = writer.getDirectContentUnder();
        
        // ===== MODERN GRADIENT BACKGROUND =====
        // Left panel - Brand Blue
        canvas.saveState();
        canvas.setColorFill(BRAND_BLUE);
        canvas.rectangle(0, 0, 170, 319);
        canvas.fill();
        
        // Right panel - White
        canvas.setColorFill(TEXT_WHITE);
        canvas.rectangle(170, 0, 336, 319);
        canvas.fill();
        canvas.restoreState();
        
        // ===== LEFT PANEL - USER PHOTO & LOGO =====
        canvas.saveState();
        
        // Company logo/icon at top
        Font logoFont = new Font(Font.FontFamily.HELVETICA, 36, Font.BOLD, TEXT_WHITE);
        ColumnText ct = new ColumnText(canvas);
        ct.setSimpleColumn(10, 260, 160, 310);
        Paragraph logoText = new Paragraph("🎓", logoFont);
        logoText.setAlignment(Element.ALIGN_CENTER);
        ct.addElement(logoText);
        ct.go();
        
        canvas.restoreState();
        
        // User Photo (centered in left panel)
        if (userPhotoBase64 != null && !userPhotoBase64.isEmpty()) {
            try {
                byte[] photoBytes = Base64.getDecoder().decode(userPhotoBase64);
                Image userPhoto = Image.getInstance(photoBytes);
                userPhoto.scaleToFit(120, 120);
                userPhoto.setAbsolutePosition(25, 130);
                document.add(userPhoto);
                
                // White border around photo
                canvas.saveState();
                canvas.setLineWidth(3);
                canvas.setColorStroke(TEXT_WHITE);
                canvas.rectangle(22, 127, 126, 126);
                canvas.stroke();
                canvas.restoreState();
                
            } catch (Exception e) {
                // Default user icon
                addDefaultUserIcon(canvas);
            }
        } else {
            // Default user icon
            addDefaultUserIcon(canvas);
        }
        
        // Registration badge at bottom of left panel
        canvas.saveState();
        canvas.setColorFill(ACCENT_TEAL);
        canvas.rectangle(20, 20, 130, 35);
        canvas.fill();
        
        Font badgeFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD, TEXT_WHITE);
        ColumnText badgeCt = new ColumnText(canvas);
        badgeCt.setSimpleColumn(20, 20, 150, 55);
        Paragraph badgeP = new Paragraph("REG-" + regId, badgeFont);
        badgeP.setAlignment(Element.ALIGN_CENTER);
        badgeCt.addElement(badgeP);
        badgeCt.go();
        canvas.restoreState();
        
        // ===== RIGHT PANEL - USER & EVENT DETAILS =====
        
        // University name
        Font universityFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, BRAND_BLUE);
        ColumnText univCt = new ColumnText(canvas);
        univCt.setSimpleColumn(180, 280, 496, 310);
        Paragraph univP = new Paragraph("UNIVERSITY EVENTS", universityFont);
        univCt.addElement(univP);
        univCt.go();
        
        // Tagline
        Font taglineFont = new Font(Font.FontFamily.HELVETICA, 7, Font.ITALIC, new BaseColor(107, 114, 128));
        ColumnText tagCt = new ColumnText(canvas);
        tagCt.setSimpleColumn(180, 270, 496, 285);
        Paragraph tagP = new Paragraph("Official Event Registration Pass", taglineFont);
        tagCt.addElement(tagP);
        tagCt.go();
        
        // User Name (Large and prominent)
        Font nameFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, TEXT_DARK);
        ColumnText nameCt = new ColumnText(canvas);
        nameCt.setSimpleColumn(180, 235, 496, 265);
        Paragraph nameP = new Paragraph(userName.toUpperCase(), nameFont);
        nameCt.addElement(nameP);
        nameCt.go();
        
        // User details in compact format
        Font labelFont = new Font(Font.FontFamily.HELVETICA, 7, Font.BOLD, new BaseColor(107, 114, 128));
        Font valueFont = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, TEXT_DARK);
        
        float yPos = 215;
        float lineHeight = 18;
        
        // ID
        addInfoLine(canvas, 180, yPos, "ID", userId, labelFont, valueFont);
        yPos -= lineHeight;
        
        // Email
        addInfoLine(canvas, 180, yPos, "EMAIL", userEmail, labelFont, valueFont);
        yPos -= lineHeight;
        
        // Phone
        addInfoLine(canvas, 180, yPos, "PHONE", userPhone, labelFont, valueFont);
        yPos -= 25;
        
        // Separator line
        canvas.saveState();
        canvas.setLineWidth(0.5f);
        canvas.setColorStroke(new BaseColor(229, 231, 235));
        canvas.moveTo(180, yPos + 10);
        canvas.lineTo(490, yPos + 10);
        canvas.stroke();
        canvas.restoreState();
        
        yPos -= 5;
        
        // Event heading
        Font eventHeadFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, BRAND_BLUE);
        ColumnText eventHeadCt = new ColumnText(canvas);
        eventHeadCt.setSimpleColumn(180, yPos - 15, 496, yPos + 5);
        Paragraph eventHeadP = new Paragraph("EVENT DETAILS", eventHeadFont);
        eventHeadCt.addElement(eventHeadP);
        eventHeadCt.go();
        
        yPos -= 25;
        
        // Event details
        addInfoLine(canvas, 180, yPos, "EVENT", eventName, labelFont, valueFont);
        yPos -= lineHeight;
        
        addInfoLine(canvas, 180, yPos, "DATE", eventDate + " • " + eventTime, labelFont, valueFont);
        yPos -= lineHeight;
        
        addInfoLine(canvas, 180, yPos, "VENUE", venue, labelFont, valueFont);
        
        // Footer website
        Font footerFont = new Font(Font.FontFamily.HELVETICA, 6, Font.ITALIC, new BaseColor(156, 163, 175));
        ColumnText footerCt = new ColumnText(canvas);
        footerCt.setSimpleColumn(180, 5, 496, 20);
        Paragraph footerP = new Paragraph("www.universityevents.edu", footerFont);
        footerCt.addElement(footerP);
        footerCt.go();
    }
    
    /**
     * BACK SIDE - QR Code & Instructions
     */
    private static void addPremiumBackSide(Document document, PdfWriter writer,
                                          String eventName, String eventDate, 
                                          String eventTime, String venue, String qrCodeBase64) 
            throws DocumentException, IOException {
        
        PdfContentByte canvas = writer.getDirectContentUnder();
        
        // ===== BACKGROUND =====
        canvas.saveState();
        canvas.setColorFill(LIGHT_GRAY);
        canvas.rectangle(0, 0, 506, 319);
        canvas.fill();
        canvas.restoreState();
        
        // Accent bar at top
        canvas.saveState();
        canvas.setColorFill(BRAND_BLUE);
        canvas.rectangle(0, 295, 506, 24);
        canvas.fill();
        canvas.restoreState();
        
        // Logo and title on accent bar
        Font logoFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, TEXT_WHITE);
        ColumnText logoCt = new ColumnText(canvas);
        logoCt.setSimpleColumn(20, 295, 486, 315);
        Paragraph logoP = new Paragraph("🎓 UNIVERSITY EVENTS", logoFont);
        logoP.setAlignment(Element.ALIGN_CENTER);
        logoCt.addElement(logoP);
        logoCt.go();
        
        // Event summary box
        canvas.saveState();
        canvas.setColorFill(TEXT_WHITE);
        canvas.setLineWidth(0);
        canvas.rectangle(30, 215, 446, 60);
        canvas.fill();
        canvas.restoreState();
        
        Font summaryHeadFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BRAND_BLUE);
        ColumnText sumHeadCt = new ColumnText(canvas);
        sumHeadCt.setSimpleColumn(40, 255, 466, 270);
        Paragraph sumHeadP = new Paragraph(eventName.toUpperCase(), summaryHeadFont);
        sumHeadP.setAlignment(Element.ALIGN_CENTER);
        sumHeadCt.addElement(sumHeadP);
        sumHeadCt.go();
        
        Font summaryFont = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, TEXT_DARK);
        ColumnText sumCt = new ColumnText(canvas);
        sumCt.setSimpleColumn(40, 220, 466, 255);
        Paragraph sumP = new Paragraph();
        sumP.add(new Chunk("📅 " + eventDate + "  •  🕐 " + eventTime + "\n", summaryFont));
        sumP.add(new Chunk("📍 " + venue, summaryFont));
        sumP.setAlignment(Element.ALIGN_CENTER);
        sumCt.addElement(sumP);
        sumCt.go();
        
        // QR Code section
        Font qrHeadFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, TEXT_DARK);
        ColumnText qrHeadCt = new ColumnText(canvas);
        qrHeadCt.setSimpleColumn(30, 180, 476, 205);
        Paragraph qrHeadP = new Paragraph("SCAN TO VERIFY ENTRY", qrHeadFont);
        qrHeadP.setAlignment(Element.ALIGN_CENTER);
        qrHeadCt.addElement(qrHeadP);
        qrHeadCt.go();
        
        // QR Code with border
        if (qrCodeBase64 != null && !qrCodeBase64.isEmpty()) {
            try {
                byte[] qrBytes = Base64.getDecoder().decode(qrCodeBase64);
                Image qrImage = Image.getInstance(qrBytes);
                qrImage.scaleToFit(120, 120);
                qrImage.setAbsolutePosition(193, 50);
                document.add(qrImage);
                
                // White border around QR
                canvas.saveState();
                canvas.setColorFill(TEXT_WHITE);
                canvas.rectangle(185, 42, 136, 136);
                canvas.fill();
                canvas.restoreState();
                
                // QR image again on top
                document.add(qrImage);
                
                // Gold accent border
                canvas.saveState();
                canvas.setLineWidth(2);
                canvas.setColorStroke(GOLD_ACCENT);
                canvas.rectangle(185, 42, 136, 136);
                canvas.stroke();
                canvas.restoreState();
                
            } catch (Exception e) {
                System.err.println("⚠ Could not add QR code: " + e.getMessage());
            }
        }
        
        // ✅ FIXED: Instructions (compact) - instructFont is now used
        Font instructFont = new Font(Font.FontFamily.HELVETICA, 6, Font.NORMAL, new BaseColor(75, 85, 99));
        Font timestampFont = new Font(Font.FontFamily.HELVETICA, 5, Font.ITALIC, new BaseColor(156, 163, 175));
        
        ColumnText instCt = new ColumnText(canvas);
        instCt.setSimpleColumn(30, 5, 476, 40);
        Paragraph instP = new Paragraph();
        instP.add(new Chunk("✓ Arrive 15 min early  •  ✓ Valid ID required  •  ✓ Non-transferable\n", instructFont));
        instP.add(new Chunk("Generated: " + new SimpleDateFormat("dd-MM-yyyy HH:mm").format(new Date()), timestampFont));
        instP.setAlignment(Element.ALIGN_CENTER);
        instCt.addElement(instP);
        instCt.go();
    }
    
    /**
     * Helper to add default user icon
     */
    /**
     * Helper to add default user icon
     * ✅ FIXED: Added throws DocumentException
     */
    private static void addDefaultUserIcon(PdfContentByte canvas) throws DocumentException {
        canvas.saveState();
        Font iconFont = new Font(Font.FontFamily.HELVETICA, 80, Font.NORMAL, TEXT_WHITE);
        ColumnText iconCt = new ColumnText(canvas);
        iconCt.setSimpleColumn(10, 130, 160, 250);
        Paragraph iconP = new Paragraph("👤", iconFont);
        iconP.setAlignment(Element.ALIGN_CENTER);
        iconCt.addElement(iconP);
        iconCt.go();
        canvas.restoreState();
    }

    /**
     * Helper to add info line with label and value
     * ✅ FIXED: Added throws DocumentException
     */
    private static void addInfoLine(PdfContentByte canvas, float x, float y, 
                                    String label, String value, Font labelFont, Font valueFont) 
            throws DocumentException {
        ColumnText ct = new ColumnText(canvas);
        ct.setSimpleColumn(x, y - 12, x + 310, y + 5);
        Paragraph p = new Paragraph();
        p.add(new Chunk(label + ": ", labelFont));
        p.add(new Chunk(value, valueFont));
        ct.addElement(p);
        ct.go();
    }

}
