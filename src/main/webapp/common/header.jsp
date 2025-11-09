<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="University Event Management System - QR-based event registration, secure payments, and real-time attendance tracking">
    <meta name="keywords" content="university events, event management, QR code, event registration, student events">
    <meta name="author" content="University Event Management System">
    
    <title><%= request.getParameter("title") != null ? request.getParameter("title") : "University Events" %> - Event Management System</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
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

        html {
            height: 100%;
        }

        body {
            min-height: 100%;
            display: flex;
            flex-direction: column;
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(212, 175, 55, 0.08), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(91, 192, 190, 0.08), transparent 60%),
                        linear-gradient(135deg, var(--primary-navy) 0%, #0d1b2a 50%, var(--primary-navy) 100%);
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

        /* Main content wrapper */
        .main-content {
            flex: 1 0 auto;
            position: relative;
            z-index: 1;
        }

        /* Smooth scroll */
        html {
            scroll-behavior: smooth;
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 10px;
        }

        ::-webkit-scrollbar-track {
            background: var(--primary-navy);
        }

        ::-webkit-scrollbar-thumb {
            background: var(--accent-gold);
            border-radius: 5px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #b8963d;
        }

        /* Loading animation */
        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--primary-navy);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            transition: opacity 0.5s, visibility 0.5s;
        }

        .page-loader.hidden {
            opacity: 0;
            visibility: hidden;
        }

        .loader-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(212, 175, 55, 0.2);
            border-top-color: var(--accent-gold);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Utility classes */
        .text-gold { color: var(--accent-gold); }
        .text-cream { color: var(--cream); }
        .bg-navy { background-color: var(--primary-navy); }
        .bg-card { background-color: var(--card-bg); }
        
        /* Animation classes */
        .fade-in {
            animation: fadeIn 0.6s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Print styles */
        @media print {
            .luxury-bg,
            .page-loader,
            nav,
            footer,
            .no-print {
                display: none !important;
            }
            
            body {
                background: white;
                color: black;
            }
        }
    </style>
</head>
<body>
    <!-- Page Loader -->
    <div class="page-loader" id="pageLoader">
        <div class="loader-spinner"></div>
    </div>

    <!-- Animated Background -->
    <div class="luxury-bg">
        <div class="luxury-orb orb-1"></div>
        <div class="luxury-orb orb-2"></div>
    </div>

    <script>
        // Hide loader after page load
        window.addEventListener('load', function() {
            setTimeout(function() {
                document.getElementById('pageLoader').classList.add('hidden');
            }, 500);
        });

        // Smooth scroll for anchor links
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    const href = this.getAttribute('href');
                    if (href !== '#' && href !== '#!') {
                        const target = document.querySelector(href);
                        if (target) {
                            e.preventDefault();
                            target.scrollIntoView({
                                behavior: 'smooth',
                                block: 'start'
                            });
                        }
                    }
                });
            });
        });

        // Add active class to current nav item
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            document.querySelectorAll('.nav-link').forEach(link => {
                if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                    link.classList.add('active');
                }
            });
        });
    </script>
