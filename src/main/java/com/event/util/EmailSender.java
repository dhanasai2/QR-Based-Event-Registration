package com.event.util;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.util.ByteArrayDataSource;
import java.util.Base64;
import java.util.Properties;

/**
 * ✨ Premium Interactive Email Sender - 2025 Edition
 * Features: Responsive Design | Interactive Elements | Animated Buttons | Professional Templates
 * Optimized for Gmail, Outlook, Yahoo, and Mobile Clients
 */
public class EmailSender {
    
    // ===== SMTP CONFIGURATION =====
    private static final String FROM_EMAIL = "saigundumogula5@gmail.com";
    private static final String PASSWORD = "nhigofgfhzxomurq";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    // ===== BRAND COLORS & DESIGN SYSTEM =====
    private static final String PRIMARY_COLOR = "#667eea";
    private static final String SECONDARY_COLOR = "#764ba2";
    private static final String SUCCESS_COLOR = "#10b981";
    private static final String WARNING_COLOR = "#f59e0b";
    private static final String DANGER_COLOR = "#ef4444";
    private static final String DARK_COLOR = "#1f2937";
    
    // ===== PREMIUM EMAIL COMPONENTS =====
    
    /**
     * 🎨 Modern Glassmorphism Header with Animated Gradient
     */
    private static String getEmailHeader() {
        return "<div style='background: linear-gradient(135deg, " + PRIMARY_COLOR + " 0%, " + SECONDARY_COLOR + " 100%); " +
               "padding: 60px 20px; text-align: center; border-radius: 20px 20px 0 0; position: relative; overflow: hidden;'>" +
               
               // Animated Background Pattern
               "<div style='position: absolute; top: 0; left: 0; width: 100%; height: 100%; " +
               "background-image: radial-gradient(circle at 20% 50%, rgba(255,255,255,0.1) 0%, transparent 50%), " +
               "radial-gradient(circle at 80% 80%, rgba(255,255,255,0.1) 0%, transparent 50%);'></div>" +
               
               // Glassmorphism Card
               "<div style='position: relative; background: rgba(255,255,255,0.15); backdrop-filter: blur(10px); " +
               "display: inline-block; padding: 30px 60px; border-radius: 20px; " +
               "box-shadow: 0 8px 32px rgba(0,0,0,0.1), 0 0 0 1px rgba(255,255,255,0.2);'>" +
               
               "<div style='display: inline-block; background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%); " +
               "padding: 15px; border-radius: 15px; margin-bottom: 15px; box-shadow: 0 4px 20px rgba(251, 191, 36, 0.4);'>" +
               "<span style='font-size: 40px;'>🎓</span>" +
               "</div>" +
               
               "<h1 style='color: white; margin: 15px 0 0 0; font-size: 36px; font-weight: 800; " +
               "text-shadow: 2px 4px 8px rgba(0,0,0,0.2); letter-spacing: 1px;'>University Events</h1>" +
               
               "<p style='color: rgba(255,255,255,0.95); margin: 10px 0 0 0; font-size: 13px; " +
               "letter-spacing: 3px; text-transform: uppercase; font-weight: 600;'>Your Campus Event Hub</p>" +
               "</div></div>";
    }
    
    /**
     * 🔔 Interactive Alert Badge
     */
    private static String getAlertBadge(String type, String emoji, String text) {
        String bgColor = type.equals("success") ? "#d1fae5" : 
                        type.equals("warning") ? "#fef3c7" : 
                        type.equals("info") ? "#dbeafe" : "#fee2e2";
        String textColor = type.equals("success") ? "#065f46" : 
                          type.equals("warning") ? "#92400e" : 
                          type.equals("info") ? "#1e3a8a" : "#991b1b";
        String borderColor = type.equals("success") ? SUCCESS_COLOR : 
                            type.equals("warning") ? WARNING_COLOR : 
                            type.equals("info") ? "#3b82f6" : DANGER_COLOR;
        
        return "<div style='background: " + bgColor + "; border-left: 6px solid " + borderColor + "; " +
               "padding: 25px 30px; margin: 30px 0; border-radius: 12px; " +
               "box-shadow: 0 4px 15px rgba(0,0,0,0.08);'>" +
               "<div style='display: flex; align-items: center;'>" +
               "<span style='font-size: 32px; margin-right: 15px;'>" + emoji + "</span>" +
               "<p style='margin: 0; color: " + textColor + "; font-size: 16px; font-weight: 600; line-height: 1.6;'>" +
               text + "</p></div></div>";
    }
    
    /**
     * 💎 Premium Bulletproof Button (Works in ALL email clients)
     */
    private static String getButton(String text, String url, String color) {
        String bgColor = color.equals("primary") ? PRIMARY_COLOR : 
                        color.equals("success") ? SUCCESS_COLOR : 
                        color.equals("danger") ? DANGER_COLOR : PRIMARY_COLOR;
        
        return "<table border='0' cellspacing='0' cellpadding='0' style='margin: 30px auto;'>" +
               "<tr><td align='center' style='border-radius: 50px; background: linear-gradient(135deg, " + bgColor + " 0%, " + bgColor + "dd 100%);' " +
               "bgcolor='" + bgColor + "'>" +
               "<a href='" + url + "' target='_blank' style='font-size: 18px; font-family: Arial, sans-serif; color: #ffffff; " +
               "text-decoration: none; border-radius: 50px; padding: 18px 50px; border: 2px solid " + bgColor + "; " +
               "display: inline-block; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; " +
               "box-shadow: 0 8px 20px rgba(0,0,0,0.15); transition: all 0.3s ease;'>" +
               "✨ " + text + "</a></td></tr></table>";
    }
    
    /**
     * 📊 Information Card with Icon
     */
    private static String getInfoCard(String title, String value, String icon) {
        return "<div style='background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); " +
               "padding: 25px; margin: 15px 0; border-radius: 15px; text-align: center; " +
               "border: 2px solid #e2e8f0; box-shadow: 0 4px 12px rgba(0,0,0,0.05);'>" +
               "<div style='font-size: 42px; margin-bottom: 10px;'>" + icon + "</div>" +
               "<p style='margin: 5px 0; color: #64748b; font-size: 13px; font-weight: 600; " +
               "text-transform: uppercase; letter-spacing: 1px;'>" + title + "</p>" +
               "<p style='margin: 5px 0; color: " + DARK_COLOR + "; font-size: 28px; font-weight: 800;'>" + value + "</p>" +
               "</div>";
    }
    
