package com.event.servlet;

import com.event.dao.UserDAO;
import com.event.model.User;
import com.event.util.EmailSender;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/approveUser")
public class ApproveUserServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        String action = request.getParameter("action");
        
        if (userIdParam == null || action == null) {
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=invalid");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/approvals.jsp?error=not_found");
                return;
            }

            if ("approve".equals(action)) {
                // Approve user
                userDAO.approveUser(userId);
                
                // ✅ SEND EMAIL: Account approved
                try {
                    EmailSender.sendUserApprovedEmail(
                        user.getEmail(),
                        user.getUsername(),
                        user.getRole()
                    );
                    System.out.println("✓ User approved email sent to: " + user.getEmail());
                } catch (Exception emailError) {
                    System.err.println("⚠ Could not send approval email: " + 
                                      emailError.getMessage());
                }

                System.out.println("✓ User approved: " + user.getUsername());
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/approvals.jsp?success=user_approved");
                
            } else if ("reject".equals(action)) {
                // Reject user
                userDAO.rejectUser(userId);
                
                // ✅ SEND EMAIL: Account rejected
                try {
                    EmailSender.sendUserRejectedEmail(
                        user.getEmail(),
                        user.getUsername()
                    );
                    System.out.println("✓ User rejection email sent to: " + user.getEmail());
                } catch (Exception emailError) {
                    System.err.println("⚠ Could not send rejection email");
                }

                System.out.println("✓ User rejected: " + user.getUsername());
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/approvals.jsp?success=user_rejected");
            }

        } catch (Exception e) {
            System.err.println("✗ Error approving/rejecting user: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/approvals.jsp?error=failed");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/approvals.jsp");
    }
}
