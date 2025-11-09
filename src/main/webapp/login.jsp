<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Login - Event Registration System</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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
    /* Luxury Color Palette - Deep Navy & Gold */
    --primary-navy: #0a1628;
    --secondary-navy: #162544;
    --accent-gold: #d4af37;
    --accent-rose: #e8b4b8;
    --accent-teal: #5bc0be;
    --accent-lavender: #9d84b7;
    
    /* Neutral Luxury */
    --cream: #f5f1e8;
    --warm-white: #faf8f3;
    --charcoal: #2d2d2d;
    --slate: #475569;
    
    /* Semantic Colors */
    --success: #10b981;
    --error: #ef4444;
    
    /* Effects */
    --border-luxury: rgba(212, 175, 55, 0.2);
    --glow-gold: rgba(212, 175, 55, 0.3);
    --glass-bg: rgba(22, 37, 68, 0.7);
}

body {
    min-height: 100vh;
    background: 
        radial-gradient(ellipse at top right, rgba(212, 175, 55, 0.08), transparent 60%),
        radial-gradient(ellipse at bottom left, rgba(91, 192, 190, 0.08), transparent 60%),
        radial-gradient(ellipse at center, rgba(157, 132, 183, 0.06), transparent 70%),
        linear-gradient(135deg, var(--primary-navy) 0%, #0d1b2a 50%, var(--primary-navy) 100%);
    font-family: 'Inter', sans-serif;
    color: var(--warm-white);
    overflow-x: hidden;
    position: relative;
}

/* Premium Animated Background */
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
    opacity: 0.15;
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
    0%, 100% {
        transform: translate(0, 0) scale(1) rotate(0deg);
    }
    33% {
        transform: translate(40px, -40px) scale(1.1) rotate(5deg);
    }
    66% {
        transform: translate(-30px, 30px) scale(0.95) rotate(-5deg);
    }
}

/* Elegant Grid Pattern */
.elegant-grid {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: 
        linear-gradient(rgba(212, 175, 55, 0.02) 1px, transparent 1px),
        linear-gradient(90deg, rgba(212, 175, 55, 0.02) 1px, transparent 1px);
    background-size: 60px 60px;
    z-index: 0;
    pointer-events: none;
    animation: grid-pulse 10s ease-in-out infinite;
}

@keyframes grid-pulse {
    0%, 100% { opacity: 0.3; }
    50% { opacity: 0.6; }
}

/* Floating Particles - Refined */
.particles-elegant {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 0;
    pointer-events: none;
}

.particle-elegant {
    position: absolute;
    width: 2px;
    height: 2px;
    background: var(--accent-gold);
    border-radius: 50%;
    box-shadow: 0 0 8px var(--glow-gold);
    animation: particle-elegant-float linear infinite;
}

@keyframes particle-elegant-float {
    0% {
        transform: translateY(100vh) translateX(0) rotate(0deg);
        opacity: 0;
    }
    10% {
        opacity: 1;
    }
    90% {
        opacity: 1;
    }
    100% {
        transform: translateY(-50px) translateX(30px) rotate(360deg);
        opacity: 0;
    }
}

/* Main Container */
.login-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem 1rem;
    position: relative;
    z-index: 1;
}

.login-wrapper {
    max-width: 1100px;
    width: 100%;
    display: grid;
    grid-template-columns: 1.1fr 1fr;
    background: var(--glass-bg);
    backdrop-filter: blur(40px);
    -webkit-backdrop-filter: blur(40px);
    border-radius: 32px;
    overflow: hidden;
    box-shadow: 
        0 30px 80px rgba(0, 0, 0, 0.6),
        0 0 0 1px rgba(212, 175, 55, 0.1),
        inset 0 1px 0 rgba(255, 255, 255, 0.05);
    position: relative;
    animation: card-grand-entrance 1s cubic-bezier(0.23, 1, 0.32, 1);
}

