<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get session variables - DO NOT REDIRECT HERE
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
%>
<style>
    /* Navbar Styles */
    .luxury-navbar {
        background: rgba(22, 37, 68, 0.95) !important;
        backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(212, 175, 55, 0.1);
        padding: 1rem 0;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    }

    .luxury-navbar .navbar-brand {
        font-family: 'Playfair Display', serif;
        font-size: 1.5rem;
        font-weight: 700;
        background: linear-gradient(135deg, #d4af37, #f5f1e8);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .luxury-navbar .navbar-brand i {
        color: #d4af37;
        font-size: 1.5rem;
        animation: icon-pulse 2s ease-in-out infinite;
    }

    @keyframes icon-pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.1); }
    }

    .luxury-navbar .navbar-brand:hover {
        transform: scale(1.05);
    }

    .luxury-navbar .nav-link {
        color: rgba(245, 241, 232, 0.7) !important;
        font-weight: 500;
        padding: 0.5rem 1rem;
        margin: 0 0.25rem;
        border-radius: 8px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .luxury-navbar .nav-link:hover {
        color: #d4af37 !important;
        background: rgba(212, 175, 55, 0.1);
        transform: translateY(-2px);
    }

    .luxury-navbar .nav-link.active {
        color: #d4af37 !important;
        background: rgba(212, 175, 55, 0.15);
        font-weight: 700;
    }

    .luxury-navbar .nav-link i {
        font-size: 1rem;
    }

    /* Dropdown Menu */
    .luxury-navbar .dropdown-menu {
        background: rgba(22, 37, 68, 0.95);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(212, 175, 55, 0.2);
        border-radius: 12px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
        padding: 0.5rem;
        margin-top: 0.5rem;
    }

    .luxury-navbar .dropdown-item {
        color: rgba(245, 241, 232, 0.8);
        padding: 0.75rem 1rem;
        border-radius: 8px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .luxury-navbar .dropdown-item:hover {
        background: rgba(212, 175, 55, 0.15);
        color: #d4af37;
        transform: translateX(5px);
    }

    .luxury-navbar .dropdown-item i {
        font-size: 1.1rem;
        width: 20px;
    }

    .luxury-navbar .dropdown-divider {
        border-color: rgba(212, 175, 55, 0.2);
        margin: 0.5rem 0;
    }

    /* User Dropdown */
    .luxury-navbar .dropdown-toggle::after {
        margin-left: 0.5rem;
        vertical-align: 0.15em;
    }

    .luxury-navbar .user-avatar {
        width: 32px;
        height: 32px;
        background: linear-gradient(135deg, #d4af37, #e8b4b8);
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: #0a1628;
        font-weight: 700;
        margin-right: 0.5rem;
    }

    /* Navbar Toggler */
    .luxury-navbar .navbar-toggler {
        border-color: rgba(212, 175, 55, 0.3);
        padding: 0.5rem 0.75rem;
    }

    .luxury-navbar .navbar-toggler:focus {
        box-shadow: 0 0 0 0.2rem rgba(212, 175, 55, 0.25);
    }

    .luxury-navbar .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28212, 175, 55, 0.8%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }

    /* Responsive */
    @media (max-width: 991px) {
        .luxury-navbar .navbar-collapse {
            background: rgba(22, 37, 68, 0.98);
            backdrop-filter: blur(20px);
            padding: 1rem;
            border-radius: 12px;
            margin-top: 1rem;
            border: 1px solid rgba(212, 175, 55, 0.1);
        }

        .luxury-navbar .nav-link {
            margin: 0.25rem 0;
        }

        .luxury-navbar .dropdown-menu {
            background: rgba(10, 22, 40, 0.95);
            border: none;
            box-shadow: none;
        }
    }

    /* Badge notification */
    .notification-badge {
        position: absolute;
        top: 0;
        right: 0;
        background: #ef4444;
        color: white;
        font-size: 0.7rem;
        font-weight: 700;
        padding: 0.15rem 0.4rem;
        border-radius: 10px;
        line-height: 1;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-dark luxury-navbar">
    <div class="container-fluid">
        <!-- Brand -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-graduation-cap"></i>
            <span>University Events</span>
        </a>

        <!-- Toggler Button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar Content -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <%
                    if (username != null) {
                        if ("participant".equals(role)) {
                %>
                    <!-- Participant Navigation -->
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/participant/dashboard.jsp">
                            <i class="fas fa-home"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/participant/register-event.jsp">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Events</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/participant/my-registrations.jsp">
                            <i class="fas fa-ticket-alt"></i>
                            <span>My Registrations</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/participant/feedback.jsp">
                            <i class="fas fa-comment"></i>
                            <span>Feedback</span>
                        </a>
                    </li>
                <%
                        } else if ("organizer".equals(role)) {
                %>
                    <!-- Organizer Navigation -->
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/organizer/dashboard.jsp">
                            <i class="fas fa-home"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/organizer/scan-qr.jsp">
                            <i class="fas fa-qrcode"></i>
                            <span>Scan QR</span>
                        </a>
                    </li>
                <%
                        } else if ("admin".equals(role)) {
                %>
                    <!-- Admin Navigation -->
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                            <i class="fas fa-home"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/events.jsp">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Events</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/approvals.jsp">
                            <i class="fas fa-check-circle"></i>
                            <span>Approvals</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/scan-qr.jsp">
                            <i class="fas fa-qrcode"></i>
                            <span>Scan QR</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports.jsp">
                            <i class="fas fa-chart-bar"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                <%
                        }
                %>
                
                <!-- User Dropdown -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <span class="user-avatar">
                            <%= username != null ? username.substring(0, 1).toUpperCase() : "U" %>
                        </span>
                        <span><%= username %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li>
                            <a class="dropdown-item" href="#">
                                <i class="fas fa-user"></i>
                                <span>Profile</span>
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item" href="#">
                                <i class="fas fa-cog"></i>
                                <span>Settings</span>
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt"></i>
                                <span>Logout</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <%
                    } else {
                %>
                    <!-- Guest Navigation -->
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">
                            <i class="fas fa-sign-in-alt"></i>
                            <span>Login</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register.jsp">
                            <i class="fas fa-user-plus"></i>
                            <span>Register</span>
                        </a>
                    </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</nav>

<script>
    // Add active class to current page
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        document.querySelectorAll('.luxury-navbar .nav-link').forEach(link => {
            const href = link.getAttribute('href');
            if (href && currentPath.includes(href) && href !== '/') {
                link.classList.add('active');
            }
        });
    });

    // Close mobile menu on link click
    document.querySelectorAll('.luxury-navbar .nav-link').forEach(link => {
        link.addEventListener('click', function() {
            const navbarCollapse = document.querySelector('.navbar-collapse');
            if (navbarCollapse.classList.contains('show')) {
                const bsCollapse = new bootstrap.Collapse(navbarCollapse);
                bsCollapse.hide();
            }
        });
    });
</script>
