package com.event.servlet;

import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/generateHash")
public class GenerateHashServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String password = "admin123";
        String hash = BCrypt.hashpw(password, BCrypt.gensalt(10));
        
        response.setContentType("text/html");
        response.getWriter().println("<h2>BCrypt Hash Generator</h2>");
        response.getWriter().println("<p><strong>Password:</strong> " + password + "</p>");
        response.getWriter().println("<p><strong>BCrypt Hash:</strong></p>");
        response.getWriter().println("<pre style='background:#f4f4f4;padding:10px;'>" + hash + "</pre>");
        response.getWriter().println("<h3>SQL Query:</h3>");
        response.getWriter().println("<pre style='background:#f4f4f4;padding:10px;'>");
        response.getWriter().println("UPDATE users \nSET password = '" + hash + "' \nWHERE username = 'admin';");
        response.getWriter().println("</pre>");
        
        // Test the hash immediately
        boolean matches = BCrypt.checkpw(password, hash);
        response.getWriter().println("<p><strong>Test:</strong> Does '" + password + "' match this hash? " + 
                                     (matches ? "✅ YES" : "❌ NO") + "</p>");
    }
}
