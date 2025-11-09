package com.event.servlet;

import com.event.dao.EventDAO;
import com.event.model.Event;
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

@WebServlet("/uploadEventImage")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UploadEventImageServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private EventDAO eventDAO = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String eventIdParam = request.getParameter("eventId");
        if (eventIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=invalid");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdParam);
            
            // Get uploaded file
            Part filePart = request.getPart("eventImage");
            
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/events.jsp?error=no_file");
                return;
            }
            
            // Get upload directory path
            String uploadPath = getServletContext().getRealPath("") + "uploads/events";
            
            // Upload file
            String imagePath = FileUploadUtil.uploadEventImage(filePart, uploadPath);
            
            if (imagePath != null) {
                // Update event in database
                Event event = eventDAO.getEventById(eventId);
                if (event != null) {
                    // Delete old image if exists
                    if (event.getEventImage() != null && !event.getEventImage().isEmpty()) {
                        String oldImagePath = getServletContext().getRealPath("") + 
                                            event.getEventImage();
                        FileUploadUtil.deleteFile(oldImagePath);
                    }
                    
                    // Update with new image path
                    eventDAO.updateEventImage(eventId, imagePath);
                    
                    System.out.println("✓ Event image updated for event: " + eventId);
                    
                    response.sendRedirect(request.getContextPath() + 
                                          "/admin/events.jsp?success=image_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                                          "/admin/events.jsp?error=event_not_found");
                }
            } else {
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/events.jsp?error=upload_failed");
            }
            
        } catch (Exception e) {
            System.err.println("✗ Event image upload error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?error=exception");
        }
    }
}