@keyframes card-grand-entrance {
    0% {
        opacity: 0;
        transform: translateY(50px) scale(0.9);
        filter: blur(10px);
    }
    100% {
        opacity: 1;
        transform: translateY(0) scale(1);
        filter: blur(0);
    }
}

.login-wrapper::before {
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

/* Left Panel - Hero */
.hero-panel {
    position: relative;
    background: linear-gradient(135deg, var(--secondary-navy) 0%, var(--primary-navy) 100%);
    padding: 4rem 3rem;
    display: flex;
    flex-direction: column;
    justify-content: center;
    overflow: hidden;
}

.hero-panel::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: 
        radial-gradient(circle at 30% 30%, rgba(212, 175, 55, 0.1) 0%, transparent 50%),
        radial-gradient(circle at 70% 70%, rgba(91, 192, 190, 0.08) 0%, transparent 50%);
    animation: hero-glow 8s ease-in-out infinite;
}

@keyframes hero-glow {
    0%, 100% { opacity: 0.6; }
    50% { opacity: 1; }
}

.hero-panel::after {
    content: '';
    position: absolute;
    top: -50%;
    right: -50%;
    width: 200%;
    height: 200%;
    background: repeating-linear-gradient(
        45deg,
        transparent,
        transparent 30px,
        rgba(212, 175, 55, 0.02) 30px,
        rgba(212, 175, 55, 0.02) 60px
    );
    animation: pattern-slide 30s linear infinite;
}

@keyframes pattern-slide {
    0% { transform: translate(0, 0); }
    100% { transform: translate(60px, 60px); }
}

.hero-content {
    position: relative;
    z-index: 1;
}

/* Luxury Icon */
.luxury-icon-container {
    margin-bottom: 2.5rem;
}

