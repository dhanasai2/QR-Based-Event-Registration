<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.EventDAO, com.event.dao.RegistrationDAO" %>
<%@ page import="com.event.model.Event, com.event.model.Registration" %>
<%@ page import="java.util.List" %>

<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    EventDAO eventDAO = new EventDAO();
    RegistrationDAO regDAO = new RegistrationDAO();
    List<Event> events = eventDAO.getAllEvents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Reports - University Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
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
            --danger: #ef4444;
            --card-bg: rgba(22, 37, 68, 0.7);
            --table-header-bg: rgba(212, 175, 55, 0.15);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(212, 175, 55, 0.06), transparent 60%), 
                        radial-gradient(ellipse at bottom right, rgba(91, 192, 190, 0.06), transparent 60%), 
                        linear-gradient(135deg, var(--primary-navy) 0%, #0d1b2a 50%, var(--primary-navy) 100%);
            min-height: 100vh;
            color: var(--warm-white);
            margin: 0;
            padding: 0;
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
        nav.sidebar {
            position: fixed;
            top: 76px;
            bottom: 0;
            left: 0;
            width: 260px;
            background: rgba(22, 37, 68, 0.95);
            backdrop-filter: blur(20px);
            border-right: 1px solid rgba(212, 175, 55, 0.1);
            padding: 2rem 0;
            overflow-y: auto;
            z-index: 100;
        }

        nav.sidebar .nav-link {
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

        nav.sidebar .nav-link:hover,
        nav.sidebar .nav-link.active {
            color: var(--accent-gold);
            background: rgba(212, 175, 55, 0.15);
            border-left-color: var(--accent-gold);
            transform: translateX(5px);
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.2);
        }

        nav.sidebar .nav-link i {
            font-size: 1.1rem;
            width: 20px;
        }

        /* Main Content */
        main.col-md-10 {
            margin-left: 260px;
            padding: 2rem 3rem;
            position: relative;
            z-index: 1;
            min-height: calc(100vh - 76px);
        }

        /* Header */
        h1.h2 {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            background: linear-gradient(135deg, var(--cream), var(--accent-gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            font-size: 2.5rem;
        }

        h1.h2 i {
            font-size: 2.5rem;
            color: var(--accent-gold);
            -webkit-text-fill-color: var(--accent-gold);
        }

        /* Cards */
        .card.shadow {
            background: var(--card-bg);
            backdrop-filter: blur(40px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.7);
            color: var(--warm-white);
            animation: fade-in 0.6s ease;
        }

        @keyframes fade-in {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-header.bg-info {
            background-image: linear-gradient(135deg, var(--accent-teal), var(--accent-lavender));
            border-radius: 24px 24px 0 0;
            font-weight: 700;
            font-size: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        /* Table */
        table.table {
            background: transparent;
            color: var(--warm-white);
            border-radius: 20px;
            overflow: hidden;
        }

        thead.table-info {
            background-color: var(--table-header-bg);
            color: var(--cream);
            font-weight: 700;
        }

        thead.table-info th {
            border: none;
            vertical-align: middle;
            font-size: 1rem;
            padding: 1rem;
        }

        tbody tr {
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background-color: rgba(212, 175, 55, 0.15);
        }

        tbody td {
            vertical-align: middle;
            font-weight: 500;
            font-size: 0.95rem;
            padding: 1rem;
        }

        /* Badges */
        .badge.bg-primary {
            background: var(--accent-gold) !important;
            color: var(--primary-navy) !important;
            font-weight: bold;
            padding: 0.5rem 1rem;
            box-shadow: 0 0 10px var(--accent-gold);
        }

        .badge.bg-success {
            background: var(--success) !important;
            color: white !important;
            font-weight: bold;
            padding: 0.5rem 1rem;
            box-shadow: 0 0 10px var(--success);
        }

        /* Progress bar */
        .progress {
            background: rgba(255,255,255,0.12);
            height: 28px;
            border-radius: 14px;
            overflow: hidden;
        }

        .progress-bar {
            font-weight: 700;
            font-size: 1rem;
            line-height: 28px;
            border-radius: 14px;
            box-shadow: 0 0 8px rgba(255, 255, 255, 0.3);
        }

        .bg-success { background-color: var(--success) !important; }
        .bg-warning { background-color: var(--warning) !important; box-shadow: 0 0 8px var(--warning) !important; }
        .bg-danger { background-color: var(--danger) !important; box-shadow: 0 0 8px var(--danger) !important; }

        /* Action Buttons */
        .btn-sm {
            padding: 0.5rem 1rem;
            font-weight: 600;
            border-radius: 12px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-success {
            background-image: linear-gradient(135deg, var(--success), var(--accent-teal));
            border: none;
            color: white !important;
            box-shadow: 0 5px 15px rgba(16, 185, 129, 0.3);
        }
        .btn-success:hover {
            background-image: linear-gradient(135deg, var(--accent-teal), var(--success));
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
            transform: translateY(-2px);
            color: white !important;
        }

        .btn-primary {
            background-image: linear-gradient(135deg, var(--accent-gold), var(--accent-lavender));
            border: none;
            color: var(--primary-navy) !important;
            box-shadow: 0 5px 15px rgba(212, 175, 55, 0.3);
        }
        .btn-primary:hover {
            background-image: linear-gradient(135deg, var(--accent-lavender), var(--accent-gold));
            box-shadow: 0 8px 20px rgba(212, 175, 55, 0.4);
            transform: translateY(-2px);
            color: var(--primary-navy) !important;
        }

        /* Summary Cards */
        .row.mt-4 > div .card {
            padding: 2.5rem 1.5rem;
            font-weight: 600;
            font-size: 2rem;
            border-radius: 24px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.65);
            animation: fade-in 0.6s ease backwards;
        }

        .row.mt-4 > div:nth-child(1) .card { animation-delay: 0.1s; }
        .row.mt-4 > div:nth-child(2) .card { animation-delay: 0.2s; }
        .row.mt-4 > div:nth-child(3) .card { animation-delay: 0.3s; }

        .row.mt-4 > div .card i {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }

        /* Responsive */
        @media (max-width: 991px) {
            nav.sidebar {
                transform: translateX(-100%);
            }
            main.col-md-10 {
                margin-left: 0;
            }
        }

        @media (max-width: 576px) {
            h1.h2 {
                font-size: 2rem;
            }
            main.col-md-10 {
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
            <nav class="col-md-2 d-md-block sidebar">
                <div class="position-sticky">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="dashboard.jsp">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="events.jsp">
                                <i class="fas fa-calendar-alt"></i> Events
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="approvals.jsp">
                                <i class="fas fa-check-circle"></i> Approvals
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="scan-qr.jsp">
                                <i class="fas fa-qrcode"></i> Scan QR
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="reports.jsp">
                                <i class="fas fa-chart-bar"></i> Reports
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom" style="border-color: rgba(212, 175, 55, 0.2) !important;">
                    <h1 class="h2"><i class="fas fa-chart-bar"></i> Event Reports</h1>
                </div>

                <div class="card shadow">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle">
                                <thead class="table-info">
                                    <tr>
                                        <th>Event Name</th>
                                        <th class="text-center">Total Registrations</th>
                                        <th class="text-center">Approved</th>
                                        <th class="text-center">Attended</th>
                                        <th>Attendance %</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    if (events == null || events.isEmpty()) {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            <i class="fas fa-info-circle fa-2x mb-2"></i>
                                            <p class="mb-0">No events found</p>
                                        </td>
                                    </tr>
                                    <% 
                                    } else {
                                        for (Event event : events) {
                                            try {
                                                List<Registration> registrations = regDAO.getRegistrationsByEventId(event.getId());
                                                
                                                int approved = 0;
                                                for (Registration r : registrations) {
                                                    if ("approved".equals(r.getStatus())) {
                                                        approved++;
                                                    }
                                                }
                                                
                                                // ✅ USE THE NEW METHOD
                                                int attended = regDAO.getAttendanceCount(event.getId());
                                                
                                                double percentage = approved > 0 ? (attended * 100.0 / approved) : 0;
                                                String progressColor = percentage >= 75 ? "success" : (percentage >= 50 ? "warning" : "danger");
                                    %>
                                    <tr>
                                        <td><strong><i class="fas fa-calendar-day"></i> <%= event.getName() %></strong></td>
                                        <td class="text-center"><%= registrations.size() %></td>
                                        <td class="text-center">
                                            <span class="badge bg-primary rounded-pill"><%= approved %></span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-success rounded-pill"><%= attended %></span>
                                        </td>
                                        <td>
                                            <div class="progress" style="height: 25px;">
                                                <div class="progress-bar bg-<%= progressColor %>" 
                                                     role="progressbar"
                                                     style="width: <%= percentage %>%">
                                                    <strong><%= String.format("%.1f", percentage) %>%</strong>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                           <a href="attendance-details.jsp?eventId=<%= event.getId() %>"
                                               class="btn btn-sm btn-success me-1">
                                                <i class="fas fa-users"></i> View Details
                                            </a>
                                            <button class="btn btn-sm btn-primary" 
                                                    onclick="downloadReport(<%= event.getId() %>)">
                                                <i class="fas fa-download"></i> Export
                                            </button>
                                        </td>
                                    </tr>
                                    <% 
                                            } catch (Exception e) {
                                                out.println("<tr><td colspan='6' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                            }
                                        }
                                    }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Summary Cards -->
                <div class="row mt-4">
                    <div class="col-md-4">
                        <div class="card text-white bg-primary">
                            <div class="card-body">
                                <h5><i class="fas fa-calendar-alt"></i> Total Events</h5>
                                <h2><%= events != null ? events.size() : 0 %></h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-success">
                            <div class="card-body">
                                <h5><i class="fas fa-check-circle"></i> Total Registrations</h5>
                                <h2>
                                    <% 
                                    int totalRegs = 0;
                                    if (events != null) {
                                        for (Event e : events) {
                                            totalRegs += regDAO.getRegistrationsByEventId(e.getId()).size();
                                        }
                                    }
                                    out.print(totalRegs);
                                    %>
                                </h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-white bg-info">
                            <div class="card-body">
                                <h5><i class="fas fa-user-check"></i> Total Attended</h5>
                                <h2>
                                    <% 
                                    // ✅ USE THE NEW METHOD FOR TOTAL
                                    int totalAttended = 0;
                                    if (events != null) {
                                        for (Event e : events) {
                                            totalAttended += regDAO.getAttendanceCount(e.getId());
                                        }
                                    }
                                    out.print(totalAttended);
                                    %>
                                </h2>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function downloadReport(eventId) {
            alert('Report export feature coming soon for Event ID: ' + eventId);
        }
    </script>
</body>
</html>
