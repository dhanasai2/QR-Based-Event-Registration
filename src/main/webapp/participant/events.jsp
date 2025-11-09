<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.EventDAO, com.event.model.Event, java.util.List, java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String username = (String) session.getAttribute("username");
    int userId = (int) session.getAttribute("userId");
    
    EventDAO eventDAO = new EventDAO();
    List<Event> events = eventDAO.getActiveEvents();
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Events - University Events</title>
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

        /* Navbar */
        .navbar {
            background: var(--sidebar-bg) !important;
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .navbar-brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent-gold), var(--cream));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-link {
            color: rgba(245, 241, 232, 0.7) !important;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 0 0.5rem;
        }

        .nav-link:hover {
            color: var(--accent-gold) !important;
        }

        .nav-link.active {
            color: var(--accent-gold) !important;
            font-weight: 700;
        }

        /* Main Content */
        .main-container {
            position: relative;
            z-index: 1;
            padding: 3rem 0;
        }

        /* Page Header */
        .page-hero {
            text-align: center;
            padding: 3rem 0;
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

        .page-hero-icon {
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

        .page-hero-icon i {
            font-size: 3rem;
            color: var(--primary-navy);
        }

        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 3.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--cream), var(--accent-gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
        }

        .page-subtitle {
            color: rgba(245, 241, 232, 0.7);
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Events Grid */
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 2rem;
            animation: fade-in-up 0.8s ease 0.3s backwards;
        }

        @keyframes fade-in-up {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Event Card */
        .event-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .event-card:hover {
            transform: translateY(-12px);
            border-color: var(--accent-gold);
            box-shadow: 0 25px 70px rgba(212, 175, 55, 0.25);
        }

        /* Event Image */
        .event-image-container {
            width: 100%;
            height: 280px;
            overflow: hidden;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose), var(--accent-lavender));
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
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

        .event-image-placeholder {
            color: rgba(255, 255, 255, 0.9);
            font-size: 5rem;
            animation: placeholder-pulse 2s ease-in-out infinite;
        }

        @keyframes placeholder-pulse {
            0%, 100% { opacity: 0.7; transform: scale(1); }
            50% { opacity: 1; transform: scale(1.05); }
        }

        .event-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(10, 22, 40, 0.9);
            backdrop-filter: blur(10px);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--accent-gold);
            border: 1px solid rgba(212, 175, 55, 0.3);
        }

        /* Event Body */
        .event-body {
            padding: 2rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .event-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .event-title i {
            color: var(--accent-gold);
        }

        .event-description {
            color: rgba(245, 241, 232, 0.7);
            line-height: 1.7;
            margin-bottom: 1.5rem;
            flex-grow: 1;
        }

        .event-details {
            background: rgba(10, 22, 40, 0.4);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .event-detail-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .event-detail-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .event-detail-icon {
            width: 40px;
            height: 40px;
            background: rgba(212, 175, 55, 0.15);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .event-detail-icon i {
            font-size: 1.1rem;
        }

        .event-detail-icon.venue i { color: #ef4444; }
        .event-detail-icon.date i { color: var(--accent-teal); }
        .event-detail-icon.fee i { color: var(--success); }

        .event-detail-content {
            flex: 1;
        }

        .event-detail-label {
            font-size: 0.85rem;
            color: rgba(245, 241, 232, 0.6);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.25rem;
        }

        .event-detail-value {
            color: var(--cream);
            font-weight: 500;
            font-size: 1rem;
        }

        /* Register Button */
        .btn-register {
            width: 100%;
            background: linear-gradient(135deg, var(--accent-gold), #b8963d);
            color: var(--primary-navy);
            border: none;
            padding: 1rem 1.5rem;
            border-radius: 14px;
            font-weight: 800;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-register::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.3), transparent);
            transform: translate(-50%, -50%);
            transition: width 0.5s ease, height 0.5s ease;
        }

        .btn-register:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.4);
            color: var(--primary-navy);
        }

        .btn-register i {
            transition: transform 0.3s ease;
        }

        .btn-register:hover i {
            transform: translateX(3px);
        }

        /* Empty State */
        .empty-state {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            padding: 4rem 2rem;
            text-align: center;
            animation: fade-in-up 0.8s ease;
        }

        .empty-state-icon {
            width: 120px;
            height: 120px;
            background: rgba(212, 175, 55, 0.1);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 2rem;
        }

        .empty-state-icon i {
            font-size: 4rem;
            color: rgba(212, 175, 55, 0.4);
        }

        .empty-state h3 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: rgba(245, 241, 232, 0.6);
            font-size: 1.1rem;
            max-width: 500px;
            margin: 0 auto;
        }

        /* Responsive */
        @media (max-width: 991px) {
            .events-grid {
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            }

            .page-title {
                font-size: 2.5rem;
            }
        }

        @media (max-width: 576px) {
            .events-grid {
                grid-template-columns: 1fr;
            }

            .page-title {
                font-size: 2rem;
            }

            .page-hero-icon {
                width: 80px;
                height: 80px;
            }

            .page-hero-icon i {
                font-size: 2.5rem;
            }

            .event-body {
                padding: 1.5rem;
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

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-graduation-cap"></i> University Events
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard.jsp">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="register-event.jsp">
                            <i class="fas fa-calendar"></i> Events
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="my-registrations.jsp">
                            <i class="fas fa-ticket-alt"></i> My Registrations
                        </a>
                    </li>
                    <li class="nav-item">
                        <span class="navbar-text text-white me-3">
                            <i class="fas fa-user"></i> <%= username %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-container">
        <div class="container">
            <!-- Page Hero -->
            <div class="page-hero">
                <div class="page-hero-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <h1 class="page-title">Available Events</h1>
                <p class="page-subtitle">Browse and register for upcoming university events</p>
            </div>

            <!-- Events Grid -->
            <% 
            if (events != null && !events.isEmpty()) {
                java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
                boolean foundFutureEvent = false;
            %>
                <div class="events-grid">
                <% 
                for (Event event : events) {
                    if (event.getEventDate().before(now)) {
                        continue;
                    }
                    foundFutureEvent = true;
                    
                    String eventImage = event.getEventImage();
                    boolean hasImage = (eventImage != null && !eventImage.isEmpty());
                    String imageSrc = hasImage ? request.getContextPath() + "/" + eventImage : "";
                %>
                    <div class="event-card">
                        <!-- Event Image -->
                        <div class="event-image-container">
                            <% if (hasImage) { %>
                                <img src="<%= imageSrc %>" 
                                     class="event-image" 
                                     alt="<%= event.getName() %>"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <i class="fas fa-calendar-star event-image-placeholder" style="display: none;"></i>
                            <% } else { %>
                                <i class="fas fa-calendar-star event-image-placeholder"></i>
                            <% } %>
                            <span class="event-badge">
                                <i class="fas fa-ticket-alt"></i> Open
                            </span>
                        </div>
                        
                        <!-- Event Body -->
                        <div class="event-body">
                            <h3 class="event-title">
                                <i class="fas fa-star"></i>
                                <span><%= event.getName() %></span>
                            </h3>
                            
                            <p class="event-description">
                                <%= event.getDescription() != null && !event.getDescription().isEmpty() 
                                    ? event.getDescription() 
                                    : "Join us for this exciting university event. Don't miss out on this amazing opportunity!" %>
                            </p>
                            
                            <div class="event-details">
                                <div class="event-detail-item">
                                    <div class="event-detail-icon venue">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div class="event-detail-content">
                                        <div class="event-detail-label">Venue</div>
                                        <div class="event-detail-value"><%= event.getVenue() %></div>
                                    </div>
                                </div>
                                
                                <div class="event-detail-item">
                                    <div class="event-detail-icon date">
                                        <i class="fas fa-calendar-check"></i>
                                    </div>
                                    <div class="event-detail-content">
                                        <div class="event-detail-label">Date & Time</div>
                                        <div class="event-detail-value"><%= dateFormat.format(event.getEventDate()) %></div>
                                    </div>
                                </div>
                                
                                <div class="event-detail-item">
                                    <div class="event-detail-icon fee">
                                        <i class="fas fa-rupee-sign"></i>
                                    </div>
                                    <div class="event-detail-content">
                                        <div class="event-detail-label">Registration Fee</div>
                                        <div class="event-detail-value">₹<%= event.getFee() %></div>
                                    </div>
                                </div>
                            </div>
                            
                            <a href="register-event.jsp?eventId=<%= event.getId() %>" class="btn-register">
                                <i class="fas fa-check-circle"></i>
                                <span>Register Now</span>
                            </a>
                        </div>
                    </div>
                <% 
                }
                %>
                </div>
                
                <% if (!foundFutureEvent) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-calendar-times"></i>
                        </div>
                        <h3>No Upcoming Events</h3>
                        <p>There are no active events available for registration at the moment. Please check back later for exciting new events!</p>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fas fa-calendar-times"></i>
                    </div>
                    <h3>No Events Available</h3>
                    <p>No events are currently available. Please check back later!</p>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add staggered animation to event cards
        document.addEventListener('DOMContentLoaded', function() {
            const eventCards = document.querySelectorAll('.event-card');
            eventCards.forEach((card, index) => {
                card.style.animation = `fade-in-up 0.6s ease ${0.1 * index}s backwards`;
            });
        });

        // Smooth scroll to top on load
        window.scrollTo({ top: 0, behavior: 'smooth' });
    </script>
</body>
</html>
