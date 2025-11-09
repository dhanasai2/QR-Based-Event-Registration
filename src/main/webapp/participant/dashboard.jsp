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
    EventDAO eventDAO = new EventDAO();
    
    List<Registration> myRegistrations = registrationDAO.getRegistrationsByUserId(userId);
    List<Event> activeEvents = eventDAO.getActiveEvents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Participant Dashboard - University Events</title>
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
            --sidebar-bg: rgba(22, 37, 68, 0.95);
            --card-bg: rgba(22, 37, 68, 0.6);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(212, 175, 55, 0.06), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(91, 192, 190, 0.06), transparent 60%),
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
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, var(--accent-gold) 0%, transparent 70%);
            top: -10%;
            right: 10%;
            animation-duration: 35s;
        }

        .orb-2 {
            width: 350px;
            height: 350px;
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

        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 76px;
            bottom: 0;
            left: 0;
            width: 260px;
            background: var(--sidebar-bg);
            backdrop-filter: blur(20px);
            border-right: 1px solid rgba(212, 175, 55, 0.1);
            padding: 2rem 0;
            overflow-y: auto;
            z-index: 100;
        }

        .sidebar::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(10, 22, 40, 0.3);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: var(--accent-gold);
            border-radius: 3px;
        }

        .nav-link {
            color: rgba(245, 241, 232, 0.7) !important;
            padding: 1rem 1.5rem;
            margin: 0.25rem 0;
            border-left: 3px solid transparent;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
        }

        .nav-link:hover {
            color: var(--accent-gold) !important;
            background: rgba(212, 175, 55, 0.1);
            border-left-color: var(--accent-gold);
            transform: translateX(5px);
        }

        .nav-link.active {
            color: var(--accent-gold) !important;
            background: rgba(212, 175, 55, 0.15);
            border-left-color: var(--accent-gold);
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.2);
        }

        .nav-link i {
            font-size: 1.1rem;
            width: 20px;
        }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            padding: 2rem;
            position: relative;
            z-index: 1;
            min-height: calc(100vh - 76px);
        }

        /* Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            animation: fade-in-down 0.6s ease;
        }

        @keyframes fade-in-down {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--cream), var(--accent-gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin: 0;
        }

        /* Alert */
        .alert {
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

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 20px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            animation: card-entrance 0.6s ease backwards;
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }

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

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(180deg, var(--accent-gold), var(--accent-rose));
        }

        .stat-card:hover {
            transform: translateY(-8px);
            border-color: var(--accent-gold);
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.2);
        }

        .stat-card.primary::before {
            background: linear-gradient(180deg, var(--accent-gold), var(--accent-rose));
        }

        .stat-card.success::before {
            background: linear-gradient(180deg, var(--success), var(--accent-teal));
        }

        .stat-card.warning::before {
            background: linear-gradient(180deg, var(--warning), var(--accent-gold));
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            background: rgba(212, 175, 55, 0.15);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .stat-icon i {
            font-size: 1.8rem;
            color: var(--accent-gold);
        }

        .stat-card.success .stat-icon {
            background: rgba(16, 185, 129, 0.15);
        }

        .stat-card.success .stat-icon i {
            color: var(--success);
        }

        .stat-card.warning .stat-icon {
            background: rgba(245, 158, 11, 0.15);
        }

        .stat-card.warning .stat-icon i {
            color: var(--warning);
        }

        .stat-label {
            color: rgba(245, 241, 232, 0.7);
            font-size: 0.95rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 700;
            color: var(--cream);
            line-height: 1;
        }

        /* Section Card */
        .section-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            overflow: hidden;
            margin-bottom: 2rem;
            animation: card-entrance 0.6s ease 0.4s backwards;
        }

        .section-header {
            background: rgba(10, 22, 40, 0.5);
            padding: 1.5rem 2rem;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--cream);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-title i {
            color: var(--accent-gold);
        }

        .section-body {
            padding: 2rem;
        }

        /* Event Cards */
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
            gap: 1.5rem;
        }

        .event-card {
            background: rgba(10, 22, 40, 0.5);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 20px;
            padding: 2rem;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            position: relative;
            overflow: hidden;
        }

        .event-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-gold), var(--accent-rose));
        }

        .event-card:hover {
            transform: translateY(-5px);
            border-color: var(--accent-gold);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.2);
        }

        .event-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .event-description {
            color: rgba(245, 241, 232, 0.7);
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .event-details {
            list-style: none;
            padding: 0;
            margin-bottom: 1.5rem;
        }

        .event-details li {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem 0;
            color: rgba(245, 241, 232, 0.8);
        }

        .event-details i {
            width: 20px;
            font-size: 1rem;
        }

        .event-details .fa-map-marker-alt { color: var(--error); }
        .event-details .fa-clock { color: var(--accent-teal); }
        .event-details .fa-rupee-sign { color: var(--success); }

        .btn-register {
            background: linear-gradient(135deg, var(--accent-gold), #b8963d);
            color: var(--primary-navy);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 5px 15px rgba(212, 175, 55, 0.3);
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(212, 175, 55, 0.4);
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
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state i {
            font-size: 4rem;
            color: rgba(212, 175, 55, 0.3);
            margin-bottom: 1.5rem;
        }

        .empty-state h3 {
            color: var(--cream);
            margin-bottom: 0.75rem;
        }

        .empty-state p {
            color: rgba(245, 241, 232, 0.6);
        }

        /* Responsive */
        @media (max-width: 991px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .sidebar.show {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .events-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            .page-header h1 {
                font-size: 2rem;
            }

            .stat-value {
                font-size: 2.5rem;
            }

            .main-content {
                padding: 1rem;
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

    <!-- Sidebar -->
    <nav class="sidebar">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link active" href="dashboard.jsp">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="register-event.jsp">
                    <i class="fas fa-calendar-plus"></i>
                    <span>Register Event</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="my-registrations.jsp">
                    <i class="fas fa-list"></i>
                    <span>My Registrations</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="feedback.jsp">
                    <i class="fas fa-comment"></i>
                    <span>Feedback</span>
                </a>
            </li>
        </ul>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1>Welcome, <%= session.getAttribute("username") %>!</h1>
        </div>

        <!-- Success Message -->
        <% if (request.getParameter("message") != null) { %>
            <div class="alert alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>
                <%= request.getParameter("message").replace("feedbackSubmitted", "Feedback submitted successfully!") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card primary">
                <div class="stat-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="stat-label">Total Registrations</div>
                <div class="stat-value"><%= myRegistrations.size() %></div>
            </div>

            <div class="stat-card success">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-label">Approved</div>
                <div class="stat-value"><%= myRegistrations.stream().filter(r -> "approved".equals(r.getStatus())).count() %></div>
            </div>

            <div class="stat-card warning">
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-label">Pending</div>
                <div class="stat-value"><%= myRegistrations.stream().filter(r -> "pending".equals(r.getStatus())).count() %></div>
            </div>
        </div>

        <!-- Available Events Section -->
        <div class="section-card">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Available Events</span>
                </h2>
            </div>
            <div class="section-body">
                <% if (activeEvents != null && !activeEvents.isEmpty()) { %>
                    <div class="events-grid">
                        <% for (Event event : activeEvents) { %>
                        <div class="event-card">
                            <h3 class="event-title"><%= event.getName() %></h3>
                            <p class="event-description">
                                <%= event.getDescription() != null && !event.getDescription().isEmpty() 
                                    ? event.getDescription() 
                                    : "Join us for this exciting event!" %>
                            </p>
                            <ul class="event-details">
                                <li>
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span><%= event.getVenue() %></span>
                                </li>
                                <li>
                                    <i class="fas fa-clock"></i>
                                    <span><%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(event.getEventDate()) %></span>
                                </li>
                                <li>
                                    <i class="fas fa-rupee-sign"></i>
                                    <span>Fee: ₹<%= event.getFee() %></span>
                                </li>
                            </ul>
                            <a href="register-event.jsp?eventId=<%= event.getId() %>" class="btn-register">
                                <i class="fas fa-plus"></i>
                                <span>Register Now</span>
                            </a>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h3>No Active Events</h3>
                        <p>There are no events available for registration at the moment. Check back soon!</p>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Animate stat values on scroll
        const observerOptions = {
            threshold: 0.3
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const value = entry.target;
                    const target = parseInt(value.textContent);
                    animateValue(value, 0, target, 1000);
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-value').forEach(stat => {
            observer.observe(stat);
        });

        function animateValue(element, start, end, duration) {
            const range = end - start;
            const increment = range / (duration / 16);
            let current = start;

            const timer = setInterval(() => {
                current += increment;
                if (current >= end) {
                    element.textContent = end;
                    clearInterval(timer);
                } else {
                    element.textContent = Math.floor(current);
                }
            }, 16);
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
    </script>
</body>
</html>
