<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* Ensure body takes full height */
    html {
        height: 100%;
    }

    body {
        min-height: 100%;
        display: flex;
        flex-direction: column;
    }

    /* Main content should grow to push footer down */
    .main-content, 
    .login-container, 
    .register-container, 
    .payment-container, 
    .main-container,
    main {
        flex: 1 0 auto;
    }

    /* Footer Styles */
    .luxury-footer {
        flex-shrink: 0;
        background: rgba(22, 37, 68, 0.95);
        backdrop-filter: blur(20px);
        border-top: 1px solid rgba(212, 175, 55, 0.1);
        color: #faf8f3;
        padding: 3rem 0 1.5rem;
        margin-top: auto;
        position: relative;
        z-index: 100;
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
        background: linear-gradient(135deg, #d4af37 0%, #f5f1e8 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .footer-brand i {
        color: #d4af37;
        font-size: 1.5rem;
    }

    .footer-description {
        color: rgba(245, 241, 232, 0.7);
        line-height: 1.6;
        margin-bottom: 1.5rem;
    }

    .footer-social {
        display: flex;
        gap: 1rem;
    }

    .social-icon {
        width: 40px;
        height: 40px;
        background: rgba(212, 175, 55, 0.1);
        border: 1px solid rgba(212, 175, 55, 0.2);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #d4af37;
        font-size: 1.1rem;
        transition: all 0.3s ease;
        text-decoration: none;
    }

    .social-icon:hover {
        background: #d4af37;
        color: #0a1628;
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(212, 175, 55, 0.3);
    }

    .footer-section-title {
        font-weight: 700;
        color: #f5f1e8;
        margin-bottom: 1rem;
        font-size: 1.1rem;
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
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .footer-links a:hover {
        color: #d4af37;
        padding-left: 5px;
    }

    .footer-links a i {
        font-size: 0.9rem;
        width: 16px;
    }

    .footer-bottom {
        padding-top: 2rem;
        border-top: 1px solid rgba(212, 175, 55, 0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .footer-copyright {
        color: rgba(245, 241, 232, 0.6);
        font-size: 0.9rem;
    }

    .footer-bottom-links {
        display: flex;
        gap: 2rem;
        flex-wrap: wrap;
    }

    .footer-bottom-links a {
        color: rgba(245, 241, 232, 0.6);
        text-decoration: none;
        font-size: 0.9rem;
        transition: color 0.3s ease;
    }

    .footer-bottom-links a:hover {
        color: #d4af37;
    }

    /* Responsive */
    @media (max-width: 991px) {
        .footer-content {
            grid-template-columns: 1fr 1fr;
        }
    }

    @media (max-width: 576px) {
        .footer-content {
            grid-template-columns: 1fr;
        }

        .footer-bottom {
            flex-direction: column;
            text-align: center;
        }

        .footer-bottom-links {
            flex-direction: column;
            gap: 0.5rem;
        }
    }
</style>

<footer class="luxury-footer">
    <div class="container">
        <div class="footer-content">
            <!-- Brand Section -->
            <div>
                <div class="footer-brand">
                    <i class="fas fa-graduation-cap"></i>
                    <span>University Events</span>
                </div>
                <p class="footer-description">
                    The ultimate platform for managing university events with QR codes, secure payments, and real-time notifications.
                </p>
                <div class="footer-social">
                    <a href="#" class="social-icon" title="Facebook">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="social-icon" title="Twitter">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="social-icon" title="Instagram">
                        <i class="fab fa-instagram"></i>
                    </a>
                    <a href="#" class="social-icon" title="LinkedIn">
                        <i class="fab fa-linkedin-in"></i>
                    </a>
                </div>
            </div>

            <!-- Quick Links -->
            <div>
                <h4 class="footer-section-title">Quick Links</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/participant/register-event.jsp"><i class="fas fa-calendar"></i> Events</a></li>
                    <li><a href="#"><i class="fas fa-info-circle"></i> About Us</a></li>
                    <li><a href="#"><i class="fas fa-envelope"></i> Contact</a></li>
                </ul>
            </div>

            <!-- Support -->
            <div>
                <h4 class="footer-section-title">Support</h4>
                <ul class="footer-links">
                    <li><a href="#"><i class="fas fa-question-circle"></i> Help Center</a></li>
                    <li><a href="#"><i class="fas fa-file-alt"></i> FAQs</a></li>
                    <li><a href="#"><i class="fas fa-headset"></i> Contact Support</a></li>
                    <li><a href="#"><i class="fas fa-bug"></i> Report Issue</a></li>
                </ul>
            </div>

            <!-- Legal -->
            <div>
                <h4 class="footer-section-title">Legal</h4>
                <ul class="footer-links">
                    <li><a href="#"><i class="fas fa-shield-alt"></i> Privacy Policy</a></li>
                    <li><a href="#"><i class="fas fa-file-contract"></i> Terms of Service</a></li>
                    <li><a href="#"><i class="fas fa-cookie"></i> Cookie Policy</a></li>
                    <li><a href="#"><i class="fas fa-lock"></i> Security</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <div class="footer-copyright">
                &copy; 2025 University Event Management System. All rights reserved.
            </div>
            <div class="footer-bottom-links">
                <a href="#">Privacy</a>
                <a href="#">Terms</a>
                <a href="#">Cookies</a>
                <a href="#">Accessibility</a>
            </div>
        </div>
    </div>
</footer>