.luxury-icon-wrapper {
    position: relative;
    width: 120px;
    height: 120px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.luxury-icon-bg {
    position: absolute;
    inset: 0;
    background: linear-gradient(135deg, var(--accent-gold) 0%, var(--accent-rose) 100%);
    border-radius: 28px;
    animation: icon-rotate 10s linear infinite, icon-pulse 3s ease-in-out infinite;
    box-shadow: 
        0 20px 60px rgba(212, 175, 55, 0.4),
        inset 0 2px 10px rgba(255, 255, 255, 0.3);
}

@keyframes icon-rotate {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

@keyframes icon-pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

.luxury-icon-inner {
    position: absolute;
    inset: 6px;
    background: var(--secondary-navy);
    border-radius: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.luxury-icon-inner i {
    font-size: 3.5rem;
    background: linear-gradient(135deg, var(--accent-gold) 0%, var(--cream) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    animation: icon-float 4s ease-in-out infinite;
    filter: drop-shadow(0 4px 12px rgba(212, 175, 55, 0.4));
}

@keyframes icon-float {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50% { transform: translateY(-10px) rotate(5deg); }
}

/* Hero Typography */
.hero-title {
    font-family: 'Playfair Display', serif;
    font-size: 3rem;
    font-weight: 700;
    color: var(--cream);
    margin-bottom: 1rem;
    line-height: 1.2;
    animation: text-reveal 1s ease 0.3s backwards;
}

@keyframes text-reveal {
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
    font-size: 1.15rem;
    color: rgba(245, 241, 232, 0.8);
    line-height: 1.7;
    margin-bottom: 3rem;
    font-weight: 400;
    animation: text-reveal 1s ease 0.5s backwards;
}

/* Feature Cards */
.feature-cards {
    display: grid;
    gap: 1rem;
}

.feature-card {
    display: flex;
    align-items: flex-start;
    gap: 1rem;
    padding: 1.25rem;
    background: rgba(255, 255, 255, 0.03);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(212, 175, 55, 0.15);
    border-radius: 16px;
    transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
    animation: card-fade-in 0.6s ease backwards;
}

.feature-card:nth-child(1) { animation-delay: 0.7s; }
.feature-card:nth-child(2) { animation-delay: 0.8s; }
.feature-card:nth-child(3) { animation-delay: 0.9s; }

@keyframes card-fade-in {
    from {
        opacity: 0;
        transform: translateX(-30px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

.feature-card:hover {
    background: rgba(255, 255, 255, 0.06);
    border-color: var(--accent-gold);
    transform: translateX(8px);
    box-shadow: 
        0 10px 40px rgba(212, 175, 55, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

.feature-icon {
    flex-shrink: 0;
    width: 48px;
    height: 48px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(91, 192, 190, 0.2));
    border-radius: 12px;
    font-size: 1.3rem;
    color: var(--accent-gold);
    transition: all 0.3s ease;
}

.feature-card:hover .feature-icon {
    transform: scale(1.1) rotate(5deg);
    box-shadow: 0 5px 20px var(--glow-gold);
}

.feature-text h4 {
    font-size: 1rem;
    font-weight: 700;
    color: var(--cream);
    margin-bottom: 0.25rem;
}

.feature-text p {
    font-size: 0.875rem;
    color: rgba(245, 241, 232, 0.6);
    margin: 0;
    line-height: 1.5;
}

/* Right Panel - Form */
.form-panel {
    padding: 4rem 3rem;
    position: relative;
    background: rgba(10, 22, 40, 0.4);
}

.form-header {
    margin-bottom: 2.5rem;
    animation: fade-in-down 0.8s ease;
}

@keyframes fade-in-down {
    from {
        opacity: 0;
        transform: translateY(-30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.form-title {
    font-family: 'Playfair Display', serif;
    font-size: 2.5rem;
    font-weight: 700;
    background: linear-gradient(135deg, var(--cream) 0%, var(--accent-gold) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 0.5rem;
}

.form-subtitle {
    color: rgba(245, 241, 232, 0.7);
    font-size: 1rem;
    font-weight: 400;
}

/* Premium Alerts */
.alert {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1.25rem 1.5rem;
    border-radius: 16px;
    font-size: 0.9rem;
    font-weight: 500;
    margin-bottom: 2rem;
    border: 1.5px solid;
    position: relative;
    overflow: hidden;
    animation: alert-elegant 0.6s cubic-bezier(0.23, 1, 0.32, 1);
}

@keyframes alert-elegant {
    0% {
        opacity: 0;
        transform: translateX(-50px) scale(0.9);
    }
    60% {
        transform: translateX(10px) scale(1.02);
    }
    100% {
        opacity: 1;
        transform: translateX(0) scale(1);
    }
}

.alert::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    width: 5px;
    height: 100%;
    animation: alert-pulse 2s ease-in-out infinite;
}

@keyframes alert-pulse {
    0%, 100% { opacity: 0.6; transform: scaleY(1); }
    50% { opacity: 1; transform: scaleY(1.1); }
}

.alert-success {
    background: rgba(16, 185, 129, 0.08);
    color: var(--success);
    border-color: rgba(16, 185, 129, 0.25);
}

.alert-success::before {
    background: var(--success);
}

.alert-danger {
    background: rgba(239, 68, 68, 0.08);
    color: var(--error);
    border-color: rgba(239, 68, 68, 0.25);
}

.alert-danger::before {
    background: var(--error);
}

.alert i {
    font-size: 1.3rem;
    flex-shrink: 0;
}

/* Premium Form Controls */
.form-group {
    margin-bottom: 1.75rem;
    animation: form-reveal 0.6s ease backwards;
}

.form-group:nth-child(1) { animation-delay: 0.2s; }
.form-group:nth-child(2) { animation-delay: 0.3s; }

@keyframes form-reveal {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.form-label {
    display: flex;
    align-items: center;
    justify-content: space-between;
    color: rgba(245, 241, 232, 0.8);
    font-weight: 600;
    font-size: 0.9rem;
    margin-bottom: 0.75rem;
    letter-spacing: 0.3px;
    transition: color 0.3s ease;
}

.input-wrapper {
    position: relative;
}

.input-icon-left {
    position: absolute;
    left: 1.25rem;
    top: 50%;
    transform: translateY(-50%);
    color: rgba(212, 175, 55, 0.5);
    font-size: 1.1rem;
    transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
    pointer-events: none;
    z-index: 1;
}

.form-control {
    width: 100%;
    background: rgba(22, 37, 68, 0.6);
    border: 2px solid rgba(212, 175, 55, 0.15);
    border-radius: 16px;
    color: var(--cream);
    font-size: 1rem;
    font-weight: 500;
    padding: 1.1rem 1.25rem 1.1rem 3.5rem;
    transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
    outline: none;
}

.form-control::placeholder {
    color: rgba(245, 241, 232, 0.4);
    font-weight: 400;
}

.form-control:focus {
    background: rgba(22, 37, 68, 0.8);
    border-color: var(--accent-gold);
    box-shadow: 
        0 0 0 4px rgba(212, 175, 55, 0.08),
        0 8px 30px rgba(212, 175, 55, 0.15);
    transform: translateY(-3px);
}

.form-control:focus + .input-icon-left {
    color: var(--accent-gold);
    transform: translateY(-50%) scale(1.15) rotate(-5deg);
    filter: drop-shadow(0 0 8px var(--glow-gold));
}

.input-wrapper:has(.form-control:focus) ~ .form-label {
    color: var(--accent-gold);
}

/* Password Toggle */
.password-toggle {
    position: absolute;
    right: 1.25rem;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: rgba(212, 175, 55, 0.5);
    cursor: pointer;
    padding: 0.5rem;
    transition: all 0.3s ease;
    z-index: 2;
}

.password-toggle:hover {
    color: var(--accent-gold);
    transform: translateY(-50%) scale(1.15);
}

/* Form Options */
.form-options {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 2rem;
    font-size: 0.9rem;
    animation: fade-in 0.6s ease 0.4s backwards;
}

@keyframes fade-in {
    from { opacity: 0; }
    to { opacity: 1; }
}

.checkbox-label {
    display: flex;
    align-items: center;
    gap: 0.625rem;
    cursor: pointer;
    color: rgba(245, 241, 232, 0.7);
    transition: color 0.3s ease;
}

.checkbox-label:hover {
    color: var(--cream);
}

.checkbox-label input[type="checkbox"] {
    width: 20px;
    height: 20px;
    cursor: pointer;
    accent-color: var(--accent-gold);
}

.forgot-link {
    color: var(--accent-gold);
    text-decoration: none;
    font-weight: 600;
    position: relative;
    transition: all 0.3s ease;
}

.forgot-link::after {
    content: '';
    position: absolute;
    bottom: -3px;
    left: 0;
    width: 0;
    height: 2px;
    background: linear-gradient(90deg, var(--accent-gold), var(--accent-rose));
    transition: width 0.3s ease;
}

.forgot-link:hover {
    color: var(--accent-rose);
}

.forgot-link:hover::after {
    width: 100%;
}

/* Luxury Submit Button */
.btn-submit {
    width: 100%;
    position: relative;
    background: linear-gradient(135deg, var(--accent-gold) 0%, #b8963d 100%);
    color: var(--primary-navy);
    border: none;
    border-radius: 16px;
    padding: 1.25rem 2rem;
    font-weight: 800;
    font-size: 1.05rem;
    letter-spacing: 0.5px;
    cursor: pointer;
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
    box-shadow: 
        0 15px 40px rgba(212, 175, 55, 0.35),
        inset 0 2px 10px rgba(255, 255, 255, 0.3);
    margin-bottom: 2rem;
    animation: button-reveal 0.6s ease 0.5s backwards;
}

@keyframes button-reveal {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.btn-submit::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.4) 0%, transparent 70%);
    transform: translate(-50%, -50%);
    transition: width 0.6s ease, height 0.6s ease;
}

.btn-submit:hover::before {
    width: 400px;
    height: 400px;
}

.btn-submit:hover {
    transform: translateY(-4px);
    box-shadow: 
        0 20px 50px rgba(212, 175, 55, 0.5),
        inset 0 2px 15px rgba(255, 255, 255, 0.4);
}

.btn-submit:active {
    transform: translateY(-2px) scale(0.98);
}

.btn-submit i {
    margin-right: 0.625rem;
    transition: transform 0.3s ease;
}

.btn-submit:hover i {
    transform: translateX(4px);
}

/* Elegant Divider */
.divider {
    display: flex;
    align-items: center;
    margin: 2rem 0;
    color: rgba(245, 241, 232, 0.5);
    font-size: 0.875rem;
    font-weight: 500;
    animation: fade-in 0.6s ease 0.6s backwards;
}

.divider::before,
.divider::after {
    content: '';
    flex: 1;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(212, 175, 55, 0.3), transparent);
}

.divider span {
    padding: 0 1.25rem;
}

/* Social Buttons */
.social-buttons {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-bottom: 2rem;
    animation: fade-in 0.6s ease 0.7s backwards;
}

.btn-social {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.625rem;
    background: rgba(22, 37, 68, 0.6);
    border: 2px solid rgba(212, 175, 55, 0.15);
    border-radius: 14px;
    padding: 1rem;
    color: var(--cream);
    font-weight: 600;
    font-size: 0.95rem;
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
    position: relative;
    overflow: hidden;
}

.btn-social::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    background: radial-gradient(circle, rgba(212, 175, 55, 0.1), transparent);
    border-radius: 50%;
    transform: translate(-50%, -50%);
    transition: width 0.4s ease, height 0.4s ease;
}

.btn-social:hover::before {
    width: 300px;
    height: 300px;
}

.btn-social:hover {
    background: rgba(22, 37, 68, 0.8);
    border-color: var(--accent-gold);
    transform: translateY(-4px);
    box-shadow: 0 10px 30px rgba(212, 175, 55, 0.2);
}

.btn-social i {
    font-size: 1.2rem;
    transition: transform 0.3s ease;
}

.btn-social:hover i {
    transform: scale(1.1) rotate(5deg);
}

/* Footer */
.form-footer {
    text-align: center;
    color: rgba(245, 241, 232, 0.6);
    font-size: 0.95rem;
    animation: fade-in 0.6s ease 0.8s backwards;
}

.form-footer a {
    color: var(--accent-gold);
    text-decoration: none;
    font-weight: 700;
    transition: all 0.3s ease;
}

.form-footer a:hover {
    color: var(--accent-rose);
    text-decoration: underline;
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

/* Responsive Design */
@media (max-width: 991px) {
    .login-wrapper {
        grid-template-columns: 1fr;
        max-width: 550px;
    }
    
    .hero-panel {
        padding: 3rem 2rem;
    }
    
    .form-panel {
        padding: 3rem 2rem;
    }
    
    .hero-title {
        font-size: 2.5rem;
    }
    
    .form-title {
        font-size: 2rem;
    }
}

@media (max-width: 576px) {
    .login-container {
        padding: 1rem;
    }
    
    .hero-panel,
    .form-panel {
        padding: 2rem 1.5rem;
    }
    
    .hero-title {
        font-size: 2rem;
    }
    
    .form-title {
        font-size: 1.75rem;
    }
    
    .luxury-icon-wrapper {
        width: 100px;
        height: 100px;
    }
    
    .luxury-icon-inner i {
        font-size: 3rem;
    }
    
    .social-buttons {
        grid-template-columns: 1fr;
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
.btn-submit:focus-visible,
a:focus-visible,
button:focus-visible {
    outline: 3px solid var(--accent-gold);
    outline-offset: 3px;
}
</style>
</head>
<body>
<!-- Luxury Background -->
<div class="luxury-bg">
    <div class="luxury-orb orb-gold"></div>
    <div class="luxury-orb orb-teal"></div>
    <div class="luxury-orb orb-lavender"></div>
</div>
<div class="elegant-grid"></div>
<div class="particles-elegant" id="elegantParticles"></div>

<div class="login-container">
    <div class="login-wrapper">
        <!-- Hero Panel -->
        <div class="hero-panel">
            <div class="hero-content">
                <div class="luxury-icon-container">
                    <div class="luxury-icon-wrapper">
                        <div class="luxury-icon-bg"></div>
                        <div class="luxury-icon-inner">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                    </div>
                </div>
                
                <h1 class="hero-title">
                    Your Academic <span class="highlight">Excellence</span> Awaits
                </h1>
                <p class="hero-subtitle">
                    Experience seamless event management with our premium platform designed for academic excellence and professional growth.
                </p>
                
                <div class="feature-cards">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <div class="feature-text">
                            <h4>Instant Access</h4>
                            <p>Lightning-fast login and real-time updates</p>
                        </div>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="feature-text">
                            <h4>Enterprise Security</h4>
                            <p>Bank-level encryption for your data</p>
                        </div>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-crown"></i>
                        </div>
                        <div class="feature-text">
                            <h4>Premium Experience</h4>
                            <p>Designed for professionals like you</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Form Panel -->
        <div class="form-panel">
            <div class="form-header">
                <h2 class="form-title">Sign In</h2>
                <p class="form-subtitle">Welcome back! Please enter your credentials</p>
            </div>

            <%-- Success/Error Messages --%>
            <%
            String success = request.getParameter("success");
            if (success != null) {
            %>
                <% if ("registered".equals(success)) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>Registration successful! Awaiting administrator approval.</span>
                </div>
                <% } else if ("approved".equals(success)) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>Account approved! Welcome to the platform.</span>
                </div>
                <% } %>
            <% } %>
            
            <%
            String error = request.getParameter("error");
            if (error != null) {
            %>
                <% if ("invalid".equals(error)) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>Invalid credentials. Please verify and try again.</span>
                </div>
                <% } %>
            <% } %>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= request.getAttribute("errorMessage") %></span>
            </div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/login" autocomplete="off" novalidate id="loginForm">
                <div class="form-group">
                    <label class="form-label" for="username">
                        <span>Username</span>
                    </label>
                    <div class="input-wrapper">
                        <i class="fas fa-user input-icon-left"></i>
                        <input 
                            type="text" 
                            class="form-control" 
                            id="username" 
                            name="username"
                            placeholder="Enter your username" 
                            required 
                            autofocus
                        >
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="password">
                        <span>Password</span>
                    </label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock input-icon-left"></i>
                        <input 
                            type="password" 
                            class="form-control" 
                            id="password" 
                            name="password"
                            placeholder="Enter your password" 
                            required
                        >
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye" id="toggleIcon"></i>
                        </button>
                    </div>
                </div>

                <div class="form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" name="remember">
                        <span>Remember me</span>
                    </label>
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>
                
                <button type="submit" class="btn-submit" id="submitBtn">
                    <i class="fas fa-sign-in-alt"></i> Sign In Securely
                </button>
            </form>

            <div class="divider">
                <span>Or continue with</span>
            </div>

            <div class="social-buttons">
                <button type="button" class="btn-social">
                    <i class="fab fa-google"></i>
                    <span>Google</span>
                </button>
                <button type="button" class="btn-social">
                    <i class="fab fa-github"></i>
                    <span>GitHub</span>
                </button>
            </div>
            
            <div class="form-footer">
                New to the platform? <a href="register.jsp">Create an account</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Create Elegant Particles
function createElegantParticles() {
    const container = document.getElementById('elegantParticles');
    const particleCount = 30;
    const colors = ['#d4af37', '#5bc0be', '#9d84b7'];
    
    for (let i = 0; i < particleCount; i++) {
        const particle = document.createElement('div');
        particle.classList.add('particle-elegant');
        particle.style.left = Math.random() * 100 + '%';
        particle.style.width = (Math.random() * 2 + 1) + 'px';
        particle.style.height = particle.style.width;
        particle.style.animationDuration = (Math.random() * 20 + 20) + 's';
        particle.style.animationDelay = Math.random() * 15 + 's';
        
        const randomColor = colors[Math.floor(Math.random() * colors.length)];
        particle.style.background = randomColor;
        
        const glowColor = randomColor === '#d4af37' ? 'rgba(212, 175, 55, 0.3)' :
                         randomColor === '#5bc0be' ? 'rgba(91, 192, 190, 0.3)' :
                         'rgba(157, 132, 183, 0.3)';
        particle.style.boxShadow = `0 0 8px ${glowColor}`;
        
        container.appendChild(particle);
    }
}

// Password Toggle
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.getElementById('toggleIcon');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.classList.remove('fa-eye');
        toggleIcon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        toggleIcon.classList.remove('fa-eye-slash');
        toggleIcon.classList.add('fa-eye');
    }
}

// Form Validation & Submission
const loginForm = document.getElementById('loginForm');
const submitBtn = document.getElementById('submitBtn');

loginForm.addEventListener('submit', function(e) {
    if (!this.checkValidity()) {
        e.preventDefault();
        
        const invalidInputs = this.querySelectorAll(':invalid');
        invalidInputs.forEach(input => {
            const wrapper = input.closest('.input-wrapper');
            wrapper.style.animation = 'none';
            setTimeout(() => {
                wrapper.style.animation = 'shake 0.5s cubic-bezier(0.36, 0.07, 0.19, 0.97)';
            }, 10);
        });
        
        return;
    }
    
    if (!this.submitted) {
        this.submitted = true;
        submitBtn.classList.add('btn-loading');
        submitBtn.disabled = true;
    } else {
        e.preventDefault();
    }
});

// Shake Animation
const shakeStyle = document.createElement('style');
shakeStyle.textContent = `
    @keyframes shake {
        10%, 90% { transform: translate3d(-1px, 0, 0); }
        20%, 80% { transform: translate3d(2px, 0, 0); }
        30%, 50%, 70% { transform: translate3d(-4px, 0, 0); }
        40%, 60% { transform: translate3d(4px, 0, 0); }
    }
`;
document.head.appendChild(shakeStyle);

// Input Enhancement
document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('input', function() {
        if (this.value.length > 0) {
            this.style.borderColor = 'rgba(212, 175, 55, 0.4)';
        } else {
            this.style.borderColor = 'rgba(212, 175, 55, 0.15)';
        }
    });
});

// Auto-hide Alerts with Fade
document.querySelectorAll('.alert').forEach(alert => {
    setTimeout(() => {
        alert.style.transition = 'all 0.5s cubic-bezier(0.4, 0, 0.2, 1)';
        alert.style.opacity = '0';
        alert.style.transform = 'translateX(-50px) scale(0.95)';
        setTimeout(() => alert.remove(), 500);
    }, 7000);
});

// Initialize
window.addEventListener('load', () => {
    createElegantParticles();
    
    // Add smooth scroll reveal
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.1 });
});

// Ripple Effect on Buttons
document.querySelectorAll('.btn-social, .btn-submit').forEach(button => {
    button.addEventListener('click', function(e) {
        const ripple = document.createElement('span');
        const rect = this.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = e.clientX - rect.left - size / 2;
        const y = e.clientY - rect.top - size / 2;
        
        ripple.style.cssText = `
            position: absolute;
            width: ${size}px;
            height: ${size}px;
            left: ${x}px;
            top: ${y}px;
            background: rgba(212, 175, 55, 0.4);
            border-radius: 50%;
            transform: scale(0);
            animation: ripple-effect 0.6s ease-out;
            pointer-events: none;
        `;
        
        this.style.position = 'relative';
        this.style.overflow = 'hidden';
        this.appendChild(ripple);
        
        setTimeout(() => ripple.remove(), 600);
    });
});

// Ripple Animation
const rippleStyle = document.createElement('style');
rippleStyle.textContent = `
    @keyframes ripple-effect {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(rippleStyle);
</script>
</body>
</html>
