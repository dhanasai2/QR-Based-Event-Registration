package com.event.servlet;

import com.event.dao.EventDAO;
import com.event.dao.RegistrationDAO;
import com.event.dao.UserDAO;
import com.event.model.Event;
import com.event.model.Registration;
import com.event.model.User;
import com.event.util.EmailSender;
import com.event.util.QRCodeGenerator;
import com.event.util.PDFTicketGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/approval")
public class ApprovalServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    private UserDAO userDAO = new UserDAO();
    private EventDAO eventDAO = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String regIdParam = request.getParameter("regId");
        String action = request.getParameter("action");
        String reason = request.getParameter("reason");
        
        if (regIdParam == null || action == null) {
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=invalid");
            return;
        }

        try {
            int regId = Integer.parseInt(regIdParam);
            
            Registration registration = registrationDAO.getRegistrationById(regId);
            if (registration == null) {
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/approvals.jsp?error=not_found");
                return;
            }

            if ("approve".equals(action)) {
                handleApproval(request, response, registration);
            } else if ("reject".equals(action)) {
                handleRejection(request, response, registration, reason);
            } else {
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/approvals.jsp?error=invalid_action");
            }
            
        } catch (Exception e) {
            System.err.println("✗ Approval error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=exception");
        }
    }
    
    private void handleApproval(HttpServletRequest request, HttpServletResponse response,
                                Registration registration) throws Exception {
        
        int regId = registration.getId();
        System.out.println("=== APPROVAL PROCESS STARTED ===");
        System.out.println("Registration ID: " + regId);
        
        User user = userDAO.getUserById(registration.getUserId());
        Event event = eventDAO.getEventById(registration.getEventId());
        
        if (user == null || event == null) {
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=details_not_found");
            return;
        }
        
        System.out.println("User: " + user.getUsername() + " (" + user.getEmail() + ")");
        System.out.println("Event: " + event.getName());
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
        String eventDate = dateFormat.format(event.getEventDate());
        String eventTime = timeFormat.format(event.getEventDate());
        
        System.out.println("Step 1: Generating simple QR code...");
        
        String qrData = QRCodeGenerator.generateQRData(regId, event.getId(), user.getEmail());
        System.out.println("QR Data: " + qrData);
        
        String qrCodeBase64 = null;
        try {
            qrCodeBase64 = QRCodeGenerator.generateQRCodeBase64(qrData);
            if (qrCodeBase64 != null) {
                System.out.println("✓ QR code generated successfully, Base64 length: " + qrCodeBase64.length());
            } else {
                System.err.println("✗ QR code Base64 is null!");
            }
        } catch (Exception qrError) {
            System.err.println("✗ QR Code generation error: " + qrError.getMessage());
            qrError.printStackTrace();
            qrCodeBase64 = "";
        }
        
        System.out.println("Step 2: Generating PDF ticket...");
        
        String ticketFileName = "ticket_" + regId + "_" + System.currentTimeMillis() + ".pdf";
        String ticketPath = request.getServletContext().getRealPath("") + 
                          "uploads" + File.separator + "tickets" + File.separator + ticketFileName;
        
        File ticketsDir = new File(request.getServletContext().getRealPath("") + 
                                   "uploads" + File.separator + "tickets");
        if (!ticketsDir.exists()) {
            ticketsDir.mkdirs();
            System.out.println("✓ Created tickets directory: " + ticketsDir.getAbsolutePath());
        }
        
        String pdfBase64 = null;
        try {
            pdfBase64 = PDFTicketGenerator.generateTicketPDF(
                user.getUsername(),
                String.valueOf(user.getId()),
                String.valueOf(regId),
                event.getName(),
                eventDate,
                eventTime,
                event.getVenue(),
                user.getEmail(),
                user.getPhone() != null ? user.getPhone() : "N/A",
                qrCodeBase64,
                ticketPath
            );
            
            if (pdfBase64 != null) {
                System.out.println("✓ PDF ticket generated: " + ticketPath);
                System.out.println("✓ PDF Base64 length: " + pdfBase64.length());
            } else {
                System.err.println("✗ PDF Base64 is null!");
            }
            
        } catch (Exception pdfError) {
            System.err.println("✗ PDF generation error: " + pdfError.getMessage());
            pdfError.printStackTrace();
        }
        
        System.out.println("Step 3: Updating registration status...");
        
        boolean updated = registrationDAO.updateRegistrationStatus(regId, "approved");
        
        if (!updated) {
            System.err.println("✗ Failed to update registration status");
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=update_failed");
            return;
        }
        
        System.out.println("✓ Registration status updated to: approved");
        
        System.out.println("Step 4: Sending approval email...");
        
        try {
            if (qrCodeBase64 != null && !qrCodeBase64.isEmpty() && pdfBase64 != null && !pdfBase64.isEmpty()) {
                EmailSender.sendApprovalNotificationWithPDF(
                    user.getEmail(),
                    user.getUsername(),
                    event.getName(),
                    eventDate,
                    eventTime,
                    event.getVenue(),
                    qrCodeBase64,
                    pdfBase64,
                    ticketFileName
                );
                
                System.out.println("✓ Approval email with PDF sent to: " + user.getEmail());
            } else {
                System.err.println("⚠ QR or PDF is null/empty, sending simple approval email");
                EmailSender.sendApprovalNotification(
                    user.getEmail(),
                    user.getUsername(),
                    event.getName(),
                    qrCodeBase64 != null ? qrCodeBase64 : ""
                );
                System.out.println("✓ Simple approval email sent to: " + user.getEmail());
            }
            
        } catch (Exception emailError) {
            System.err.println("⚠ Could not send approval email: " + emailError.getMessage());
            emailError.printStackTrace();
        }
        
        System.out.println("=== APPROVAL PROCESS COMPLETED ===\n");
        
        response.sendRedirect(request.getContextPath() + 
                              "/admin/approvals.jsp?success=approved");
    }
    
    private void handleRejection(HttpServletRequest request, HttpServletResponse response,
                                 Registration registration, String reason) throws Exception {
        
        int regId = registration.getId();
        System.out.println("=== REJECTION PROCESS STARTED ===");
        System.out.println("Registration ID: " + regId);
        System.out.println("Reason: " + (reason != null ? reason : "No reason provided"));
        
        boolean updated = registrationDAO.updateRegistrationStatus(regId, "rejected");
        
        if (!updated) {
            System.err.println("✗ Failed to update registration status");
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=update_failed");
            return;
        }
        
        System.out.println("✓ Registration status updated to: rejected");
        
        User user = userDAO.getUserById(registration.getUserId());
        Event event = eventDAO.getEventById(registration.getEventId());
        
        if (user != null && event != null) {
            try {
                EmailSender.sendRejectionEmail(
                    user.getEmail(),
                    user.getUsername(),
                    event.getName(),
                    reason != null ? reason : "Registration could not be approved at this time."
                );
                
                System.out.println("✓ Rejection email sent to: " + user.getEmail());
                
            } catch (Exception emailError) {
                System.err.println("⚠ Could not send rejection email: " + emailError.getMessage());
            }
        }
        
        System.out.println("=== REJECTION PROCESS COMPLETED ===\n");
        
        response.sendRedirect(request.getContextPath() + 
                              "/admin/approvals.jsp?success=rejected");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp");
    }
}
// ✅ FILE SHOULD END HERE - NO MORE CLASSES BELOW THIS LINE
