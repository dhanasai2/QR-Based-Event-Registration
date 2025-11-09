package com.event.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter({"/admin/*", "/organizer/*", "/participant/*"})
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        
        if (session == null || session.getAttribute("role") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        
        String userRole = (String) session.getAttribute("role");
        String uri = httpRequest.getRequestURI();
        
        // Role-based access control
        boolean hasAccess = false;
        
        if (uri.contains("/admin/") && "admin".equals(userRole)) {
            hasAccess = true;
        } else if (uri.contains("/organizer/") && ("organizer".equals(userRole) || "admin".equals(userRole))) {
            hasAccess = true;
        } else if (uri.contains("/participant/") && "participant".equals(userRole)) {
            hasAccess = true;
        }
        
        if (!hasAccess) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error-403.jsp");
            return;
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup
    }
}
