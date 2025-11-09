<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Proof Submitted - Event Registration</title>
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
            --cream: #f5f1e8;
            --warm-white: #faf8f3;
            --success: #10b981;
            --success-light: #34d399;
            --warning: #f59e0b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(245, 158, 11, 0.12), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(91, 192, 190, 0.1), transparent 60%),
                        linear-gradient(135deg, var(--primary-navy) 0%, #0d1b2a 50%, var(--primary-navy) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 2rem 1rem;
            position: relative;
            overflow: hidden;
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
            opacity: 0.1;
            animation: luxury-float 25s ease-in-out infinite;
        }

        .orb-warning {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, var(--warning) 0%, transparent 70%);
            top: -15%;
            right: -10%;
            animation-duration: 30s;
        }

        .orb-teal {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, var(--accent-teal) 0%, transparent 70%);
            bottom: -15%;
            left: -10%;
            animation-duration: 35s;
            animation-delay: 5s;
        }

        @keyframes luxury-float {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(50px, -50px) scale(1.1); }
            66% { transform: translate(-30px, 30px) scale(0.95); }
        }

        /* Confetti Animation */
        .confetti-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            pointer-events: none;
            overflow: hidden;
        }

        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: var(--accent-gold);
            top: -10%;
            animation: confetti-fall linear forwards;
        }

        @keyframes confetti-fall {
            to {
                transform: translateY(110vh) rotate(720deg);
                opacity: 0;
            }
        }

        /* Success Container */
        .success-container {
            max-width: 750px;
            width: 100%;
            margin: 0 auto;
            position: relative;
            z-index: 2;
            animation: success-entrance 0.8s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes success-entrance {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Success Card */
        .success-card {
            background: rgba(22, 37, 68, 0.7);
            backdrop-filter: blur(40px);
            border-radius: 32px;
            overflow: hidden;
            border: 1px solid rgba(245, 158, 11, 0.2);
            box-shadow: 
                0 30px 80px rgba(0, 0, 0, 0.6),
                0 0 0 1px rgba(245, 158, 11, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.05);
        }

        .success-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--warning), transparent);
            animation: shimmer-line 3s ease-in-out infinite;
        }

        @keyframes shimmer-line {
            0%, 100% { opacity: 0.3; }
            50% { opacity: 1; }
        }

        /* Success Icon Section */
        .success-icon-section {
            padding: 3rem 2rem 2rem;
            text-align: center;
            position: relative;
        }

        .success-icon-wrapper {
            position: relative;
            display: inline-block;
            margin-bottom: 1.5rem;
        }

        .success-icon-bg {
            position: absolute;
            inset: -25px;
            background: radial-gradient(circle, rgba(245, 158, 11, 0.3), transparent 70%);
            border-radius: 50%;
            animation: pulse-success 2s ease-in-out infinite;
        }

        @keyframes pulse-success {
            0%, 100% {
                transform: scale(1);
                opacity: 0.5;
            }
            50% {
                transform: scale(1.15);
                opacity: 0.8;
            }
        }

        .success-icon {
            position: relative;
            width: 140px;
            height: 140px;
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.2), rgba(251, 191, 36, 0.2));
            backdrop-filter: blur(10px);
            border: 4px solid var(--warning);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: success-scale 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) 0.3s backwards;
            box-shadow: 
                0 20px 60px rgba(245, 158, 11, 0.4),
                inset 0 2px 10px rgba(255, 255, 255, 0.2);
        }

        @keyframes success-scale {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            60% {
                transform: scale(1.15);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        .success-icon i {
            font-size: 5rem;
            color: var(--warning);
            animation: icon-draw 0.8s ease 0.5s backwards;
        }

        @keyframes icon-draw {
            0% {
                transform: scale(0) rotate(-45deg);
                opacity: 0;
            }
            100% {
                transform: scale(1) rotate(0deg);
                opacity: 1;
            }
        }

        .success-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--warning) 0%, #fbbf24 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.75rem;
            animation: title-reveal 0.8s ease 0.6s backwards;
        }

        @keyframes title-reveal {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .success-subtitle {
            font-size: 1.15rem;
            color: rgba(245, 241, 232, 0.8);
            margin-bottom: 1rem;
            animation: subtitle-reveal 0.8s ease 0.7s backwards;
            line-height: 1.6;
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

        .registration-id {
            display: inline-block;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            color: var(--primary-navy);
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            font-weight: 800;
            font-size: 1.1rem;
            margin-top: 0.5rem;
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
            animation: badge-pop 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) 0.8s backwards;
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

        .registration-id i {
            margin-right: 0.5rem;
        }

        /* Success Body */
        .success-body {
            padding: 2rem 2.5rem 2.5rem;
        }

        /* Info Alert */
        .info-alert {
            background: rgba(245, 158, 11, 0.1);
            border: 2px solid rgba(245, 158, 11, 0.3);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            animation: alert-slide 0.6s ease 0.9s backwards;
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

        .info-alert::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(180deg, var(--warning), var(--accent-gold));
            animation: glow-bar 2s ease-in-out infinite;
        }

        @keyframes glow-bar {
            0%, 100% { opacity: 0.6; }
            50% { opacity: 1; }
        }

        .info-alert-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .info-alert-icon {
            width: 50px;
            height: 50px;
            background: rgba(245, 158, 11, 0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--warning);
            font-size: 1.5rem;
        }

        .info-alert-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--cream);
            margin: 0;
        }

        .info-alert-content {
            color: rgba(245, 241, 232, 0.85);
            line-height: 1.7;
            font-size: 1rem;
        }

        .info-alert-content strong {
            color: var(--warning);
            font-weight: 700;
        }

        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(245, 158, 11, 0.2);
            border: 2px solid var(--warning);
            color: var(--warning);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.9rem;
            margin-top: 1rem;
        }

        .status-badge i {
            animation: spin-pulse 2s ease-in-out infinite;
        }

        @keyframes spin-pulse {
            0%, 100% { transform: rotate(0deg) scale(1); }
            25% { transform: rotate(90deg) scale(1.1); }
            50% { transform: rotate(180deg) scale(1); }
            75% { transform: rotate(270deg) scale(1.1); }
        }

        /* Timeline Steps */
        .next-steps {
            background: rgba(10, 22, 40, 0.4);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .next-steps-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .next-steps-title i {
            color: var(--accent-gold);
        }

        .step-item {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.25rem;
            animation: step-reveal 0.5s ease backwards;
        }

        .step-item:last-child {
            margin-bottom: 0;
        }

        .step-item:nth-child(2) { animation-delay: 1s; }
        .step-item:nth-child(3) { animation-delay: 1.1s; }
        .step-item:nth-child(4) { animation-delay: 1.2s; }
        .step-item:nth-child(5) { animation-delay: 1.3s; }

        @keyframes step-reveal {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .step-number {
            width: 35px;
            height: 35px;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            color: var(--primary-navy);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            flex-shrink: 0;
        }

        .step-content {
            flex: 1;
            padding-top: 0.25rem;
        }

        .step-content strong {
            color: var(--cream);
            display: block;
            margin-bottom: 0.25rem;
        }

        .step-content span {
            color: rgba(245, 241, 232, 0.7);
            font-size: 0.9rem;
        }

        /* Important Notice */
        .important-notice {
            background: rgba(91, 192, 190, 0.1);
            border: 1px solid rgba(91, 192, 190, 0.3);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            gap: 1rem;
            align-items: flex-start;
        }

        .notice-icon {
            width: 40px;
            height: 40px;
            background: rgba(91, 192, 190, 0.2);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--accent-teal);
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .notice-content {
            flex: 1;
        }

        .notice-title {
            color: var(--accent-teal);
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }

        .notice-text {
            color: rgba(245, 241, 232, 0.8);
            font-size: 0.9rem;
            line-height: 1.6;
        }

        /* Divider */
        .divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212, 175, 55, 0.3), transparent);
            margin: 2rem 0;
        }

        /* Action Buttons */
        .action-buttons {
            display: grid;
            gap: 1rem;
        }

        .btn-primary-action {
            width: 100%;
            background: linear-gradient(135deg, var(--accent-gold) 0%, #b8963d 100%);
            color: var(--primary-navy);
            border: none;
            border-radius: 14px;
            padding: 1.1rem 2rem;
            font-weight: 700;
            font-size: 1.05rem;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            animation: button-reveal 0.6s ease 1.4s backwards;
        }

        @keyframes button-reveal {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .btn-primary-action::before {
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

        .btn-primary-action:hover::before {
            width: 400px;
            height: 400px;
        }

        .btn-primary-action:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.4);
            color: var(--primary-navy);
        }

        .btn-secondary-action {
            width: 100%;
            background: rgba(22, 37, 68, 0.6);
            color: var(--cream);
            border: 2px solid rgba(212, 175, 55, 0.2);
            border-radius: 14px;
            padding: 1rem 2rem;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            animation: button-reveal 0.6s ease 1.5s backwards;
        }

        .btn-secondary-action:hover {
            background: rgba(22, 37, 68, 0.8);
            border-color: var(--accent-teal);
            color: var(--accent-teal);
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(91, 192, 190, 0.2);
        }

        /* Responsive */
        @media (max-width: 576px) {
            .success-container {
                padding: 1rem;
            }

            .success-icon-section {
                padding: 2rem 1.5rem 1.5rem;
            }

            .success-icon {
                width: 110px;
                height: 110px;
            }

            .success-icon i {
                font-size: 4rem;
            }

            .success-title {
                font-size: 2.2rem;
            }

            .success-body {
                padding: 1.5rem;
            }

            .info-alert, .next-steps {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="luxury-bg">
        <div class="luxury-orb orb-warning"></div>
        <div class="luxury-orb orb-teal"></div>
    </div>

    <!-- Confetti Container -->
    <div class="confetti-container" id="confettiContainer"></div>

    <div class="success-container">
        <div class="success-card">
            <!-- Success Icon Section -->
            <div class="success-icon-section">
                <div class="success-icon-wrapper">
                    <div class="success-icon-bg"></div>
                    <div class="success-icon">
                        <i class="fas fa-clock-rotate-left"></i>
                    </div>
                </div>
                <h1 class="success-title">Proof Submitted!</h1>
                <p class="success-subtitle">
                    Your payment proof has been submitted successfully.<br>
                    Awaiting admin verification.
                </p>
                <div class="registration-id">
                    <i class="fas fa-ticket-alt"></i>
                    REG-<%= request.getParameter("regId") != null ? request.getParameter("regId") : "XXXXX" %>
                </div>
                <div class="status-badge">
                    <i class="fas fa-hourglass-half"></i>
                    <span>Pending Verification</span>
                </div>
            </div>

            <!-- Success Body -->
            <div class="success-body">
                <!-- Info Alert -->
                <div class="info-alert">
                    <div class="info-alert-header">
                        <div class="info-alert-icon">
                            <i class="fas fa-shield-check"></i>
                        </div>
                        <h3 class="info-alert-title">Payment Under Review</h3>
                    </div>
                    <p class="info-alert-content">
                        Thank you for submitting your payment proof! Our admin team will <strong>verify your payment details</strong> and approve your registration. This typically takes <strong>24-48 hours</strong>. You'll receive an email confirmation once approved.
                    </p>
                </div>

                <!-- Important Notice -->
                <div class="important-notice">
                    <div class="notice-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div class="notice-content">
                        <div class="notice-title">Check Your Email</div>
                        <div class="notice-text">
                            We've sent a confirmation email with your registration details. 
                            Please check your inbox and spam folder.
                        </div>
                    </div>
                </div>

                <!-- Next Steps -->
                <div class="next-steps">
                    <h3 class="next-steps-title">
                        <i class="fas fa-list-check"></i>
                        What Happens Next?
                    </h3>
                    
                    <div class="step-item">
                        <div class="step-number">1</div>
                        <div class="step-content">
                            <strong>Payment Verification</strong>
                            <span>Admin will verify your UTR number and payment screenshot</span>
                        </div>
                    </div>
                    
                    <div class="step-item">
                        <div class="step-number">2</div>
                        <div class="step-content">
                            <strong>Registration Approval</strong>
                            <span>Once payment is verified, your registration will be approved</span>
                        </div>
                    </div>
                    
                    <div class="step-item">
                        <div class="step-number">3</div>
                        <div class="step-content">
                            <strong>Confirmation Email</strong>
                            <span>You'll receive an approval email with event details</span>
                        </div>
                    </div>
                    
                    <div class="step-item">
                        <div class="step-number">4</div>
                        <div class="step-content">
                            <strong>QR Code Generation</strong>
                            <span>Your unique entry QR code will be generated and sent via email</span>
                        </div>
                    </div>
                </div>

                <div class="divider"></div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/participant/my-registrations.jsp" 
                       class="btn-primary-action">
                        <i class="fas fa-list"></i>
                        <span>View My Registrations</span>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/participant/dashboard.jsp" 
                       class="btn-secondary-action">
                        <i class="fas fa-home"></i>
                        <span>Go to Dashboard</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Create Confetti Animation
        function createConfetti() {
            const container = document.getElementById('confettiContainer');
            const colors = ['#d4af37', '#e8b4b8', '#5bc0be', '#f59e0b', '#fbbf24'];
            const confettiCount = 40;

            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.classList.add('confetti');
                
                // Random properties
                confetti.style.left = Math.random() * 100 + '%';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.animationDuration = (Math.random() * 3 + 2) + 's';
                confetti.style.animationDelay = Math.random() * 2 + 's';
                confetti.style.width = (Math.random() * 8 + 6) + 'px';
                confetti.style.height = confetti.style.width;
                
                container.appendChild(confetti);
            }

            // Remove confetti after animation
            setTimeout(() => {
                container.innerHTML = '';
            }, 6000);
        }

        // Create confetti on load
        window.addEventListener('load', () => {
            setTimeout(createConfetti, 500);
        });

        // Add smooth animations to buttons
        document.querySelectorAll('.btn-secondary-action').forEach(button => {
            button.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-4px)';
            });
            
            button.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Auto-refresh status every 30 seconds (optional)
        // Uncomment if you want to check verification status periodically
        /*
        setInterval(() => {
            // AJAX call to check payment verification status
            fetch('${pageContext.request.contextPath}/checkPaymentStatus?regId=<%= request.getParameter("regId") %>')
                .then(response => response.json())
                .then(data => {
                    if (data.verified) {
                        window.location.href = '${pageContext.request.contextPath}/participant/my-registrations.jsp?verified=true';
                    }
                });
        }, 30000); // Check every 30 seconds
        */
    </script>
</body>
</html>
