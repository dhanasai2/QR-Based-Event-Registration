<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - University Events</title>
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
            --glass-bg: rgba(22, 37, 68, 0.7);
            --border-luxury: rgba(212, 175, 55, 0.2);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(212, 175, 55, 0.08), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(139, 92, 246, 0.08), transparent 60%),
                        radial-gradient(ellipse at center, rgba(91, 192, 190, 0.06), transparent 70%),
                        linear-gradient(135deg, var(--primary-navy) 0%, #0d1b2a 50%, var(--primary-navy) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
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
            opacity: 0.12;
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

        /* Register Container */
        .register-container {
            max-width: 600px;
            width: 100%;
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

        /* Register Card */
        .register-card {
            background: var(--glass-bg);
            backdrop-filter: blur(40px);
            border-radius: 32px;
            overflow: hidden;
            border: 1px solid var(--border-luxury);
            box-shadow: 
                0 30px 80px rgba(0, 0, 0, 0.6),
                0 0 0 1px rgba(212, 175, 55, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.05);
            padding: 3rem 2.5rem;
        }

        .register-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, var(--accent-gold), transparent);
            animation: shimmer-line 3s ease-in-out infinite;
        }

        @keyframes shimmer-line {
            0%, 100% { opacity: 0.3; }
            50% { opacity: 1; }
        }

        /* Header */
        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .register-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            animation: icon-float 4s ease-in-out infinite;
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.3);
        }

        @keyframes icon-float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .register-icon i {
            font-size: 2.5rem;
            color: var(--primary-navy);
        }

        .register-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--cream) 0%, var(--accent-gold) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .register-subtitle {
            color: rgba(245, 241, 232, 0.7);
            font-size: 1rem;
        }

        /* Alerts */
        .alert {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.25rem;
            border-radius: 14px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 1.5rem;
            border: 1.5px solid;
            animation: alert-slide 0.5s cubic-bezier(0.23, 1, 0.32, 1);
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

        .alert i {
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border-color: rgba(16, 185, 129, 0.3);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            color: var(--error);
            border-color: rgba(239, 68, 68, 0.3);
        }

        /* Photo Upload */
        .photo-upload-section {
            text-align: center;
            margin-bottom: 2rem;
        }

        .photo-label {
            color: rgba(245, 241, 232, 0.8);
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            display: block;
        }

        .photo-upload-preview {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 3px dashed rgba(212, 175, 55, 0.4);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            background: rgba(10, 22, 40, 0.4);
            position: relative;
        }

        .photo-upload-preview:hover {
            border-color: var(--accent-gold);
            border-style: solid;
            transform: scale(1.05);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
        }

        .photo-upload-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .photo-upload-preview i {
            font-size: 3rem;
            color: var(--accent-gold);
            transition: all 0.3s ease;
        }

        .photo-upload-preview:hover i {
            transform: scale(1.1);
        }

        .photo-hint {
            color: rgba(245, 241, 232, 0.5);
            font-size: 0.85rem;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: rgba(245, 241, 232, 0.8);
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
        }

        .form-label i {
            color: var(--accent-gold);
            width: 20px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-control,
        .form-select {
            width: 100%;
            background: rgba(10, 22, 40, 0.5);
            border: 2px solid rgba(212, 175, 55, 0.15);
            border-radius: 14px;
            color: var(--cream);
            font-size: 0.95rem;
            font-weight: 500;
            padding: 0.875rem 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            outline: none;
        }

        .form-control::placeholder {
            color: rgba(245, 241, 232, 0.4);
        }

        .form-control:focus,
        .form-select:focus {
            background: rgba(10, 22, 40, 0.7);
            border-color: var(--accent-gold);
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.1);
            transform: translateY(-2px);
        }

        .form-select option {
            background: var(--secondary-navy);
            color: var(--cream);
        }

        /* Password Strength Indicator */
        .password-strength {
            height: 4px;
            background: rgba(212, 175, 55, 0.1);
            border-radius: 2px;
            margin-top: 0.5rem;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .strength-weak { width: 33%; background: var(--error); }
        .strength-medium { width: 66%; background: #f59e0b; }
        .strength-strong { width: 100%; background: var(--success); }

        /* Submit Button */
        .btn-register {
            width: 100%;
            background: linear-gradient(135deg, var(--accent-gold) 0%, #b8963d 100%);
            color: var(--primary-navy);
            border: none;
            border-radius: 14px;
            padding: 1.1rem 2rem;
            font-weight: 800;
            font-size: 1.05rem;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.35);
            margin: 2rem 0 1.5rem;
        }

        .btn-register::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.4), transparent);
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
        }

        .btn-register:hover::before {
            width: 400px;
            height: 400px;
        }

        .btn-register:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 50px rgba(212, 175, 55, 0.5);
        }

        .btn-register:active {
            transform: translateY(-2px) scale(0.98);
        }

        .btn-register:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .btn-register i {
            margin-right: 0.625rem;
        }

        /* Login Link */
        .login-link {
            text-align: center;
            color: rgba(245, 241, 232, 0.7);
            font-size: 0.95rem;
        }

        .login-link a {
            color: var(--accent-gold);
            text-decoration: none;
            font-weight: 700;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: var(--accent-rose);
        }

        /* Loading State */
        .btn-loading {
            pointer-events: none;
            color: transparent;
        }

        .btn-loading::after {
            content: '';
            position: absolute;
            width: 26px;
            height: 26px;
            top: 50%;
            left: 50%;
            margin-left: -13px;
            margin-top: -13px;
            border: 3px solid rgba(10, 22, 40, 0.3);
            border-radius: 50%;
            border-top-color: var(--primary-navy);
            animation: spinner 0.8s linear infinite;
        }

        @keyframes spinner {
            to { transform: rotate(360deg); }
        }

        /* Responsive */
        @media (max-width: 576px) {
            .register-container {
                padding: 1rem;
            }

            .register-card {
                padding: 2rem 1.5rem;
            }

            .register-title {
                font-size: 2rem;
            }

            .register-icon {
                width: 70px;
                height: 70px;
            }

            .register-icon i {
                font-size: 2rem;
            }

            .photo-upload-preview {
                width: 120px;
                height: 120px;
            }
        }

        /* Accessibility */
        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }

        .form-control:focus-visible,
        .form-select:focus-visible,
        .btn-register:focus-visible {
            outline: 3px solid var(--accent-gold);
            outline-offset: 2px;
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

    <div class="register-container">
        <div class="register-card">
            <!-- Header -->
            <div class="register-header">
                <div class="register-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <h1 class="register-title">Create Account</h1>
                <p class="register-subtitle">Join our event management platform</p>
            </div>

            <!-- Alerts -->
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                
                if (error != null) {
                    String errorMsg = "";
                    switch(error) {
                        case "username_exists": errorMsg = "Username already exists!"; break;
                        case "email_exists": errorMsg = "Email already registered!"; break;
                        case "invalid_input": errorMsg = "All fields are required!"; break;
                        case "photo_size": errorMsg = "Photo size must be less than 2MB!"; break;
                        case "photo_type": errorMsg = "Only JPG, PNG, GIF images allowed!"; break;
                        case "registration_failed": errorMsg = "Registration failed. Try again!"; break;
                        default: errorMsg = "An error occurred!";
                    }
            %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= errorMsg %></span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <% if (success != null && "registered".equals(success)) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i>
                    <span>Registration successful! Please wait for admin approval.</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data" id="registerForm">
                
                <!-- Profile Photo Upload -->
                <div class="photo-upload-section">
                    <label class="photo-label">Profile Photo (Optional)</label>
                    <div class="photo-upload-preview" onclick="document.getElementById('profilePhoto').click()">
                        <img id="photoPreview" src="" alt="" style="display:none;">
                        <i class="fas fa-camera" id="cameraIcon"></i>
                    </div>
                    <input type="file" id="profilePhoto" name="profilePhoto" accept="image/*" 
                           style="display:none;" onchange="previewPhoto(this)">
                    <small class="photo-hint">Max 2MB (JPG, PNG, GIF)</small>
                </div>
                
                <!-- Username -->
                <div class="form-group">
                    <label class="form-label" for="username">
                        <i class="fas fa-user"></i>
                        <span>Username</span>
                    </label>
                    <div class="input-wrapper">
                        <input type="text" class="form-control" id="username" name="username" 
                               placeholder="Choose a unique username" required>
                    </div>
                </div>
                
                <!-- Email -->
                <div class="form-group">
                    <label class="form-label" for="email">
                        <i class="fas fa-envelope"></i>
                        <span>Email Address</span>
                    </label>
                    <div class="input-wrapper">
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="Enter your email" required>
                    </div>
                </div>
                
                <!-- Phone -->
                <div class="form-group">
                    <label class="form-label" for="phone">
                        <i class="fas fa-phone"></i>
                        <span>Phone Number</span>
                    </label>
                    <div class="input-wrapper">
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               placeholder="10-digit mobile number" required pattern="[0-9]{10}">
                    </div>
                </div>
                
                <!-- Password -->
                <div class="form-group">
                    <label class="form-label" for="password">
                        <i class="fas fa-lock"></i>
                        <span>Password</span>
                    </label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Minimum 8 characters" required minlength="8">
                        <div class="password-strength">
                            <div class="password-strength-bar" id="strengthBar"></div>
                        </div>
                    </div>
                </div>
                
                <!-- Confirm Password -->
                <div class="form-group">
                    <label class="form-label" for="confirmPassword">
                        <i class="fas fa-lock"></i>
                        <span>Confirm Password</span>
                    </label>
                    <div class="input-wrapper">
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                               placeholder="Re-enter your password" required>
                    </div>
                </div>
                
                <!-- Role Selection -->
                <div class="form-group">
                    <label class="form-label" for="role">
                        <i class="fas fa-user-tag"></i>
                        <span>Register As</span>
                    </label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="">-- Select Your Role --</option>
                        <option value="participant">Participant</option>
                        <option value="organizer">Organizer</option>
                    </select>
                </div>
                
                <!-- Submit Button -->
                <button type="submit" class="btn-register" id="submitBtn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
                
                <!-- Login Link -->
                <div class="login-link">
                    Already have an account? 
                    <a href="${pageContext.request.contextPath}/login.jsp">Sign in here</a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Photo preview function
        function previewPhoto(input) {
            const preview = document.getElementById('photoPreview');
            const cameraIcon = document.getElementById('cameraIcon');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                // Validate file size (2MB max)
                if (file.size > 2 * 1024 * 1024) {
                    alert('Photo size must be less than 2MB!');
                    input.value = '';
                    return;
                }
                
                // Validate file type
                const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                if (!validTypes.includes(file.type)) {
                    alert('Only JPG, PNG, GIF images are allowed!');
                    input.value = '';
                    return;
                }
                
                // Show preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    cameraIcon.style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
        }

        // Password strength checker
        const passwordInput = document.getElementById('password');
        const strengthBar = document.getElementById('strengthBar');

        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = 0;
            
            if (password.length >= 8) strength++;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
            if (password.match(/\d/)) strength++;
            if (password.match(/[^a-zA-Z\d]/)) strength++;
            
            strengthBar.className = 'password-strength-bar';
            
            if (strength === 0 || strength === 1) {
                strengthBar.classList.add('strength-weak');
            } else if (strength === 2 || strength === 3) {
                strengthBar.classList.add('strength-medium');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        });
        
        // Form validation
        const registerForm = document.getElementById('registerForm');
        const submitBtn = document.getElementById('submitBtn');

        registerForm.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                document.getElementById('confirmPassword').focus();
                return false;
            }

            if (password.length < 8) {
                e.preventDefault();
                alert('Password must be at least 8 characters long!');
                passwordInput.focus();
                return false;
            }

            // Show loading state
            if (!this.submitted) {
                this.submitted = true;
                submitBtn.classList.add('btn-loading');
                submitBtn.disabled = true;
            } else {
                e.preventDefault();
            }
        });

        // Input animations
        document.querySelectorAll('.form-control, .form-select').forEach(input => {
            input.addEventListener('focus', function() {
                this.style.transition = 'all 0.3s ease';
            });
            
            input.addEventListener('input', function() {
                if (this.value.length > 0) {
                    this.style.borderColor = 'rgba(212, 175, 55, 0.4)';
                }
            });
        });

        // Auto-hide alerts after 5 seconds
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
