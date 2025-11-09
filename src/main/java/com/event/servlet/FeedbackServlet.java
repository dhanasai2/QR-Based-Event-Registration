package com.event.servlet;

import com.event.dao.FeedbackDAO;
import com.event.model.Feedback;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/submitFeedback")
public class FeedbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int registrationId = Integer.parseInt(request.getParameter("registrationId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comments = request.getParameter("comments");

        try {
            Feedback feedback = new Feedback();
            feedback.setRegistrationId(registrationId);
            feedback.setRating(rating);
            feedback.setComments(comments);

            boolean submitted = feedbackDAO.submitFeedback(feedback);

            if (submitted) {
                response.sendRedirect(request.getContextPath() + 
                                      "/participant/dashboard.jsp?message=feedbackSubmitted");
            } else {
                request.setAttribute("errorMessage", "Failed to submit feedback");
                request.getRequestDispatcher("/participant/feedback.jsp")
                       .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/participant/feedback.jsp").forward(request, response);
        }
    }
}
