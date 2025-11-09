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
import org.json.JSONObject;

@WebServlet("/scanQR")
public class QRScanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String qrData = request.getParameter("qrData");
        String scannerEventIdParam = request.getParameter("eventId"); // Event ID from scanner page
        
        System.out.println("=== QR SCAN ATTEMPT ===");
        System.out.println("QR Data: " + qrData);
        System.out.println("Scanner Event ID: " + scannerEventIdParam);
        
        JSONObject json = new JSONObject();
        
        try {
            // Create DAOs
            RegistrationDAO registrationDAO = new RegistrationDAO();
            EventDAO eventDAO = new EventDAO();
            UserDAO userDAO = new UserDAO();
            
            // ✅ Parse scanner event ID (which event the scanner is for)
            int scannerEventId = -1;
            if (scannerEventIdParam != null && !scannerEventIdParam.isEmpty()) {
                scannerEventId = Integer.parseInt(scannerEventIdParam);
            }
            
            // Extract Registration ID from QR
            int regId = -1;
            if (qrData.startsWith("REG-")) {
                String[] parts = qrData.split("\\|");
                regId = Integer.parseInt(parts[0].substring(4));
            }
            
            if (regId == -1) {
                json.put("success", false);
                json.put("alreadyMarked", false);
                json.put("message", "Invalid QR code format");
                out.print(json.toString());
                out.flush();
                return;
            }
            
            System.out.println("✓ Registration ID: " + regId);
            
            // ✅ Get registration details
            Registration reg = registrationDAO.getRegistrationById(regId);
            
            if (reg == null) {
                System.err.println("✗ Registration not found: " + regId);
                json.put("success", false);
                json.put("alreadyMarked", false);
                json.put("message", "Registration not found");
                out.print(json.toString());
                out.flush();
                return;
            }
            
            // ✅ Get user and event details
            User user = userDAO.getUserById(reg.getUserId());
            Event event = eventDAO.getEventById(reg.getEventId());
            
            if (user == null || event == null) {
                System.err.println("✗ User or Event not found");
                json.put("success", false);
                json.put("alreadyMarked", false);
                json.put("message", "User or Event not found");
                out.print(json.toString());
                out.flush();
                return;
            }
            
            System.out.println("✓ User: " + user.getUsername());
            System.out.println("✓ Event: " + event.getName());
            System.out.println("✓ Registration Event ID: " + reg.getEventId());
            
            // ✅ CHECK 1: Verify QR is for the correct event
            if (scannerEventId != -1 && reg.getEventId() != scannerEventId) {
                System.err.println("✗ QR code is for event " + reg.getEventId() + 
                                  " but scanner is for event " + scannerEventId);
                json.put("success", false);
                json.put("alreadyMarked", false);
                json.put("message", "Wrong event! This QR is for: " + event.getName());
                json.put("expectedEvent", event.getName());
                out.print(json.toString());
                out.flush();
                return;
            }
            
            // ✅ CHECK 2: Verify registration is approved
            if (!"approved".equals(reg.getStatus())) {
                System.err.println("✗ Registration not approved. Status: " + reg.getStatus());
                json.put("success", false);
                json.put("alreadyMarked", false);
                json.put("message", "Registration not approved. Status: " + reg.getStatus());
                out.print(json.toString());
                out.flush();
                return;
            }
            
            // ✅ CHECK 3: Check if attendance already marked
            if (registrationDAO.isAttendanceMarked(regId)) {
                System.out.println("⚠ Attendance already marked for registration: " + regId);
                
                json.put("success", false);
                json.put("alreadyMarked", true);
                json.put("message", "Already checked in");
                json.put("userName", user.getUsername());
                json.put("userEmail", user.getEmail());
                json.put("eventName", event.getName());
                json.put("registrationId", regId);
                
                System.out.println("JSON Response: " + json.toString());
                out.print(json.toString());
                out.flush();
                return;
            }
            
            // ✅ ALL CHECKS PASSED - Mark attendance
            boolean marked = registrationDAO.markAttendance(regId);
            
            if (marked) {
                System.out.println("✓ Attendance marked successfully for registration: " + regId);
                
                json.put("success", true);
                json.put("alreadyMarked", false);
                json.put("message", "Check-in successful");
                json.put("userName", user.getUsername());
                json.put("userEmail", user.getEmail());
                json.put("eventName", event.getName());
                json.put("registrationId", regId);
                
                System.out.println("JSON Response: " + json.toString());
                out.print(json.toString());
                out.flush();
            } else {
                System.err.println("✗ Failed to mark attendance");
                json.put("success", false);
                json.put("alreadyMarked", false);
                json.put("message", "Failed to mark attendance");
                out.print(json.toString());
                out.flush();
            }
            
        } catch (NumberFormatException e) {
            System.err.println("✗ Number format error: " + e.getMessage());
            e.printStackTrace();
            
            json.put("success", false);
            json.put("alreadyMarked", false);
            json.put("message", "Invalid QR code data");
            out.print(json.toString());
            out.flush();
            
        } catch (Exception e) {
            System.err.println("✗ Error: " + e.getMessage());
            e.printStackTrace();
            
            json.put("success", false);
            json.put("alreadyMarked", false);
            json.put("message", "Error: " + e.getMessage());
            out.print(json.toString());
            out.flush();
        }
    }
}