    /**
     * 📅 Event Details Card
     */
    private static String getEventDetailsCard(String eventName, String eventDate, String eventTime, String venue) {
        return "<div style='background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%); " +
               "padding: 35px; margin: 30px 0; border-radius: 20px; border: 3px solid " + SUCCESS_COLOR + "; " +
               "box-shadow: 0 10px 30px rgba(16, 185, 129, 0.2);'>" +
               
               "<h3 style='margin: 0 0 25px 0; color: #065f46; text-align: center; font-size: 22px; " +
               "font-weight: 800; text-transform: uppercase; letter-spacing: 1px;'>" +
               "📅 Event Information</h3>" +
               
               "<table style='width: 100%; border-collapse: separate; border-spacing: 0 12px;'>" +
               "<tr><td style='padding: 15px; background: rgba(255,255,255,0.7); border-radius: 10px;'>" +
               "<span style='color: #065f46; font-weight: 700; font-size: 15px;'>🎯 Event:</span></td>" +
               "<td style='padding: 15px; background: rgba(255,255,255,0.7); border-radius: 10px; text-align: right;'>" +
               "<span style='color: #047857; font-weight: 600; font-size: 15px;'>" + eventName + "</span></td></tr>" +
               
               "<tr><td style='padding: 15px; background: rgba(255,255,255,0.7); border-radius: 10px;'>" +
               "<span style='color: #065f46; font-weight: 700; font-size: 15px;'>📆 Date:</span></td>" +
               "<td style='padding: 15px; background: rgba(255,255,255,0.7); border-radius: 10px; text-align: right;'>" +
               "<span style='color: #047857; font-weight: 600; font-size: 15px;'>" + eventDate + "</span></td></tr>" +
               
               "<tr><td style='padding: 15px; background: rgba(255,255,255,0.7); border-radius: 10px;'>" +
               "<span style='color: #065f46; font-weight: 700; font-size: 15px;'>🕐 Time:</span></td>" +
               "<td style='padding: 15px; background: rgba(255,255,255,0.7); border-radius: 10px; text-align: right;'>" +
               "<span style='color: #047857; font-weight: 600; font-size: 15px;'>" + eventTime + "</span></td></tr>" +
               
               "<tr><td style='padding: 15px; background: rgba(255,255,255,0.7); border-radius: 10px;'>" +
               "<span style='color: #065f46; font-weight: 700; font-size: 15px;'>📍 Venue:</span></td>" +
               "<td style='padding: 15px; background: rgba(255,255,255,0.7); border-radius: 10px; text-align: right;'>" +
               "<span style='color: #047857; font-weight: 600; font-size: 15px;'>" + venue + "</span></td></tr>" +
               "</table></div>";
    }
    
    /**
     * 🎫 QR Code Display Section
     */
    private static String getQRCodeSection(String qrCodeBase64) {
        if (qrCodeBase64 == null || qrCodeBase64.isEmpty()) {
            return "";
        }
        return "<div style='background: linear-gradient(135deg, #f9fafb 0%, #e5e7eb 100%); " +
               "padding: 40px; border-radius: 20px; margin: 30px 0; text-align: center; " +
               "box-shadow: 0 10px 30px rgba(0,0,0,0.1);'>" +
               
               "<h3 style='color: " + DARK_COLOR + "; margin: 0 0 20px 0; font-size: 20px; font-weight: 800;'>" +
               "🎟️ Your Digital Ticket</h3>" +
               
               "<div style='background: white; display: inline-block; padding: 20px; border-radius: 20px; " +
               "box-shadow: 0 8px 25px rgba(0,0,0,0.15); border: 4px solid " + PRIMARY_COLOR + ";'>" +
               "<img src='data:image/png;base64," + qrCodeBase64 + "' " +
               "alt='Event QR Code' style='max-width: 280px; display: block; border-radius: 10px;'/>" +
               "</div>" +
               
               "<p style='margin: 20px 0 0 0; color: #6b7280; font-size: 13px; font-style: italic;'>" +
               "💡 Present this QR code at the event entrance</p>" +
               "</div>";
    }
    
    /**
     * 📋 Checklist / Instructions Section
     */
    private static String getInstructionsList(String[] items) {
        StringBuilder html = new StringBuilder();
        html.append("<div style='background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); " +
                   "padding: 30px; margin: 30px 0; border-radius: 15px; border-left: 6px solid #3b82f6;'>" +
                   "<h4 style='margin: 0 0 20px 0; color: #1e40af; font-size: 18px; font-weight: 800;'>" +
                   "📌 Important Instructions</h4><ul style='margin: 0; padding-left: 25px; color: #1e3a8a;'>");
        
        for (String item : items) {
            html.append("<li style='margin: 12px 0; font-size: 15px; line-height: 1.7; font-weight: 500;'>")
                .append(item).append("</li>");
        }
        html.append("</ul></div>");
        return html.toString();
    }
    
