package com.event.filter;

import com.event.dao.EventDAO;
import com.event.model.Event;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebFilter("/*")
public class EventExpirationFilter implements Filter {
    
    private static long lastCheck = 0;
    private static final long CHECK_INTERVAL = 60000; // Check every 1 minute
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        long currentTime = System.currentTimeMillis();
        
        // Only check once per minute
        if (currentTime - lastCheck > CHECK_INTERVAL) {
            try {
                EventDAO eventDAO = new EventDAO();
                List<Event> events = eventDAO.getAllEvents();
                
                Timestamp now = new Timestamp(System.currentTimeMillis());
                
                for (Event event : events) {
                    // ✅ FIX: Use eventDate instead of getDeadline()
                    if ("active".equals(event.getStatus()) && 
                        event.getEventDate() != null && 
                        event.getEventDate().before(now)) {
                        
                        // Update status to "expired"
                        eventDAO.updateEventStatus(event.getId(), "expired");
                        System.out.println("✓ Event expired: " + event.getName() + " (ID: " + event.getId() + ")");
                    }
                }
                
                lastCheck = currentTime;
            } catch (Exception e) {
                System.err.println("Error checking event expiration: " + e.getMessage());
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void destroy() {
    }
}
