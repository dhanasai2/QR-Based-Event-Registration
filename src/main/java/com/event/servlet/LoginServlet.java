package com.event.servlet;

import com.event.dao.UserDAO;
import com.event.model.User;
import com.event.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ✅ Accept both username and email
        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Username/Email: " + usernameOrEmail);
        System.out.println("Password provided: " + (password != null ? "YES" : "NO"));

        try {
            User user = null;
            
            // ✅ Try to find user by username first
            user = userDAO.getUserByUsername(usernameOrEmail);
            
            // ✅ If not found, try to find by email
            if (user == null) {
                user = userDAO.getUserByEmail(usernameOrEmail);
                System.out.println("Tried email lookup: " + (user != null ? "Found" : "Not found"));
            } else {
                System.out.println("Found by username");
            }
            
            if (user != null) {
                System.out.println("User ID: " + user.getId());
                System.out.println("User role: " + user.getRole());
                System.out.println("User status: " + user.getStatus());
                
                // ==== UPDATED: Safe password hash print ====
                String passwordHashFromDB = user.getPassword();
                if (passwordHashFromDB != null && passwordHashFromDB.length() > 20) {
                    passwordHashFromDB = passwordHashFromDB.substring(0, 20) + "...";
                }
                System.out.println("Password hash from DB: " + passwordHashFromDB);
                // ==== /UPDATED ====
                
                // ✅ CHECK 1: Verify password
                boolean passwordMatch = PasswordUtil.checkPassword(password, user.getPassword());
                System.out.println("Password match: " + passwordMatch);
                
                if (!passwordMatch) {
                    System.err.println("✗ LOGIN FAILED - Invalid password");
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                    return;
                }
                
                // ✅ CHECK 2: Verify user status (MUST BE APPROVED)
                if (!"approved".equals(user.getStatus())) {
                    System.err.println("✗ LOGIN DENIED - User status: " + user.getStatus());
                    
                    if ("pending".equals(user.getStatus())) {
                        response.sendRedirect(request.getContextPath() + 
                                              "/login.jsp?error=pending_approval");
                    } else if ("rejected".equals(user.getStatus())) {
                        response.sendRedirect(request.getContextPath() + 
                                              "/login.jsp?error=rejected");
                    } else {
                        response.sendRedirect(request.getContextPath() + 
                                              "/login.jsp?error=not_approved");
                    }
                    return;
                }
                
                // ✅ ALL CHECKS PASSED - Login successful
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("status", user.getStatus());
                
                System.out.println("✓ LOGIN SUCCESSFUL - Role: " + user.getRole() + 
                                  ", Status: " + user.getStatus());

                // Redirect based on role
                String redirectUrl = request.getContextPath();
                if ("admin".equals(user.getRole())) {
                    redirectUrl += "/admin/dashboard.jsp";
                } else if ("organizer".equals(user.getRole())) {
                    redirectUrl += "/organizer/dashboard.jsp";
                } else if ("participant".equals(user.getRole())) {
                    redirectUrl += "/participant/dashboard.jsp";
                } else {
                    redirectUrl += "/login.jsp?error=invalid_role";
                }
                
                System.out.println("Redirecting to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
                return;
            }
            
            // User not found
            System.err.println("✗ LOGIN FAILED - User not found with username/email: " + usernameOrEmail);
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
            
        } catch (Exception e) {
            System.err.println("✗ LOGIN ERROR: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=exception");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
