<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.RegistrationDAO" %>
<%@ page import="com.event.dao.UserDAO" %>
<%@ page import="com.event.model.Registration" %>
<%@ page import="com.event.model.User" %>
<%@ page import="java.util.List" %>

<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    RegistrationDAO registrationDAO = new RegistrationDAO();
    UserDAO userDAO = new UserDAO();
    
    List<Registration> pendingRegistrations = registrationDAO.getPendingRegistrations();
    List<User> pendingUsers = userDAO.getPendingUsers();
    
    int totalPending = pendingRegistrations.size() + pendingUsers.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approvals - University Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
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

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(212, 175, 55, 0.08), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(91, 192, 190, 0.08), transparent 60%),
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

        .sidebar .nav-link {
            color: rgba(245, 241, 232, 0.7);
            padding: 1rem 1.5rem;
            margin: 0.25rem 0;
            border-left: 3px solid transparent;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
        }

        .sidebar .nav-link:hover {
            color: var(--accent-gold);
            background: rgba(212, 175, 55, 0.1);
            border-left-color: var(--accent-gold);
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            color: var(--accent-gold);
            background: rgba(212, 175, 55, 0.15);
            border-left-color: var(--accent-gold);
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.2);
        }

        .sidebar .nav-link i {
            font-size: 1.1rem;
            width: 20px;
        }

        .sidebar .badge {
            margin-left: auto;
            background: var(--error);
            padding: 0.35rem 0.6rem;
            border-radius: 50px;
            font-weight: 700;
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
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
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

        .badge-pending {
            background: linear-gradient(135deg, var(--warning), var(--accent-gold));
            color: var(--primary-navy);
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.125rem;
        }

        /* Alerts */
        .alert {
            border-radius: 14px;
            border: none;
            backdrop-filter: blur(10px);
            animation: slide-down 0.4s ease;
        }

        @keyframes slide-down {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: var(--success);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: var(--error);
        }

        .alert-info {
            background: rgba(91, 192, 190, 0.15);
            border: 1px solid rgba(91, 192, 190, 0.3);
            color: var(--accent-teal);
        }

        /* Nav Pills */
        .nav-pills {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .nav-pills .nav-link {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 14px;
            color: rgba(245, 241, 232, 0.7);
            padding: 1rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .nav-pills .nav-link:hover {
            border-color: var(--accent-gold);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(212, 175, 55, 0.2);
        }

        .nav-pills .nav-link.active {
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            color: var(--primary-navy);
            border-color: transparent;
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
        }

        .badge-count {
            background: var(--error);
            color: white;
            padding: 0.35rem 0.6rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            margin-left: 0.5rem;
        }

        /* Cards */
        .card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 20px;
            color: var(--warm-white);
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

        .card-header {
            background: rgba(10, 22, 40, 0.5);
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            padding: 1.5rem 2rem;
        }

        .card-header h5 {
            font-weight: 700;
            color: var(--cream);
            margin: 0;
        }

        .card-body {
            padding: 2rem;
        }

        /* Table */
        .table {
            color: var(--warm-white);
            margin-bottom: 0;
        }

        .table thead th {
            background: rgba(212, 175, 55, 0.15);
            color: var(--cream);
            font-weight: 600;
            border-bottom: 2px solid rgba(212, 175, 55, 0.2);
            padding: 1rem;
        }

        .table tbody tr {
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background: rgba(212, 175, 55, 0.05);
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
        }

        /* Badges */
        .badge {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .bg-primary {
            background: var(--accent-gold) !important;
            color: var(--primary-navy) !important;
        }

        .bg-info {
            background: var(--accent-teal) !important;
        }

        .bg-warning {
            background: var(--warning) !important;
            color: var(--primary-navy) !important;
        }

        .bg-success {
            background: var(--success) !important;
        }

        .bg-danger {
            background: var(--error) !important;
        }

        /* Buttons */
        .btn-success {
            background: linear-gradient(135deg, var(--success), var(--accent-teal));
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(16, 185, 129, 0.4);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--error), #dc2626);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(239, 68, 68, 0.4);
            color: white;
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

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="sidebar">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="events.jsp">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Events</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="approvals.jsp">
                            <i class="fas fa-check-circle"></i>
                            <span>Approvals</span>
                            <% if (totalPending > 0) { %>
                                <span class="badge"><%= totalPending %></span>
                            <% } %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="scan-qr.jsp">
                            <i class="fas fa-qrcode"></i>
                            <span>Scan QR</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reports.jsp">
                            <i class="fas fa-chart-bar"></i>
                            <span>Reports</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1><i class="fas fa-check-double" style="color: var(--accent-gold);"></i> Pending Approvals</h1>
                    <span class="badge-pending"><%= totalPending %> Total Pending</span>
                </div>

                <%-- Success/Error Messages --%>
                <% 
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                if (success != null) { 
                %>
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i>
                        <% if ("user_approved".equals(success)) { %>
                            User account approved successfully! Approval email sent.
                        <% } else if ("user_rejected".equals(success)) { %>
                            User account rejected. Rejection email sent.
                        <% } else if ("event_approved".equals(success)) { %>
                            Event registration approved! QR code sent via email.
                        <% } else if ("event_rejected".equals(success)) { %>
                            Event registration rejected.
                        <% } %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <%= error.equals("not_found") ? "Record not found" : "Operation failed. Please try again." %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <%-- Tabs Navigation --%>
                <ul class="nav nav-pills" id="approvalTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="users-tab" data-bs-toggle="pill" 
                                data-bs-target="#users" type="button" role="tab">
                            <i class="fas fa-user-clock"></i> User Account Approvals
                            <% if (pendingUsers.size() > 0) { %>
                                <span class="badge-count"><%= pendingUsers.size() %></span>
                            <% } %>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="events-tab" data-bs-toggle="pill" 
                                data-bs-target="#events" type="button" role="tab">
                            <i class="fas fa-calendar-check"></i> Event Registration Approvals
                            <% if (pendingRegistrations.size() > 0) { %>
                                <span class="badge-count"><%= pendingRegistrations.size() %></span>
                            <% } %>
                        </button>
                    </li>
                </ul>

                <%-- Tabs Content --%>
                <div class="tab-content" id="approvalTabsContent">
                    
                    <%-- TAB 1: USER ACCOUNT APPROVALS --%>
                    <div class="tab-pane fade show active" id="users" role="tabpanel">
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="fas fa-users"></i> Pending User Account Approvals</h5>
                            </div>
                            <div class="card-body">
                                <% if (pendingUsers.isEmpty()) { %>
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i> No pending user account approvals.
                                    </div>
                                <% } else { %>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>User ID</th>
                                                    <th>Username</th>
                                                    <th>Email</th>
                                                    <th>Phone</th>
                                                    <th>Role</th>
                                                    <th>Registered On</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (User user : pendingUsers) { %>
                                                <tr>
                                                    <td><strong>#<%= user.getId() %></strong></td>
                                                    <td><%= user.getUsername() %></td>
                                                    <td><%= user.getEmail() %></td>
                                                    <td><%= user.getPhone() %></td>
                                                    <td>
                                                        <span class="badge bg-<%= user.getRole().equals("organizer") ? "primary" : "info" %>">
                                                            <%= user.getRole().toUpperCase() %>
                                                        </span>
                                                    </td>
                                                    <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm").format(user.getCreatedAt()) %></td>
                                                    <td><span class="badge bg-warning">PENDING</span></td>
                                                    <td>
                                                        <form method="post" action="${pageContext.request.contextPath}/approveUser" style="display: inline;">
                                                            <input type="hidden" name="userId" value="<%= user.getId() %>">
                                                            <input type="hidden" name="action" value="approve">
                                                            <button type="submit" class="btn btn-sm btn-success" 
                                                                    onclick="return confirm('Approve this user account?')">
                                                                <i class="fas fa-check"></i> Approve
                                                            </button>
                                                        </form>
                                                        <button class="btn btn-sm btn-danger" 
                                                                onclick="rejectUser(<%= user.getId() %>)">
                                                            <i class="fas fa-times"></i> Reject
                                                        </button>
                                                    </td>
                                                </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <%-- TAB 2: EVENT REGISTRATION APPROVALS --%>
                    <div class="tab-pane fade" id="events" role="tabpanel">
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="fas fa-calendar-alt"></i> Pending Event Registration Approvals</h5>
                            </div>
                            <div class="card-body">
                                <% if (pendingRegistrations.isEmpty()) { %>
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i> No pending event registration approvals.
                                    </div>
                                <% } else { %>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Reg ID</th>
                                                    <th>Participant</th>
                                                    <th>Email</th>
                                                    <th>Event</th>
                                                    <th>Payment Status</th>
                                                    <th>Registered On</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (Registration reg : pendingRegistrations) { %>
                                                <tr>
                                                    <td><strong>REG<%= reg.getId() %></strong></td>
                                                    <td><%= reg.getUserName() %></td>
                                                    <td><%= reg.getUserEmail() %></td>
                                                    <td><%= reg.getEventName() %></td>
                                                    <td>
                                                        <span class="badge bg-<%= reg.getPaymentStatus().equals("completed") ? "success" : "danger" %>">
                                                            <%= reg.getPaymentStatus().toUpperCase() %>
                                                        </span>
                                                    </td>
                                                    <td><%= new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm").format(reg.getRegistrationDate()) %></td>
                                                    <td>
                                                        <form method="post" action="${pageContext.request.contextPath}/approveRegistration" style="display: inline;">
                                                            <input type="hidden" name="regId" value="<%= reg.getId() %>">
                                                            <input type="hidden" name="action" value="approve">
                                                            <button type="submit" class="btn btn-sm btn-success"
                                                                    onclick="return confirm('Approve this event registration?')">
                                                                <i class="fas fa-check"></i> Approve
                                                            </button>
                                                        </form>
                                                        <button class="btn btn-sm btn-danger" 
                                                                onclick="rejectRegistration(<%= reg.getId() %>)">
                                                            <i class="fas fa-times"></i> Reject
                                                        </button>
                                                    </td>
                                                </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Reject User Account
        function rejectUser(userId) {
            if (confirm('Are you sure you want to reject this user account?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/approveUser';
                
                const userInput = document.createElement('input');
                userInput.type = 'hidden';
                userInput.name = 'userId';
                userInput.value = userId;
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'reject';
                
                form.appendChild(userInput);
                form.appendChild(actionInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Reject Event Registration
        function rejectRegistration(regId) {
            const reason = prompt('Enter rejection reason (optional):');
            if (reason !== null) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/approveRegistration';
                
                const regInput = document.createElement('input');
                regInput.type = 'hidden';
                regInput.name = 'regId';
                regInput.value = regId;
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'reject';
                
                if (reason.trim() !== '') {
                    const reasonInput = document.createElement('input');
                    reasonInput.type = 'hidden';
                    reasonInput.name = 'reason';
                    reasonInput.value = reason;
                    form.appendChild(reasonInput);
                }
                
                form.appendChild(regInput);
                form.appendChild(actionInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Remember active tab
        const triggerTabList = document.querySelectorAll('#approvalTabs button');
        triggerTabList.forEach(triggerEl => {
            const tabTrigger = new bootstrap.Tab(triggerEl);
            triggerEl.addEventListener('click', event => {
                event.preventDefault();
                tabTrigger.show();
                localStorage.setItem('activeApprovalTab', triggerEl.id);
            });
        });

        // Restore active tab on page load
        const activeTab = localStorage.getItem('activeApprovalTab');
        if (activeTab) {
            const tab = document.getElementById(activeTab);
            if (tab) {
                new bootstrap.Tab(tab).show();
            }
        }
    </script>
</body>
</html>
