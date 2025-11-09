package com.event.servlet;

import com.event.dao.EventDAO;
import com.event.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

@WebServlet("/updateEvent")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 5,        // 5MB
    maxRequestSize = 1024 * 1024 * 10     // 10MB
)
public class UpdateEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private static final String UPLOAD_DIR = "uploads/events";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin session
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Get event ID
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String venue = request.getParameter("venue");
            String eligibility = request.getParameter("eligibility");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            
            // ✅ FIXED: Changed from double to BigDecimal
            BigDecimal fee = new BigDecimal(request.getParameter("fee"));
            
            String status = request.getParameter("status");
            String eventDateStr = request.getParameter("eventDate");
            
            // Parse date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Timestamp eventDate = new Timestamp(sdf.parse(eventDateStr).getTime());
            
            // Get existing event
            EventDAO eventDAO = new EventDAO();
            Event event = eventDAO.getEventById(eventId);
            
            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=not_found");
                return;
            }
            
            // Update event details
            event.setName(name);
            event.setDescription(description);
            event.setVenue(venue);
            event.setEligibility(eligibility);
            event.setCapacity(capacity);
            event.setFee(fee); // ✅ Now uses BigDecimal
            event.setStatus(status);
            event.setEventDate(eventDate);
            
            // Handle image upload (if new image provided)
            Part filePart = request.getPart("eventImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // Validate file type
                String contentType = filePart.getContentType();
                if (!contentType.startsWith("image/")) {
                    response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=image_type");
                    return;
                }
                
                // Validate file size (5MB max)
                if (filePart.getSize() > 5 * 1024 * 1024) {
                    response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=image_size");
                    return;
                }
                
                // Generate unique filename
                String timestamp = String.valueOf(System.currentTimeMillis());
                String extension = fileName.substring(fileName.lastIndexOf("."));
                String newFileName = "event_" + timestamp + extension;
                
                // Get upload path
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Save file
                String filePath = uploadPath + File.separator + newFileName;
                filePart.write(filePath);
                
                // Delete old image if exists
                if (event.getEventImage() != null && !event.getEventImage().isEmpty()) {
                    String oldImagePath = getServletContext().getRealPath("") + File.separator + event.getEventImage();
                    File oldFile = new File(oldImagePath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                
                // Update image path
                event.setEventImage(UPLOAD_DIR + "/" + newFileName);
            }
            
            // Update event in database
            boolean updated = eventDAO.updateEvent(event);
            
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/events.jsp?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=update_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=update_error");
        }
    }
}
