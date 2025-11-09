<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.event.dao.PaymentConfigDAO" %>
<%@ page import="java.util.Map" %>

<%
    // Check admin authentication
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Fetch payment configuration from database
    PaymentConfigDAO configDAO = new PaymentConfigDAO();
    Map<String, String> paymentConfig = configDAO.getPaymentConfig(); // ✅ Changed variable name
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Settings - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem;
        }
        
        .settings-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 2.5rem;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .page-header h2 {
            color: #667eea;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #475569;
            margin-bottom: 0.5rem;
        }
        
        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-save {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 10px;
            font-weight: 700;
            transition: all 0.3s;
        }
        
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-back {
            background: #64748b;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-back:hover {
            background: #475569;
            transform: translateY(-2px);
            color: white;
        }
        
        .info-badge {
            background: #dbeafe;
            color: #1e40af;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            border-left: 4px solid #3b82f6;
        }
    </style>
</head>
<body>
    <div class="settings-card">
        <div class="page-header">
            <h2><i class="fas fa-credit-card"></i> Payment Configuration</h2>
            <p class="text-muted mb-0">Manage your payment gateway details</p>
        </div>
        
        <% 
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        
        if (success != null) { 
        %>
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>
                Payment configuration updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle me-2"></i>
                Failed to update configuration. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <div class="info-badge">
            <i class="fas fa-info-circle"></i>
            <strong>Note:</strong> These details will be displayed to users during payment. 
            Make sure all information is accurate.
        </div>
        
        <form method="post" action="${pageContext.request.contextPath}/updatePaymentConfig">
            
            <h5 class="mb-3"><i class="fas fa-mobile-alt text-primary"></i> UPI Details</h5>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="fas fa-at"></i> UPI ID
                    </label>
                    <input type="text" name="upi_id" class="form-control" 
                           value="<%= paymentConfig.get("upi_id") %>" required
                           placeholder="yourname@upi">
                </div>
                
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="fas fa-user"></i> UPI Name
                    </label>
                    <input type="text" name="upi_name" class="form-control" 
                           value="<%= paymentConfig.get("upi_name") %>" required
                           placeholder="Full Name">
                </div>
            </div>
            
            <hr class="my-4">
            
            <h5 class="mb-3"><i class="fas fa-university text-primary"></i> Bank Account Details</h5>
            
            <div class="mb-3">
                <label class="form-label">
                    <i class="fas fa-hashtag"></i> Account Number
                </label>
                <input type="text" name="account_number" class="form-control" 
                       value="<%= paymentConfig.get("account_number") %>" required
                       placeholder="1234567890">
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="fas fa-code"></i> IFSC Code
                    </label>
                    <input type="text" name="ifsc_code" class="form-control" 
                           value="<%= paymentConfig.get("ifsc_code") %>" required
                           placeholder="SBIN0001234">
                </div>
                
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="fas fa-building"></i> Bank Name
                    </label>
                    <input type="text" name="bank_name" class="form-control" 
                           value="<%= paymentConfig.get("bank_name") %>" required
                           placeholder="State Bank of India">
                </div>
            </div>
            
            <div class="mb-4">
                <label class="form-label">
                    <i class="fas fa-user-circle"></i> Account Holder Name
                </label>
                <input type="text" name="account_holder" class="form-control" 
                       value="<%= paymentConfig.get("account_holder") %>" required
                       placeholder="Full Name as per Bank">
            </div>
            
            <div class="d-flex gap-2 justify-content-between">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
                <button type="submit" class="btn-save">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </div>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
