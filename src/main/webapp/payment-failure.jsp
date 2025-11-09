<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submission Failed - Event Registration</title>
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
            --error: #ef4444;
            --warning: #f59e0b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(239, 68, 68, 0.1), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(245, 158, 11, 0.08), transparent 60%),
                        linear-gradient(135deg, var(--primary-navy) 0%, #0d1b2a 50%, var(--primary-navy) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 2rem 1rem;
            position: relative;
            overflow-x: hidden;
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
            opacity: 0.08;
            animation: luxury-float 25s ease-in-out infinite;
        }

        .orb-error {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, var(--error) 0%, transparent 70%);
            top: -15%;
            right: -10%;
            animation-duration: 30s;
        }

        .orb-warning {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, var(--warning) 0%, transparent 70%);
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

        /* Error Container */
        .error-container {
            max-width: 750px;
            width: 100%;
            margin: 0 auto;
            position: relative;
            z-index: 1;
            animation: error-entrance 0.8s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes error-entrance {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Error Card */
        .error-card {
            background: rgba(22, 37, 68, 0.7);
            backdrop-filter: blur(40px);
            border-radius: 32px;
            overflow: hidden;
            border: 1px solid rgba(239, 68, 68, 0.2);
            box-shadow: 
                0 30px 80px rgba(0, 0, 0, 0.6),
                0 0 0 1px rgba(239, 68, 68, 0.15),
                inset 0 1px 0 rgba(255, 255, 255, 0.05);
            animation: shake 0.6s cubic-bezier(0.36, 0.07, 0.19, 0.97);
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-8px); }
            20%, 40%, 60%, 80% { transform: translateX(8px); }
        }

        .error-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--error), transparent);
            animation: shimmer-line 3s ease-in-out infinite;
        }

        @keyframes shimmer-line {
            0%, 100% { opacity: 0.3; }
            50% { opacity: 1; }
        }

        /* Error Icon Section */
        .error-icon-section {
            padding: 3rem 2rem 2rem;
            text-align: center;
            position: relative;
        }

        .error-icon-wrapper {
            position: relative;
            display: inline-block;
            margin-bottom: 1.5rem;
        }

        .error-icon-bg {
            position: absolute;
            inset: -20px;
            background: radial-gradient(circle, rgba(239, 68, 68, 0.2), transparent 70%);
            border-radius: 50%;
            animation: pulse-error 2s ease-in-out infinite;
        }

        @keyframes pulse-error {
            0%, 100% {
                transform: scale(1);
                opacity: 0.5;
            }
            50% {
                transform: scale(1.1);
                opacity: 0.8;
            }
        }

        .error-icon {
            position: relative;
            width: 120px;
            height: 120px;
            background: rgba(239, 68, 68, 0.15);
            backdrop-filter: blur(10px);
            border: 3px solid var(--error);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: icon-bounce 2s ease-in-out infinite;
        }

        @keyframes icon-bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .error-icon i {
            font-size: 4rem;
            color: var(--error);
            animation: icon-pulse 1.5s ease-in-out infinite;
        }

        @keyframes icon-pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .error-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--error);
            margin-bottom: 0.75rem;
        }

        .error-subtitle {
            font-size: 1.15rem;
            color: rgba(245, 241, 232, 0.7);
            margin-bottom: 0;
            line-height: 1.6;
        }

        /* Error Message Box */
        .error-message-box {
            background: rgba(239, 68, 68, 0.1);
            border: 2px solid rgba(239, 68, 68, 0.3);
            border-radius: 16px;
            padding: 1.5rem;
            margin: 1.5rem 2.5rem;
            text-align: center;
        }

        .error-message-text {
            color: var(--error);
            font-weight: 600;
            font-size: 1rem;
            margin: 0;
        }

        /* Error Body */
        .error-body {
            padding: 0 2.5rem 2.5rem;
        }

        /* Info Box */
        .info-box {
            background: rgba(245, 158, 11, 0.1);
            border: 1px solid rgba(245, 158, 11, 0.3);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .info-box::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(180deg, var(--warning), var(--error));
        }

        .info-box-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .info-box-icon {
            width: 40px;
            height: 40px;
            background: rgba(245, 158, 11, 0.2);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--warning);
            font-size: 1.3rem;
        }

        .info-box-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--cream);
            margin: 0;
        }

        .info-box-content {
            color: rgba(245, 241, 232, 0.8);
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .info-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .info-list li {
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            padding: 0.5rem 0;
            color: rgba(245, 241, 232, 0.8);
            font-size: 0.95rem;
        }

        .info-list li i {
            color: var(--warning);
            width: 20px;
            margin-top: 0.2rem;
            flex-shrink: 0;
        }

        /* Tips Box */
        .tips-box {
            background: rgba(91, 192, 190, 0.1);
            border: 1px solid rgba(91, 192, 190, 0.3);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .tips-box::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 5px;
            height: 100%;
            background: var(--accent-teal);
        }

        .tips-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .tips-icon {
            width: 40px;
            height: 40px;
            background: rgba(91, 192, 190, 0.2);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--accent-teal);
            font-size: 1.3rem;
        }

        .tips-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--cream);
            margin: 0;
        }

        .tips-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .tips-list li {
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            padding: 0.5rem 0;
            color: rgba(245, 241, 232, 0.8);
            font-size: 0.95rem;
        }

        .tips-list li i {
            color: var(--accent-teal);
            width: 20px;
            margin-top: 0.2rem;
            flex-shrink: 0;
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

        .btn-retry {
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
        }

        .btn-retry::before {
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

        .btn-retry:hover::before {
            width: 400px;
            height: 400px;
        }

        .btn-retry:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.4);
        }

        .btn-retry i {
            margin-right: 0.5rem;
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
        }

        .btn-secondary-action:hover {
            background: rgba(22, 37, 68, 0.8);
            border-color: var(--accent-teal);
            color: var(--accent-teal);
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(91, 192, 190, 0.2);
        }

        /* Support Section */
        .support-section {
            text-align: center;
            padding: 1.5rem;
            background: rgba(10, 22, 40, 0.3);
            border-radius: 16px;
            margin-top: 2rem;
        }

        .support-text {
            color: rgba(245, 241, 232, 0.6);
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
        }

        .support-email {
            color: var(--accent-gold);
            font-weight: 700;
            text-decoration: none;
            transition: color 0.3s ease;
            font-size: 1rem;
        }

        .support-email:hover {
            color: var(--accent-rose);
        }

        .support-options {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1.5rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }

        .support-option {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: rgba(245, 241, 232, 0.7);
            font-size: 0.875rem;
        }

        .support-option i {
            color: var(--accent-teal);
        }

        /* Responsive */
        @media (max-width: 576px) {
            .error-container {
                padding: 1rem;
            }

            .error-icon-section {
                padding: 2rem 1.5rem 1.5rem;
            }

            .error-icon {
                width: 100px;
                height: 100px;
            }

            .error-icon i {
                font-size: 3rem;
            }

            .error-title {
                font-size: 2rem;
            }

            .error-body {
                padding: 0 1.5rem 1.5rem;
            }

            .error-message-box {
                margin: 1.5rem 1.5rem;
            }

            .info-box, .tips-box {
                padding: 1.5rem;
            }

            .support-options {
                flex-direction: column;
                gap: 0.75rem;
            }
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="luxury-bg">
        <div class="luxury-orb orb-error"></div>
        <div class="luxury-orb orb-warning"></div>
    </div>

    <%
        // Get error parameters
        String errorType = request.getParameter("error");
        String errorMessage = request.getParameter("message");
        
        // Default error message
        if (errorMessage == null || errorMessage.isEmpty()) {
            if ("missing_params".equals(errorType)) {
                errorMessage = "Required information is missing. Please fill all mandatory fields.";
            } else if ("duplicate_utr".equals(errorType)) {
                errorMessage = "This UTR number has already been used. Please check your transaction details.";
            } else if ("invalid_file_type".equals(errorType)) {
                errorMessage = "Invalid file format. Please upload JPG, PNG, or PDF files only.";
            } else if ("no_file".equals(errorType)) {
                errorMessage = "Payment proof screenshot is required. Please upload your payment confirmation.";
            } else if ("file_too_large".equals(errorType)) {
                errorMessage = "File size exceeds 10MB limit. Please upload a smaller file.";
            } else {
                errorMessage = "Something went wrong while processing your request. Please try again.";
            }
        }
    %>

    <div class="error-container">
        <div class="error-card">
            <!-- Error Icon Section -->
            <div class="error-icon-section">
                <div class="error-icon-wrapper">
                    <div class="error-icon-bg"></div>
                    <div class="error-icon">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                </div>
                <h1 class="error-title">Submission Failed</h1>
                <p class="error-subtitle">
                    We couldn't process your payment proof submission
                </p>
            </div>

            <!-- Error Message -->
            <div class="error-message-box">
                <p class="error-message-text">
                    <i class="fas fa-info-circle"></i> <%= errorMessage %>
                </p>
            </div>

            <!-- Error Body -->
            <div class="error-body">
                <!-- Info Box -->
                <div class="info-box">
                    <div class="info-box-header">
                        <div class="info-box-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <h3 class="info-box-title">Common Issues</h3>
                    </div>
                    <p class="info-box-content">
                        Payment proof submission can fail due to several reasons:
                    </p>
                    <ul class="info-list">
                        <li>
                            <i class="fas fa-file-excel"></i>
                            <span><strong>Missing UTR Number:</strong> Transaction ID or UTR is mandatory for verification</span>
                        </li>
                        <li>
                            <i class="fas fa-copy"></i>
                            <span><strong>Duplicate UTR:</strong> This transaction has already been submitted by you or someone else</span>
                        </li>
                        <li>
                            <i class="fas fa-image"></i>
                            <span><strong>Missing Screenshot:</strong> Payment proof image is required to verify the transaction</span>
                        </li>
                        <li>
                            <i class="fas fa-file-alt"></i>
                            <span><strong>Invalid File Format:</strong> Only JPG, PNG, and PDF files are accepted (max 10MB)</span>
                        </li>
                        <li>
                            <i class="fas fa-wifi-slash"></i>
                            <span><strong>Network Issues:</strong> Poor internet connection during file upload</span>
                        </li>
                    </ul>
                </div>

                <!-- Tips Box -->
                <div class="tips-box">
                    <div class="tips-header">
                        <div class="tips-icon">
                            <i class="fas fa-lightbulb"></i>
                        </div>
                        <h3 class="tips-title">How to Fix This</h3>
                    </div>
                    <ul class="tips-list">
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Double-check your UTR/Transaction ID from your payment app or bank SMS</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Take a clear screenshot showing payment success, amount, and transaction ID</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Ensure file size is under 10MB and format is JPG, PNG, or PDF</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Verify you entered the correct UTR number without spaces or special characters</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Use a stable internet connection for file upload</span>
                        </li>
                    </ul>
                </div>

                <div class="divider"></div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button onclick="history.back()" class="btn-retry">
                        <i class="fas fa-redo"></i> Try Again
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/participant/my-registrations.jsp" 
                       class="btn-secondary-action">
                        <i class="fas fa-list"></i>
                        <span>View My Registrations</span>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/participant/dashboard.jsp" 
                       class="btn-secondary-action">
                        <i class="fas fa-home"></i>
                        <span>Go to Dashboard</span>
                    </a>
                </div>

                <!-- Support Section -->
                <div class="support-section">
                    <p class="support-text">Still having trouble? We're here to help!</p>
                    <a href="mailto:support@university.edu" class="support-email">
                        <i class="fas fa-envelope"></i> support@university.edu
                    </a>
                    
                    <div class="support-options">
                        <div class="support-option">
                            <i class="fas fa-phone"></i>
                            <span>24/7 Support Available</span>
                        </div>
                        <div class="support-option">
                            <i class="fas fa-comments"></i>
                            <span>Live Chat Support</span>
                        </div>
                        <div class="support-option">
                            <i class="fas fa-headset"></i>
                            <span>Help Center</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add smooth animations to buttons
        document.querySelectorAll('.btn-secondary-action').forEach(button => {
            button.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-4px)';
            });
            
            button.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Auto-focus retry button after animation
        setTimeout(() => {
            document.querySelector('.btn-retry')?.focus();
        }, 1000);

        // Log error for debugging (can be removed in production)
        const urlParams = new URLSearchParams(window.location.search);
        const errorType = urlParams.get('error');
        const errorMessage = urlParams.get('message');
        
        if (errorType || errorMessage) {
            console.log('Payment submission error:', {
                type: errorType,
                message: errorMessage,
                timestamp: new Date().toISOString()
            });
        }
    </script>
</body>
</html>