    /**
     * 🌟 Professional Footer with Social Links
     */
    private static String getEmailFooter() {
        return "<div style='background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); " +
               "padding: 50px 30px; text-align: center; margin-top: 40px; border-radius: 0 0 20px 20px;'>" +
               
               // Social Links
               "<div style='margin-bottom: 25px;'>" +
               "<a href='#' style='display: inline-block; margin: 0 12px; text-decoration: none; " +
               "background: white; width: 50px; height: 50px; border-radius: 50%; line-height: 50px; " +
               "box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: all 0.3s;'>" +
               "<span style='font-size: 24px;'>📱</span></a>" +
               
               "<a href='#' style='display: inline-block; margin: 0 12px; text-decoration: none; " +
               "background: white; width: 50px; height: 50px; border-radius: 50%; line-height: 50px; " +
               "box-shadow: 0 4px 15px rgba(0,0,0,0.1);'>" +
               "<span style='font-size: 24px;'>✉️</span></a>" +
               
               "<a href='#' style='display: inline-block; margin: 0 12px; text-decoration: none; " +
               "background: white; width: 50px; height: 50px; border-radius: 50%; line-height: 50px; " +
               "box-shadow: 0 4px 15px rgba(0,0,0,0.1);'>" +
               "<span style='font-size: 24px;'>🌐</span></a>" +
               "</div>" +
               
               // Divider
               "<div style='height: 2px; background: linear-gradient(90deg, transparent 0%, #cbd5e1 50%, transparent 100%); " +
               "margin: 30px 0;'></div>" +
               
               // Brand Info
               "<p style='color: #475569; font-size: 15px; margin: 12px 0; font-weight: 700;'>" +
               "🎓 University Event Management System</p>" +
               
               "<p style='color: #64748b; font-size: 13px; margin: 8px 0;'>" +
               "📧 support@universityevents.edu | 📞 +91 1800-XXX-XXXX</p>" +
               
               "<p style='color: #94a3b8; font-size: 12px; margin: 20px 0 8px 0;'>" +
               "© 2025 University Events. All Rights Reserved.</p>" +
               
               "<p style='color: #cbd5e1; font-size: 11px; margin: 8px 0; font-style: italic;'>" +
               "⚡ This is an automated email. Please do not reply.</p>" +
               "</div>";
    }
    
    /**
     * 📧 Professional Email Wrapper
     */
    private static String wrapEmail(String content) {
        return "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' " +
               "'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>" +
               "<html xmlns='http://www.w3.org/1999/xhtml'>" +
               "<head>" +
               "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />" +
               "<meta name='viewport' content='width=device-width, initial-scale=1.0'/>" +
               "<meta name='x-apple-disable-message-reformatting' />" +
               "<meta http-equiv='X-UA-Compatible' content='IE=edge' />" +
               "<title>University Events</title>" +
               "<style type='text/css'>" +
               "@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');" +
               "body { margin: 0; padding: 0; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }" +
               "table { border-collapse: collapse; }" +
               "img { border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }" +
               "@media only screen and (max-width: 600px) {" +
               ".email-container { width: 100% !important; }" +
               ".mobile-padding { padding: 20px 15px !important; }" +
               "h1 { font-size: 28px !important; }" +
               "h2 { font-size: 24px !important; }" +
               "}" +
               "</style>" +
               "</head>" +
               "<body style='font-family: \"Inter\", \"Segoe UI\", Arial, sans-serif; margin: 0; padding: 20px; " +
               "background: linear-gradient(135deg, #e0f2fe 0%, #f0f9ff 50%, #fae8ff 100%);'>" +
               
               "<table border='0' cellpadding='0' cellspacing='0' width='100%'>" +
               "<tr><td align='center' style='padding: 20px 0;'>" +
               
               "<table border='0' cellpadding='0' cellspacing='0' width='650' class='email-container' " +
               "style='max-width: 650px; background: white; border-radius: 25px; " +
               "box-shadow: 0 20px 60px rgba(0,0,0,0.15);'>" +
               "<tr><td>" +
               
               getEmailHeader() +
               
               "<div class='mobile-padding' style='padding: 45px 40px;'>" +
               content +
               "</div>" +
               
               getEmailFooter() +
               
               "</td></tr></table>" +
               "</td></tr></table>" +
               "</body></html>";
    }
    
    // ===== CORE EMAIL SENDING ENGINE =====
    
