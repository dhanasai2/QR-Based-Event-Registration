<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.EventDAO, com.event.model.Event, java.util.List" %>
<%
    // Get all events for dropdown
    EventDAO eventDAO = new EventDAO();
    List<Event> events = eventDAO.getAllEvents();
    
    // Get selected event ID (if any)
    String selectedEventIdParam = request.getParameter("eventId");
    int selectedEventId = selectedEventIdParam != null ? Integer.parseInt(selectedEventIdParam) : -1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>QR Scanner - University Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/html5-qrcode"></script>
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
            0%,
            100% {
                transform: translate(0, 0) scale(1);
            }
            50% {
                transform: translate(30px, -30px) scale(1.1);
            }
        }

        /* Main Container */
        .main-container {
            position: relative;
            z-index: 1;
            padding: 3rem 0;
            min-height: 100vh;
        }

        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 2rem;
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

        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--cream), var(--accent-gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: rgba(245, 241, 232, 0.7);
            font-size: 1.1rem;
        }

        /* Event Selector */
        .event-selector-card {
            background: var(--card-bg);
            backdrop-filter: blur(40px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .event-selector-label {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--cream);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .event-selector {
            width: 100%;
            padding: 1rem;
            background: rgba(10, 22, 40, 0.8);
            border: 2px solid rgba(212, 175, 55, 0.3);
            border-radius: 12px;
            color: var(--cream);
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .event-selector:focus {
            outline: none;
            border-color: var(--accent-gold);
            box-shadow: 0 0 20px rgba(212, 175, 55, 0.3);
        }

        .event-selector option {
            background: var(--primary-navy);
            color: var(--cream);
        }

        /* Scanner Card */
        .scanner-card {
            background: var(--card-bg);
            backdrop-filter: blur(40px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.6);
            animation: card-entrance 0.8s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes card-entrance {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .scanner-header {
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .scanner-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 30% 30%, rgba(255, 255, 255, 0.1), transparent 60%);
        }

        .scanner-header-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .scanner-icon {
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: var(--primary-navy);
            animation: icon-pulse 2s ease-in-out infinite;
        }

        @keyframes icon-pulse {
            0%,
            100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }

        .scanner-title {
            flex: 1;
        }

        .scanner-title h4 {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary-navy);
            margin-bottom: 0.25rem;
        }

        .scanner-title p {
            color: rgba(10, 22, 40, 0.8);
            margin: 0;
        }

        /* Scanner Body */
        .scanner-body {
            padding: 2.5rem;
        }

        /* QR Reader */
        #reader {
            border: 3px solid var(--accent-gold);
            border-radius: 20px;
            overflow: hidden;
            margin-bottom: 2rem;
            box-shadow: 0 10px 40px rgba(212, 175, 55, 0.3);
        }

        /* No Event Selected Warning */
        .warning-card {
            background: rgba(245, 158, 11, 0.1);
            border: 2px solid rgba(245, 158, 11, 0.3);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .warning-card i {
            font-size: 3rem;
            color: var(--warning);
            margin-bottom: 1rem;
        }

        .warning-card h5 {
            color: var(--cream);
            margin-bottom: 0.5rem;
        }

        .warning-card p {
            color: rgba(245, 241, 232, 0.7);
            margin: 0;
        }

        /* Result Section */
        #result {
            min-height: 100px;
        }

        .scan-result {
            animation: result-slide 0.5s cubic-bezier(0.23, 1, 0.32, 1);
        }

        @keyframes result-slide {
            from {
                opacity: 0;
                transform: translateY(-20px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .result-card {
            background: rgba(10, 22, 40, 0.5);
            border-radius: 16px;
            padding: 2rem;
            border: 2px solid;
            position: relative;
            overflow: hidden;
        }

        .result-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 5px;
            height: 100%;
        }

        .result-card.success {
            border-color: rgba(16, 185, 129, 0.3);
            background: rgba(16, 185, 129, 0.05);
        }

        .result-card.success::before {
            background: var(--success);
        }

        .result-card.warning {
            border-color: rgba(245, 158, 11, 0.3);
            background: rgba(245, 158, 11, 0.05);
        }

        .result-card.warning::before {
            background: var(--warning);
        }

        .result-card.danger {
            border-color: rgba(239, 68, 68, 0.3);
            background: rgba(239, 68, 68, 0.05);
        }

        .result-card.danger::before {
            background: var(--error);
        }

        .result-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .result-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .result-card.success .result-icon {
            background: rgba(16, 185, 129, 0.2);
            color: var(--success);
        }

        .result-card.warning .result-icon {
            background: rgba(245, 158, 11, 0.2);
            color: var(--warning);
        }

        .result-card.danger .result-icon {
            background: rgba(239, 68, 68, 0.2);
            color: var(--error);
        }

        .result-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--cream);
            margin: 0;
        }

        .result-details {
            display: grid;
            gap: 0.75rem;
        }

        .result-detail-item {
            display: flex;
            gap: 0.5rem;
            color: rgba(245, 241, 232, 0.8);
        }

        .result-detail-item strong {
            color: var(--cream);
            min-width: 120px;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .stat-card {
            background: rgba(10, 22, 40, 0.5);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 16px;
            padding: 1.75rem;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
        }

        .stat-card.success {
            border-color: rgba(16, 185, 129, 0.3);
        }

        .stat-card.success::before {
            background: linear-gradient(90deg, var(--success), var(--accent-teal));
        }

        .stat-card.warning {
            border-color: rgba(245, 158, 11, 0.3);
        }

        .stat-card.warning::before {
            background: linear-gradient(90deg, var(--warning), var(--accent-gold));
        }

        .stat-card.danger {
            border-color: rgba(239, 68, 68, 0.3);
        }

        .stat-card.danger::before {
            background: linear-gradient(90deg, var(--error), var(--accent-rose));
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.2);
        }

        .stat-label {
            font-size: 1rem;
            font-weight: 600;
            color: rgba(245, 241, 232, 0.7);
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .stat-value {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 700;
            color: var(--cream);
            line-height: 1;
        }

        /* Responsive */
        @media (max-width: 576px) {
            .page-title {
                font-size: 2.5rem;
            }

            .scanner-body {
                padding: 1.5rem;
            }

            .result-card {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../common/navbar.jsp" %>

    <div class="main-container">
        <div class="container">
            <div class="row">
                <div class="col-lg-10 mx-auto">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1 class="page-title">
                            <i class="fas fa-qrcode"></i> QR Code Scanner
                        </h1>
                        <p class="page-subtitle">Scan event tickets to verify and mark attendance</p>
                    </div>

                    <!-- Event Selector -->
                    <div class="event-selector-card">
                        <label class="event-selector-label">
                            <i class="fas fa-calendar-alt"></i>
                            Select Event to Scan For:
                        </label>
                        <select class="event-selector" id="eventSelector" onchange="selectEvent()">
                            <option value="">-- Select an Event --</option>
                            <% for (Event event : events) { %>
                                <option value="<%= event.getId() %>" <%= (event.getId() == selectedEventId) ? "selected" : "" %>>
                                    <%= event.getName() %> - <%= event.getEventDate() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <% if (selectedEventId != -1) { %>
                        <!-- Scanner Card -->
                        <div class="scanner-card">
                            <div class="scanner-header">
                                <div class="scanner-header-content">
                                    <div class="scanner-icon">
                                        <i class="fas fa-camera"></i>
                                    </div>
                                    <div class="scanner-title">
                                        <h4>Live Scanner</h4>
                                        <p>Scanning for: <%= eventDAO.getEventById(selectedEventId).getName() %></p>
                                    </div>
                                </div>
                            </div>

                            <div class="scanner-body">
                                <!-- QR Reader -->
                                <div id="reader"></div>

                                <!-- Result Display -->
                                <div id="result"></div>

                                <!-- Statistics -->
                                <div class="stats-grid">
                                    <div class="stat-card success">
                                        <div class="stat-label">
                                            <i class="fas fa-check-circle"></i>
                                            <span>Successful</span>
                                        </div>
                                        <div class="stat-value" id="successCount">0</div>
                                    </div>

                                    <div class="stat-card warning">
                                        <div class="stat-label">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            <span>Already Marked</span>
                                        </div>
                                        <div class="stat-value" id="duplicateCount">0</div>
                                    </div>

                                    <div class="stat-card danger">
                                        <div class="stat-label">
                                            <i class="fas fa-times-circle"></i>
                                            <span>Failed</span>
                                        </div>
                                        <div class="stat-value" id="failedCount">0</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } else { %>
                        <!-- No Event Selected Warning -->
                        <div class="warning-card">
                            <i class="fas fa-exclamation-triangle"></i>
                            <h5>No Event Selected</h5>
                            <p>Please select an event from the dropdown above to start scanning QR codes.</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script>
        var selectedEventId = <%= selectedEventId %>;
        var successCount = 0;
        var duplicateCount = 0;
        var failedCount = 0;
        var isProcessing = false;

        function selectEvent() {
            var eventId = document.getElementById('eventSelector').value;
            if (eventId) {
                window.location.href = 'scan-qr.jsp?eventId=' + eventId;  // ✅ Fixed: scan-qr.jsp
            } else {
                window.location.href = 'scan-qr.jsp';  // ✅ Fixed: scan-qr.jsp
            }
        }

        <% if (selectedEventId != -1) { %>
        function onScanSuccess(decodedText, decodedResult) {
            if (isProcessing) return;
            isProcessing = true;

            console.log('🔍 Scanned QR:', decodedText);
            console.log('📅 Event ID:', selectedEventId);

            html5QrcodeScanner.pause();

            fetch('<%= request.getContextPath() %>/scanQR', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'qrData=' + encodeURIComponent(decodedText) + '&eventId=' + selectedEventId,
            })
                .then(function (response) {
                    return response.json();
                })
                .then(function (data) {
                    console.log('📡 Server response:', data);

                    var resultDiv = document.getElementById('result');

                    if (data.alreadyMarked === true) {
                        duplicateCount++;
                        document.getElementById('duplicateCount').textContent = duplicateCount;

                        resultDiv.innerHTML =
                            '<div class="result-card warning scan-result">' +
                            '<div class="result-header">' +
                            '<div class="result-icon"><i class="fas fa-exclamation-triangle"></i></div>' +
                            '<h5 class="result-title">Already Checked In</h5>' +
                            '</div>' +
                            '<div class="result-details">' +
                            '<div class="result-detail-item"><strong>Name:</strong> <span>' + (data.userName || 'Unknown') + '</span></div>' +
                            '<div class="result-detail-item"><strong>Email:</strong> <span>' + (data.userEmail || 'No email') + '</span></div>' +
                            '<div class="result-detail-item"><strong>Event:</strong> <span>' + (data.eventName || 'Unknown event') + '</span></div>' +
                            '<div class="result-detail-item"><strong>Status:</strong> <span>Attendance was already marked</span></div>' +
                            '</div>' +
                            '</div>';
                    } else if (data.success === true) {
                        successCount++;
                        document.getElementById('successCount').textContent = successCount;

                        resultDiv.innerHTML =
                            '<div class="result-card success scan-result">' +
                            '<div class="result-header">' +
                            '<div class="result-icon"><i class="fas fa-check-circle"></i></div>' +
                            '<h5 class="result-title">Check-in Successful!</h5>' +
                            '</div>' +
                            '<div class="result-details">' +
                            '<div class="result-detail-item"><strong>Name:</strong> <span>' + (data.userName || 'Unknown') + '</span></div>' +
                            '<div class="result-detail-item"><strong>Email:</strong> <span>' + (data.userEmail || 'No email') + '</span></div>' +
                            '<div class="result-detail-item"><strong>Event:</strong> <span>' + (data.eventName || 'Unknown event') + '</span></div>' +
                            '<div class="result-detail-item"><strong>Registration ID:</strong> <span>REG-' + (data.registrationId || 'N/A') + '</span></div>' +
                            '</div>' +
                            '</div>';
                    } else {
                        failedCount++;
                        document.getElementById('failedCount').textContent = failedCount;

                        resultDiv.innerHTML =
                            '<div class="result-card danger scan-result">' +
                            '<div class="result-header">' +
                            '<div class="result-icon"><i class="fas fa-times-circle"></i></div>' +
                            '<h5 class="result-title">Check-in Failed</h5>' +
                            '</div>' +
                            '<div class="result-details">' +
                            '<div class="result-detail-item"><strong>Reason:</strong> <span>' + (data.message || 'Unknown error') + '</span></div>' +
                            '</div>' +
                            '</div>';
                    }

                    setTimeout(function () {
                        resultDiv.innerHTML = '';
                        html5QrcodeScanner.resume();
                        isProcessing = false;
                    }, 4000);
                })
                .catch(function (error) {
                    console.error('❌ Error:', error);
                    failedCount++;
                    document.getElementById('failedCount').textContent = failedCount;

                    document.getElementById('result').innerHTML =
                        '<div class="result-card danger scan-result">' +
                        '<div class="result-header">' +
                        '<div class="result-icon"><i class="fas fa-times-circle"></i></div>' +
                        '<h5 class="result-title">System Error</h5>' +
                        '</div>' +
                        '<div class="result-details">' +
                        '<div class="result-detail-item"><strong>Error:</strong> <span>Could not connect to server</span></div>' +
                        '</div>' +
                        '</div>';

                    setTimeout(function () {
                        document.getElementById('result').innerHTML = '';
                        html5QrcodeScanner.resume();
                        isProcessing = false;
                    }, 4000);
                });
        }

        function onScanFailure(error) {
            // Silent handling for continuous scanning
        }

        var html5QrcodeScanner = new Html5QrcodeScanner('reader', {
            fps: 10,
            qrbox: { width: 250, height: 250 },
            rememberLastUsedCamera: true,
        }, false);

        html5QrcodeScanner.render(onScanSuccess, onScanFailure);
        console.log('✅ QR Scanner initialized and ready for Event ID:', selectedEventId);
        <% } %>
    </script>
</body>
</html>
