<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.model.Event, java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Event event = (Event) request.getAttribute("event");
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/admin/events.jsp");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event - <%= event.getName() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #0a1628 0%, #0d1b2a 50%, #0a1628 100%);
            min-height: 100vh;
            color: #faf8f3;
        }
        .edit-card {
            background: rgba(22, 37, 68, 0.8);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(212, 175, 55, 0.2);
            border-radius: 24px;
            padding: 3rem;
            margin-top: 2rem;
        }
        .form-label {
            color: #f5f1e8;
            font-weight: 600;
        }
        .form-control, .form-select {
            background: rgba(10, 22, 40, 0.6);
            border: 1px solid rgba(212, 175, 55, 0.3);
            color: #faf8f3;
            border-radius: 12px;
        }
        .form-control:focus, .form-select:focus {
            background: rgba(10, 22, 40, 0.8);
            border-color: #d4af37;
            color: #faf8f3;
            box-shadow: 0 0 0 0.25rem rgba(212, 175, 55, 0.25);
        }
        .btn-update {
            background: linear-gradient(135deg, #d4af37, #b8963d);
            color: #0a1628;
            border: none;
            padding: 0.875rem 2rem;
            border-radius: 12px;
            font-weight: 700;
            transition: all 0.3s ease;
        }
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.4);
        }
        .btn-cancel {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            color: white;
            border: none;
            padding: 0.875rem 2rem;
            border-radius: 12px;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <%@ include file="../common/navbar.jsp" %>
    
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="edit-card">
                    <h2 class="mb-4" style="color: #d4af37;">
                        <i class="fas fa-edit"></i> Edit Event
                    </h2>
                    
                    <form action="<%= request.getContextPath() %>/updateEvent" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="eventId" value="<%= event.getId() %>">
                        
                        <div class="mb-3">
                            <label class="form-label">Event Name</label>
                            <input type="text" class="form-control" name="name" value="<%= event.getName() %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="4" required><%= event.getDescription() != null ? event.getDescription() : "" %></textarea>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Event Date & Time</label>
                                <input type="datetime-local" class="form-control" name="eventDate" 
                                       value="<%= dateFormat.format(event.getEventDate()) %>" required>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Venue</label>
                                <input type="text" class="form-control" name="venue" value="<%= event.getVenue() %>" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Eligibility</label>
                                <input type="text" class="form-control" name="eligibility" value="<%= event.getEligibility() %>" required>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Capacity</label>
                                <input type="number" class="form-control" name="capacity" value="<%= event.getCapacity() %>" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Registration Fee (₹)</label>
                                <input type="number" class="form-control" name="fee" value="<%= event.getFee() %>" required>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="status" required>
                                    <option value="active" <%= "active".equals(event.getStatus()) ? "selected" : "" %>>Active</option>
                                    <option value="inactive" <%= "inactive".equals(event.getStatus()) ? "selected" : "" %>>Inactive</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Event Banner (Optional - leave empty to keep current)</label>
                            <input type="file" class="form-control" name="eventImage" accept="image/*">
                            <% if (event.getEventImage() != null && !event.getEventImage().isEmpty()) { %>
                                <small class="text-muted">Current image: <%= event.getEventImage() %></small>
                            <% } %>
                        </div>
                        
                        <div class="d-flex gap-2 justify-content-end">
                            <a href="<%= request.getContextPath() %>/admin/events.jsp" class="btn btn-cancel">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                            <button type="submit" class="btn-update btn">
                                <i class="fas fa-save"></i> Update Event
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
