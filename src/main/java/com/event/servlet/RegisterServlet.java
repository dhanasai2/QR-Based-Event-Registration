package com.event.servlet;

import com.event.dao.UserDAO;
import com.event.model.User;
import com.event.util.EmailSender;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/register")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 2,         // 2 MB
    maxRequestSize = 1024 * 1024 * 4       // 4 MB
)
public class RegisterServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get form parameters (use getParameter for text fields with multipart)
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String role = request.getParameter("role");
            
            System.out.println("=== REGISTRATION ATTEMPT ===");
            System.out.println("Username: " + username);
            System.out.println("Email: " + email);
            System.out.println("Role: " + role);
            
            // Validate input
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                role == null || role.trim().isEmpty()) {
                
                System.out.println("✗ Validation failed: Missing required fields");
                response.sendRedirect(request.getContextPath() + 
                                      "/register.jsp?error=invalid_input");
                return;
            }
            
            // Validate passwords match
            if (!password.equals(confirmPassword)) {
                System.out.println("✗ Passwords don't match");
                response.sendRedirect(request.getContextPath() + 
                                      "/register.jsp?error=password_mismatch");
                return;
            }
            
            // Check if username exists
            if (userDAO.getUserByUsername(username) != null) {
                System.out.println("✗ Username already exists: " + username);
                response.sendRedirect(request.getContextPath() + 
                                      "/register.jsp?error=username_exists");
                return;
            }
            
            // Check if email exists
            if (userDAO.getUserByEmail(email) != null) {
                System.out.println("✗ Email already registered: " + email);
                response.sendRedirect(request.getContextPath() + 
                                      "/register.jsp?error=email_exists");
                return;
            }
            
            // Handle profile photo upload
            String photoPath = null;
            Part photoPart = request.getPart("profilePhoto");
            
            if (photoPart != null && photoPart.getSize() > 0) {
                System.out.println("Profile photo uploaded, size: " + photoPart.getSize() + " bytes");
                
                // Validate file size (2MB max)
                if (photoPart.getSize() > 2 * 1024 * 1024) {
                    System.out.println("✗ Photo too large");
                    response.sendRedirect(request.getContextPath() + 
                                          "/register.jsp?error=photo_size");
                    return;
                }
                
                // Validate file type
                String contentType = photoPart.getContentType();
                if (!contentType.equals("image/jpeg") && 
                    !contentType.equals("image/jpg") && 
                    !contentType.equals("image/png") && 
                    !contentType.equals("image/gif")) {
                    
                    System.out.println("✗ Invalid photo type: " + contentType);
                    response.sendRedirect(request.getContextPath() + 
                                          "/register.jsp?error=photo_type");
                    return;
                }
                
                // Save photo
                photoPath = saveProfilePhoto(request, photoPart, username);
                System.out.println("✓ Photo saved: " + photoPath);
            } else {
                System.out.println("No profile photo uploaded");
            }
            
            // Hash password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            
            // Create user object
            User user = new User(username, hashedPassword, email, phone, role, "pending");
            if (photoPath != null) {
                user.setProfilePhoto(photoPath);
            }
            
            // Save to database
            int userId = userDAO.createUser(user);
            
            if (userId > 0) {
                System.out.println("✓ User registered successfully with ID: " + userId);
                
                // Send registration email
                try {
                    EmailSender.sendRegistrationEmail(email, username);
                    System.out.println("✓ Registration email sent to: " + email);
                } catch (Exception emailError) {
                    System.err.println("⚠ Could not send registration email: " + 
                                     emailError.getMessage());
                }
                
                response.sendRedirect(request.getContextPath() + 
                                      "/register.jsp?success=registered");
            } else {
                System.err.println("✗ Registration failed");
                response.sendRedirect(request.getContextPath() + 
                                      "/register.jsp?error=registration_failed");
            }
            
        } catch (Exception e) {
            System.err.println("✗ Registration error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/register.jsp?error=registration_failed");
        }
    }
    
    /**
     * Save uploaded profile photo to server
     */
    private String saveProfilePhoto(HttpServletRequest request, Part photoPart, 
                                   String username) throws IOException {
        
        // Get file extension
        String fileName = Paths.get(photoPart.getSubmittedFileName()).getFileName().toString();
        String extension = fileName.substring(fileName.lastIndexOf("."));
        
        // Generate unique filename
        String newFileName = "profile_" + username + "_" + System.currentTimeMillis() + extension;
        
        // Create uploads directory if it doesn't exist
        String uploadPath = request.getServletContext().getRealPath("") + 
                          "uploads" + File.separator + "profiles";
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            System.out.println("✓ Created directory: " + uploadPath);
        }
        
        // Save file
        String filePath = uploadPath + File.separator + newFileName;
        
        try (InputStream fileContent = photoPart.getInputStream()) {
            Files.copy(fileContent, Paths.get(filePath), 
                      StandardCopyOption.REPLACE_EXISTING);
        }
        
        // Return relative path for database storage
        return "uploads/profiles/" + newFileName;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }
}
