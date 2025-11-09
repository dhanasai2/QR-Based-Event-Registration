package com.event.servlet;

import com.event.dao.*;
import com.event.model.*;
import com.event.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


/**
 * Servlet for approving/rejecting event registrations
 */
@WebServlet("/approveRegistration")
public class ApproveRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L; 
    
    private RegistrationDAO registrationDAO;
    private EventDAO eventDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        registrationDAO = new RegistrationDAO();
        eventDAO = new EventDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String regIdStr = request.getParameter("regId");
        
        if (regIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=invalid_request");
            return;
        }
        
        try {
            int regId = Integer.parseInt(regIdStr);
            
            if ("approve".equals(action)) {
                handleApproval(regId, request, response);
            } else if ("reject".equals(action)) {
                handleRejection(regId, request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=invalid_action");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=operation_failed");
        }
    }
    
    /**
     * Handle registration approval
     */
    private void handleApproval(int regId, HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        System.out.println("=== APPROVING REGISTRATION ===");
        System.out.println("Registration ID: " + regId);
        
        // Get registration details
        Registration registration = registrationDAO.getRegistrationById(regId);
        
        if (registration == null) {
            System.err.println("✗ Registration not found: " + regId);
            response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=not_found");
            return;
        }
        
        // Get event and user details
        Event event = eventDAO.getEventById(registration.getEventId());
        User user = userDAO.getUserById(registration.getUserId());
        
        if (event == null || user == null) {
            System.err.println("✗ Event or User not found");
            response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=not_found");
            return;
        }
        
        // Update registration status
        boolean updated = registrationDAO.updateRegistrationStatus(regId, "approved");
        
        if (!updated) {
            System.err.println("✗ Failed to update registration status");
            response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=update_failed");
            return;
        }
        
        System.out.println("✓ Registration status updated to APPROVED");
        
        // Generate QR Code
        String qrData = "REG-" + regId + "|" + user.getUsername() + "|" + event.getName();
        String qrCodeBase64 = QRCodeGenerator.generateQRCode(qrData);
        
        System.out.println("✓ QR Code generated");
        
        // Generate PDF Ticket
        String eventDateStr = new java.text.SimpleDateFormat("dd-MM-yyyy").format(event.getEventDate());
        String eventTimeStr = new java.text.SimpleDateFormat("hh:mm a").format(event.getEventDate());
        
        String ticketPDF = PDFTicketGenerator.generateTicketPDF(
            user.getUsername(),
            String.valueOf(user.getId()),
            String.valueOf(regId),
            event.getName(),
            eventDateStr,
            eventTimeStr,
            event.getVenue(),
            user.getEmail(),
            user.getPhone(),
            qrCodeBase64,
            null  // outputPath - we only need Base64
        );
        
        System.out.println("✓ PDF Ticket generated");
        
        // Save QR code to registration
        registrationDAO.updateQRCode(regId, qrCodeBase64);
        
        // Send email with ticket
        String subject = "Event Registration Approved - " + event.getName();
        String body = buildApprovalEmailBody(user.getUsername(), event.getName(), eventDateStr, eventTimeStr, event.getVenue());
        
        // ✅ FIXED: Changed EmailUtil to EmailSender
        boolean emailSent = EmailSender.sendEmailWithAttachment(
            user.getEmail(),
            subject,
            body,
            ticketPDF,
            "ticket_" + regId + "_" + System.currentTimeMillis() + ".pdf"
        );
        
        if (emailSent) {
            System.out.println("✓ Approval email sent to: " + user.getEmail());
        } else {
            System.err.println("✗ Failed to send email");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?success=event_approved");
    }
    
    /**
     * Handle registration rejection
     */
    private void handleRejection(int regId, HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        System.out.println("=== REJECTING REGISTRATION ===");
        System.out.println("Registration ID: " + regId);
        
        String reason = request.getParameter("reason");
        
        // Get registration details for email
        Registration registration = registrationDAO.getRegistrationById(regId);
        
        if (registration == null) {
            response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=not_found");
            return;
        }
        
        // Update status
        boolean updated = registrationDAO.updateRegistrationStatus(regId, "rejected");
        
        if (!updated) {
            response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?error=update_failed");
            return;
        }
        
        System.out.println("✓ Registration status updated to REJECTED");
        
        // Send rejection email
        Event event = eventDAO.getEventById(registration.getEventId());
        User user = userDAO.getUserById(registration.getUserId());
        
        if (event != null && user != null) {
            String subject = "Event Registration Rejected - " + event.getName();
            String body = buildRejectionEmailBody(user.getUsername(), event.getName(), reason);
            
            // ✅ FIXED: Changed EmailUtil to EmailSender
            EmailSender.sendEmail(user.getEmail(), subject, body);
            System.out.println("✓ Rejection email sent");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp?success=event_rejected");
    }
    
    /**
     * Build approval email body
     */
    private String buildApprovalEmailBody(String userName, String eventName, 
                                         String eventDate, String eventTime, String venue) {
        return "<!DOCTYPE html>" +
                "<html><body style='font-family: Arial, sans-serif; line-height: 1.6;'>" +
                "<div style='max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f4f4f4;'>" +
                "<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center; color: white;'>" +
                "<h1 style='margin: 0; font-size: 28px;'>🎉 Registration Approved!</h1>" +
                "</div>" +
                "<div style='background: white; padding: 30px; border-radius: 0 0 10px 10px;'>" +
                "<p style='font-size: 16px;'>Dear <strong>" + userName + "</strong>,</p>" +
                "<p>Great news! Your registration for <strong>" + eventName + "</strong> has been approved!</p>" +
                "<div style='background: #f8f9fa; padding: 20px; border-left: 4px solid #667eea; margin: 20px 0;'>" +
                "<h3 style='margin-top: 0; color: #667eea;'>📅 Event Details</h3>" +
                "<p><strong>Event:</strong> " + eventName + "</p>" +
                "<p><strong>Date:</strong> " + eventDate + "</p>" +
                "<p><strong>Time:</strong> " + eventTime + "</p>" +
                "<p><strong>Venue:</strong> " + venue + "</p>" +
                "</div>" +
                "<p><strong>Your event ticket is attached to this email.</strong> Please download and keep it safe.</p>" +
                "<p>✅ Present the QR code at the event entrance for verification.</p>" +
                "<p>✅ Arrive 15 minutes early to ensure smooth entry.</p>" +
                "<p>We look forward to seeing you at the event!</p>" +
                "<p style='margin-top: 30px;'>Best regards,<br><strong>University Events Team</strong></p>" +
                "</div>" +
                "<div style='text-align: center; padding: 20px; color: #666; font-size: 12px;'>" +
                "<p>© " + java.time.Year.now() + " University Events. All rights reserved.</p>" +
                "</div>" +
                "</div>" +
                "</body></html>";
    }
    
    /**
     * Build rejection email body
     */
    private String buildRejectionEmailBody(String userName, String eventName, String reason) {
        String reasonText = (reason != null && !reason.trim().isEmpty()) 
            ? "<p><strong>Reason:</strong> " + reason + "</p>" 
            : "";
            
        return "<!DOCTYPE html>" +
                "<html><body style='font-family: Arial, sans-serif; line-height: 1.6;'>" +
                "<div style='max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f4f4f4;'>" +
                "<div style='background: #dc3545; padding: 30px; text-align: center; color: white;'>" +
                "<h1 style='margin: 0; font-size: 28px;'>Registration Status Update</h1>" +
                "</div>" +
                "<div style='background: white; padding: 30px; border-radius: 0 0 10px 10px;'>" +
                "<p style='font-size: 16px;'>Dear <strong>" + userName + "</strong>,</p>" +
                "<p>We regret to inform you that your registration for <strong>" + eventName + "</strong> could not be approved at this time.</p>" +
                reasonText +
                "<p>You may register again for future events or contact us for more information.</p>" +
                "<p style='margin-top: 30px;'>Best regards,<br><strong>University Events Team</strong></p>" +
                "</div>" +
                "</div>" +
                "</body></html>";
    }
}
