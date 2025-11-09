package com.event.servlet;

import com.event.dao.*;
import com.event.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.List;

@WebServlet("/getAttendanceDetails")
public class GetAttendanceDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String eventIdParam = request.getParameter("eventId");
        
        System.out.println("=== FETCHING ATTENDANCE DETAILS ===");
        System.out.println("Event ID: " + eventIdParam);
        
        try {
            int eventId = Integer.parseInt(eventIdParam);
            
            RegistrationDAO registrationDAO = new RegistrationDAO();
            UserDAO userDAO = new UserDAO();
            
            List<Registration> registrations = registrationDAO.getRegistrationsByEventId(eventId);
            
            System.out.println("Total registrations: " + registrations.size());
            
            JSONObject json = new JSONObject();
            JSONArray attendeesArray = new JSONArray();
            
            // ✅ FIX: Set timezone to IST
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
            dateFormat.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata")); // IST timezone
            
            int attendeeCount = 0;
            for (Registration reg : registrations) {
                System.out.println("Checking Reg ID: " + reg.getId() + 
                                 " | Attendance Marked: " + reg.isAttendanceMarked());
                
                if (reg.isAttendanceMarked()) {
                    attendeeCount++;
                    
                    String userName = reg.getUserName();
                    String userEmail = reg.getUserEmail();
                    
                    if (userName == null || userName.isEmpty()) {
                        User user = userDAO.getUserById(reg.getUserId());
                        if (user != null) {
                            userName = user.getUsername();
                            userEmail = user.getEmail();
                        }
                    }
                    
                    JSONObject attendee = new JSONObject();
                    attendee.put("registrationId", reg.getId());
                    attendee.put("userName", userName != null ? userName : "Unknown");
                    attendee.put("userEmail", userEmail != null ? userEmail : "No email");
                    attendee.put("attendanceTime", reg.getAttendanceTime() != null ? 
                                 dateFormat.format(reg.getAttendanceTime()) : "N/A");
                    
                    attendeesArray.put(attendee);
                    
                    System.out.println("  Added: " + userName + " (" + userEmail + ")");
                }
            }
            
            System.out.println("Total attendees found: " + attendeeCount);
            
            json.put("success", true);
            json.put("attendees", attendeesArray);
            
            System.out.println("JSON Response: " + json.toString());
            
            out.print(json.toString());
            out.flush();
            
        } catch (Exception e) {
            System.err.println("✗ Error fetching attendance: " + e.getMessage());
            e.printStackTrace();
            
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", e.getMessage());
            error.put("attendees", new JSONArray());
            
            out.print(error.toString());
            out.flush();
        }
    }
}
