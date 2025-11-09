package com.event.servlet;

import com.event.dao.*;
import com.event.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/admin/attendanceDetails")
public class AttendanceDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L; // ✅ FIX: Add serialVersionUID
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin session
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String eventIdParam = request.getParameter("eventId");
        
        EventDAO eventDAO = new EventDAO();
        RegistrationDAO regDAO = new RegistrationDAO();
        UserDAO userDAO = new UserDAO();
        
        try { // ✅ FIX: Add try-catch for SQLException
            if (eventIdParam != null && !eventIdParam.isEmpty()) {
                // Show specific event attendance details
                int eventId = Integer.parseInt(eventIdParam);
                Event event = eventDAO.getEventById(eventId);
                
                if (event != null) {
                    // Get all registrations for this event where attendance is marked
                    List<Registration> allRegs = regDAO.getRegistrationsByEventId(eventId);
                    List<Registration> attendedList = new ArrayList<>();
                    
                    // Populate user data for each registration
                    for (Registration reg : allRegs) {
                        if (reg.isAttendanceMarked()) {
                            // Fetch user details and populate the registration object
                            User user = userDAO.getUserById(reg.getUserId());
                            if (user != null) {
                                // Set user data in registration object
                                reg.setUserName(user.getUsername());
                                reg.setUserEmail(user.getEmail());
                            }
                            attendedList.add(reg);
                        }
                    }
                    
                    request.setAttribute("event", event);
                    request.setAttribute("attendedList", attendedList);
                }
            } else {
                // Show all events list
                List<Event> events = eventDAO.getAllEvents();
                request.setAttribute("events", events);
            }
        } catch (SQLException e) { // ✅ FIX: Handle SQLException
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/admin/attendance-details.jsp").forward(request, response);
    }
}
