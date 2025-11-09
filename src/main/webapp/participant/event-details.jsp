<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.EventDAO, com.event.model.Event, java.text.SimpleDateFormat" %>
<%
    // Check session
    Integer userId = (Integer) session.getAttribute("userId");
    
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String eventIdParam = request.getParameter("eventId");
    if (eventIdParam == null || eventIdParam.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/participant/register-event.jsp");
        return;
    }
    
    int eventId = Integer.parseInt(eventIdParam);
    EventDAO eventDAO = new EventDAO();
    Event event = eventDAO.getEventById(eventId);
    
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/participant/register-event.jsp?error=not_found");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
    
    String eventImage = event.getEventImage();
    boolean hasImage = (eventImage != null && !eventImage.isEmpty());
    String imageSrc = hasImage ? request.getContextPath() + "/" + eventImage : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - <%= event.getName() %></title>
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
            margin-bottom: 2rem;
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
            margin-bottom: 0.5rem;
        }

        .event-banner {
            width: 100%;
            height: 400px;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose), var(--accent-lavender));
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 28px;
            overflow: hidden;
            margin-bottom: 2rem;
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.6);
            animation: banner-entrance 0.8s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes banner-entrance {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .event-banner img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .event-banner:hover img {
            transform: scale(1.05);
        }

        .event-banner-placeholder {
            color: rgba(255, 255, 255, 0.9);
            font-size: 8rem;
        }

        .registration-card {
            background: var(--card-bg);
            backdrop-filter: blur(40px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.6);
            animation: card-entrance 0.8s cubic-bezier(0.23, 1, 0.32, 1) 0.2s backwards;
        }

        @keyframes card-entrance {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .event-header {
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            padding: 3rem;
            position: relative;
            overflow: hidden;
        }

        .event-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.1), transparent 60%);
        }

        .event-header-content {
            position: relative;
            z-index: 1;
        }

        .event-name {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--primary-navy);
            margin-bottom: 1rem;
        }

        .event-description {
            color: rgba(10, 22, 40, 0.8);
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .event-details {
            padding: 3rem;
        }

        .section-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-title i {
            color: var(--accent-gold);
        }

        .details-grid {
            display: grid;
            gap: 1.25rem;
            margin-bottom: 3rem;
        }

        .detail-card {
            background: rgba(10, 22, 40, 0.5);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 16px;
            padding: 1.75rem;
            transition: all 0.3s cubic-bezier(0.23, 1, 0.32, 1);
            position: relative;
            overflow: hidden;
        }

        .detail-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 5px;
            height: 100%;
            background: var(--accent-gold);
        }

        .detail-card:hover {
            transform: translateX(5px);
            border-color: var(--accent-gold);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.2);
        }

        .detail-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 0.75rem;
        }

        .detail-icon {
            width: 50px;
            height: 50px;
            background: rgba(212, 175, 55, 0.15);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .detail-icon i {
            font-size: 1.5rem;
        }

        .detail-icon.venue i { color: var(--error); }
        .detail-icon.date i { color: var(--accent-teal); }
        .detail-icon.eligibility i { color: var(--success); }
        .detail-icon.fee i { color: var(--warning); }
        .detail-icon.seats i { color: var(--accent-lavender); }

        .detail-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--cream);
        }

        .detail-content {
            color: rgba(245, 241, 232, 0.8);
            font-size: 1.05rem;
            line-height: 1.6;
        }

        .seats-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-top: 0.75rem;
        }

        .seats-progress {
            flex: 1;
            height: 10px;
            background: rgba(212, 175, 55, 0.2);
            border-radius: 5px;
            overflow: hidden;
        }

        .seats-progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--success), var(--accent-teal));
            border-radius: 5px;
            transition: width 0.6s ease;
        }

        .seats-text {
            font-weight: 700;
            color: var(--accent-lavender);
            white-space: nowrap;
        }

        .btn-register {
            width: 100%;
            background: linear-gradient(135deg, var(--accent-gold), #b8963d);
            color: var(--primary-navy);
            border: none;
            padding: 1.25rem 2rem;
            border-radius: 14px;
            font-weight: 800;
            font-size: 1.15rem;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.35);
        }

        .btn-register:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 50px rgba(212, 175, 55, 0.5);
        }

        @media (max-width: 576px) {
            .page-title {
                font-size: 2.5rem;
            }

            .event-banner {
                height: 280px;
            }

            .event-header {
                padding: 2rem;
            }

            .event-name {
                font-size: 2rem;
            }

            .event-details {
                padding: 2rem;
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
            <div class="row justify-content-center">
                <div class="col-lg-9">
                    <div class="page-header">
                        <h1 class="page-title">
                            <i class="fas fa-calendar-plus"></i> Confirm Registration
                        </h1>
                    </div>

                    <div class="event-banner">
                        <% if (hasImage) { %>
                            <img src="<%= imageSrc %>" alt="<%= event.getName() %>">
                        <% } else { %>
                            <i class="fas fa-calendar-star event-banner-placeholder"></i>
                        <% } %>
                    </div>

                    <div class="registration-card">
                        <div class="event-header">
                            <div class="event-header-content">
                                <h2 class="event-name">
                                    <i class="fas fa-star"></i>
                                    <%= event.getName() %>
                                </h2>
                                <p class="event-description">
                                    <%= event.getDescription() != null && !event.getDescription().isEmpty() 
                                        ? event.getDescription() 
                                        : "Join us for this exciting university event!" %>
                                </p>
                            </div>
                        </div>
                        
                        <div class="event-details">
                            <h3 class="section-title">
                                <i class="fas fa-info-circle"></i>
                                <span>Event Information</span>
                            </h3>
                            
                            <div class="details-grid">
                                <div class="detail-card">
                                    <div class="detail-header">
                                        <div class="detail-icon venue">
                                            <i class="fas fa-map-marker-alt"></i>
                                        </div>
                                        <h4 class="detail-title">Venue</h4>
                                    </div>
                                    <div class="detail-content"><%= event.getVenue() %></div>
                                </div>
                                
                                <div class="detail-card">
                                    <div class="detail-header">
                                        <div class="detail-icon date">
                                            <i class="fas fa-calendar-check"></i>
                                        </div>
                                        <h4 class="detail-title">Date &amp; Time</h4>
                                    </div>
                                    <div class="detail-content"><%= dateFormat.format(event.getEventDate()) %></div>
                                </div>
                                
                                <div class="detail-card">
                                    <div class="detail-header">
                                        <div class="detail-icon eligibility">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <h4 class="detail-title">Eligibility</h4>
                                    </div>
                                    <div class="detail-content"><%= event.getEligibility() %></div>
                                </div>
                                
                                <div class="detail-card">
                                    <div class="detail-header">
                                        <div class="detail-icon fee">
                                            <i class="fas fa-rupee-sign"></i>
                                        </div>
                                        <h4 class="detail-title">Registration Fee</h4>
                                    </div>
                                    <div class="detail-content">&#8377;<%= event.getFee() %></div>
                                </div>
                                
                                <div class="detail-card">
                                    <div class="detail-header">
                                        <div class="detail-icon seats">
                                            <i class="fas fa-user-friends"></i>
                                        </div>
                                        <h4 class="detail-title">Available Seats</h4>
                                    </div>
                                    <%
                                        int registeredCount = eventDAO.getRegistrationCount(eventId);
                                        int availableSeats = event.getCapacity() - registeredCount;
                                        int percentage = event.getCapacity() > 0 ? (registeredCount * 100) / event.getCapacity() : 0;
                                    %>
                                    <div class="detail-content">
                                        <div class="seats-info">
                                            <div class="seats-progress">
                                                <div class="seats-progress-bar" style="width: <%= percentage %>%;"></div>
                                            </div>
                                            <span class="seats-text"><%= availableSeats %> / <%= event.getCapacity() %></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <form action="<%= request.getContextPath() %>/registerEvent" method="post">
                                <input type="hidden" name="eventId" value="<%= eventId %>">
                                <button type="submit" class="btn-register">
                                    <i class="fas fa-check-circle"></i> Confirm Registration
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
