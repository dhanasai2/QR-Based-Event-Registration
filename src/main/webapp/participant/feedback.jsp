<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%@ page import="com.event.model.Registration" %> 

<%
    if (session.getAttribute("userId") == null || !"participant".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    int userId = (int) session.getAttribute("userId");
    RegistrationDAO registrationDAO = new RegistrationDAO();
    List<Registration> approvedRegistrations = registrationDAO.getRegistrationsByUserId(userId)
        .stream()
        .filter(r -> "approved".equals(r.getStatus()))
        .collect(java.util.stream.Collectors.toList());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Feedback - University Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-navy: #0a1628;
            --secondary-navy: #162544;
            --accent-gold: #d4af37;
            --accent-rose: #e8b4b8;
            --accent-teal: #5bc0be;
            --accent-lavender: #9d84b7;
            --cream: #f5f1e8;
            --warm-white: #faf8f3;
            --success: #10b981;
            --error: #ef4444;
            --warning: #f59e0b;
            --card-bg: rgba(22, 37, 68, 0.6);
            --sidebar-bg: rgba(22, 37, 68, 0.95);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(212, 175, 55, 0.08), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(91, 192, 190, 0.08), transparent 60%),
                        linear-gradient(135deg, var(--primary-navy) 0%, #0d1b2a 50%, var(--primary-navy) 100%);
            min-height: 100vh;
            color: var(--warm-white);
        }

        /* Animated Background */
        .luxury-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            pointer-events: none;
        }

        .luxury-orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(120px);
            opacity: 0.08;
            animation: luxury-float 30s ease-in-out infinite;
        }

        .orb-1 {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, var(--accent-gold) 0%, transparent 70%);
            top: -10%;
            right: 10%;
            animation-duration: 35s;
        }

        .orb-2 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, var(--accent-teal) 0%, transparent 70%);
            bottom: -10%;
            left: 20%;
            animation-duration: 40s;
            animation-delay: 5s;
        }

        @keyframes luxury-float {
            0%, 100% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(30px, -30px) scale(1.1); }
        }

        /* Main Container */
        .main-container {
            position: relative;
            z-index: 1;
            padding: 3rem 0;
            min-height: 100vh;
        }

        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: fade-in-down 0.8s ease;
        }

        @keyframes fade-in-down {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .page-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            border-radius: 24px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            animation: icon-float 4s ease-in-out infinite;
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.3);
        }

        @keyframes icon-float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }

        .page-icon i {
            font-size: 3rem;
            color: var(--primary-navy);
        }

        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--cream), var(--accent-gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.75rem;
        }

        .page-subtitle {
            color: rgba(245, 241, 232, 0.7);
            font-size: 1.1rem;
        }

        /* Alert Messages */
        .alert {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.25rem;
            border-radius: 14px;
            font-size: 0.95rem;
            font-weight: 500;
            margin-bottom: 2rem;
            border: 1.5px solid;
            animation: alert-slide 0.5s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes alert-slide {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--error);
            border-color: rgba(239, 68, 68, 0.3);
        }

        .alert-info {
            background: rgba(91, 192, 190, 0.1);
            color: var(--accent-teal);
            border-color: rgba(91, 192, 190, 0.3);
        }

        .alert i {
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        /* Feedback Card */
        .feedback-card {
            background: var(--card-bg);
            backdrop-filter: blur(40px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.6);
            animation: card-entrance 0.8s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes card-entrance {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .card-header-custom::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.1), transparent 60%);
        }

        .card-header-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary-navy);
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .card-header-title i {
            margin-right: 0.75rem;
        }

        .card-body-custom {
            padding: 2.5rem;
        }

        /* Form Groups */
        .form-group-custom {
            margin-bottom: 2rem;
        }

        .form-label-custom {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: rgba(245, 241, 232, 0.9);
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 1rem;
        }

        .form-label-custom i {
            color: var(--accent-gold);
        }

        .required-mark {
            color: var(--error);
            margin-left: 0.25rem;
        }

        /* Select Dropdown */
        .form-select-custom {
            width: 100%;
            background: rgba(10, 22, 40, 0.6);
            border: 2px solid rgba(212, 175, 55, 0.2);
            border-radius: 14px;
            color: var(--cream);
            font-size: 1rem;
            font-weight: 500;
            padding: 1rem 1.25rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            outline: none;
            cursor: pointer;
        }

        .form-select-custom option {
            background: var(--secondary-navy);
            color: var(--cream);
            padding: 1rem;
        }

        .form-select-custom:focus {
            background: rgba(10, 22, 40, 0.8);
            border-color: var(--accent-gold);
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.1);
            transform: translateY(-2px);
        }

        /* Star Rating */
        .star-rating-container {
            background: rgba(10, 22, 40, 0.4);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
        }

        .star-rating {
            direction: rtl;
            display: inline-flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .star-rating input[type="radio"] {
            display: none;
        }

        .star-rating label {
            color: rgba(212, 175, 55, 0.3);
            cursor: pointer;
            font-size: 3rem;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            filter: drop-shadow(0 0 0 transparent);
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: var(--accent-gold);
            filter: drop-shadow(0 0 8px rgba(212, 175, 55, 0.6));
            transform: scale(1.15);
        }

        .star-rating input:checked ~ label {
            color: var(--accent-gold);
            filter: drop-shadow(0 0 12px rgba(212, 175, 55, 0.8));
        }

        .rating-display {
            color: var(--accent-gold);
            font-size: 1.1rem;
            font-weight: 600;
            min-height: 30px;
            animation: fade-in 0.3s ease;
        }

        @keyframes fade-in {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* Textarea */
        .form-textarea-custom {
            width: 100%;
            background: rgba(10, 22, 40, 0.6);
            border: 2px solid rgba(212, 175, 55, 0.2);
            border-radius: 14px;
            color: var(--cream);
            font-size: 1rem;
            font-weight: 500;
            padding: 1rem 1.25rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            outline: none;
            resize: vertical;
            min-height: 150px;
            font-family: 'Inter', sans-serif;
        }

        .form-textarea-custom::placeholder {
            color: rgba(245, 241, 232, 0.4);
        }

        .form-textarea-custom:focus {
            background: rgba(10, 22, 40, 0.8);
            border-color: var(--accent-gold);
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.1);
        }

        .form-hint {
            color: rgba(245, 241, 232, 0.5);
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        /* Buttons */
        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            border: none;
            padding: 1.1rem 2rem;
            border-radius: 14px;
            font-weight: 800;
            font-size: 1.05rem;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            box-shadow: 0 15px 40px rgba(16, 185, 129, 0.35);
            position: relative;
            overflow: hidden;
            margin-bottom: 1rem;
        }

        .btn-submit::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.3), transparent);
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
        }

        .btn-submit:hover::before {
            width: 400px;
            height: 400px;
        }

        .btn-submit:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 50px rgba(16, 185, 129, 0.5);
        }

        .btn-submit i {
            margin-right: 0.625rem;
        }

        .btn-back {
            width: 100%;
            background: rgba(22, 37, 68, 0.6);
            color: var(--cream);
            border: 2px solid rgba(212, 175, 55, 0.2);
            padding: 1rem 2rem;
            border-radius: 14px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-back:hover {
            background: rgba(22, 37, 68, 0.8);
            border-color: var(--accent-gold);
            color: var(--accent-gold);
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(212, 175, 55, 0.2);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state-icon {
            width: 120px;
            height: 120px;
            background: rgba(91, 192, 190, 0.15);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 2rem;
        }

        .empty-state-icon i {
            font-size: 4rem;
            color: var(--accent-teal);
        }

        .empty-state h3 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: rgba(245, 241, 232, 0.7);
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        /* Responsive */
        @media (max-width: 576px) {
            .page-title {
                font-size: 2.5rem;
            }

            .page-icon {
                width: 80px;
                height: 80px;
            }

            .page-icon i {
                font-size: 2.5rem;
            }

            .card-body-custom {
                padding: 1.5rem;
            }

            .star-rating label {
                font-size: 2.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="luxury-bg">
        <div class="luxury-orb orb-1"></div>
        <div class="luxury-orb orb-2"></div>
    </div>

    <%@ include file="../common/navbar.jsp" %>

    <div class="main-container">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="page-icon">
                    <i class="fas fa-comment-dots"></i>
                </div>
                <h1 class="page-title">Event Feedback</h1>
                <p class="page-subtitle">Share your experience and help us improve</p>
            </div>

            <!-- Error Message -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= request.getAttribute("errorMessage") %></span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Content -->
            <% if (approvedRegistrations.isEmpty()) { %>
                <div class="feedback-card">
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-calendar-times"></i>
                        </div>
                        <h3>No Events Available</h3>
                        <p>You don't have any attended events to provide feedback for. Register for upcoming events to share your experience!</p>
                        <a href="dashboard.jsp" class="btn-back">
                            <i class="fas fa-arrow-left"></i>
                            <span>Back to Dashboard</span>
                        </a>
                    </div>
                </div>
            <% } else { %>
                <div class="feedback-card">
                    <div class="card-header-custom">
                        <h2 class="card-header-title">
                            <i class="fas fa-star"></i> Submit Your Feedback
                        </h2>
                    </div>
                    <div class="card-body-custom">
                        <form method="post" action="${pageContext.request.contextPath}/submitFeedback" 
                              onsubmit="return validateFeedbackForm()" id="feedbackForm">
                            
                            <!-- Event Selection -->
                            <div class="form-group-custom">
                                <label class="form-label-custom">
                                    <i class="fas fa-calendar-check"></i>
                                    <span>Select Event</span>
                                    <span class="required-mark">*</span>
                                </label>
                                <select class="form-select-custom" name="registrationId" id="registrationSelect" required>
                                    <option value="">-- Choose an Event --</option>
                                    <% for (Registration reg : approvedRegistrations) { %>
                                        <option value="<%= reg.getId() %>"><%= reg.getEventName() %></option>
                                    <% } %>
                                </select>
                            </div>

                            <!-- Star Rating -->
                            <div class="form-group-custom">
                                <label class="form-label-custom">
                                    <i class="fas fa-star"></i>
                                    <span>Rate Your Experience</span>
                                    <span class="required-mark">*</span>
                                </label>
                                <div class="star-rating-container">
                                    <div class="star-rating">
                                        <input type="radio" id="star5" name="rating" value="5" required>
                                        <label for="star5" title="Excellent">★</label>
                                        
                                        <input type="radio" id="star4" name="rating" value="4">
                                        <label for="star4" title="Very Good">★</label>
                                        
                                        <input type="radio" id="star3" name="rating" value="3">
                                        <label for="star3" title="Good">★</label>
                                        
                                        <input type="radio" id="star2" name="rating" value="2">
                                        <label for="star2" title="Fair">★</label>
                                        
                                        <input type="radio" id="star1" name="rating" value="1">
                                        <label for="star1" title="Poor">★</label>
                                    </div>
                                    <div id="ratingDisplay" class="rating-display"></div>
                                </div>
                            </div>

                            <!-- Comments -->
                            <div class="form-group-custom">
                                <label class="form-label-custom">
                                    <i class="fas fa-pen"></i>
                                    <span>Your Comments</span>
                                </label>
                                <textarea class="form-textarea-custom" name="comments" id="comments" 
                                          placeholder="Share your experience, suggestions, and feedback..."></textarea>
                                <div class="form-hint">
                                    Tell us what you liked or how we can improve (optional)
                                </div>
                            </div>

                            <!-- Submit Buttons -->
                            <button type="submit" class="btn-submit">
                                <i class="fas fa-paper-plane"></i> Submit Feedback
                            </button>
                            <a href="dashboard.jsp" class="btn-back">
                                <i class="fas fa-arrow-left"></i> Back to Dashboard
                            </a>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Display selected rating
        const ratingLabels = ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];
        const ratingEmojis = ['😞', '😕', '😊', '😄', '🤩'];
        
        document.querySelectorAll('.star-rating input').forEach(input => {
            input.addEventListener('change', function() {
                const ratingDisplay = document.getElementById('ratingDisplay');
                const value = parseInt(this.value);
                ratingDisplay.innerHTML = `
                    <span style="font-size: 2rem; margin-right: 0.5rem;">${ratingEmojis[value - 1]}</span>
                    <span>${value} star${value > 1 ? 's' : ''} - ${ratingLabels[value - 1]}</span>
                `;
            });
        });

        // Form validation
        function validateFeedbackForm() {
            const registrationId = document.getElementById('registrationSelect').value;
            const rating = document.querySelector('input[name="rating"]:checked');
            
            if (!registrationId) {
                alert('Please select an event');
                document.getElementById('registrationSelect').focus();
                return false;
            }
            
            if (!rating) {
                alert('Please provide a rating');
                return false;
            }
            
            return true;
        }

        // Auto-hide alerts
        document.querySelectorAll('.alert').forEach(alert => {
            setTimeout(() => {
                alert.style.transition = 'all 0.4s ease';
                alert.style.opacity = '0';
                alert.style.transform = 'translateX(-30px)';
                setTimeout(() => alert.remove(), 400);
            }, 5000);
        });

        // Animate form on load
        document.addEventListener('DOMContentLoaded', function() {
            const formGroups = document.querySelectorAll('.form-group-custom');
            formGroups.forEach((group, index) => {
                group.style.animation = `fade-in-up 0.5s ease ${0.1 * index}s backwards`;
            });
        });
    </script>
</body>
</html>
