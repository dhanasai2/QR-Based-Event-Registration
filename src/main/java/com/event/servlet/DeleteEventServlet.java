package com.event.servlet;

import com.event.dao.EventDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/admin/deleteEvent")
public class DeleteEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String eventIdParam = request.getParameter("eventId");
        
        try {
            int eventId = Integer.parseInt(eventIdParam);
            
            EventDAO eventDAO = new EventDAO();
            boolean deleted = eventDAO.deleteEvent(eventId);
            
            if (deleted) {
                System.out.println("✓ Event deleted: ID " + eventId);
                response.sendRedirect(request.getContextPath() + "/admin/events.jsp?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=delete_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=delete_error");
        }
    }
}
