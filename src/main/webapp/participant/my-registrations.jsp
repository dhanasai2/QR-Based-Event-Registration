<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.RegistrationDAO, com.event.dao.EventDAO, com.event.model.Registration, com.event.model.Event, java.util.List, java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    String username = (String) session.getAttribute("username");
    int userId = (int) session.getAttribute("userId");
    
    RegistrationDAO registrationDAO = new RegistrationDAO();
    EventDAO eventDAO = new EventDAO();
    List<Registration> registrations = registrationDAO.getRegistrationsByUser(userId);
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Registrations - University Events</title>
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
            --warning: #f59e0b;
            --error: #ef4444;
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

        /* Page Hero */
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
        }

        /* Alert */
        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.3);
            border-radius: 14px;
            padding: 1rem 1.25rem;
            color: var(--success);
            margin-bottom: 2rem;
            animation: alert-slide 0.5s ease;
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

        /* Registration Card */
        .registration-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            margin-bottom: 2rem;
            animation: card-entrance 0.6s ease backwards;
        }

        .registration-card:nth-child(odd) { animation-delay: 0.1s; }
        .registration-card:nth-child(even) { animation-delay: 0.2s; }

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

        .registration-card:hover {
            transform: translateY(-8px);
            border-color: var(--accent-gold);
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.25);
        }

        /* Event Thumbnail */
        .event-thumbnail-container {
            position: relative;
            width: 100%;
            height: 250px;
            overflow: hidden;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose), var(--accent-lavender));
        }

        .event-thumbnail {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .registration-card:hover .event-thumbnail {
            transform: scale(1.1);
        }

        .event-thumbnail-placeholder {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: rgba(255, 255, 255, 0.9);
            font-size: 5rem;
            animation: placeholder-pulse 2s ease-in-out infinite;
        }

        @keyframes placeholder-pulse {
            0%, 100% { opacity: 0.7; transform: translate(-50%, -50%) scale(1); }
            50% { opacity: 1; transform: translate(-50%, -50%) scale(1.05); }
        }

        /* Status Badge */
        .status-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.625rem 1.25rem;
            border-radius: 50px;
            font-weight: 800;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255, 255, 255, 0.2);
            z-index: 10;
            animation: badge-pop 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) 0.3s backwards;
        }

        @keyframes badge-pop {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.9);
            color: var(--primary-navy);
            box-shadow: 0 0 20px rgba(245, 158, 11, 0.4);
        }

        .status-approved {
            background: rgba(16, 185, 129, 0.9);
            color: white;
            box-shadow: 0 0 20px rgba(16, 185, 129, 0.4);
        }

        .status-rejected {
            background: rgba(239, 68, 68, 0.9);
            color: white;
            box-shadow: 0 0 20px rgba(239, 68, 68, 0.4);
        }

        /* Card Body */
        .card-body-custom {
            padding: 2rem;
        }

        .event-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .event-name i {
            color: var(--accent-gold);
        }

        /* Details Section */
        .details-grid {
            background: rgba(10, 22, 40, 0.4);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .detail-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
            padding: 0.875rem 0;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .detail-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .detail-icon {
            width: 36px;
            height: 36px;
            background: rgba(212, 175, 55, 0.15);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .detail-icon i {
            font-size: 1rem;
        }

        .detail-icon.venue i { color: var(--error); }
        .detail-icon.date i { color: var(--accent-teal); }
        .detail-icon.fee i { color: var(--success); }
        .detail-icon.id i { color: var(--accent-lavender); }
        .detail-icon.time i { color: var(--warning); }

        .detail-content {
            flex: 1;
        }

        .detail-label {
            font-size: 0.85rem;
            color: rgba(245, 241, 232, 0.6);
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .detail-value {
            color: var(--cream);
            font-weight: 500;
            font-size: 1rem;
        }

        /* Email Notice */
        .email-notice {
            background: rgba(91, 192, 190, 0.1);
            border: 1px solid rgba(91, 192, 190, 0.3);
            border-radius: 14px;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .email-notice-icon {
            width: 50px;
            height: 50px;
            background: rgba(91, 192, 190, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .email-notice-icon i {
            font-size: 1.5rem;
            color: var(--accent-teal);
        }

        .email-notice-content {
            flex: 1;
        }

        .email-notice-title {
            font-weight: 700;
            color: var(--accent-teal);
            margin-bottom: 0.25rem;
        }

        .email-notice-text {
            color: rgba(245, 241, 232, 0.8);
            font-size: 0.95rem;
        }

        /* Status Alerts */
        .status-alert {
            padding: 1rem 1.25rem;
            border-radius: 14px;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .status-alert i {
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .status-alert.warning {
            background: rgba(245, 158, 11, 0.1);
            border: 1px solid rgba(245, 158, 11, 0.3);
            color: var(--warning);
        }

        .status-alert.danger {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: var(--error);
        }

        /* Empty State */
        .empty-state {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            padding: 4rem 2rem;
            text-align: center;
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

        .btn-browse {
            background: linear-gradient(135deg, var(--accent-gold), #b8963d);
            color: var(--primary-navy);
            border: none;
            padding: 1rem 2rem;
            border-radius: 14px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
        }

        .btn-browse:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.4);
            color: var(--primary-navy);
        }

        /* Responsive */
        @media (max-width: 576px) {
            .page-title {
                font-size: 2.5rem;
            }

            .page-hero-icon {
                width: 80px;
                height: 80px;
            }

            .page-hero-icon i {
                font-size: 2.5rem;
            }

            .card-body-custom {
                padding: 1.5rem;
            }

            .event-thumbnail-container {
                height: 200px;
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
                        <a class="nav-link" href="register-event.jsp">
                            <i class="fas fa-calendar"></i> Events
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="my-registrations.jsp">
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
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <h1 class="page-title">My Registrations</h1>
                <p class="page-subtitle">View and manage your event registrations</p>
            </div>

            <!-- Success Alert -->
            <%
                String success = request.getParameter("success");
                if (success != null) {
            %>
                <div class="alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle"></i> Registration successful! Check your email for QR code and ticket details.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Registrations Grid -->
            <div class="row">
                <% 
                if (registrations != null && !registrations.isEmpty()) {
                    for (Registration registration : registrations) {
                        Event event = eventDAO.getEventById(registration.getEventId());
                        if (event == null) continue;
                        
                        String eventImage = event.getEventImage();
                        boolean hasImage = (eventImage != null && !eventImage.isEmpty());
                        String imageSrc = hasImage ? request.getContextPath() + "/" + eventImage : "";
                        
                        String statusClass = "";
                        String statusText = "";
                        String statusIcon = "";
                        
                        switch(registration.getStatus()) {
                            case "pending":
                                statusClass = "status-pending";
                                statusText = "PENDING";
                                statusIcon = "fa-clock";
                                break;
                            case "approved":
                                statusClass = "status-approved";
                                statusText = "APPROVED";
                                statusIcon = "fa-check-circle";
                                break;
                            case "rejected":
                                statusClass = "status-rejected";
                                statusText = "REJECTED";
                                statusIcon = "fa-times-circle";
                                break;
                        }
                %>
                    <div class="col-lg-6">
                        <div class="registration-card">
                            <div class="event-thumbnail-container">
                                <% if (hasImage) { %>
                                    <img src="<%= imageSrc %>" 
                                         class="event-thumbnail"
                                         alt="<%= event.getName() %>"
                                         onerror="this.style.display='none';">
                                    <i class="fas fa-calendar-star event-thumbnail-placeholder" style="display: <%= hasImage ? "none" : "block" %>;"></i>
                                <% } else { %>
                                    <i class="fas fa-calendar-star event-thumbnail-placeholder"></i>
                                <% } %>
                                
                                <span class="status-badge <%= statusClass %>">
                                    <i class="fas <%= statusIcon %>"></i> <%= statusText %>
                                </span>
                            </div>
                            
                            <div class="card-body-custom">
                                <h3 class="event-name">
                                    <i class="fas fa-star"></i>
                                    <span><%= event.getName() %></span>
                                </h3>
                                
                                <div class="details-grid">
                                    <div class="detail-item">
                                        <div class="detail-icon venue">
                                            <i class="fas fa-map-marker-alt"></i>
                                        </div>
                                        <div class="detail-content">
                                            <div class="detail-label">Venue</div>
                                            <div class="detail-value"><%= event.getVenue() %></div>
                                        </div>
                                    </div>
                                    
                                    <div class="detail-item">
                                        <div class="detail-icon date">
                                            <i class="fas fa-calendar-check"></i>
                                        </div>
                                        <div class="detail-content">
                                            <div class="detail-label">Event Date</div>
                                            <div class="detail-value"><%= dateFormat.format(event.getEventDate()) %></div>
                                        </div>
                                    </div>
                                    
                                    <div class="detail-item">
                                        <div class="detail-icon fee">
                                            <i class="fas fa-rupee-sign"></i>
                                        </div>
                                        <div class="detail-content">
                                            <div class="detail-label">Registration Fee</div>
                                            <div class="detail-value">₹<%= event.getFee() %></div>
                                        </div>
                                    </div>
                                    
                                    <div class="detail-item">
                                        <div class="detail-icon id">
                                            <i class="fas fa-hashtag"></i>
                                        </div>
                                        <div class="detail-content">
                                            <div class="detail-label">Registration ID</div>
                                            <div class="detail-value">#<%= registration.getId() %></div>
                                        </div>
                                    </div>
                                    
                                    <div class="detail-item">
                                        <div class="detail-icon time">
                                            <i class="fas fa-clock"></i>
                                        </div>
                                        <div class="detail-content">
                                            <div class="detail-label">Registered On</div>
                                            <div class="detail-value"><%= dateFormat.format(registration.getRegistrationDate()) %></div>
                                        </div>
                                    </div>
                                </div>
                                
                                <% if ("approved".equals(registration.getStatus())) { %>
                                    <!-- Email Notice Instead of QR Code -->
                                    <div class="email-notice">
                                        <div class="email-notice-icon">
                                            <i class="fas fa-envelope-circle-check"></i>
                                        </div>
                                        <div class="email-notice-content">
                                            <div class="email-notice-title">Entry Ticket Sent</div>
                                            <div class="email-notice-text">
                                                Your QR code and event ticket have been sent to your registered email address. Please check your inbox.
                                            </div>
                                        </div>
                                    </div>
                                <% } else if ("pending".equals(registration.getStatus())) { %>
                                    <div class="status-alert warning">
                                        <i class="fas fa-info-circle"></i>
                                        <span>Your registration is pending admin approval. You'll receive your ticket via email once approved.</span>
                                    </div>
                                <% } else if ("rejected".equals(registration.getStatus())) { %>
                                    <div class="status-alert danger">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <span>Your registration was rejected. Please contact the admin for details.</span>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% 
                    }
                } else {
                %>
                    <div class="col-12">
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-inbox"></i>
                            </div>
                            <h3>No Registrations Yet</h3>
                            <p>You haven't registered for any events yet. Start exploring and register for exciting events!</p>
                            <a href="register-event.jsp" class="btn-browse">
                                <i class="fas fa-calendar"></i>
                                <span>Browse Events</span>
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-hide alerts
        document.querySelectorAll('.alert-success').forEach(alert => {
            setTimeout(() => {
                alert.style.transition = 'all 0.4s ease';
                alert.style.opacity = '0';
                alert.style.transform = 'translateX(-30px)';
                setTimeout(() => alert.remove(), 400);
            }, 5000);
        });

        // Smooth scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    </script>
</body>
</html>
