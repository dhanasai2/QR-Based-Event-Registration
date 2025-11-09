package com.event.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Public URLs that don't require authentication
        boolean isPublicResource = uri.endsWith("login.jsp") || 
                                    uri.endsWith("/login") || 
                                    uri.endsWith("register.jsp") ||
                                    uri.endsWith("/register") ||
                                    uri.endsWith("index.jsp") ||
                                    uri.contains("/assets/") ||
                                    uri.endsWith("/");
        
        // Check if user is accessing protected resources
        boolean isProtectedResource = uri.contains("/admin/") || 
                                       uri.contains("/organizer/") || 
                                       uri.contains("/participant/");
        
        if (isPublicResource || !isProtectedResource) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check for valid session
        HttpSession session = httpRequest.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=notAuthenticated");
            return;
        }
        
        // User is authenticated, proceed
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}
