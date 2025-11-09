package com.event.servlet;

import com.event.dao.EventDAO;
import com.event.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

@WebServlet("/manageEvent")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB
    maxFileSize = 1024 * 1024 * 5,         // 5 MB
    maxRequestSize = 1024 * 1024 * 10      // 10 MB
)
public class EventManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EventDAO eventDAO = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");

        try {
            if (action == null) {
                response.sendRedirect(request.getContextPath() + "/admin/events.jsp");
                return;
            }
            
            switch (action) {
                case "create":
                    createEvent(request, response, session);
                    break;
                case "update":
                    updateEvent(request, response);
                    break;
                case "delete":
                    deleteEvent(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/events.jsp");
            }
        } catch (Exception e) {
            System.err.println("✗ Event management error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?error=operation_failed");
        }
    }

    /**
     * Create new event with optional image upload
     */
    private void createEvent(HttpServletRequest request, HttpServletResponse response, 
                             HttpSession session) throws Exception {
        
        System.out.println("=== CREATE EVENT ATTEMPT ===");
        
        int createdBy = (int) session.getAttribute("userId");
        
        // Get form parameters
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String venue = request.getParameter("venue");
        String eventDateStr = request.getParameter("eventDate");
        String deadlineStr = request.getParameter("registrationDeadline"); // ADDED THIS LINE
        String eligibility = request.getParameter("eligibility");
        String feeStr = request.getParameter("fee");
        String capacityStr = request.getParameter("capacity");
        String status = request.getParameter("status");
        
        System.out.println("Event Name: " + name);
        System.out.println("Venue: " + venue);
        
        // Validate required fields
        if (name == null || name.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            venue == null || venue.trim().isEmpty() ||
            eventDateStr == null || eventDateStr.trim().isEmpty() ||
            deadlineStr == null || deadlineStr.trim().isEmpty() ||  // ADDED THIS LINE
            eligibility == null || eligibility.trim().isEmpty() ||
            feeStr == null || capacityStr == null) {
            
            System.out.println("✗ Validation failed: Missing required fields");
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?error=invalid_input");
            return;
        }
        
        // Create event object
        Event event = new Event();
        event.setName(name);
        event.setDescription(description);
        event.setVenue(venue);
        
        // Parse dates - UPDATED THIS SECTION
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        try {
            event.setEventDate(new Timestamp(sdf.parse(eventDateStr).getTime()));
            event.setRegistrationDeadline(new Timestamp(sdf.parse(deadlineStr).getTime())); // ADDED THIS LINE
        } catch (Exception e) {
            System.err.println("✗ Date parsing error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?error=invalid_date");
            return;
        }
        
        event.setEligibility(eligibility);
        event.setFee(new BigDecimal(feeStr));
        event.setCapacity(Integer.parseInt(capacityStr));
        event.setCreatedBy(createdBy);
        event.setStatus(status != null ? status : "upcoming"); // CHANGED DEFAULT TO 'upcoming'
        
        // ===== HANDLE EVENT IMAGE UPLOAD =====
        String imagePath = null;
        Part imagePart = request.getPart("eventImage");
        
        if (imagePart != null && imagePart.getSize() > 0) {
            System.out.println("Event image uploaded, size: " + imagePart.getSize() + " bytes");
            
            // Validate file size (5MB max)
            if (imagePart.getSize() > 5 * 1024 * 1024) {
                System.out.println("✗ Image too large");
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/events.jsp?error=image_size");
                return;
            }
            
            // Validate file type
            String contentType = imagePart.getContentType();
            if (!contentType.equals("image/jpeg") && 
                !contentType.equals("image/jpg") && 
                !contentType.equals("image/png") && 
                !contentType.equals("image/gif")) {
                
                System.out.println("✗ Invalid image type: " + contentType);
                response.sendRedirect(request.getContextPath() + 
                                      "/admin/events.jsp?error=image_type");
                return;
            }
            
            // Save image
            imagePath = saveEventImage(request, imagePart, name);
            System.out.println("✓ Image saved: " + imagePath);
        } else {
            System.out.println("No event image uploaded");
        }
        
        // Set image path if uploaded
        if (imagePath != null) {
            event.setEventImage(imagePath);
        }

        // Save event to database
        int eventId = eventDAO.createEvent(event);

        if (eventId > 0) {
            System.out.println("✓ Event created successfully with ID: " + eventId);
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?success=created");
        } else {
            System.err.println("✗ Event creation failed");
            throw new Exception("Event creation failed");
        }
    }

    /**
     * Update existing event with optional image upload
     */
    private void updateEvent(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        System.out.println("=== UPDATE EVENT ATTEMPT ===");
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        Event event = eventDAO.getEventById(eventId);
        
        if (event == null) {
            System.err.println("✗ Event not found: " + eventId);
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?error=event_not_found");
            return;
        }
        
        event.setName(request.getParameter("name"));
        event.setDescription(request.getParameter("description"));
        event.setVenue(request.getParameter("venue"));
        
        // Parse dates - UPDATED THIS SECTION
        String eventDateStr = request.getParameter("eventDate");
        String deadlineStr = request.getParameter("registrationDeadline"); // ADDED THIS LINE
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        
        try {
            event.setEventDate(new Timestamp(sdf.parse(eventDateStr).getTime()));
            event.setRegistrationDeadline(new Timestamp(sdf.parse(deadlineStr).getTime())); // ADDED THIS LINE
        } catch (Exception e) {
            System.err.println("✗ Date parsing error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?error=invalid_date");
            return;
        }
        
        event.setEligibility(request.getParameter("eligibility"));
        event.setFee(new BigDecimal(request.getParameter("fee")));
        event.setCapacity(Integer.parseInt(request.getParameter("capacity")));
        event.setStatus(request.getParameter("status"));
        
        // ===== HANDLE EVENT IMAGE UPDATE =====
        Part imagePart = request.getPart("eventImage");
        
        if (imagePart != null && imagePart.getSize() > 0) {
            System.out.println("New event image uploaded");
            
            // Validate and save new image
            if (imagePart.getSize() <= 5 * 1024 * 1024) {
                String contentType = imagePart.getContentType();
                if (contentType.startsWith("image/")) {
                    String imagePath = saveEventImage(request, imagePart, event.getName());
                    event.setEventImage(imagePath);
                    System.out.println("✓ Image updated: " + imagePath);
                }
            }
        }

        boolean updated = eventDAO.updateEvent(event);

        if (updated) {
            System.out.println("✓ Event updated successfully");
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?success=updated");
        } else {
            System.err.println("✗ Event update failed");
            throw new Exception("Event update failed");
        }
    }

    /**
     * Delete event
     */
    private void deleteEvent(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        System.out.println("=== DELETE EVENT ATTEMPT ===");
        
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        boolean deleted = eventDAO.deleteEvent(eventId);

        if (deleted) {
            System.out.println("✓ Event deleted successfully");
            response.sendRedirect(request.getContextPath() + 
                                  "/admin/events.jsp?success=deleted");
        } else {
            System.err.println("✗ Event deletion failed");
            throw new Exception("Event deletion failed");
        }
    }
    
    /**
     * Save uploaded event image to server
     */
    private String saveEventImage(HttpServletRequest request, Part imagePart, 
                                 String eventName) throws IOException {
        
        // Get file extension
        String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String extension = fileName.substring(fileName.lastIndexOf("."));
        
        // Generate unique filename (sanitize event name)
        String sanitizedName = eventName.replaceAll("[^a-zA-Z0-9]", "_").toLowerCase();
        String newFileName = "event_" + sanitizedName + "_" + System.currentTimeMillis() + extension;
        
        // Create uploads directory if it doesn't exist
        String uploadPath = request.getServletContext().getRealPath("") + 
                          "uploads" + File.separator + "events";
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            System.out.println("✓ Created directory: " + uploadPath);
        }
        
        // Save file
        String filePath = uploadPath + File.separator + newFileName;
        
        try (InputStream fileContent = imagePart.getInputStream()) {
            Files.copy(fileContent, Paths.get(filePath), 
                      StandardCopyOption.REPLACE_EXISTING);
        }
        
        // Return relative path for database storage
        return "uploads/events/" + newFileName;
    }
}
