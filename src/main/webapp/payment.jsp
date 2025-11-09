<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.RegistrationDAO" %>
<%@ page import="com.event.dao.EventDAO" %>
<%@ page import="com.event.dao.PaymentDAO" %>
<%@ page import="com.event.dao.PaymentConfigDAO" %>
<%@ page import="com.event.model.Registration" %>
<%@ page import="com.event.model.Event" %>
<%@ page import="com.event.model.Payment" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Map" %>

<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String regIdParam = request.getParameter("regId");
    if (regIdParam == null || regIdParam.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/participant/dashboard.jsp?error=invalid");
        return;
    }

    int regId = Integer.parseInt(regIdParam);
    
    RegistrationDAO registrationDAO = new RegistrationDAO();
    EventDAO eventDAO = new EventDAO();
    PaymentDAO paymentDAO = new PaymentDAO();
    
    Registration registration = registrationDAO.getRegistrationById(regId);
    
    if (registration == null) {
        response.sendRedirect(request.getContextPath() + "/participant/dashboard.jsp?error=invalid");
        return;
    }
    
    Event event = eventDAO.getEventById(registration.getEventId());
    
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/participant/dashboard.jsp?error=event_not_found");
        return;
    }
    
    BigDecimal amount = event.getFee();
    if (amount == null || amount.compareTo(BigDecimal.ZERO) == 0) {
        // Free event - no payment needed
        response.sendRedirect(request.getContextPath() + "/participant/my-registrations.jsp");
        return;
    }
    
    // Check if payment already submitted
    Payment existingPayment = paymentDAO.getPaymentByRegistrationId(regId);
    boolean paymentSubmitted = (existingPayment != null && 
                                "PROOF_SUBMITTED".equals(existingPayment.getPaymentStatus()));
    
    String userName = (String) session.getAttribute("username");
    String userEmail = (String) session.getAttribute("email");
    
    // ===== 🔐 OPTION 2: FETCH PAYMENT DETAILS FROM DATABASE ===== 
    PaymentConfigDAO configDAO = new PaymentConfigDAO();
    Map<String, String> paymentConfig = configDAO.getPaymentConfig();
    
    String UPI_ID = paymentConfig.get("upi_id");
    String UPI_NAME = paymentConfig.get("upi_name");
    String ACCOUNT_NUMBER = paymentConfig.get("account_number");
    String IFSC_CODE = paymentConfig.get("ifsc_code");
    String BANK_NAME = paymentConfig.get("bank_name");
    String ACCOUNT_HOLDER = paymentConfig.get("account_holder");
    // ===== END OF DATABASE CONFIG =====
    
    // Generate UPI payment string for QR code
    String upiString = String.format("upi://pay?pa=%s&pn=%s&am=%s&cu=INR&tn=Event Registration REG-%d",
                                     UPI_ID, UPI_NAME, amount, regId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Payment - Event Registration</title>
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
            --success: #10b981;
            --error: #ef4444;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(212, 175, 55, 0.1), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(91, 192, 190, 0.1), transparent 60%),
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
            opacity: 0.1;
            animation: luxury-float 25s ease-in-out infinite;
        }

        .orb-gold {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, var(--accent-gold) 0%, transparent 70%);
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

        /* Payment Container */
        .payment-container {
            max-width: 900px;
            width: 100%;
            margin: 0 auto;
            position: relative;
            z-index: 1;
            animation: card-entrance 0.8s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes card-entrance {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Payment Card */
        .payment-card {
            background: rgba(22, 37, 68, 0.7);
            backdrop-filter: blur(40px);
            border-radius: 32px;
            overflow: hidden;
            border: 1px solid rgba(212, 175, 55, 0.15);
            box-shadow: 
                0 30px 80px rgba(0, 0, 0, 0.6),
                0 0 0 1px rgba(212, 175, 55, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.05);
        }

        /* Payment Header */
        .payment-header {
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--accent-rose) 50%, var(--accent-lavender) 100%);
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .payment-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 70% 70%, rgba(255, 255, 255, 0.08) 0%, transparent 50%);
        }

        .payment-icon-wrapper {
            position: relative;
            margin-bottom: 1.5rem;
            z-index: 1;
        }

        .payment-icon {
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            animation: icon-float 4s ease-in-out infinite;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.3);
        }

        @keyframes icon-float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .payment-icon i {
            font-size: 3rem;
            color: white;
        }

        .payment-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
        }

        .payment-header p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        /* Payment Body */
        .payment-body {
            padding: 2.5rem;
        }

        /* Event Details Section */
        .event-details-card {
            background: rgba(10, 22, 40, 0.5);
            border: 1px solid rgba(212, 175, 55, 0.2);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .event-details-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(180deg, var(--accent-gold), var(--accent-rose));
        }

        .event-details-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .event-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(91, 192, 190, 0.2));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--accent-gold);
        }

        .event-details-header h5 {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--cream);
            margin: 0;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .detail-row:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .detail-label {
            color: rgba(245, 241, 232, 0.7);
            font-weight: 600;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-label i {
            color: var(--accent-gold);
            width: 20px;
        }

        .detail-value {
            color: var(--cream);
            font-weight: 600;
            text-align: right;
        }

        .registration-badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            color: var(--primary-navy);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.9rem;
        }

        /* Amount Display */
        .amount-section {
            text-align: center;
            margin: 2.5rem 0;
            padding: 2rem;
            background: rgba(10, 22, 40, 0.3);
            border-radius: 20px;
            border: 2px solid rgba(212, 175, 55, 0.2);
            position: relative;
            overflow: hidden;
        }

        .amount-label {
            color: rgba(245, 241, 232, 0.6);
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.75rem;
        }

        .amount-display {
            font-family: 'Playfair Display', serif;
            font-size: 4rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--accent-gold) 0%, var(--cream) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        /* Payment Instructions */
        .payment-instructions {
            background: rgba(10, 22, 40, 0.5);
            border: 1px solid rgba(91, 192, 190, 0.3);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .instructions-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            color: var(--accent-teal);
        }

        .instructions-header i {
            font-size: 1.5rem;
        }

        .instructions-header h5 {
            margin: 0;
            font-weight: 700;
        }

        .instruction-step {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            color: var(--cream);
        }

        .step-number {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            color: var(--primary-navy);
            flex-shrink: 0;
        }

        /* Payment Options Grid */
        .payment-options-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .payment-option-card {
            background: rgba(10, 22, 40, 0.5);
            border: 2px solid rgba(212, 175, 55, 0.2);
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .payment-option-card:hover {
            border-color: var(--accent-gold);
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.2);
        }

        .option-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(91, 192, 190, 0.2));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2.5rem;
            color: var(--accent-gold);
        }

        .option-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 0.5rem;
        }

        .option-description {
            color: rgba(245, 241, 232, 0.7);
            font-size: 0.9rem;
        }

        /* UPI Apps Grid */
        .upi-apps-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            gap: 1rem;
            margin: 1.5rem 0;
        }

        .upi-app-btn {
            background: rgba(10, 22, 40, 0.5);
            border: 2px solid rgba(212, 175, 55, 0.2);
            border-radius: 16px;
            padding: 1.5rem 1rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: var(--cream);
        }

        .upi-app-btn:hover {
            border-color: var(--accent-gold);
            transform: translateY(-3px);
            background: rgba(212, 175, 55, 0.1);
            color: var(--cream);
        }

        .upi-app-icon {
            font-size: 2.5rem;
            margin-bottom: 0.75rem;
            display: block;
        }

        .upi-app-name {
            font-weight: 600;
            font-size: 0.9rem;
        }

        /* Payment Details Box */
        .payment-details-box {
            background: rgba(10, 22, 40, 0.5);
            border: 1px solid rgba(212, 175, 55, 0.2);
            border-radius: 16px;
            padding: 1.5rem;
            margin: 1.5rem 0;
        }

        .payment-detail-item {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        }

        .payment-detail-item:last-child {
            border-bottom: none;
        }

        .payment-detail-label {
            color: rgba(245, 241, 232, 0.7);
            font-weight: 600;
        }

        .payment-detail-value {
            color: var(--cream);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .copy-btn {
            background: rgba(212, 175, 55, 0.2);
            border: 1px solid var(--accent-gold);
            color: var(--accent-gold);
            padding: 0.25rem 0.75rem;
            border-radius: 8px;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .copy-btn:hover {
            background: var(--accent-gold);
            color: var(--primary-navy);
        }

        /* QR Code Section */
        .qr-code-section {
            text-align: center;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            margin: 2rem 0;
        }

        .qr-code-container {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            display: inline-block;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        #qrcode {
            margin: 0 auto;
        }

        .qr-instruction {
            color: var(--primary-navy);
            font-weight: 600;
            margin-top: 1rem;
            font-size: 0.95rem;
        }

        /* Upload Form */
        .upload-form {
            background: rgba(10, 22, 40, 0.5);
            border: 2px dashed rgba(212, 175, 55, 0.3);
            border-radius: 20px;
            padding: 2rem;
            margin-top: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            color: var(--cream);
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .form-control {
            width: 100%;
            background: rgba(10, 22, 40, 0.5);
            border: 2px solid rgba(212, 175, 55, 0.2);
            border-radius: 12px;
            padding: 0.75rem 1rem;
            color: var(--cream);
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--accent-gold);
            background: rgba(10, 22, 40, 0.7);
        }

        .form-control::placeholder {
            color: rgba(245, 241, 232, 0.4);
        }

        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
        }

        .file-input-label {
            background: rgba(212, 175, 55, 0.2);
            border: 2px solid var(--accent-gold);
            color: var(--accent-gold);
            padding: 1rem;
            border-radius: 12px;
            cursor: pointer;
            text-align: center;
            display: block;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .file-input-label:hover {
            background: var(--accent-gold);
            color: var(--primary-navy);
        }

        .file-input {
            position: absolute;
            font-size: 100px;
            opacity: 0;
            right: 0;
            top: 0;
            cursor: pointer;
        }

        .file-name {
            color: var(--accent-teal);
            font-size: 0.9rem;
            margin-top: 0.5rem;
            font-weight: 600;
        }

        /* Submit Button */
        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, var(--accent-gold) 0%, #b8963d 100%);
            color: var(--primary-navy);
            border: none;
            border-radius: 16px;
            padding: 1.25rem 2rem;
            font-weight: 800;
            font-size: 1.15rem;
            cursor: pointer;
            transition: all 0.4s ease;
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.35);
        }

        .btn-submit:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 50px rgba(212, 175, 55, 0.5);
        }

        .btn-submit:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* Alert Messages */
        .alert-box {
            background: rgba(16, 185, 129, 0.1);
            border: 2px solid var(--success);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            color: var(--success);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .alert-box i {
            font-size: 1.5rem;
        }

        .alert-warning {
            background: rgba(234, 179, 8, 0.1);
            border-color: #eab308;
            color: #fbbf24;
        }

        /* Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: var(--secondary-navy);
            border: 2px solid var(--accent-gold);
            border-radius: 24px;
            padding: 2rem;
            max-width: 500px;
            width: 90%;
            text-align: center;
        }

        .modal-icon {
            font-size: 4rem;
            color: var(--accent-gold);
            margin-bottom: 1rem;
        }

        .modal-title {
            color: var(--cream);
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .modal-text {
            color: rgba(245, 241, 232, 0.8);
            margin-bottom: 1.5rem;
        }

        .modal-close-btn {
            background: var(--accent-gold);
            color: var(--primary-navy);
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .payment-options-grid {
                grid-template-columns: 1fr;
            }

            .upi-apps-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .amount-display {
                font-size: 3rem;
            }

            .payment-body {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="luxury-bg">
        <div class="luxury-orb orb-gold"></div>
        <div class="luxury-orb orb-teal"></div>
    </div>

    <div class="payment-container">
        <div class="payment-card">
            <!-- Payment Header -->
            <div class="payment-header">
                <div class="payment-icon-wrapper">
                    <div class="payment-icon">
                        <i class="fas fa-wallet"></i>
                    </div>
                </div>
                <h1>Complete Payment</h1>
                <p>Pay using UPI, Bank Transfer, or any payment method</p>
            </div>

            <!-- Payment Body -->
            <div class="payment-body">
                <% if (paymentSubmitted) { %>
                <!-- Payment Already Submitted -->
                <div class="alert-box">
                    <i class="fas fa-check-circle"></i>
                    <div>
                        <strong>Payment Proof Already Submitted!</strong><br>
                        Your payment is under review. Admin will verify and approve shortly.
                    </div>
                </div>
                <% } %>

                <!-- Event Details -->
                <div class="event-details-card">
                    <div class="event-details-header">
                        <div class="event-icon">
                            <i class="fas fa-calendar-star"></i>
                        </div>
                        <h5>Event Details</h5>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">
                            <i class="fas fa-tag"></i>
                            Event Name
                        </span>
                        <span class="detail-value"><%= event.getName() %></span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">
                            <i class="fas fa-map-marker-alt"></i>
                            Venue
                        </span>
                        <span class="detail-value"><%= event.getVenue() %></span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">
                            <i class="fas fa-clock"></i>
                            Date & Time
                        </span>
                        <span class="detail-value">
                            <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(event.getEventDate()) %>
                        </span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">
                            <i class="fas fa-ticket-alt"></i>
                            Registration ID
                        </span>
                        <span class="registration-badge">REG-<%= regId %></span>
                    </div>
                </div>

                <!-- Amount Display -->
                <div class="amount-section">
                    <div class="amount-label">Total Amount to Pay</div>
                    <div class="amount-display">₹ <%= amount %></div>
                </div>

                <!-- Payment Instructions -->
                <div class="payment-instructions">
                    <div class="instructions-header">
                        <i class="fas fa-info-circle"></i>
                        <h5>How to Complete Payment</h5>
                    </div>
                    <div class="instruction-step">
                        <div class="step-number">1</div>
                        <div>Choose any UPI app below or use Bank Transfer</div>
                    </div>
                    <div class="instruction-step">
                        <div class="step-number">2</div>
                        <div>Complete the payment of ₹<%= amount %></div>
                    </div>
                    <div class="instruction-step">
                        <div class="step-number">3</div>
                        <div>Upload payment screenshot and enter UTR/Transaction ID</div>
                    </div>
                    <div class="instruction-step">
                        <div class="step-number">4</div>
                        <div>Admin will verify and approve your registration</div>
                    </div>
                </div>

                <!-- Payment Options -->
                <div class="payment-options-grid">
                    <!-- UPI Option -->
                    <div class="payment-option-card" onclick="showUpiOptions()">
                        <div class="option-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <div class="option-title">Pay via UPI</div>
                        <div class="option-description">Google Pay, PhonePe, Paytm, etc.</div>
                    </div>

                    <!-- Bank Transfer Option -->
                    <div class="payment-option-card" onclick="showBankDetails()">
                        <div class="option-icon">
                            <i class="fas fa-university"></i>
                        </div>
                        <div class="option-title">Bank Transfer</div>
                        <div class="option-description">NEFT, RTGS, IMPS</div>
                    </div>
                </div>

                <!-- UPI Section (Hidden by default) -->
                <div id="upiSection" style="display: none;">
                    <div class="payment-details-box">
                        <h5 style="color: var(--accent-gold); margin-bottom: 1rem;">UPI Payment Details</h5>
                        <div class="payment-detail-item">
                            <span class="payment-detail-label">UPI ID</span>
                            <span class="payment-detail-value">
                                <span id="upiId"><%= UPI_ID %></span>
                                <button class="copy-btn" onclick="copyToClipboard('upiId')">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </span>
                        </div>
                        <div class="payment-detail-item">
                            <span class="payment-detail-label">Amount</span>
                            <span class="payment-detail-value">₹ <%= amount %></span>
                        </div>
                    </div>

                    <!-- UPI Apps -->
                    <h5 style="color: var(--cream); margin: 1.5rem 0 1rem;">Choose Your UPI App</h5>
                    <div class="upi-apps-grid">
                        <a href="<%= upiString.replace("upi://", "gpay://") %>" class="upi-app-btn">
                            <span class="upi-app-icon" style="color: #4285F4;">💳</span>
                            <span class="upi-app-name">Google Pay</span>
                        </a>
                        <a href="<%= upiString.replace("upi://", "phonepe://") %>" class="upi-app-btn">
                            <span class="upi-app-icon" style="color: #5f259f;">📱</span>
                            <span class="upi-app-name">PhonePe</span>
                        </a>
                        <a href="<%= upiString.replace("upi://", "paytmmp://") %>" class="upi-app-btn">
                            <span class="upi-app-icon" style="color: #00BAF2;">💰</span>
                            <span class="upi-app-name">Paytm</span>
                        </a>
                        <a href="<%= upiString %>" class="upi-app-btn">
                            <span class="upi-app-icon" style="color: #FF6B00;">🏦</span>
                            <span class="upi-app-name">Other UPI</span>
                        </a>
                    </div>

                    <!-- QR Code -->
                    <div class="qr-code-section">
                        <h5 style="color: var(--primary-navy); margin-bottom: 1rem;">Or Scan QR Code</h5>
                        <div class="qr-code-container">
                            <div id="qrcode"></div>
                        </div>
                        <p class="qr-instruction">Scan with any UPI app to pay ₹<%= amount %></p>
                    </div>
                </div>

                <!-- Bank Details Section (Hidden by default) -->
                <div id="bankSection" style="display: none;">
                    <div class="payment-details-box">
                        <h5 style="color: var(--accent-gold); margin-bottom: 1rem;">Bank Account Details</h5>
                        <div class="payment-detail-item">
                            <span class="payment-detail-label">Account Holder</span>
                            <span class="payment-detail-value">
                                <span id="accountHolder"><%= ACCOUNT_HOLDER %></span>
                                <button class="copy-btn" onclick="copyToClipboard('accountHolder')">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </span>
                        </div>
                        <div class="payment-detail-item">
                            <span class="payment-detail-label">Account Number</span>
                            <span class="payment-detail-value">
                                <span id="accountNumber"><%= ACCOUNT_NUMBER %></span>
                                <button class="copy-btn" onclick="copyToClipboard('accountNumber')">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </span>
                        </div>
                        <div class="payment-detail-item">
                            <span class="payment-detail-label">IFSC Code</span>
                            <span class="payment-detail-value">
                                <span id="ifscCode"><%= IFSC_CODE %></span>
                                <button class="copy-btn" onclick="copyToClipboard('ifscCode')">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </span>
                        </div>
                        <div class="payment-detail-item">
                            <span class="payment-detail-label">Bank Name</span>
                            <span class="payment-detail-value"><%= BANK_NAME %></span>
                        </div>
                        <div class="payment-detail-item">
                            <span class="payment-detail-label">Amount</span>
                            <span class="payment-detail-value">₹ <%= amount %></span>
                        </div>
                    </div>
                </div>

                <!-- Upload Payment Proof Form -->
                <% if (!paymentSubmitted) { %>
                <div class="upload-form">
                    <h5 style="color: var(--accent-gold); margin-bottom: 1.5rem;">
                        <i class="fas fa-upload"></i> Submit Payment Proof
                    </h5>
                    
                    <form id="paymentProofForm" action="${pageContext.request.contextPath}/paymentCallback" 
                          method="post" enctype="multipart/form-data">
                        <input type="hidden" name="regId" value="<%= regId %>">
                        <input type="hidden" name="amount" value="<%= amount %>">

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-hashtag"></i> UTR / Transaction ID *
                            </label>
                            <input type="text" name="utrNumber" class="form-control" 
                                   placeholder="Enter 12-digit UTR or Transaction ID" required
                                   pattern="[A-Za-z0-9]{6,}" 
                                   title="Please enter a valid UTR/Transaction ID (minimum 6 characters)">
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-user"></i> Payer Name
                            </label>
                            <input type="text" name="payerName" class="form-control" 
                                   placeholder="Name of person who made payment" value="<%= userName %>">
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-at"></i> UPI ID (Optional)
                            </label>
                            <input type="text" name="upiId" class="form-control" 
                                   placeholder="yourname@upi">
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-image"></i> Payment Screenshot *
                            </label>
                            <div class="file-input-wrapper">
                                <label class="file-input-label" for="paymentProof">
                                    <i class="fas fa-cloud-upload-alt"></i> Choose File
                                    <br><small>JPG, PNG or PDF (Max 10MB)</small>
                                </label>
                                <input type="file" name="paymentProof" id="paymentProof" 
                                       class="file-input" accept=".jpg,.jpeg,.png,.pdf" required
                                       onchange="displayFileName(this)">
                            </div>
                            <div id="fileName" class="file-name"></div>
                        </div>

                        <button type="submit" class="btn-submit" id="submitBtn">
                            <i class="fas fa-check-circle"></i> Submit Payment Proof
                        </button>
                    </form>
                </div>
                <% } %>

                <!-- Footer -->
                <div style="text-align: center; margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/participant/my-registrations.jsp" 
                       style="color: var(--accent-gold); text-decoration: none; font-weight: 600;">
                        <i class="fas fa-arrow-left"></i> Back to My Registrations
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="modal-overlay">
        <div class="modal-content">
            <i class="fas fa-check-circle modal-icon"></i>
            <h3 class="modal-title">Payment Proof Submitted!</h3>
            <p class="modal-text">
                Your payment proof has been submitted successfully. 
                Admin will verify and approve your registration shortly.
            </p>
            <button class="modal-close-btn" onclick="closeModal()">
                Got It
            </button>
        </div>
    </div>

    <!-- QR Code Library -->
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <script>
        // Generate QR Code
        let qrcode = null;
        function generateQRCode() {
            if (qrcode === null) {
                qrcode = new QRCode(document.getElementById("qrcode"), {
                    text: "<%= upiString %>",
                    width: 200,
                    height: 200,
                    colorDark: "#0a1628",
                    colorLight: "#ffffff",
                    correctLevel: QRCode.CorrectLevel.H
                });
            }
        }

        // Show UPI Options
        function showUpiOptions() {
            document.getElementById('upiSection').style.display = 'block';
            document.getElementById('bankSection').style.display = 'none';
            generateQRCode();
        }

        // Show Bank Details
        function showBankDetails() {
            document.getElementById('bankSection').style.display = 'block';
            document.getElementById('upiSection').style.display = 'none';
        }

        // Copy to Clipboard
        function copyToClipboard(elementId) {
            const text = document.getElementById(elementId).innerText;
            navigator.clipboard.writeText(text).then(() => {
                alert('Copied: ' + text);
            });
        }

        // Display File Name
        function displayFileName(input) {
            const fileName = input.files[0] ? input.files[0].name : '';
            document.getElementById('fileName').textContent = fileName ? 
                '✓ Selected: ' + fileName : '';
        }

        // Form Submission
        document.getElementById('paymentProofForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Uploading...';
        });

        // Close Modal
        function closeModal() {
            window.location.href = '${pageContext.request.contextPath}/participant/my-registrations.jsp';
        }

        // Show UPI section by default
        showUpiOptions();
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
