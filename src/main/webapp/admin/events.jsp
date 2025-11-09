<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.EventDAO, com.event.model.Event, java.util.List, java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    int userId = (int) session.getAttribute("userId");
    
    EventDAO eventDAO = new EventDAO();
    List<Event> events = eventDAO.getAllEvents();
    
    // AUTO-MARK PAST EVENTS AS INACTIVE
    java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
    for (Event event : events) {
        if ("active".equals(event.getStatus()) && 
            event.getEventDate() != null && 
            event.getEventDate().before(now)) {
            try {
                eventDAO.updateEventStatus(event.getId(), "inactive");
                event.setStatus("inactive");
            } catch (Exception e) {
                System.err.println("Error auto-expiring event: " + e.getMessage());
            }
        }
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events - University Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* ALL YOUR EXISTING STYLES - KEEP THEM EXACTLY AS THEY ARE */
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

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(ellipse at top left, rgba(212, 175, 55, 0.08), transparent 60%),
                        radial-gradient(ellipse at bottom right, rgba(91, 192, 190, 0.08), transparent 60%),
                        linear-gradient(135deg, var(--primary-navy) 0%, #0d1b2a 50%, var(--primary-navy) 100%);
            min-height: 100vh;
            color: var(--warm-white);
        }

        .luxury-bg { position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 0; pointer-events: none; }
        .luxury-orb { position: absolute; border-radius: 50%; filter: blur(120px); opacity: 0.08; animation: luxury-float 30s ease-in-out infinite; }
        .orb-1 { width: 500px; height: 500px; background: radial-gradient(circle, var(--accent-gold) 0%, transparent 70%); top: -10%; right: 10%; animation-duration: 35s; }
        .orb-2 { width: 400px; height: 400px; background: radial-gradient(circle, var(--accent-teal) 0%, transparent 70%); bottom: -10%; left: 20%; animation-duration: 40s; animation-delay: 5s; }
        @keyframes luxury-float { 0%, 100% { transform: translate(0, 0) scale(1); } 50% { transform: translate(30px, -30px) scale(1.1); } }

        .main-container { position: relative; z-index: 1; padding: 3rem 0; }
        
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

        .btn-create {
            background: linear-gradient(135deg, var(--accent-gold), #b8963d);
            color: var(--primary-navy);
            border: none;
            padding: 1rem 2rem;
            border-radius: 14px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
        }

        .btn-create:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(212, 175, 55, 0.4);
            color: var(--primary-navy);
        }

        .event-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
            margin-bottom: 2rem;
            animation: card-entrance 0.6s ease backwards;
        }

        @keyframes card-entrance {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .event-card:hover {
            transform: translateY(-8px);
            border-color: var(--accent-gold);
            box-shadow: 0 20px 60px rgba(212, 175, 55, 0.25);
        }

        .event-thumbnail-container {
            position: relative;
            width: 100%;
            height: 250px;
            overflow: hidden;
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose), var(--accent-lavender));
        }

        .event-thumbnail {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .event-card:hover .event-thumbnail { transform: scale(1.1); }

        .event-thumbnail-placeholder {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: rgba(255, 255, 255, 0.9);
            font-size: 5rem;
        }

        .status-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.625rem 1.25rem;
            border-radius: 50px;
            font-weight: 800;
            font-size: 0.75rem;
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255, 255, 255, 0.2);
            z-index: 10;
        }

        .status-active { background: rgba(16, 185, 129, 0.9); color: white; box-shadow: 0 0 20px rgba(16, 185, 129, 0.4); }
        .status-inactive { background: rgba(107, 114, 128, 0.9); color: white; box-shadow: 0 0 20px rgba(107, 114, 128, 0.4); }
        .past-event-badge { background: rgba(239, 68, 68, 0.9); color: white; box-shadow: 0 0 20px rgba(239, 68, 68, 0.4); }

        .card-body-custom { padding: 2rem; }

        .event-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--cream);
            margin-bottom: 1rem;
        }

        .event-description {
            color: rgba(245, 241, 232, 0.8);
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }

        .details-grid {
            background: rgba(10, 22, 40, 0.4);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(212, 175, 55, 0.1);
            color: rgba(245, 241, 232, 0.8);
        }

        .detail-item:last-child { border-bottom: none; }
        .detail-item i { font-size: 1.2rem; width: 24px; }

        .action-buttons { display: flex; gap: 1rem; }

        .btn-edit {
            flex: 1;
            background: linear-gradient(135deg, var(--accent-teal), var(--accent-lavender));
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(91, 192, 190, 0.3);
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(91, 192, 190, 0.4);
            color: white;
        }

        .btn-delete {
            flex: 1;
            background: linear-gradient(135deg, var(--error), #dc2626);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(239, 68, 68, 0.3);
        }

        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(239, 68, 68, 0.4);
        }

        .empty-state {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.15);
            border-radius: 24px;
            padding: 4rem 2rem;
            text-align: center;
        }

        .alert {
            border-radius: 14px;
            border: none;
            backdrop-filter: blur(10px);
        }

        .alert-success {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: var(--success);
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: var(--error);
        }

        .modal-content {
            background: var(--card-bg);
            backdrop-filter: blur(40px);
            border: 1px solid rgba(212, 175, 55, 0.2);
            border-radius: 24px;
            color: var(--warm-white);
        }

        .modal-header {
            background: linear-gradient(135deg, var(--accent-gold), var(--accent-rose));
            color: var(--primary-navy);
            border-radius: 24px 24px 0 0;
            border-bottom: none;
        }

        .form-label { color: var(--cream); font-weight: 600; }

        .form-control, .form-select {
            background: rgba(10, 22, 40, 0.5);
            border: 1px solid rgba(212, 175, 55, 0.2);
            color: var(--warm-white);
            border-radius: 10px;
        }

        .form-control:focus, .form-select:focus {
            background: rgba(10, 22, 40, 0.7);
            border-color: var(--accent-gold);
            color: var(--warm-white);
            box-shadow: 0 0 0 0.2rem rgba(212, 175, 55, 0.25);
        }

        .event-image-upload-preview {
            width: 100%;
            height: 200px;
            border-radius: 16px;
            border: 3px dashed var(--accent-gold);
            background: rgba(10, 22, 40, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }

        .event-image-upload-preview:hover {
            border-color: var(--accent-teal);
            transform: scale(1.02);
        }

        .event-image-upload-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .upload-icon {
            text-align: center;
            color: var(--accent-gold);
        }

        .upload-icon i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .page-title { font-size: 2rem; }
            .event-thumbnail-container { height: 200px; }
        }
    </style>
