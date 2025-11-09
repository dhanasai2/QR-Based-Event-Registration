package com.event.servlet;

import com.event.dao.EventDAO;
import com.event.dao.PaymentDAO;
import com.event.dao.RegistrationDAO;
import com.event.dao.UserDAO;
import com.event.model.Event;
import com.event.model.Payment;
import com.event.model.Registration;
import com.event.model.User;
import com.event.util.EmailSender;
import com.event.util.FileUploadUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;

@WebServlet("/paymentCallback")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class PaymentCallbackServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads/payment-proofs";
    
    private PaymentDAO paymentDAO = new PaymentDAO();
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    private UserDAO userDAO = new UserDAO();
    private EventDAO eventDAO = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters for manual payment proof submission
        String regIdParam = request.getParameter("regId");
        String utrNumber = request.getParameter("utrNumber");
        String upiId = request.getParameter("upiId");
        String payerName = request.getParameter("payerName");
        String amountParam = request.getParameter("amount");
        
        System.out.println("=== PAYMENT PROOF SUBMISSION ===");
        System.out.println("Registration ID: " + regIdParam);
        System.out.println("UTR Number: " + utrNumber);
        System.out.println("UPI ID: " + upiId);
        System.out.println("Payer Name: " + payerName);
        System.out.println("Amount: " + amountParam);
        
        // Validate required parameters
        if (regIdParam == null || utrNumber == null || utrNumber.trim().isEmpty()) {
            System.err.println("✗ Payment proof submission - Missing required parameters");
            response.sendRedirect(request.getContextPath() + 
                                  "/payment-failure.jsp?error=missing_params&message=Please provide UTR number");
            return;
        }

        try {
            int registrationId = Integer.parseInt(regIdParam);
            BigDecimal amount = new BigDecimal(amountParam);
            
            // Check if UTR already exists
            if (paymentDAO.isUtrNumberExists(utrNumber)) {
                System.err.println("✗ Duplicate UTR number: " + utrNumber);
                response.sendRedirect(request.getContextPath() + 
                                      "/payment-failure.jsp?error=duplicate_utr&message=This UTR number has already been used");
                return;
            }
            
            // Get registration details
            Registration registration = registrationDAO.getRegistrationById(registrationId);
            if (registration == null) {
                System.err.println("✗ Registration not found: " + registrationId);
                response.sendRedirect(request.getContextPath() + 
                                      "/payment-failure.jsp?error=registration_not_found");
                return;
            }
            
            // Get user details
            User user = userDAO.getUserById(registration.getUserId());
            if (user == null) {
                System.err.println("✗ User not found for registration: " + registrationId);
                response.sendRedirect(request.getContextPath() + 
                                      "/payment-failure.jsp?error=user_not_found");
                return;
            }
            
            // Get event details
            Event event = eventDAO.getEventById(registration.getEventId());
            if (event == null) {
                System.err.println("✗ Event not found for registration: " + registrationId);
                response.sendRedirect(request.getContextPath() + 
                                      "/payment-failure.jsp?error=event_not_found");
                return;
            }
            
            // Handle payment proof file upload
            String paymentProofFileName = null;
            Part filePart = request.getPart("paymentProof"); // Retrieves <input type="file" name="paymentProof">
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Validate file type
                String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
                if (!fileExtension.matches("\\.(jpg|jpeg|png|pdf)")) {
                    System.err.println("✗ Invalid file type: " + fileExtension);
                    response.sendRedirect(request.getContextPath() + 
                                          "/payment-failure.jsp?error=invalid_file_type&message=Only JPG, PNG, or PDF files are allowed");
                    return;
                }
                
                // Generate unique filename
                String uniqueFileName = "payment_" + registrationId + "_" + 
                                       System.currentTimeMillis() + fileExtension;
                
                // Get upload directory path
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                
                // Create directory if it doesn't exist
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Save file
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);
                
                paymentProofFileName = uniqueFileName;
                System.out.println("✓ Payment proof uploaded: " + uniqueFileName);
            } else {
                System.err.println("✗ No payment proof file uploaded");
                response.sendRedirect(request.getContextPath() + 
                                      "/payment-failure.jsp?error=no_file&message=Please upload payment proof screenshot");
                return;
            }
            
            // ✅ SAVE PAYMENT PROOF
            System.out.println("✓ Processing payment proof for registration: " + registrationId);
            
            // Get existing payment record or create new one
            Payment payment = paymentDAO.getPaymentByRegistrationId(registrationId);
            
            if (payment != null) {
                // Update existing payment record with proof
                boolean saved = paymentDAO.savePaymentProofByRegistrationId(
                    registrationId, 
                    utrNumber, 
                    paymentProofFileName, 
                    upiId, 
                    payerName
                );
                
                if (saved) {
                    System.out.println("✓ Payment proof saved successfully");
                    
                    // Update registration status to payment_submitted
                    registrationDAO.updatePaymentStatus(registrationId, "payment_submitted");
                    
                    // Send payment proof received email to user
                    try {
                        EmailSender.sendPaymentProofReceivedEmail(
                            user.getEmail(),
                            user.getUsername(),
                            event.getName(),
                            utrNumber,
                            amount.toString()
                        );
                        System.out.println("✓ Payment proof received email sent to: " + user.getEmail());
                    } catch (Exception emailError) {
                        System.err.println("⚠ Warning: Could not send email: " + emailError.getMessage());
                    }
                    
                    // Send notification to admin (optional)
                    try {
                        EmailSender.sendAdminPaymentProofNotification(
                            event.getName(),
                            user.getUsername(),
                            user.getEmail(),
                            utrNumber,
                            amount.toString()
                        );
                        System.out.println("✓ Admin notification sent");
                    } catch (Exception emailError) {
                        System.err.println("⚠ Warning: Could not send admin notification: " + emailError.getMessage());
                    }
                    
                    // Redirect to success page
                    System.out.println("✓ Payment proof submitted successfully - Redirecting to success page");
                    response.sendRedirect(request.getContextPath() + 
                                          "/payment-success.jsp?regId=" + registrationId + 
                                          "&status=proof_submitted");
                } else {
                    System.err.println("✗ Failed to save payment proof");
                    response.sendRedirect(request.getContextPath() + 
                                          "/payment-failure.jsp?error=save_failed");
                }
                
            } else {
                System.err.println("✗ Payment record not found for registration: " + registrationId);
                response.sendRedirect(request.getContextPath() + 
                                      "/payment-failure.jsp?error=payment_not_found");
            }

        } catch (NumberFormatException e) {
            System.err.println("✗ Invalid number format: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/payment-failure.jsp?error=invalid_data");
            
        } catch (Exception e) {
            System.err.println("✗ Error processing payment proof: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/payment-failure.jsp?error=exception&message=" + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to dashboard
        response.sendRedirect(request.getContextPath() + "/participant/dashboard.jsp");
    }
}
