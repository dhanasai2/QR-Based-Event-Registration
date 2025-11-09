<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.EventDAO, com.event.model.Event, java.util.List" %>
<%
    // CRITICAL: Check session ONCE and don't redirect if already on this page
    Integer userId = (Integer) session.getAttribute("userId");
    
    // Only redirect to login if no session
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get events - DON'T redirect if empty
    EventDAO eventDAO = new EventDAO();
    List<Event> events = eventDAO.getActiveEvents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Events - University Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
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
            --warning: #f59e0b;
            --error: #ef4444;
            --card-bg: rgba(22, 37, 68, 0.6);
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

        .main-container {
            position: relative;
            z-index: 1;
            padding: 3rem 0;
            min-height: 100vh;
        }

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

        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--cream), var(--accent-gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
        }

        .page-subtitle {
            color: rgba(245, 241, 232, 0.7);
            font-size: 1.1rem;
        }

        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
        }

        .event-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            animation: card-entrance 0.6s ease backwards;
        }

        @keyframes card-entrance {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .event-card:hover {
            transform: translateY(-8px);
            border-color: var(--accent-gold);
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.25);
        }

        .event-image-container {
            position: relative;
            width: 100%;
            height: 250px;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose), var(--accent-lavender));
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .event-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .event-card:hover .event-image {
            transform: scale(1.1);
        }

        .event-placeholder-icon {
            color: rgba(255, 255, 255, 0.7);
            font-size: 4rem;
        }

        .event-body {
            padding: 2rem;
        }

        .event-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .event-description {
            color: rgba(245, 241, 232, 0.7);
            margin-bottom: 1.5rem;
            line-height: 1.6;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .event-info {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: rgba(245, 241, 232, 0.8);
        }

        .info-item i {
            width: 20px;
            font-size: 1rem;
        }

        .btn-register {
            background: linear-gradient(135deg, var(--accent-gold), #b8963d);
            color: var(--primary-navy);
            border: none;
            padding: 0.875rem 1.5rem;
            border-radius: 12px;
            font-weight: 700;
            width: 100%;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.4);
            color: var(--primary-navy);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            animation: fade-in 0.8s ease;
        }

        @keyframes fade-in {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .empty-state i {
            color: var(--accent-teal);
            margin-bottom: 1.5rem;
        }

        .empty-state h3 {
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: rgba(245, 241, 232, 0.7);
        }

        @media (max-width: 768px) {
            .page-title {
                font-size: 2.5rem;
            }

            .events-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="luxury-bg">
        <div class="luxury-orb orb-1"></div>
        <div class="luxury-orb orb-2"></div>
    </div>

    <%@ include file="../common/navbar.jsp" %>

    <div class="main-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-calendar-alt"></i> Available Events
                </h1>
                <p class="page-subtitle">Browse and register for upcoming university events</p>
            </div>

            <% if (events != null && !events.isEmpty()) { %>
                <div class="events-grid">
                    <% 
                    int cardDelay = 0;
                    for (Event event : events) {
                        String eventImage = event.getEventImage();
                        boolean hasImage = (eventImage != null && !eventImage.isEmpty());
                        String imageSrc = hasImage ? request.getContextPath() + "/" + eventImage : "";
                    %>
                        <div class="event-card" style="animation-delay: <%= (cardDelay * 0.1) %>s;">
                            <div class="event-image-container">
                                <% if (hasImage) { %>
                                    <img src="<%= imageSrc %>" 
                                         class="event-image" 
                                         alt="<%= event.getName() %>"
                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                    <i class="fas fa-calendar-star event-placeholder-icon" style="display: none;"></i>
                                <% } else { %>
                                    <i class="fas fa-calendar-star event-placeholder-icon"></i>
                                <% } %>
                            </div>
                            
                            <div class="event-body">
                                <h3 class="event-name"><%= event.getName() %></h3>
                                
                                <% if (event.getDescription() != null && !event.getDescription().isEmpty()) { %>
                                    <p class="event-description"><%= event.getDescription() %></p>
                                <% } %>
                                
                                <div class="event-info">
                                    <div class="info-item">
                                        <i class="fas fa-map-marker-alt" style="color: var(--error);"></i>
                                        <span><%= event.getVenue() %></span>
                                    </div>
                                    <div class="info-item">
                                        <i class="fas fa-calendar-check" style="color: var(--accent-teal);"></i>
                                        <span><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(event.getEventDate()) %></span>
                                    </div>
                                    <div class="info-item">
                                        <i class="fas fa-users" style="color: var(--success);"></i>
                                        <span><%= event.getEligibility() %></span>
                                    </div>
                                    <div class="info-item">
                                        <i class="fas fa-rupee-sign" style="color: var(--warning);"></i>
                                        <span>&#8377;<%= event.getFee() %></span>
                                    </div>
                                </div>
                                
                                <a href="event-details.jsp?eventId=<%= event.getId() %>" class="btn-register">
                                    <i class="fas fa-ticket-alt"></i> Register Now
                                </a>
                            </div>
                        </div>
                    <% 
                        cardDelay++;
                    } 
                    %>
                </div>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-inbox fa-4x"></i>
                    <h3>No Active Events</h3>
                    <p>There are no events available for registration at the moment. Check back soon!</p>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
