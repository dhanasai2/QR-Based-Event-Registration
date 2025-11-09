<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%@ page import="com.event.model.Registration" %>  

<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    EventDAO eventDAO = new EventDAO();
    RegistrationDAO registrationDAO = new RegistrationDAO();
    UserDAO userDAO = new UserDAO();
    
    List<Event> events = eventDAO.getAllEvents();
    List<Registration> pendingRegistrations = registrationDAO.getPendingRegistrations();
    List<User> participants = userDAO.getAllUsersByRole("participant");
    
    int totalEvents = events.size();
    int totalParticipants = participants.size();
    int pendingApprovals = pendingRegistrations.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - University Events</title>
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

        .sidebar .nav-link {
            color: rgba(245, 241, 232, 0.7);
            padding: 1rem 1.5rem;
            margin: 0.25rem 0;
            border-left: 3px solid transparent;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
        }

        .sidebar .nav-link:hover {
            color: var(--accent-gold);
            background: rgba(212, 175, 55, 0.1);
            border-left-color: var(--accent-gold);
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            color: var(--accent-gold);
            background: rgba(212, 175, 55, 0.15);
            border-left-color: var(--accent-gold);
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.2);
        }

        .sidebar .nav-link i {
            font-size: 1.1rem;
            width: 20px;
        }

        .sidebar .badge {
            margin-left: auto;
        }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            padding: 2rem;
            position: relative;
            z-index: 1;
            min-height: calc(100vh - 76px);
        }

        /* Page Header */
        .page-header {
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

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
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

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
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

        .stat-card.danger::before {
            background: linear-gradient(180deg, var(--error), var(--accent-rose));
        }

        .stat-card:hover {
            transform: translateY(-8px);
            border-color: var(--accent-gold);
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.2);
        }

        .stat-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-info h6 {
            color: rgba(245, 241, 232, 0.7);
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.75rem;
        }

        .stat-info .stat-value {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--cream);
            line-height: 1;
        }

        .stat-icon-wrapper {
            width: 70px;
            height: 70px;
            background: rgba(212, 175, 55, 0.15);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-icon-wrapper {
            transform: scale(1.1) rotate(5deg);
        }

        .stat-icon-wrapper i {
            font-size: 2rem;
        }

        .stat-card.primary .stat-icon-wrapper {
            background: rgba(212, 175, 55, 0.15);
        }

        .stat-card.primary .stat-icon-wrapper i {
            color: var(--accent-gold);
        }

        .stat-card.success .stat-icon-wrapper {
            background: rgba(16, 185, 129, 0.15);
        }

        .stat-card.success .stat-icon-wrapper i {
            color: var(--success);
        }

        .stat-card.warning .stat-icon-wrapper {
            background: rgba(245, 158, 11, 0.15);
        }

        .stat-card.warning .stat-icon-wrapper i {
            color: var(--warning);
        }

        .stat-card.danger .stat-icon-wrapper {
            background: rgba(239, 68, 68, 0.15);
        }

        .stat-card.danger .stat-icon-wrapper i {
            color: var(--error);
        }

        /* Table Card */
        .table-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 20px;
            overflow: hidden;
            animation: card-entrance 0.6s ease 0.5s backwards;
        }

        .table-card-header {
            background: rgba(10, 22, 40, 0.5);
            padding: 1.5rem 2rem;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .table-card-header h6 {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--cream);
            margin: 0;
        }

        .table-card-body {
            padding: 2rem;
        }

        .table {
            color: var(--warm-white);
            margin-bottom: 0;
        }

        .table thead th {
            background: rgba(10, 22, 40, 0.5);
            color: var(--cream);
            font-weight: 600;
            border-bottom: 2px solid rgba(212, 175, 55, 0.2);
            padding: 1rem;
        }

        .table tbody tr {
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background: rgba(212, 175, 55, 0.05);
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
        }

        .badge {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .bg-success {
            background: var(--success) !important;
        }

        .bg-secondary {
            background: #6b7280 !important;
        }

        .bg-danger {
            background: var(--error) !important;
        }

        .btn-info {
            background: linear-gradient(135deg, var(--accent-teal), var(--accent-lavender));
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-info:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(91, 192, 190, 0.4);
            color: white;
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
        }

        @media (max-width: 576px) {
            .page-header h1 {
                font-size: 2rem;
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

    <div class="container-fluid">
        <div class="row">
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
                        <a class="nav-link" href="events.jsp">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Events</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="approvals.jsp">
                            <i class="fas fa-check-circle"></i>
                            <span>Approvals</span>
                            <% if (pendingApprovals > 0) { %>
                                <span class="badge bg-danger"><%= pendingApprovals %></span>
                            <% } %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="scan-qr.jsp">
                            <i class="fas fa-qrcode"></i>
                            <span>Scan QR</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reports.jsp">
                            <i class="fas fa-chart-bar"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1><i class="fas fa-tachometer-alt" style="color: var(--accent-gold);"></i> Admin Dashboard</h1>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-content">
                            <div class="stat-info">
                                <h6>Total Events</h6>
                                <div class="stat-value"><%= totalEvents %></div>
                            </div>
                            <div class="stat-icon-wrapper">
                                <i class="fas fa-calendar"></i>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card success">
                        <div class="stat-content">
                            <div class="stat-info">
                                <h6>Total Participants</h6>
                                <div class="stat-value"><%= totalParticipants %></div>
                            </div>
                            <div class="stat-icon-wrapper">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card warning">
                        <div class="stat-content">
                            <div class="stat-info">
                                <h6>Pending Approvals</h6>
                                <div class="stat-value"><%= pendingApprovals %></div>
                            </div>
                            <div class="stat-icon-wrapper">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card danger">
                        <div class="stat-content">
                            <div class="stat-info">
                                <h6>Active Events</h6>
                                <div class="stat-value"><%= eventDAO.getActiveEvents().size() %></div>
                            </div>
                            <div class="stat-icon-wrapper">
                                <i class="fas fa-check"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Events Table -->
                <div class="table-card">
                    <div class="table-card-header">
                        <h6><i class="fas fa-calendar-alt" style="color: var(--accent-gold); margin-right: 0.5rem;"></i>Recent Events</h6>
                    </div>
                    <div class="table-card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Event Name</th>
                                        <th>Venue</th>
                                        <th>Date</th>
                                        <th>Capacity</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    int count = 0;
                                    for (Event event : events) {
                                        if (count++ >= 5) break;
                                    %>
                                    <tr>
                                        <td><strong><%= event.getName() %></strong></td>
                                        <td><%= event.getVenue() %></td>
                                        <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm").format(event.getEventDate()) %></td>
                                        <td><%= event.getCapacity() %></td>
                                        <td>
                                            <span class="badge bg-<%= event.getStatus().equals("active") ? "success" : "secondary" %>">
                                                <%= event.getStatus().toUpperCase() %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="events.jsp?view=<%= event.getId() %>" class="btn btn-sm btn-info">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                        </td>
                                    </tr>
                                    <% } 
                                    if (events.isEmpty()) {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center" style="padding: 2rem; color: rgba(245, 241, 232, 0.6);">
                                            <i class="fas fa-info-circle fa-2x mb-2"></i>
                                            <p class="mb-0">No events available</p>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
