package com.event.servlet;

import com.event.dao.EventDAO;
import com.event.dao.PaymentDAO;
import com.event.dao.RegistrationDAO;
import com.event.model.Event;
import com.event.model.Payment;
import com.event.model.Registration;
import com.event.util.EmailSender;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

@WebServlet("/registerEvent")
public class RegistrationServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    private EventDAO eventDAO = new EventDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();  // ADDED THIS

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String userEmail = (String) session.getAttribute("email");
        String userName = (String) session.getAttribute("username");
        
        String eventIdParam = request.getParameter("eventId");
        if (eventIdParam == null || eventIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                                  "/participant/dashboard.jsp?error=invalid");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdParam);
            
            // Get event details
            Event event = eventDAO.getEventById(eventId);
            
            if (event == null) {
                request.setAttribute("errorMessage", "Event not found");
                request.getRequestDispatcher("/participant/register-event.jsp")
                       .forward(request, response);
                return;
            }
            
            // Check if already registered
            if (registrationDAO.isUserRegistered(userId, eventId)) {
                response.sendRedirect(request.getContextPath() + 
                                      "/participant/my-registrations.jsp?error=already_registered");
                return;
            }

            // Create registration
            Registration registration = new Registration();
            registration.setUserId(userId);
            registration.setEventId(eventId);
            registration.setStatus("pending");
            
            // Set payment status based on event fee
            boolean hasFee = event.getFee() != null && 
                           event.getFee().compareTo(BigDecimal.ZERO) > 0;
            registration.setPaymentStatus(hasFee ? "pending" : "completed");

            // Save registration to database
            int registrationId = registrationDAO.createRegistration(registration);

            if (registrationId > 0) {
                
                // ✅ CREATE PAYMENT RECORD FOR PAID EVENTS
                if (hasFee) {
                    try {
                        Payment payment = new Payment();
                        payment.setRegistrationId(registrationId);
                        payment.setAmount(event.getFee());
                        payment.setPaymentMethod("UPI");
                        payment.setStatus("pending");
                        payment.setTransactionDate(new Timestamp(System.currentTimeMillis()));

                        
                        int paymentId = paymentDAO.createPayment(payment);
                        
                        if (paymentId > 0) {
                            System.out.println("✓ Payment record created with ID: " + paymentId);
                        } else {
                            System.err.println("⚠ Warning: Could not create payment record");
                        }
                    } catch (Exception paymentError) {
                        System.err.println("⚠ Warning: Payment record creation failed: " + 
                                          paymentError.getMessage());
                        // Continue anyway - registration is saved
                    }
                }
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
                String eventDate = event.getEventDate() != null ? 
                                  sdf.format(event.getEventDate()) : "TBD";
                
                // ✅ SEND EMAIL BASED ON PAYMENT REQUIREMENT
                try {
                    if (hasFee) {
                        // 🔴 PAID EVENT - Send "Payment Pending" email
                        EmailSender.sendPaymentPendingEmail(
                            userEmail,
                            userName,
                            event.getName(),
                            eventDate,
                            event.getFee().toString()
                        );
                        System.out.println("✓ Payment pending email sent to: " + userEmail);
                        
                    } else {
                        // 🟢 FREE EVENT - Send "Registration Received" email
                        EmailSender.sendRegistrationConfirmation(
                            userEmail,
                            userName,
                            event.getName(),
                            eventDate
                        );
                        System.out.println("✓ Registration confirmation email sent to: " + userEmail);
                    }
                    
                } catch (Exception emailError) {
                    System.err.println("⚠ Warning: Could not send email: " + 
                                      emailError.getMessage());
                    // Continue anyway - registration is saved
                }

                // Redirect based on payment requirement
                if (hasFee) {
                    // Event has fee - redirect to payment page
                    System.out.println("✓ Registration created (ID: " + registrationId + 
                                      ") - Redirecting to payment");
                    response.sendRedirect(request.getContextPath() + 
                                          "/payment.jsp?regId=" + registrationId);
                } else {
                    // Free event - redirect to dashboard with success message
                    System.out.println("✓ Free event registration successful (ID: " + registrationId + ")");
                    response.sendRedirect(request.getContextPath() + 
                                          "/participant/my-registrations.jsp?success=registered");
                }
            } else {
                // Registration failed
                System.err.println("✗ Failed to create registration for user: " + userId + 
                                  ", event: " + eventId);
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/participant/register-event.jsp?eventId=" + eventId)
                       .forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            System.err.println("✗ Invalid event ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + 
                                  "/participant/dashboard.jsp?error=invalid");
            
        } catch (Exception e) {
            System.err.println("✗ Registration error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Registration failed. Please try again later.");
            request.getRequestDispatcher("/participant/dashboard.jsp")
                   .forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/participant/dashboard.jsp");
    }
}
