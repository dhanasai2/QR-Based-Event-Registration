<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.EventDAO" %>
<%@ page import="com.event.dao.RegistrationDAO" %>
<%@ page import="com.event.model.Event" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Fetch data directly in JSP
    EventDAO eventDAO = new EventDAO();
    RegistrationDAO regDAO = new RegistrationDAO();
    
    String eventIdParam = request.getParameter("eventId");
    Event event = null;
    List<com.event.model.Registration> attendedList = null;
    
    if (eventIdParam != null && !eventIdParam.trim().isEmpty()) {
        try {
            int eventId = Integer.parseInt(eventIdParam);
            event = eventDAO.getEventById(eventId);
            attendedList = regDAO.getAttendedRegistrations(eventId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    List<Event> events = eventDAO.getAllEvents();
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Details - University Events</title>
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

        .btn-back {
            background: linear-gradient(135deg, var(--accent-teal), var(--accent-lavender));
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(91, 192, 190, 0.3);
            text-decoration: none;
            display: inline-block;
        }

        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(91, 192, 190, 0.4);
            color: white;
        }

        /* Event Cards Grid */
        .event-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .event-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 20px;
            padding: 2rem;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            animation: card-entrance 0.6s ease backwards;
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

        .event-card:hover {
            transform: translateY(-8px);
            border-color: var(--accent-gold);
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.25);
        }

        .event-card h5 {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .badge-attended {
            background: linear-gradient(135deg, var(--success), var(--accent-teal));
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1rem;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .btn-view {
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            color: var(--primary-navy);
            border: none;
            padding: 0.625rem 1.25rem;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.3s ease;
            width: 100%;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(212, 175, 55, 0.4);
            color: var(--primary-navy);
        }

        /* Detail Card */
        .detail-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 20px;
            overflow: hidden;
            animation: card-entrance 0.6s ease 0.2s backwards;
        }

        .detail-card-header {
            background: linear-gradient(135deg, var(--success), var(--accent-teal));
            padding: 2rem;
            color: white;
        }

        .detail-card-header h4 {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .detail-card-body {
            padding: 2rem;
        }

        /* Table */
        .table {
            color: var(--warm-white);
            margin-bottom: 0;
        }

        .table thead th {
            background: rgba(16, 185, 129, 0.2);
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

        .bg-success {
            background: var(--success) !important;
        }

        /* Action Buttons */
        .btn-success {
            background: linear-gradient(135deg, var(--success), var(--accent-teal));
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(107, 114, 128, 0.4);
            color: white;
        }

        /* Alert */
        .alert-info {
            background: rgba(91, 192, 190, 0.1);
            border: 1px solid rgba(91, 192, 190, 0.3);
            color: var(--accent-teal);
            border-radius: 14px;
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
                        <a class="nav-link" href="approvals.jsp">
                            <i class="fas fa-check-circle"></i>
                            <span>Approvals</span>
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
                    <li class="nav-item">
                        <a class="nav-link active" href="attendance-details.jsp">
                            <i class="fas fa-user-check"></i>
                            <span>Attendance Details</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1><i class="fas fa-user-check" style="color: var(--success);"></i> Attendance Details</h1>
                    <% if (event != null) { %>
                    <a href="attendance-details.jsp" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Back to Events
                    </a>
                    <% } %>
                </div>

                <% if (event == null) { %>
                    <!-- Event List View -->
                    <div class="event-cards-grid">
                        <% 
                        for (Event e : events) {
                            int attendedCount = regDAO.getAttendanceCount(e.getId());
                        %>
                        <div class="event-card">
                            <h5><i class="fas fa-calendar-day" style="color: var(--accent-gold);"></i> <%= e.getName() %></h5>
                            <span class="badge-attended">
                                <i class="fas fa-users"></i> <%= attendedCount %> Attended
                            </span>
                            <a href="attendance-details.jsp?eventId=<%= e.getId() %>" 
                               class="btn-view">
                                <i class="fas fa-list"></i> View Details
                            </a>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <!-- Detailed Attendance List for Specific Event -->
                    <div class="detail-card">
                        <div class="detail-card-header">
                            <h4><i class="fas fa-calendar-day"></i> <%= event.getName() %></h4>
                            <p class="mb-0">Total Attended: <strong><%= attendedList != null ? attendedList.size() : 0 %></strong></p>
                        </div>
                        <div class="detail-card-body">
                            <% if (attendedList == null || attendedList.isEmpty()) { %>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i> No attendance records found for this event.
                                </div>
                            <% } else { %>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Registration ID</th>
                                                <th>Check-in Time</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% 
                                            int count = 1;
                                            for (com.event.model.Registration reg : attendedList) { 
                                            %>
                                            <tr>
                                                <td><%= count++ %></td>
                                                <td><strong><%= reg.getUserName() != null ? reg.getUserName() : "N/A" %></strong></td>
                                                <td><%= reg.getUserEmail() != null ? reg.getUserEmail() : "N/A" %></td>
                                                <td><span class="badge bg-primary">REG-<%= reg.getId() %></span></td>
                                                <td>
                                                    <i class="fas fa-clock"></i> Recently
                                                </td>
                                                <td><span class="badge bg-success">Attended</span></td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Export Buttons -->
                                <div class="text-end mt-3">
                                    <button class="btn-success" onclick="exportToCSV()">
                                        <i class="fas fa-file-csv"></i> Export to CSV
                                    </button>
                                    <button class="btn-secondary ms-2" onclick="window.print()">
                                        <i class="fas fa-print"></i> Print
                                    </button>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function exportToCSV() {
            const table = document.querySelector('.table');
            if (!table) {
                alert('No data to export');
                return;
            }
            
            let csv = [];
            const rows = table.querySelectorAll('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const row = [], cols = rows[i].querySelectorAll('td, th');
                
                for (let j = 0; j < cols.length; j++) {
                    let data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, '').replace(/(\s\s)/gm, ' ');
                    data = data.replace(/"/g, '""');
                    row.push('"' + data + '"');
                }
                
                csv.push(row.join(','));
            }
            
            const csvFile = new Blob([csv.join('\n')], { type: 'text/csv' });
            const downloadLink = document.createElement('a');
            downloadLink.download = 'attendance_report_<%= event != null ? event.getName().replaceAll(" ", "_") : "all" %>.csv';
            downloadLink.href = window.URL.createObjectURL(csvFile);
            downloadLink.style.display = 'none';
            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
        }
    </script>
</body>
</html>
