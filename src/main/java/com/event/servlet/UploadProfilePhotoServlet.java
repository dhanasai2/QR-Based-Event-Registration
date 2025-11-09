package com.event.servlet;

import com.event.dao.UserDAO;
import com.event.model.User;
import com.event.util.FileUploadUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;

@WebServlet("/uploadProfilePhoto")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 5,        // 5 MB
    maxRequestSize = 1024 * 1024 * 10     // 10 MB
)
public class UploadProfilePhotoServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");
        
        try {
            // Get uploaded file
            Part filePart = request.getPart("profilePhoto");
            
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect(request.getContextPath() + 
                                      "/participant/profile.jsp?error=no_file");
                return;
            }
            
            // Get upload directory path
            String uploadPath = getServletContext().getRealPath("") + "uploads/users";
            
            // Upload file
            String photoPath = FileUploadUtil.uploadUserPhoto(filePart, uploadPath);
            
            if (photoPath != null) {
                // Update user profile in database
                User user = userDAO.getUserById(userId);
                if (user != null) {
                    // Delete old photo if exists
                    if (user.getProfilePhoto() != null && !user.getProfilePhoto().isEmpty()) {
                        String oldPhotoPath = getServletContext().getRealPath("") + 
                                            user.getProfilePhoto();
                        FileUploadUtil.deleteFile(oldPhotoPath);
                    }
                    
                    // Update with new photo path
                    user.setProfilePhoto(photoPath);
                    userDAO.updateUserPhoto(userId, photoPath);
                    
                    System.out.println("✓ Profile photo updated for user: " + userId);
                    
                    response.sendRedirect(request.getContextPath() + 
                                          "/participant/profile.jsp?success=photo_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                                          "/participant/profile.jsp?error=user_not_found");
                }
            } else {
                response.sendRedirect(request.getContextPath() + 
                                      "/participant/profile.jsp?error=upload_failed");
            }
            
        } catch (Exception e) {
            System.err.println("✗ Profile photo upload error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/participant/profile.jsp?error=exception");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/participant/profile.jsp");
    }
}
