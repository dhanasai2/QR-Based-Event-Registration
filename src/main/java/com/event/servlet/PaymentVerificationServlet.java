package com.event.servlet;

import com.event.dao.PaymentDAO;
import com.event.dao.RegistrationDAO;
import com.event.dao.UserDAO;
import com.event.dao.EventDAO;
import com.event.model.Payment;
import com.event.model.Registration;
import com.event.model.User;
import com.event.model.Event;
import com.event.util.EmailSender;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/verifyPayment")  // Keep the same URL mapping
public class PaymentVerificationServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    private PaymentDAO paymentDAO = new PaymentDAO();
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    private UserDAO userDAO = new UserDAO();
    private EventDAO eventDAO = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || 
            !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String paymentIdParam = request.getParameter("paymentId");
        String action = request.getParameter("action");
        String remarks = request.getParameter("remarks");
        
        if (paymentIdParam == null || action == null) {
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=invalid");
            return;
        }

        try {
            int paymentId = Integer.parseInt(paymentIdParam);
            int adminUserId = (Integer) session.getAttribute("userId");
            
            Payment payment = paymentDAO.getPaymentById(paymentId);
            if (payment == null) {
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/approvals.jsp?error=not_found");
                return;
            }

            if ("verify".equals(action)) {
                handlePaymentVerification(request, response, payment, adminUserId, remarks);
            } else if ("reject".equals(action)) {
                handlePaymentRejection(request, response, payment, adminUserId, remarks);
            } else {
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/approvals.jsp?error=invalid_action");
            }
            
        } catch (Exception e) {
            System.err.println("✗ Payment verification error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=exception");
        }
    }
    
    /**
     * Handle payment verification (approval)
     */
    private void handlePaymentVerification(HttpServletRequest request, HttpServletResponse response,
                                          Payment payment, int adminUserId, String remarks) throws Exception {
        
        System.out.println("=== PAYMENT VERIFICATION STARTED ===");
        System.out.println("Payment ID: " + payment.getId());
        System.out.println("Registration ID: " + payment.getRegistrationId());
        System.out.println("UTR Number: " + payment.getUtrNumber());
        System.out.println("Amount: " + payment.getAmount());
        System.out.println("Verified By Admin ID: " + adminUserId);
        System.out.println("Remarks: " + (remarks != null ? remarks : "None"));
        
        // Verify payment in database
        boolean verified = paymentDAO.verifyPayment(payment.getId(), adminUserId, remarks);
        
        if (!verified) {
            System.err.println("✗ Failed to verify payment");
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=verification_failed");
            return;
        }
        
        System.out.println("✓ Payment verified in database");
        
        // Update registration payment status
        boolean regUpdated = registrationDAO.updatePaymentStatus(
            payment.getRegistrationId(), 
            "completed"
        );
        
        if (!regUpdated) {
            System.err.println("⚠ Warning: Could not update registration payment status");
        } else {
            System.out.println("✓ Registration payment status updated to: completed");
        }
        
        // Get user and event details for email
        Registration registration = registrationDAO.getRegistrationById(payment.getRegistrationId());
        
        if (registration != null) {
            User user = userDAO.getUserById(registration.getUserId());
            Event event = eventDAO.getEventById(registration.getEventId());
            
            if (user != null && event != null) {
                try {
                    // Send payment verified email
                    EmailSender.sendPaymentVerifiedEmail(
                        user.getEmail(),
                        user.getUsername(),
                        event.getName(),
                        payment.getUtrNumber(),
                        payment.getAmount().toString(),
                        remarks
                    );
                    
                    System.out.println("✓ Payment verification email sent to: " + user.getEmail());
                    
                } catch (Exception emailError) {
                    System.err.println("⚠ Could not send verification email: " + emailError.getMessage());
                    emailError.printStackTrace();
                }
            }
        }
        
        System.out.println("=== PAYMENT VERIFICATION COMPLETED ===\n");
        
        // Redirect to success page
        response.sendRedirect(request.getContextPath() + 
                              "/admin/approvals.jsp?success=payment_verified");
    }
    
    /**
     * Handle payment rejection
     */
    private void handlePaymentRejection(HttpServletRequest request, HttpServletResponse response,
                                       Payment payment, int adminUserId, String remarks) throws Exception {
        
        System.out.println("=== PAYMENT REJECTION STARTED ===");
        System.out.println("Payment ID: " + payment.getId());
        System.out.println("Registration ID: " + payment.getRegistrationId());
        System.out.println("UTR Number: " + payment.getUtrNumber());
        System.out.println("Rejected By Admin ID: " + adminUserId);
        System.out.println("Rejection Reason: " + (remarks != null ? remarks : "None"));
        
        // Validate rejection reason
        if (remarks == null || remarks.trim().isEmpty()) {
            System.err.println("✗ Rejection reason is required");
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=reason_required");
            return;
        }
        
        // Reject payment in database
        boolean rejected = paymentDAO.rejectPayment(payment.getId(), adminUserId, remarks);
        
        if (!rejected) {
            System.err.println("✗ Failed to reject payment");
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=rejection_failed");
            return;
        }
        
        System.out.println("✓ Payment rejected in database");
        
        // Update registration payment status to failed
        boolean regUpdated = registrationDAO.updatePaymentStatus(
            payment.getRegistrationId(), 
            "failed"
        );
        
        if (!regUpdated) {
            System.err.println("⚠ Warning: Could not update registration payment status");
        } else {
            System.out.println("✓ Registration payment status updated to: failed");
        }
        
        // Get user and event details for email
        Registration registration = registrationDAO.getRegistrationById(payment.getRegistrationId());
        
        if (registration != null) {
            User user = userDAO.getUserById(registration.getUserId());
            Event event = eventDAO.getEventById(registration.getEventId());
            
            if (user != null && event != null) {
                try {
                    // Send payment rejected email
                    EmailSender.sendPaymentRejectedEmail(
                        user.getEmail(),
                        user.getUsername(),
                        event.getName(),
                        payment.getUtrNumber(),
                        payment.getAmount().toString(),
                        remarks
                    );
                    
                    System.out.println("✓ Payment rejection email sent to: " + user.getEmail());
                    
                } catch (Exception emailError) {
                    System.err.println("⚠ Could not send rejection email: " + emailError.getMessage());
                    emailError.printStackTrace();
                }
            }
        }
        
        System.out.println("=== PAYMENT REJECTION COMPLETED ===\n");
        
        // Redirect to success page
        response.sendRedirect(request.getContextPath() + 
                              "/admin/approvals.jsp?success=payment_rejected");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp");
    }
}
