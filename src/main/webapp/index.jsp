<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>University Event Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-navy: #0a1628;
            --secondary-navy: #162544;
            --accent-gold: #d4af37;
            --accent-rose: #e8b4b8;
            --accent-teal: #5bc0be;
            --accent-lavender: #9d84b7;
            --cream: #f5f1e8;
            --warm-white: #faf8f3;
            --charcoal: #2d2d2d;
            --slate: #475569;
        }

        body {
            font-family: 'Inter', sans-serif;
            color: var(--warm-white);
            overflow-x: hidden;
            background: var(--primary-navy);
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
            overflow: hidden;
        }

        .luxury-orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(120px);
            opacity: 0.12;
            animation: luxury-float 25s ease-in-out infinite;
        }

        .orb-gold {
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, var(--accent-gold) 0%, transparent 70%);
            top: -15%;
            right: -10%;
            animation-duration: 30s;
        }

        .orb-teal {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, var(--accent-teal) 0%, transparent 70%);
            bottom: -15%;
            left: -10%;
            animation-duration: 35s;
            animation-delay: 5s;
        }

        .orb-lavender {
            width: 450px;
            height: 450px;
            background: radial-gradient(circle, var(--accent-lavender) 0%, transparent 70%);
            top: 50%;
            left: 50%;
            animation-duration: 40s;
            animation-delay: 10s;
        }

        @keyframes luxury-float {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(50px, -50px) scale(1.1); }
            66% { transform: translate(-30px, 30px) scale(0.95); }
        }

        /* Navigation */
        .navbar-luxury {
            background: rgba(22, 37, 68, 0.9) !important;
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            padding: 1.25rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            animation: navbar-slide 0.8s ease;
        }

        @keyframes navbar-slide {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .navbar-brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--cream) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            transition: all 0.3s ease;
        }

        .navbar-brand:hover {
            transform: scale(1.05);
            filter: drop-shadow(0 0 15px rgba(212, 175, 55, 0.4));
        }

        .navbar-brand i {
            color: var(--accent-gold);
            margin-right: 0.5rem;
            animation: icon-spin 3s linear infinite;
        }

        @keyframes icon-spin {
            0%, 90% { transform: rotate(0deg); }
            95% { transform: rotate(15deg); }
            100% { transform: rotate(0deg); }
        }

        .nav-link {
            color: var(--cream) !important;
            font-weight: 600;
            padding: 0.5rem 1.25rem !important;
            margin: 0 0.25rem;
            border-radius: 10px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: var(--accent-gold);
            transform: translateX(-50%);
            transition: width 0.3s ease;
        }

        .nav-link:hover {
            color: var(--accent-gold) !important;
            background: rgba(212, 175, 55, 0.1);
            transform: translateY(-2px);
        }

        .nav-link:hover::before {
            width: 60%;
        }

        .nav-link i {
            margin-right: 0.5rem;
        }

        /* Hero Section */
        .hero-section {
            position: relative;
            min-height: 90vh;
            display: flex;
            align-items: center;
            background: linear-gradient(135deg, var(--primary-navy) 0%, var(--secondary-navy) 100%);
            overflow: hidden;
            z-index: 1;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 30% 30%, rgba(212, 175, 55, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 70% 70%, rgba(91, 192, 190, 0.06) 0%, transparent 50%);
            animation: hero-glow 8s ease-in-out infinite;
        }

        @keyframes hero-glow {
            0%, 100% { opacity: 0.6; }
            50% { opacity: 1; }
        }

        .hero-content {
            position: relative;
            z-index: 2;
            animation: hero-reveal 1.2s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes hero-reveal {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero-badge {
            display: inline-block;
            padding: 0.5rem 1.25rem;
            background: rgba(212, 175, 55, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.3);
            border-radius: 50px;
            color: var(--accent-gold);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            animation: badge-float 3s ease-in-out infinite;
        }

        @keyframes badge-float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-5px); }
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: 4rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 1.5rem;
            animation: title-reveal 1s ease 0.3s backwards;
        }

        @keyframes title-reveal {
            from {
                opacity: 0;
                transform: translateY(30px);
                letter-spacing: 0.1em;
            }
            to {
                opacity: 1;
                transform: translateY(0);
                letter-spacing: normal;
            }
        }

        .hero-title .highlight {
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--accent-rose) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-subtitle {
            font-size: 1.3rem;
            color: rgba(245, 241, 232, 0.8);
            line-height: 1.7;
            margin-bottom: 2.5rem;
            max-width: 600px;
            animation: subtitle-reveal 1s ease 0.5s backwards;
        }

        @keyframes subtitle-reveal {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero-buttons {
            display: flex;
            gap: 1.25rem;
            flex-wrap: wrap;
            animation: buttons-reveal 1s ease 0.7s backwards;
        }

        @keyframes buttons-reveal {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .btn-primary-gold {
            background: linear-gradient(135deg, var(--accent-gold) 0%, #b8963d 100%);
            color: var(--primary-navy);
            border: none;
            padding: 1rem 2.5rem;
            font-weight: 700;
            font-size: 1.05rem;
            border-radius: 12px;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-primary-gold::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.3), transparent);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
        }

        .btn-primary-gold:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-primary-gold:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.5);
            color: var(--primary-navy);
        }

        .btn-outline-gold {
            background: transparent;
            color: var(--accent-gold);
            border: 2px solid var(--accent-gold);
            padding: 1rem 2.5rem;
            font-weight: 700;
            font-size: 1.05rem;
            border-radius: 12px;
            transition: all 0.4s ease;
        }

        .btn-outline-gold:hover {
            background: rgba(212, 175, 55, 0.1);
            border-color: var(--accent-rose);
            color: var(--accent-rose);
            transform: translateY(-4px);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.2);
        }

        /* Stats Section */
        .stats-section {
            position: relative;
            padding: 4rem 0;
            background: rgba(22, 37, 68, 0.5);
            backdrop-filter: blur(20px);
            z-index: 1;
        }

        .stat-card {
            text-align: center;
            padding: 2rem 1rem;
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-number {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--cream) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: rgba(245, 241, 232, 0.7);
            font-size: 1rem;
            font-weight: 600;
        }

        /* Features Section */
        .features-section {
            position: relative;
            padding: 6rem 0;
            z-index: 1;
        }

        .section-header {
            text-align: center;
            margin-bottom: 4rem;
            animation: fade-in-up 0.8s ease;
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

        .section-badge {
            display: inline-block;
            padding: 0.5rem 1.25rem;
            background: rgba(91, 192, 190, 0.1);
            border: 1px solid rgba(91, 192, 190, 0.3);
            border-radius: 50px;
            color: var(--accent-teal);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .section-subtitle {
            font-size: 1.15rem;
            color: rgba(245, 241, 232, 0.7);
            max-width: 700px;
            margin: 0 auto;
        }

        .feature-card {
            background: rgba(22, 37, 68, 0.6);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            padding: 2.5rem;
            height: 100%;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at top left, rgba(212, 175, 55, 0.05), transparent 70%);
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        .feature-card:hover::before {
            opacity: 1;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            border-color: var(--accent-gold);
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.2);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(91, 192, 190, 0.2));
            border-radius: 20px;
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            transition: all 0.4s ease;
        }

        .feature-card:hover .feature-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
        }

        .feature-icon.gold { color: var(--accent-gold); }
        .feature-icon.teal { color: var(--accent-teal); }
        .feature-icon.rose { color: var(--accent-rose); }
        .feature-icon.lavender { color: var(--accent-lavender); }

        .feature-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .feature-description {
            color: rgba(245, 241, 232, 0.7);
            line-height: 1.7;
            margin-bottom: 1.5rem;
        }

        .feature-link {
            color: var(--accent-gold);
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .feature-link:hover {
            color: var(--accent-rose);
            gap: 0.75rem;
        }

        /* How It Works Section */
        .how-it-works-section {
            position: relative;
            padding: 6rem 0;
            background: rgba(10, 22, 40, 0.5);
            z-index: 1;
        }

        .timeline {
            position: relative;
            max-width: 900px;
            margin: 0 auto;
        }

        .timeline-item {
            display: grid;
            grid-template-columns: 1fr 80px 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
            align-items: center;
        }

        .timeline-item:nth-child(even) .timeline-content:first-child {
            order: 3;
        }

        .timeline-content {
            background: rgba(22, 37, 68, 0.6);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 20px;
            padding: 2rem;
            transition: all 0.4s ease;
        }

        .timeline-content:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.2);
            border-color: var(--accent-gold);
        }

        .timeline-number {
            width: 80px;
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            color: var(--primary-navy);
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 700;
            border-radius: 50%;
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.4);
            animation: pulse-number 2s ease-in-out infinite;
        }

        @keyframes pulse-number {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .timeline-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 0.75rem;
        }

        .timeline-description {
            color: rgba(245, 241, 232, 0.7);
            line-height: 1.6;
        }

        /* CTA Section */
        .cta-section {
            position: relative;
            padding: 6rem 0;
            text-align: center;
            z-index: 1;
        }

        .cta-card {
            background: linear-gradient(135deg, var(--secondary-navy) 0%, var(--primary-navy) 100%);
            border: 2px solid rgba(212, 175, 55, 0.3);
            border-radius: 32px;
            padding: 4rem 2rem;
            max-width: 900px;
            margin: 0 auto;
            position: relative;
            overflow: hidden;
        }

        .cta-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 30% 30%, rgba(212, 175, 55, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 70% 70%, rgba(91, 192, 190, 0.08) 0%, transparent 50%);
        }

        .cta-content {
            position: relative;
            z-index: 1;
        }

        .cta-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .cta-subtitle {
            font-size: 1.15rem;
            color: rgba(245, 241, 232, 0.8);
            margin-bottom: 2rem;
        }

        /* Footer */
        .footer {
            position: relative;
            background: rgba(10, 22, 40, 0.8);
            padding: 3rem 0 1.5rem;
            border-top: 1px solid rgba(212, 175, 55, 0.1);
            z-index: 1;
        }

        .footer-content {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 3rem;
            margin-bottom: 2rem;
        }

        .footer-brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--cream) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
        }

        .footer-description {
            color: rgba(245, 241, 232, 0.7);
            line-height: 1.6;
        }

        .footer-title {
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 0.75rem;
        }

        .footer-links a {
            color: rgba(245, 241, 232, 0.7);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--accent-gold);
            padding-left: 5px;
        }

        .footer-bottom {
            padding-top: 2rem;
            border-top: 1px solid rgba(212, 175, 55, 0.1);
            text-align: center;
            color: rgba(245, 241, 232, 0.6);
        }

        /* Responsive */
        @media (max-width: 991px) {
            .hero-title { font-size: 3rem; }
            .section-title { font-size: 2.5rem; }
            .timeline-item { grid-template-columns: 1fr; }
            .timeline-number { margin: 0 auto; }
            .footer-content { grid-template-columns: 1fr 1fr; }
        }

        @media (max-width: 576px) {
            .hero-title { font-size: 2.5rem; }
            .hero-subtitle { font-size: 1.1rem; }
            .section-title { font-size: 2rem; }
            .hero-buttons { flex-direction: column; }
            .footer-content { grid-template-columns: 1fr; }
        }

        /* Scroll Animations */
        .animate-on-scroll {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s cubic-bezier(0.23, 1, 0.32, 1);
        }

        .animate-on-scroll.animated {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="luxury-bg">
        <div class="luxury-orb orb-gold"></div>
        <div class="luxury-orb orb-teal"></div>
        <div class="luxury-orb orb-lavender"></div>
    </div>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-luxury">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-graduation-cap"></i> University Events
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#features">
                            <i class="fas fa-star"></i> Features
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#how-it-works">
                            <i class="fas fa-lightbulb"></i> How It Works
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">
                            <i class="fas fa-sign-in-alt"></i> Login
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="register.jsp">
                            <i class="fas fa-user-plus"></i> Register
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="hero-content">
                <div class="hero-badge">
                    <i class="fas fa-sparkles"></i> Trusted by 10,000+ Students
                </div>
                <h1 class="hero-title">
                    Your Gateway to<br>
                    <span class="highlight">Academic Excellence</span>
                </h1>
                <p class="hero-subtitle">
                    Experience seamless event registration with QR codes, secure payments, and instant confirmations. Join the future of university event management.
                </p>
                <div class="hero-buttons">
                    <a href="register.jsp" class="btn btn-primary-gold">
                        <i class="fas fa-rocket"></i> Get Started Free
                    </a>
                    <a href="#how-it-works" class="btn btn-outline-gold">
                        <i class="fas fa-play-circle"></i> See How It Works
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-6">
                    <div class="stat-card animate-on-scroll">
                        <div class="stat-number" data-target="10000">0</div>
                        <div class="stat-label">Active Users</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card animate-on-scroll">
                        <div class="stat-number" data-target="500">0</div>
                        <div class="stat-label">Events Hosted</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card animate-on-scroll">
                        <div class="stat-number" data-target="98">0</div>
                        <div class="stat-label">% Satisfaction</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card animate-on-scroll">
                        <div class="stat-number" data-target="24">0</div>
                        <div class="stat-label">Hour Support</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="container">
            <div class="section-header">
                <div class="section-badge">
                    <i class="fas fa-crown"></i> Premium Features
                </div>
                <h2 class="section-title">Everything You Need</h2>
                <p class="section-subtitle">
                    Powerful features designed to make event management effortless and efficient for students and organizers alike
                </p>
            </div>

            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card animate-on-scroll">
                        <div class="feature-icon gold">
                            <i class="fas fa-qrcode"></i>
                        </div>
                        <h3 class="feature-title">Smart QR Registration</h3>
                        <p class="feature-description">
                            Get instant QR codes for seamless event check-ins. No more paper tickets or long queues at entry points.
                        </p>
                        <a href="#" class="feature-link">
                            Learn more <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card animate-on-scroll">
                        <div class="feature-icon teal">
                            <i class="fas fa-shield-check"></i>
                        </div>
                        <h3 class="feature-title">Secure Payments</h3>
                        <p class="feature-description">
                            Integrated Razorpay ensures your transactions are safe, fast, and reliable with multiple payment options.
                        </p>
                        <a href="#" class="feature-link">
                            Learn more <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card animate-on-scroll">
                        <div class="feature-icon rose">
                            <i class="fas fa-envelope-open-text"></i>
                        </div>
                        <h3 class="feature-title">Instant Notifications</h3>
                        <p class="feature-description">
                            Receive automated email confirmations with event details, QR codes, and reminders right in your inbox.
                        </p>
                        <a href="#" class="feature-link">
                            Learn more <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card animate-on-scroll">
                        <div class="feature-icon lavender">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3 class="feature-title">Real-time Analytics</h3>
                        <p class="feature-description">
                            Track registrations, attendance, and engagement with comprehensive analytics dashboards and reports.
                        </p>
                        <a href="#" class="feature-link">
                            Learn more <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card animate-on-scroll">
                        <div class="feature-icon gold">
                            <i class="fas fa-users-cog"></i>
                        </div>
                        <h3 class="feature-title">Role Management</h3>
                        <p class="feature-description">
                            Separate dashboards for students, volunteers, and admins with customized access and permissions.
                        </p>
                        <a href="#" class="feature-link">
                            Learn more <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card animate-on-scroll">
                        <div class="feature-icon teal">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h3 class="feature-title">Mobile Optimized</h3>
                        <p class="feature-description">
                            Fully responsive design ensures smooth experience on all devices - desktop, tablet, and mobile.
                        </p>
                        <a href="#" class="feature-link">
                            Learn more <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="how-it-works-section" id="how-it-works">
        <div class="container">
            <div class="section-header">
                <div class="section-badge">
                    <i class="fas fa-route"></i> Simple Process
                </div>
                <h2 class="section-title">How It Works</h2>
                <p class="section-subtitle">
                    Get started in minutes with our streamlined registration process
                </p>
            </div>

            <div class="timeline">
                <div class="timeline-item animate-on-scroll">
                    <div class="timeline-content">
                        <h3 class="timeline-title">Create Account</h3>
                        <p class="timeline-description">
                            Sign up with your university email and get instant access to all events
                        </p>
                    </div>
                    <div class="timeline-number">1</div>
                    <div></div>
                </div>

                <div class="timeline-item animate-on-scroll">
                    <div></div>
                    <div class="timeline-number">2</div>
                    <div class="timeline-content">
                        <h3 class="timeline-title">Browse Events</h3>
                        <p class="timeline-description">
                            Explore upcoming events, workshops, and seminars tailored for you
                        </p>
                    </div>
                </div>

                <div class="timeline-item animate-on-scroll">
                    <div class="timeline-content">
                        <h3 class="timeline-title">Register & Pay</h3>
                        <p class="timeline-description">
                            Complete registration with secure payment and receive instant confirmation
                        </p>
                    </div>
                    <div class="timeline-number">3</div>
                    <div></div>
                </div>

                <div class="timeline-item animate-on-scroll">
                    <div></div>
                    <div class="timeline-number">4</div>
                    <div class="timeline-content">
                        <h3 class="timeline-title">Get QR Code</h3>
                        <p class="timeline-description">
                            Receive your unique QR code via email for hassle-free event entry
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-card">
                <div class="cta-content">
                    <h2 class="cta-title">Ready to Transform Your Event Experience?</h2>
                    <p class="cta-subtitle">
                        Join thousands of students who have already embraced the future of event management
                    </p>
                    <div class="hero-buttons" style="justify-content: center;">
                        <a href="register.jsp" class="btn btn-primary-gold">
                            <i class="fas fa-user-plus"></i> Create Account Now
                        </a>
                        <a href="login.jsp" class="btn btn-outline-gold">
                            <i class="fas fa-sign-in-alt"></i> Sign In
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div>
                    <div class="footer-brand">
                        <i class="fas fa-graduation-cap"></i> University Events
                    </div>
                    <p class="footer-description">
                        The ultimate platform for managing university events with QR codes, secure payments, and real-time notifications.
                    </p>
                </div>
                <div>
                    <h4 class="footer-title">Quick Links</h4>
                    <ul class="footer-links">
                        <li><a href="#features">Features</a></li>
                        <li><a href="#how-it-works">How It Works</a></li>
                        <li><a href="#">Pricing</a></li>
                        <li><a href="#">About Us</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="footer-title">Support</h4>
                    <ul class="footer-links">
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">Contact Us</a></li>
                        <li><a href="#">FAQs</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="footer-title">Account</h4>
                    <ul class="footer-links">
                        <li><a href="login.jsp">Login</a></li>
                        <li><a href="register.jsp">Register</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Security</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 University Event Management System. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Scroll Animations
        const observerOptions = {
            threshold: 0.15,
            rootMargin: '0px 0px -100px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animated');
                }
            });
        }, observerOptions);

        document.querySelectorAll('.animate-on-scroll').forEach(el => {
            observer.observe(el);
        });

        // Counter Animation
        const counters = document.querySelectorAll('.stat-number');
        const speed = 200;

        const animateCounter = (counter) => {
            const target = +counter.getAttribute('data-target');
            const increment = target / speed;
            let count = 0;

            const updateCount = () => {
                count += increment;
                if (count < target) {
                    counter.textContent = Math.ceil(count);
                    setTimeout(updateCount, 10);
                } else {
                    counter.textContent = target + (target === 98 ? '%' : '+');
                }
            };

            updateCount();
        };

        const counterObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const counter = entry.target;
                    animateCounter(counter);
                    counterObserver.unobserve(counter);
                }
            });
        }, { threshold: 0.5 });

        counters.forEach(counter => {
            counterObserver.observe(counter);
        });

        // Smooth Scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>
</body>
</html>
