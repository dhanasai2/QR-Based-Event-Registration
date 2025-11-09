<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    if (session.getAttribute("userId") == null || 
        (!session.getAttribute("role").equals("organizer") && !session.getAttribute("role").equals("admin"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organizer Dashboard - University Events</title>
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

        /* Page Header */
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

        /* Welcome Card */
        .welcome-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            animation: card-entrance 0.6s ease;
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

        .welcome-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(180deg, var(--accent-teal), var(--accent-lavender));
        }

        .welcome-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .welcome-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--accent-teal), var(--accent-lavender));
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            animation: icon-pulse 2s ease-in-out infinite;
        }

        @keyframes icon-pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .welcome-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--cream);
            margin: 0;
        }

        .welcome-text {
            color: rgba(245, 241, 232, 0.8);
            line-height: 1.7;
            margin-bottom: 1.5rem;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin-bottom: 2rem;
        }

        .feature-list li {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem 0;
            color: rgba(245, 241, 232, 0.8);
        }

        .feature-list li i {
            color: var(--accent-teal);
            font-size: 1.1rem;
            width: 20px;
        }

        .btn-scan {
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

        .btn-scan:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.4);
            color: var(--primary-navy);
        }

        .btn-scan i {
            font-size: 1.2rem;
        }

        /* Stats Section */
        .stats-section {
            margin-top: 2rem;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-title i {
            color: var(--accent-gold);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
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

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
        }

        .stat-card:nth-child(1)::before {
            background: linear-gradient(180deg, var(--accent-gold), var(--accent-rose));
        }

        .stat-card:nth-child(2)::before {
            background: linear-gradient(180deg, var(--success), var(--accent-teal));
        }

        .stat-card:nth-child(3)::before {
            background: linear-gradient(180deg, var(--accent-teal), var(--accent-lavender));
        }

        .stat-card:hover {
            transform: translateY(-8px);
            border-color: var(--accent-gold);
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.2);
        }

        .stat-icon-wrapper {
            width: 70px;
            height: 70px;
            background: rgba(212, 175, 55, 0.15);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-icon-wrapper {
            transform: scale(1.1) rotate(5deg);
        }

        .stat-icon-wrapper i {
            font-size: 2rem;
        }

        .stat-card:nth-child(1) .stat-icon-wrapper {
            background: rgba(212, 175, 55, 0.15);
        }

        .stat-card:nth-child(1) .stat-icon-wrapper i {
            color: var(--accent-gold);
        }

        .stat-card:nth-child(2) .stat-icon-wrapper {
            background: rgba(16, 185, 129, 0.15);
        }

        .stat-card:nth-child(2) .stat-icon-wrapper i {
            color: var(--success);
        }

        .stat-card:nth-child(3) .stat-icon-wrapper {
            background: rgba(91, 192, 190, 0.15);
        }

        .stat-card:nth-child(3) .stat-icon-wrapper i {
            color: var(--accent-teal);
        }

        .stat-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 0.5rem;
        }

        .stat-description {
            color: rgba(245, 241, 232, 0.6);
            font-size: 0.95rem;
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

            .welcome-card {
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
                <a class="nav-link" href="scan-qr.jsp">
                    <i class="fas fa-qrcode"></i>
                    <span>Scan QR Code</span>
                </a>
            </li>
        </ul>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1>Organizer Dashboard</h1>
        </div>

        <!-- Welcome Card -->
        <div class="welcome-card">
            <div class="welcome-header">
                <div class="welcome-icon">
                    <i class="fas fa-user-tie"></i>
                </div>
                <h2 class="welcome-title">Welcome, <%= session.getAttribute("username") %>!</h2>
            </div>
            
            <p class="welcome-text">
                As an event organizer, you have the tools to efficiently manage event attendance and ensure a smooth check-in experience for all participants.
            </p>

            <ul class="feature-list">
                <li>
                    <i class="fas fa-qrcode"></i>
                    <span>Scan participant QR codes at event entry points</span>
                </li>
                <li>
                    <i class="fas fa-check-circle"></i>
                    <span>Mark attendance in real-time with instant verification</span>
                </li>
                <li>
                    <i class="fas fa-shield-check"></i>
                    <span>Verify participant registration status and eligibility</span>
                </li>
                <li>
                    <i class="fas fa-hands-helping"></i>
                    <span>Assist with on-site registration and support</span>
                </li>
            </ul>

            <a href="scan-qr.jsp" class="btn-scan">
                <i class="fas fa-qrcode"></i>
                <span>Start Scanning QR Codes</span>
            </a>
        </div>

        <!-- Stats Section -->
        <div class="stats-section">
            <h3 class="section-title">
                <i class="fas fa-chart-line"></i>
                <span>Quick Overview</span>
            </h3>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <h4 class="stat-title">Active Events</h4>
                    <p class="stat-description">Monitor and manage upcoming events</p>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <i class="fas fa-users"></i>
                    </div>
                    <h4 class="stat-title">Participants</h4>
                    <p class="stat-description">Track registered attendees across events</p>
                </div>

                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h4 class="stat-title">Check-ins</h4>
                    <p class="stat-description">View total scanned QR codes and entries</p>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Smooth scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });

        // Add animation to stat cards on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-card').forEach(card => {
            observer.observe(card);
        });
    </script>
</body>
</html>