</head>
<body>
    <div class="luxury-bg">
        <div class="luxury-orb orb-1"></div>
        <div class="luxury-orb orb-2"></div>
    </div>

    <%@ include file="../common/navbar.jsp" %>

    <div class="main-container">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <h1 class="page-title">
                    <i class="fas fa-calendar-alt"></i> Manage Events
                </h1>
                <button class="btn-create" data-bs-toggle="modal" data-bs-target="#createEventModal">
                    <i class="fas fa-plus-circle"></i> Create New Event
                </button>
            </div>

            <!-- Alerts -->
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                
                if (error != null) {
                    String errorMsg = "";
                    switch(error) {
                        case "invalid_input": errorMsg = "All required fields must be filled!"; break;
                        case "image_size": errorMsg = "Event image must be less than 5MB!"; break;
                        case "image_type": errorMsg = "Only JPG, PNG, GIF images allowed!"; break;
                        case "creation_failed": errorMsg = "Event creation failed!"; break;
                        case "delete_failed": errorMsg = "Failed to delete event!"; break;
                        case "delete_error": errorMsg = "Error deleting event!"; break;
                        default: errorMsg = "An error occurred!";
                    }
            %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMsg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <% if (success != null) {
                String successMsg = "";
                switch(success) {
                    case "created": successMsg = "Event created successfully!"; break;
                    case "updated": successMsg = "Event updated successfully!"; break;
                    case "deleted": successMsg = "Event deleted successfully!"; break;
                    default: successMsg = "Operation successful!";
                }
            %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> <%= successMsg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Events Grid -->
            <div class="row">
                <% if (events != null && !events.isEmpty()) {
                    for (Event event : events) {
                        boolean isPastEvent = event.getEventDate().before(now);
                        String eventImage = event.getEventImage();
                        boolean hasImage = (eventImage != null && !eventImage.isEmpty());
                        String imageSrc = hasImage ? request.getContextPath() + "/" + eventImage : "";
                %>
                    <div class="col-lg-4 col-md-6">
                        <div class="event-card">
                            <div class="event-thumbnail-container">
                                <% if (isPastEvent) { %>
                                    <span class="status-badge past-event-badge">
                                        <i class="fas fa-clock"></i> PAST EVENT
                                    </span>
                                <% } else if ("active".equals(event.getStatus())) { %>
                                    <span class="status-badge status-active">
                                        <i class="fas fa-check-circle"></i> ACTIVE
                                    </span>
                                <% } else { %>
                                    <span class="status-badge status-inactive">
                                        <i class="fas fa-times-circle"></i> INACTIVE
                                    </span>
                                <% } %>
                                
                                <% if (hasImage) { %>
                                    <img src="<%= imageSrc %>" 
                                         class="event-thumbnail"
                                         alt="<%= event.getName() %>"
                                         onerror="this.style.display='none';">
                                <% } else { %>
                                    <i class="fas fa-calendar-star event-thumbnail-placeholder"></i>
                                <% } %>
                            </div>
                            
                            <div class="card-body-custom">
                                <h3 class="event-name">
                                    <%= event.getName() %>
                                </h3>
                                <p class="event-description"><%= event.getDescription() %></p>
                                
                                <div class="details-grid">
                                    <div class="detail-item">
                                        <i class="fas fa-map-marker-alt" style="color: var(--error);"></i>
                                        <span><%= event.getVenue() %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-calendar-check" style="color: var(--accent-teal);"></i>
                                        <span><%= dateFormat.format(event.getEventDate()) %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-users" style="color: var(--success);"></i>
                                        <span>Capacity: <%= event.getCapacity() %></span>
                                    </div>
                                    <div class="detail-item">
                                        <i class="fas fa-rupee-sign" style="color: var(--warning);"></i>
                                        <span>Fee: &#8377;<%= event.getFee() %></span>
                                    </div>
                                </div>
                                
                                <div class="action-buttons">
                                    <a href="<%= request.getContextPath() %>/admin/editEvent?id=<%= event.getId() %>" 
                                       class="btn-edit">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <button class="btn-delete" 
                                            onclick="confirmDelete(<%= event.getId() %>, '<%= event.getName().replace("'", "\\'") %>')">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                <%  }
                } else { %>
                    <div class="col-12">
                        <div class="empty-state">
                            <i class="fas fa-inbox" style="font-size: 4rem; color: var(--accent-teal); margin-bottom: 1rem;"></i>
                            <h3 style="color: var(--cream);">No events created yet</h3>
                            <p style="color: rgba(245, 241, 232, 0.7);">Click "Create New Event" to get started!</p>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Create Event Modal -->
    <div class="modal fade" id="createEventModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-calendar-plus"></i> Create New Event
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/manageEvent" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="modal-body">
                        <div class="mb-4">
                            <label class="form-label">
                                <i class="fas fa-image"></i> Event Banner Image (Optional)
                            </label>
                            <div class="event-image-upload-preview" onclick="document.getElementById('eventImage').click()">
                                <img id="imagePreview" src="" alt="" style="display:none;">
                                <div class="upload-icon" id="uploadIcon">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <p class="mb-0 fw-bold">Click to upload event banner</p>
                                    <small>Max 5MB (JPG, PNG, GIF) - Recommended: 1200x400</small>
                                </div>
                            </div>
                            <input type="file" id="eventImage" name="eventImage" accept="image/*" 
                                   style="display:none;" onchange="previewEventImage(this)">
                        </div>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="fas fa-tag"></i> Event Name <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" name="name" required placeholder="Enter event name">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="fas fa-map-marker-alt"></i> Venue <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" name="venue" required placeholder="Enter venue">
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label">
                                    <i class="fas fa-align-left"></i> Description <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control" name="description" rows="3" required placeholder="Enter event description"></textarea>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="fas fa-calendar"></i> Event Date &amp; Time <span class="text-danger">*</span>
                                </label>
                                <input type="datetime-local" class="form-control" name="eventDate" required id="eventDate">
                            </div>
                            
                            <!-- ADDED REGISTRATION DEADLINE FIELD -->
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="fas fa-calendar-times"></i> Registration Deadline <span class="text-danger">*</span>
                                </label>
                                <input type="datetime-local" class="form-control" name="registrationDeadline" required id="registrationDeadline">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="fas fa-users"></i> Eligibility <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" name="eligibility" required>
                                    <option value="">-- Select --</option>
                                    <option value="All Students">All Students</option>
                                    <option value="UG Students">UG Students</option>
                                    <option value="PG Students">PG Students</option>
                                    <option value="Faculty">Faculty</option>
                                    <option value="Open to All">Open to All</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="fas fa-rupee-sign"></i> Registration Fee <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" name="fee" required min="0" step="0.01" placeholder="0.00">
                                <small class="text-muted">Enter 0 for free events</small>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="fas fa-user-friends"></i> Capacity <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" name="capacity" required min="1" placeholder="Maximum participants">
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label">
                                    <i class="fas fa-toggle-on"></i> Status <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" name="status" required>
                                    <option value="upcoming">Upcoming (Open for Registration)</option>
                                    <option value="ongoing">Ongoing</option>
                                    <option value="completed">Completed</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer" style="border-top: 1px solid rgba(212, 175, 55, 0.1);">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="submit" class="btn-create">
                            <i class="fas fa-plus-circle"></i> Create Event
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(eventId, eventName) {
            if (confirm('Are you sure you want to delete "' + eventName + '"?\n\nThis action cannot be undone.')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/admin/deleteEvent';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'eventId';
                input.value = eventId;
                form.appendChild(input);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function previewEventImage(input) {
            const preview = document.getElementById('imagePreview');
            const uploadIcon = document.getElementById('uploadIcon');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                if (file.size > 5 * 1024 * 1024) {
                    alert('Event image must be less than 5MB!');
                    input.value = '';
                    return;
                }
                
                const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                if (!validTypes.includes(file.type)) {
                    alert('Only JPG, PNG, GIF images are allowed!');
                    input.value = '';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    uploadIcon.style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
        }
        
        // UPDATED DATE VALIDATION SCRIPT
        document.addEventListener('DOMContentLoaded', function() {
            const eventDateInput = document.getElementById('eventDate');
            const registrationDeadlineInput = document.getElementById('registrationDeadline');
            
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            const minDateTime = now.toISOString().slice(0, 16);
            
            // Set minimum date for both fields
            eventDateInput.min = minDateTime;
            registrationDeadlineInput.min = minDateTime;
            
            // When event date changes, ensure registration deadline is before event date
            eventDateInput.addEventListener('change', function() {
                if (this.value) {
                    registrationDeadlineInput.max = this.value;
                }
            });
            
            // Validate registration deadline is before event date
            registrationDeadlineInput.addEventListener('change', function() {
                if (eventDateInput.value && this.value) {
                    if (new Date(this.value) >= new Date(eventDateInput.value)) {
                        alert('Registration deadline must be before the event date!');
                        this.value = '';
                    }
                }
            });
        });
    </script>
</body>

</html>
