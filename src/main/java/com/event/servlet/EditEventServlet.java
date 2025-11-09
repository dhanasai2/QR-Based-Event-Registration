package com.event.servlet;

import com.event.dao.EventDAO;
import com.event.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/editEvent")
public class EditEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
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
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=invalid_id");
            return;
        }
        
        try {
            int eventId = Integer.parseInt(idParam);
            EventDAO eventDAO = new EventDAO();
            Event event = eventDAO.getEventById(eventId);
            
            if (event == null) {
                response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=not_found");
                return;
            }
            
            // Set event as request attribute
            request.setAttribute("event", event);
            
            // Forward to edit page
            request.getRequestDispatcher("/admin/edit-event.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=invalid_id");
        } catch (Exception e) { // ✅ FIXED: Changed from SQLException to Exception
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/events.jsp?error=database_error");
        }
    }
}
