package com.event.servlet;

import com.event.dao.PaymentConfigDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/updatePaymentConfig")
public class UpdatePaymentConfigServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
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
        
        try {
            PaymentConfigDAO configDAO = new PaymentConfigDAO();
            
            // Get form parameters
            String upiId = request.getParameter("upi_id");
            String upiName = request.getParameter("upi_name");
            String accountNumber = request.getParameter("account_number");
            String ifscCode = request.getParameter("ifsc_code");
            String bankName = request.getParameter("bank_name");
            String accountHolder = request.getParameter("account_holder");
            
            // Update each configuration
            boolean success = true;
            success &= configDAO.updatePaymentConfig("upi_id", upiId);
            success &= configDAO.updatePaymentConfig("upi_name", upiName);
            success &= configDAO.updatePaymentConfig("account_number", accountNumber);
            success &= configDAO.updatePaymentConfig("ifsc_code", ifscCode);
            success &= configDAO.updatePaymentConfig("bank_name", bankName);
            success &= configDAO.updatePaymentConfig("account_holder", accountHolder);
            
            if (success) {
                System.out.println("✓ Payment configuration updated successfully");
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/payment-settings.jsp?success=true");
            } else {
                System.err.println("✗ Failed to update payment configuration");
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/payment-settings.jsp?error=true");
            }
            
        } catch (Exception e) {
            System.err.println("✗ Error updating payment config: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/payment-settings.jsp?error=true");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/payment-settings.jsp");
    }
}