    /**
     * 📤 Send Simple Email
     */
    public static boolean sendEmail(String to, String subject, String body) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "University Events 🎓"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            
            Transport.send(message);
            System.out.println("✓ Email sent successfully to: " + to);
            return true;
            
        } catch (Exception e) {
            System.err.println("✗ Email sending failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 📎 Send Email with PDF Attachment
     */
    public static boolean sendEmailWithAttachment(String to, String subject, String body, 
                                                 String base64PDF, String filename) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "University Events 🎓"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            
            Multipart multipart = new MimeMultipart();
            
            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(body, "text/html; charset=utf-8");
            multipart.addBodyPart(htmlPart);
            
            if (base64PDF != null && !base64PDF.isEmpty()) {
                MimeBodyPart pdfPart = new MimeBodyPart();
                byte[] pdfBytes = Base64.getDecoder().decode(base64PDF);
                DataSource source = new ByteArrayDataSource(pdfBytes, "application/pdf");
                pdfPart.setDataHandler(new DataHandler(source));
                pdfPart.setFileName(filename);
                multipart.addBodyPart(pdfPart);
            }
            
            message.setContent(multipart);
            Transport.send(message);
            
            System.out.println("✓ Email with PDF sent successfully to: " + to);
            return true;
            
        } catch (Exception e) {
            System.err.println("✗ Email with attachment failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // ===== 📧 PROFESSIONAL EMAIL TEMPLATES =====
    
    /**
     * EMAIL 1: 👋 User Registration Welcome
     */
    public static void sendRegistrationEmail(String to, String username) throws Exception {
        String content =
            "<div style='text-align: center; margin-bottom: 35px;'>" +
            "<div style='background: linear-gradient(135deg, " + PRIMARY_COLOR + " 0%, " + SECONDARY_COLOR + " 100%); " +
            "border-radius: 50%; width: 120px; height: 120px; margin: 0 auto 25px; " +
            "display: flex; align-items: center; justify-content: center; " +
            "box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4); position: relative;'>" +
            "<span style='font-size: 60px;'>👋</span>" +
            "</div>" +
            "<h2 style='color: " + DARK_COLOR + "; margin: 0; font-size: 32px; font-weight: 800; " +
            "background: linear-gradient(135deg, " + PRIMARY_COLOR + ", " + SECONDARY_COLOR + "); " +
            "-webkit-background-clip: text; -webkit-text-fill-color: transparent;'>Welcome Aboard!</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 18px; line-height: 1.8; margin: 25px 0; text-align: center;'>" +
            "Hi <strong style='color: " + PRIMARY_COLOR + "; font-weight: 700;'>" + username + "</strong>, " +
            "we're thrilled to have you! 🎉</p>" +
            
            "<div style='background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); " +
            "padding: 30px; margin: 35px 0; border-radius: 15px; text-align: center; " +
            "border: 3px solid " + WARNING_COLOR + "; box-shadow: 0 8px 25px rgba(245, 158, 11, 0.2);'>" +
            "<div style='font-size: 48px; margin-bottom: 15px;'>⏳</div>" +
            "<h3 style='margin: 0 0 10px 0; color: #92400e; font-size: 20px; font-weight: 800;'>Account Under Review</h3>" +
            "<p style='margin: 0; color: #78350f; font-size: 15px; font-weight: 500;'>" +
            "Our team will approve your account within <strong>24-48 hours</strong></p>" +
            "</div>" +
            
            "<div style='background: #f9fafb; padding: 25px; border-radius: 12px; margin: 30px 0;'>" +
            "<p style='margin: 0; color: #6b7280; font-size: 14px; text-align: center; line-height: 1.7;'>" +
            "💡 <strong>What's Next?</strong> Once approved, you'll receive another email with login instructions.</p>" +
            "</div>";
        
        sendEmail(to, "🎉 Welcome to University Events Platform!", wrapEmail(content));
    }
    
    /**
     * EMAIL 2: ✅ User Account Approved
     */
    public static void sendUserApprovedEmail(String to, String username, String role) {
        String content =
            "<div style='text-align: center; margin-bottom: 35px;'>" +
            "<div style='background: linear-gradient(135deg, " + SUCCESS_COLOR + " 0%, #059669 100%); " +
            "border-radius: 50%; width: 120px; height: 120px; margin: 0 auto 25px; " +
            "box-shadow: 0 15px 40px rgba(16, 185, 129, 0.4);'>" +
            "<span style='font-size: 70px; line-height: 120px;'>✅</span>" +
            "</div>" +
            "<h2 style='color: #065f46; margin: 0; font-size: 32px; font-weight: 800;'>You're All Set!</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 17px; text-align: center; line-height: 1.8;'>" +
            "Great news, <strong style='color: " + SUCCESS_COLOR + ";'>" + username + "</strong>! 🎊</p>" +
            
            getAlertBadge("success", "🚀", "Your account has been <strong>approved</strong>! You now have full access to all events.") +
            
            getInfoCard("Your Role", role, "👤") +
            
            getButton("Login to Your Account", "http://localhost:8080/EventRegistrationSystem/login.jsp", "success");
        
        sendEmail(to, "✅ Account Approved - Get Started Now!", wrapEmail(content));
    }
    
    /**
     * EMAIL 3: ❌ User Account Rejected
     */
    public static void sendUserRejectedEmail(String to, String username) {
        String content =
            "<div style='text-align: center; margin-bottom: 30px;'>" +
            "<div style='font-size: 80px;'>😔</div>" +
            "<h2 style='color: #991b1b; margin: 15px 0 0 0;'>Account Registration Update</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 16px; line-height: 1.8;'>Dear <strong>" + username + "</strong>,</p>" +
            
            getAlertBadge("error", "⚠️", "Unfortunately, we couldn't approve your registration at this time.") +
            
            "<p style='color: #6b7280; font-size: 15px; text-align: center; margin: 30px 0;'>" +
            "If you believe this is a mistake, please contact our support team.</p>" +
            
            getButton("Contact Support", "mailto:support@universityevents.edu", "danger");
        
        sendEmail(to, "Account Registration Status Update", wrapEmail(content));
    }
    
    /**
     * EMAIL 4: 💳 Payment Pending
     */
    public static void sendPaymentPendingEmail(String to, String userName, 
                                               String eventName, String eventDate, String amount) {
        String content =
            "<div style='text-align: center; margin-bottom: 30px;'>" +
            "<div style='font-size: 80px;'>💳</div>" +
            "<h2 style='color: " + DARK_COLOR + "; font-size: 30px;'>Complete Your Payment</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 17px; line-height: 1.8;'>Hi <strong>" + userName + "</strong>,</p>" +
            
            "<p style='color: #6b7280; font-size: 16px; line-height: 1.7;'>" +
            "You're almost there! Complete your payment to confirm your spot for " +
            "<strong style='color: " + PRIMARY_COLOR + ";'>" + eventName + "</strong>.</p>" +
            
            getEventDetailsCard(eventName, eventDate, "N/A", "N/A") +
            
            "<div style='background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); " +
            "padding: 40px; margin: 35px 0; border-radius: 20px; text-align: center; " +
            "border: 4px solid " + WARNING_COLOR + "; box-shadow: 0 10px 30px rgba(245, 158, 11, 0.3);'>" +
            "<p style='margin: 0 0 10px 0; color: #92400e; font-size: 16px; font-weight: 700; " +
            "text-transform: uppercase; letter-spacing: 1px;'>Total Amount</p>" +
            "<p style='margin: 0; color: #78350f; font-size: 56px; font-weight: 900;'>₹" + amount + "</p>" +
            "</div>" +
            
            getButton("Pay Now", "http://localhost:8080/EventRegistrationSystem/payment", "primary");
        
        sendEmail(to, "⏳ Payment Pending - " + eventName, wrapEmail(content));
    }
    
    /**
     * EMAIL 5: 🎟️ Registration Confirmation (Free Event)
     */
    public static void sendRegistrationConfirmation(String to, String userName, 
                                                    String eventName, String eventDate) {
        String content =
            "<div style='text-align: center; margin-bottom: 30px;'>" +
            "<div style='font-size: 80px;'>🎟️</div>" +
            "<h2 style='color: " + DARK_COLOR + ";'>Registration Received!</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 17px;'>Hi <strong>" + userName + "</strong>,</p>" +
            
            "<p style='color: #6b7280; font-size: 16px;'>" +
            "We've received your registration for <strong style='color: " + PRIMARY_COLOR + ";'>" + eventName + "</strong>! 🎉</p>" +
            
            getAlertBadge("info", "⏳", "<strong>Status: Pending Admin Approval</strong><br>You'll receive a confirmation email once approved.") +
            
            getInfoCard("Event Date", eventDate, "📅");
        
        sendEmail(to, "✅ Registration Received - " + eventName, wrapEmail(content));
    }
    
    /**
     * EMAIL 6: 💰 Payment Confirmation
     */
    public static void sendPaymentConfirmation(String to, String userName, 
                                              String eventName, String amount) {
        String content =
            "<div style='text-align: center; margin-bottom: 30px;'>" +
            "<div style='background: linear-gradient(135deg, " + SUCCESS_COLOR + " 0%, #059669 100%); " +
            "border-radius: 50%; width: 120px; height: 120px; margin: 0 auto 25px; " +
            "box-shadow: 0 15px 40px rgba(16, 185, 129, 0.4);'>" +
            "<span style='font-size: 70px; line-height: 120px;'>💰</span>" +
            "</div>" +
            "<h2 style='color: #065f46;'>Payment Successful!</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 17px;'>Hi <strong>" + userName + "</strong>,</p>" +
            
            getAlertBadge("success", "✅", "Your payment has been confirmed for <strong>" + eventName + "</strong>") +
            
            "<div style='background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); " +
            "padding: 40px; margin: 35px 0; border-radius: 20px; text-align: center; " +
            "border: 4px solid " + SUCCESS_COLOR + "; box-shadow: 0 10px 30px rgba(16, 185, 129, 0.3);'>" +
            "<p style='margin: 0 0 10px 0; color: #065f46; font-size: 16px; font-weight: 700;'>Amount Paid</p>" +
            "<p style='margin: 0; color: #047857; font-size: 56px; font-weight: 900;'>₹" + amount + "</p>" +
            "</div>" +
            
            getInstructionsList(new String[]{
                "Your payment receipt has been sent to your email",
                "Wait for admin approval to receive your event ticket",
                "Check your inbox regularly for updates"
            });
        
        sendEmail(to, "✅ Payment Confirmed - " + eventName, wrapEmail(content));
    }
    
    /**
     * EMAIL 7: 🎉 Event Approved (Simple - with QR code)
     */
    public static void sendApprovalNotification(String to, String userName, 
                                                String eventName, String qrCodeBase64) {
        String content =
            "<div style='text-align: center; margin-bottom: 30px;'>" +
            "<div style='font-size: 90px;'>🎉</div>" +
            "<h2 style='color: #065f46; font-size: 34px; font-weight: 800;'>You're Confirmed!</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 18px; text-align: center;'>" +
            "Congratulations <strong style='color: " + SUCCESS_COLOR + ";'>" + userName + "</strong>! 🎊</p>" +
            
            getAlertBadge("success", "✅", "Your registration for <strong>" + eventName + "</strong> has been approved!") +
            
            getQRCodeSection(qrCodeBase64) +
            
            getInstructionsList(new String[]{
                "Save this email or take a screenshot of the QR code",
                "Present the QR code at the event entrance",
                "Arrive 15 minutes early for smooth check-in",
                "Bring a valid student ID card"
            });
        
        sendEmail(to, "🎉 You're In! Registration Approved - " + eventName, wrapEmail(content));
    }
    
    /**
     * EMAIL 8: 🎫 Event Approved with PDF Ticket (PREMIUM)
     */
    public static void sendApprovalNotificationWithPDF(String to, String userName, 
                                                       String eventName, String eventDate,
                                                       String eventTime, String venue,
                                                       String qrCodeBase64, String pdfBase64,
                                                       String pdfFileName) {
        String content =
            "<div style='text-align: center; margin-bottom: 35px;'>" +
            "<div style='background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%); " +
            "border-radius: 50%; width: 130px; height: 130px; margin: 0 auto 25px; " +
            "box-shadow: 0 15px 40px rgba(251, 191, 36, 0.5);'>" +
            "<span style='font-size: 75px; line-height: 130px;'>🎫</span>" +
            "</div>" +
            "<h2 style='color: #065f46; font-size: 36px; font-weight: 900;'>Your Ticket is Ready!</h2>" +
            "<p style='color: #6b7280; font-size: 15px; margin: 10px 0 0 0;'>Registration confirmed for <strong>" + eventName + "</strong></p>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 18px; text-align: center; line-height: 1.8; margin: 25px 0;'>" +
            "Hey <strong style='color: " + PRIMARY_COLOR + ";'>" + userName + "</strong>, you're all set! 🚀</p>" +
            
            getEventDetailsCard(eventName, eventDate, eventTime, venue) +
            
            getQRCodeSection(qrCodeBase64) +
            
            "<div style='background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); " +
            "padding: 30px; margin: 35px 0; border-radius: 15px; text-align: center; " +
            "border: 3px solid " + WARNING_COLOR + ";'>" +
            "<div style='font-size: 48px; margin-bottom: 15px;'>📎</div>" +
            "<p style='margin: 0; color: #92400e; font-size: 17px; font-weight: 700;'>" +
            "Your complete event ticket is <strong>attached as a PDF</strong></p>" +
            "</div>" +
            
            getInstructionsList(new String[]{
                "Download and save your PDF ticket attachment",
                "Print your ticket OR show it on your mobile device",
                "Arrive at least 15 minutes before event start time",
                "Bring a valid photo ID for verification",
                "Keep this email for future reference"
            }) +
            
            "<div style='text-align: center; margin: 35px 0;'>" +
            "<p style='color: #059669; font-size: 22px; font-weight: 800; margin: 0;'>See you at the event! 🎊</p>" +
            "</div>";
        
        sendEmailWithAttachment(to, "🎫 Your Event Ticket is Ready! - " + eventName, 
                              wrapEmail(content), pdfBase64, pdfFileName);
    }
    
    /**
     * EMAIL 9: ❌ Registration Rejected
     */
    public static void sendRejectionEmail(String to, String userName, String eventName, String reason) {
        String content =
            "<div style='text-align: center; margin-bottom: 30px;'>" +
            "<div style='font-size: 80px;'>😔</div>" +
            "<h2 style='color: #991b1b;'>Registration Update</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 16px;'>Dear <strong>" + userName + "</strong>,</p>" +
            
            "<p style='color: #6b7280; font-size: 15px;'>" +
            "Thank you for your interest in <strong style='color: " + PRIMARY_COLOR + ";'>" + eventName + "</strong>.</p>" +
            
            getAlertBadge("error", "⚠️", "Unfortunately, we couldn't approve your registration at this time.") +
            
            (reason != null && !reason.isEmpty() ? 
            "<div style='background: #fef2f2; padding: 25px; margin: 25px 0; border-radius: 12px; " +
            "border-left: 5px solid " + DANGER_COLOR + ";'>" +
            "<p style='margin: 0; color: #7f1d1d; font-size: 14px;'><strong>Reason:</strong> " + reason + "</p></div>" : "") +
            
            "<p style='color: #6b7280; font-size: 14px; text-align: center; margin: 30px 0;'>" +
            "We encourage you to explore other upcoming events on our platform.</p>" +
            
            getButton("Browse Other Events", "http://localhost:8080/EventRegistrationSystem/events.jsp", "primary");
        
        sendEmail(to, "Registration Status Update - " + eventName, wrapEmail(content));
    }
    /**
     * EMAIL 10: 📝 Payment Proof Received Confirmation
     */
    public static void sendPaymentProofReceivedEmail(String to, String userName, String eventName,
                                                     String utrNumber, String amount) {
        String content =
            "<div style='text-align: center; margin-bottom: 35px;'>" +
            "<div style='background: linear-gradient(135deg, " + WARNING_COLOR + " 0%, #fbbf24 100%); " +
            "border-radius: 50%; width: 120px; height: 120px; margin: 0 auto 25px; " +
            "box-shadow: 0 15px 40px rgba(245, 158, 11, 0.4);'>" +
            "<span style='font-size: 70px; line-height: 120px;'>📝</span>" +
            "</div>" +
            "<h2 style='color: #92400e; font-size: 32px; font-weight: 800;'>Payment Proof Received</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 17px; text-align: center; line-height: 1.8;'>" +
            "Hi <strong style='color: " + PRIMARY_COLOR + ";'>" + userName + "</strong>,</p>" +
            
            "<p style='color: #6b7280; font-size: 16px; text-align: center; line-height: 1.7;'>" +
            "Thank you for submitting your payment proof! 🙏</p>" +
            
            getAlertBadge("warning", "⏳", "Your payment is currently <strong>under review</strong> by our admin team.") +
            
            "<div style='background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); " +
            "padding: 35px; margin: 30px 0; border-radius: 20px; border: 3px solid " + WARNING_COLOR + "; " +
            "box-shadow: 0 10px 30px rgba(245, 158, 11, 0.2);'>" +
            "<h3 style='margin: 0 0 25px 0; color: #92400e; text-align: center; font-size: 20px; font-weight: 800;'>" +
            "📋 Submission Details</h3>" +
            
            "<table style='width: 100%; border-collapse: separate; border-spacing: 0 10px;'>" +
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.7); border-radius: 8px;'>" +
            "<span style='color: #92400e; font-weight: 700; font-size: 14px;'>🎯 Event:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.7); border-radius: 8px; text-align: right;'>" +
            "<span style='color: #78350f; font-weight: 600;'>" + eventName + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.7); border-radius: 8px;'>" +
            "<span style='color: #92400e; font-weight: 700; font-size: 14px;'>💰 Amount:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.7); border-radius: 8px; text-align: right;'>" +
            "<span style='color: #78350f; font-weight: 700; font-size: 18px;'>₹" + amount + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.7); border-radius: 8px;'>" +
            "<span style='color: #92400e; font-weight: 700; font-size: 14px;'>🔢 UTR Number:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.7); border-radius: 8px; text-align: right;'>" +
            "<code style='color: #78350f; font-weight: 700; background: rgba(251, 191, 36, 0.2); " +
            "padding: 6px 12px; border-radius: 6px;'>" + utrNumber + "</code></td></tr>" +
            "</table></div>" +
            
            "<div style='background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); " +
            "padding: 25px; margin: 30px 0; border-radius: 15px; border-left: 5px solid #3b82f6;'>" +
            "<h4 style='margin: 0 0 15px 0; color: #1e40af; font-size: 17px; font-weight: 800;'>" +
            "⏰ What Happens Next?</h4>" +
            "<ul style='margin: 0; padding-left: 25px; color: #1e3a8a;'>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'>Admin will verify your payment details</li>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'>Verification typically takes <strong>24-48 hours</strong></li>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'>You'll receive an email once verification is complete</li>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'>After approval, your event ticket will be sent</li>" +
            "</ul></div>" +
            
            "<p style='color: #6b7280; font-size: 14px; text-align: center; margin: 30px 0; font-style: italic;'>" +
            "💡 Please check your email regularly for updates</p>";
        
        sendEmail(to, "📝 Payment Proof Received - " + eventName, wrapEmail(content));
    }
    
    /**
     * EMAIL 11: ✅ Payment Verified by Admin
     */
    public static void sendPaymentVerifiedEmail(String to, String userName, String eventName,
                                               String utrNumber, String amount, String remarks) {
        String content =
            "<div style='text-align: center; margin-bottom: 35px;'>" +
            "<div style='background: linear-gradient(135deg, " + SUCCESS_COLOR + " 0%, #059669 100%); " +
            "border-radius: 50%; width: 130px; height: 130px; margin: 0 auto 25px; " +
            "box-shadow: 0 15px 40px rgba(16, 185, 129, 0.4); animation: pulse 2s ease-in-out infinite;'>" +
            "<span style='font-size: 75px; line-height: 130px;'>✅</span>" +
            "</div>" +
            "<h2 style='color: #065f46; font-size: 36px; font-weight: 900;'>Payment Verified!</h2>" +
            "<p style='color: #6b7280; font-size: 15px; margin: 10px 0 0 0;'>Great news! Your payment has been confirmed 🎉</p>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 18px; text-align: center; line-height: 1.8; margin: 25px 0;'>" +
            "Dear <strong style='color: " + SUCCESS_COLOR + ";'>" + userName + "</strong>,</p>" +
            
            getAlertBadge("success", "🎊", "<strong>Excellent News!</strong> Your payment has been successfully verified by our admin team.") +
            
            "<div style='background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); " +
            "padding: 35px; margin: 30px 0; border-radius: 20px; border: 3px solid " + SUCCESS_COLOR + "; " +
            "box-shadow: 0 10px 30px rgba(16, 185, 129, 0.3);'>" +
            "<h3 style='margin: 0 0 25px 0; color: #065f46; text-align: center; font-size: 20px; font-weight: 800;'>" +
            "✅ Verified Payment Details</h3>" +
            
            "<table style='width: 100%; border-collapse: separate; border-spacing: 0 10px;'>" +
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px;'>" +
            "<span style='color: #065f46; font-weight: 700; font-size: 14px;'>🎯 Event:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px; text-align: right;'>" +
            "<span style='color: #047857; font-weight: 600;'>" + eventName + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px;'>" +
            "<span style='color: #065f46; font-weight: 700; font-size: 14px;'>💰 Amount Paid:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px; text-align: right;'>" +
            "<span style='color: #047857; font-weight: 700; font-size: 20px;'>₹" + amount + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px;'>" +
            "<span style='color: #065f46; font-weight: 700; font-size: 14px;'>🔢 UTR Number:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px; text-align: right;'>" +
            "<code style='color: #047857; font-weight: 700; background: rgba(16, 185, 129, 0.15); " +
            "padding: 6px 12px; border-radius: 6px;'>" + utrNumber + "</code></td></tr>" +
            "</table></div>" +
            
            (remarks != null && !remarks.trim().isEmpty() ? 
            "<div style='background: rgba(219, 234, 254, 0.5); padding: 20px; margin: 25px 0; border-radius: 12px; " +
            "border-left: 4px solid #3b82f6;'>" +
            "<p style='margin: 0 0 8px 0; color: #1e40af; font-size: 13px; font-weight: 700; text-transform: uppercase;'>" +
            "📝 Admin Remarks:</p>" +
            "<p style='margin: 0; color: #1e3a8a; font-size: 15px; line-height: 1.6;'>" + remarks + "</p></div>" : "") +
            
            "<div style='background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); " +
            "padding: 25px; margin: 30px 0; border-radius: 15px; border-left: 5px solid " + WARNING_COLOR + ";'>" +
            "<h4 style='margin: 0 0 15px 0; color: #92400e; font-size: 17px; font-weight: 800;'>" +
            "🎯 What's Next?</h4>" +
            "<ul style='margin: 0; padding-left: 25px; color: #78350f;'>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'><strong>Registration Pending Final Approval</strong> - Your registration is now queued for approval</li>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'><strong>Event Ticket</strong> - You'll receive your QR code and PDF ticket once approved</li>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'><strong>Email Confirmation</strong> - Check your inbox for the approval notification</li>" +
            "</ul></div>" +
            
            "<div style='text-align: center; margin: 35px 0;'>" +
            "<p style='color: #059669; font-size: 24px; font-weight: 800; margin: 0;'>You're Almost There! 🚀</p>" +
            "<p style='color: #6b7280; font-size: 14px; margin: 10px 0 0 0;'>Stay tuned for your event ticket</p>" +
            "</div>";
        
        sendEmail(to, "✅ Payment Verified - " + eventName, wrapEmail(content));
    }
    
    /**
     * EMAIL 12: ❌ Payment Rejected by Admin
     */
    public static void sendPaymentRejectedEmail(String to, String userName, String eventName,
                                               String utrNumber, String amount, String reason) {
        String content =
            "<div style='text-align: center; margin-bottom: 35px;'>" +
            "<div style='background: linear-gradient(135deg, " + DANGER_COLOR + " 0%, #dc2626 100%); " +
            "border-radius: 50%; width: 120px; height: 120px; margin: 0 auto 25px; " +
            "box-shadow: 0 15px 40px rgba(239, 68, 68, 0.4);'>" +
            "<span style='font-size: 70px; line-height: 120px;'>❌</span>" +
            "</div>" +
            "<h2 style='color: #991b1b; font-size: 32px; font-weight: 800;'>Payment Verification Failed</h2>" +
            "</div>" +
            
            "<p style='color: #374151; font-size: 17px; text-align: center; line-height: 1.8;'>" +
            "Dear <strong style='color: " + DANGER_COLOR + ";'>" + userName + "</strong>,</p>" +
            
            "<p style='color: #6b7280; font-size: 16px; text-align: center; line-height: 1.7;'>" +
            "Unfortunately, we were unable to verify your payment proof.</p>" +
            
            getAlertBadge("error", "⚠️", "Your payment proof for <strong>" + eventName + "</strong> could not be verified.") +
            
            "<div style='background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%); " +
            "padding: 35px; margin: 30px 0; border-radius: 20px; border: 3px solid " + DANGER_COLOR + "; " +
            "box-shadow: 0 10px 30px rgba(239, 68, 68, 0.2);'>" +
            "<h3 style='margin: 0 0 25px 0; color: #991b1b; text-align: center; font-size: 20px; font-weight: 800;'>" +
            "❌ Submission Details</h3>" +
            
            "<table style='width: 100%; border-collapse: separate; border-spacing: 0 10px;'>" +
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px;'>" +
            "<span style='color: #991b1b; font-weight: 700; font-size: 14px;'>🎯 Event:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px; text-align: right;'>" +
            "<span style='color: #7f1d1d; font-weight: 600;'>" + eventName + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px;'>" +
            "<span style='color: #991b1b; font-weight: 700; font-size: 14px;'>💰 Amount:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px; text-align: right;'>" +
            "<span style='color: #7f1d1d; font-weight: 700; font-size: 18px;'>₹" + amount + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px;'>" +
            "<span style='color: #991b1b; font-weight: 700; font-size: 14px;'>🔢 UTR Number:</span></td>" +
            "<td style='padding: 12px; background: rgba(255,255,255,0.8); border-radius: 8px; text-align: right;'>" +
            "<code style='color: #7f1d1d; font-weight: 700; background: rgba(239, 68, 68, 0.15); " +
            "padding: 6px 12px; border-radius: 6px;'>" + utrNumber + "</code></td></tr>" +
            "</table></div>" +
            
            (reason != null && !reason.trim().isEmpty() ? 
            "<div style='background: rgba(254, 242, 242, 0.8); padding: 25px; margin: 25px 0; border-radius: 15px; " +
            "border: 2px solid " + DANGER_COLOR + ";'>" +
            "<h4 style='margin: 0 0 12px 0; color: #991b1b; font-size: 16px; font-weight: 800;'>" +
            "🔍 Rejection Reason:</h4>" +
            "<p style='margin: 0; color: #7f1d1d; font-size: 15px; line-height: 1.7; font-weight: 600;'>" + reason + "</p></div>" : "") +
            
            "<div style='background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); " +
            "padding: 25px; margin: 30px 0; border-radius: 15px; border-left: 5px solid " + WARNING_COLOR + ";'>" +
            "<h4 style='margin: 0 0 15px 0; color: #92400e; font-size: 17px; font-weight: 800;'>" +
            "🔧 How to Fix This:</h4>" +
            "<ul style='margin: 0; padding-left: 25px; color: #78350f;'>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'><strong>Verify UTR Number</strong> - Double-check from your payment app or bank SMS</li>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'><strong>Clear Screenshot</strong> - Upload a clear screenshot showing payment success, amount, and transaction ID</li>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'><strong>Check Amount</strong> - Ensure the paid amount matches the event fee</li>" +
            "<li style='margin: 10px 0; font-size: 14px; line-height: 1.6;'><strong>File Format</strong> - Use JPG, PNG, or PDF format (max 10MB)</li>" +
            "</ul></div>" +
            
            getButton("Resubmit Payment Proof", "http://localhost:8080/EventRegistrationSystem/participant/my-registrations.jsp", "danger") +
            
            "<div style='background: rgba(219, 234, 254, 0.5); padding: 20px; margin: 30px 0; border-radius: 12px; text-align: center;'>" +
            "<p style='margin: 0; color: #1e3a8a; font-size: 14px; line-height: 1.6;'>" +
            "💡 <strong>Need Help?</strong> If you believe this is an error, please contact our support team at " +
            "<a href='mailto:support@universityevents.edu' style='color: #2563eb; text-decoration: none; font-weight: 700;'>" +
            "support@universityevents.edu</a></p></div>";
        
        sendEmail(to, "❌ Payment Verification Failed - " + eventName, wrapEmail(content));
    }
    
    /**
     * EMAIL 13: 🔔 Admin Notification - New Payment Proof Submitted
     */
    public static void sendAdminPaymentProofNotification(String eventName, String userName,
                                                         String userEmail, String utrNumber, String amount) {
        String adminEmail = "admin@university.edu"; // Configure your admin email
        
        String content =
            "<div style='text-align: center; margin-bottom: 35px;'>" +
            "<div style='background: linear-gradient(135deg, " + PRIMARY_COLOR + " 0%, " + SECONDARY_COLOR + " 100%); " +
            "border-radius: 50%; width: 120px; height: 120px; margin: 0 auto 25px; " +
            "box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);'>" +
            "<span style='font-size: 70px; line-height: 120px;'>🔔</span>" +
            "</div>" +
            "<h2 style='color: " + PRIMARY_COLOR + "; font-size: 32px; font-weight: 800;'>New Payment Proof Submitted</h2>" +
            "<p style='color: #6b7280; font-size: 15px; margin: 10px 0 0 0;'>Action Required: Payment Verification</p>" +
            "</div>" +
            
            getAlertBadge("info", "⏰", "A user has submitted payment proof that requires your verification.") +
            
            "<div style='background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); " +
            "padding: 35px; margin: 30px 0; border-radius: 20px; border: 3px solid " + PRIMARY_COLOR + "; " +
            "box-shadow: 0 10px 30px rgba(102, 126, 234, 0.2);'>" +
            "<h3 style='margin: 0 0 25px 0; color: " + DARK_COLOR + "; text-align: center; font-size: 20px; font-weight: 800;'>" +
            "👤 User Submission Details</h3>" +
            
            "<table style='width: 100%; border-collapse: separate; border-spacing: 0 10px;'>" +
            "<tr><td style='padding: 12px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: #64748b; font-weight: 700; font-size: 14px;'>👤 User:</span></td>" +
            "<td style='padding: 12px; background: white; border-radius: 8px; text-align: right; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: " + DARK_COLOR + "; font-weight: 600;'>" + userName + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: #64748b; font-weight: 700; font-size: 14px;'>📧 Email:</span></td>" +
            "<td style='padding: 12px; background: white; border-radius: 8px; text-align: right; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: " + DARK_COLOR + "; font-weight: 600;'>" + userEmail + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: #64748b; font-weight: 700; font-size: 14px;'>🎯 Event:</span></td>" +
            "<td style='padding: 12px; background: white; border-radius: 8px; text-align: right; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: " + DARK_COLOR + "; font-weight: 600;'>" + eventName + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: #64748b; font-weight: 700; font-size: 14px;'>💰 Amount:</span></td>" +
            "<td style='padding: 12px; background: white; border-radius: 8px; text-align: right; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: " + SUCCESS_COLOR + "; font-weight: 700; font-size: 20px;'>₹" + amount + "</span></td></tr>" +
            
            "<tr><td style='padding: 12px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<span style='color: #64748b; font-weight: 700; font-size: 14px;'>🔢 UTR Number:</span></td>" +
            "<td style='padding: 12px; background: white; border-radius: 8px; text-align: right; box-shadow: 0 2px 8px rgba(0,0,0,0.05);'>" +
            "<code style='color: " + PRIMARY_COLOR + "; font-weight: 700; background: rgba(102, 126, 234, 0.1); " +
            "padding: 8px 14px; border-radius: 8px; font-size: 15px;'>" + utrNumber + "</code></td></tr>" +
            "</table></div>" +
            
            "<div style='background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); " +
            "padding: 25px; margin: 30px 0; border-radius: 15px; border-left: 5px solid " + WARNING_COLOR + "; text-align: center;'>" +
            "<p style='margin: 0; color: #92400e; font-size: 16px; font-weight: 700;'>" +
            "⚡ <strong>Quick Action Required:</strong> Please review and verify this payment proof</p>" +
            "</div>" +
            
            getButton("Review Payment Proof", "http://localhost:8080/EventRegistrationSystem/admin/approvals.jsp", "primary") +
            
            "<p style='color: #6b7280; font-size: 13px; text-align: center; margin: 30px 0; font-style: italic;'>" +
            "🔐 This is an automated notification for admin review purposes only</p>";
        
        sendEmail(adminEmail, "🔔 Action Required: New Payment Proof - " + eventName, wrapEmail(content));
   }


}
