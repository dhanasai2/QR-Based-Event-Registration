// Form Validation Functions

// Email validation
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(String(email).toLowerCase());
}

// Phone validation (Indian format)
function validatePhone(phone) {
    const re = /^[6-9]\d{9}$/;
    return re.test(phone);
}

// Password strength validation
function validatePassword(password) {
    // At least 6 characters
    if (password.length < 6) {
        return {
            valid: false,
            message: "Password must be at least 6 characters long"
        };
    }
    
    // Contains at least one letter and one number
    const hasLetter = /[a-zA-Z]/.test(password);
    const hasNumber = /\d/.test(password);
    
    if (!hasLetter || !hasNumber) {
        return {
            valid: false,
            message: "Password must contain both letters and numbers"
        };
    }
    
    return { valid: true, message: "Strong password" };
}

// Registration form validation
function validateRegistrationForm() {
    const username = document.getElementById('username').value.trim();
    const email = document.getElementById('email').value.trim();
    const phone = document.getElementById('phone').value.trim();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    // Username validation
    if (username.length < 3) {
        showError('Username must be at least 3 characters long');
        return false;
    }
    
    // Email validation
    if (!validateEmail(email)) {
        showError('Please enter a valid email address');
        return false;
    }
    
    // Phone validation
    if (!validatePhone(phone)) {
        showError('Please enter a valid 10-digit phone number');
        return false;
    }
    
    // Password validation
    const passwordCheck = validatePassword(password);
    if (!passwordCheck.valid) {
        showError(passwordCheck.message);
        return false;
    }
    
    // Confirm password
    if (password !== confirmPassword) {
        showError('Passwords do not match');
        return false;
    }
    
    return true;
}

// Event creation form validation
function validateEventForm() {
    const name = document.querySelector('input[name="name"]').value.trim();
    const venue = document.querySelector('input[name="venue"]').value.trim();
    const eventDate = document.querySelector('input[name="eventDate"]').value;
    const fee = parseFloat(document.querySelector('input[name="fee"]').value);
    const capacity = parseInt(document.querySelector('input[name="capacity"]').value);
    
    if (name.length < 3) {
        showError('Event name must be at least 3 characters long');
        return false;
    }
    
    if (venue.length < 3) {
        showError('Venue must be at least 3 characters long');
        return false;
    }
    
    // Check if event date is in the future
    const selectedDate = new Date(eventDate);
    const now = new Date();
    
    if (selectedDate <= now) {
        showError('Event date must be in the future');
        return false;
    }
    
    if (fee < 0) {
        showError('Fee cannot be negative');
        return false;
    }
    
    if (capacity < 1) {
        showError('Capacity must be at least 1');
        return false;
    }
    
    return true;
}

// Show error message
function showError(message) {
    alert(message); // You can replace this with a more elegant notification system
}

// Real-time password strength indicator
function checkPasswordStrength(password) {
    const strengthBar = document.getElementById('passwordStrength');
    if (!strengthBar) return;
    
    let strength = 0;
    
    if (password.length >= 6) strength += 25;
    if (password.length >= 10) strength += 25;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 25;
    if (/\d/.test(password)) strength += 25;
    
    strengthBar.style.width = strength + '%';
    
    if (strength < 50) {
        strengthBar.className = 'progress-bar bg-danger';
        strengthBar.textContent = 'Weak';
    } else if (strength < 75) {
        strengthBar.className = 'progress-bar bg-warning';
        strengthBar.textContent = 'Medium';
    } else {
        strengthBar.className = 'progress-bar bg-success';
        strengthBar.textContent = 'Strong';
    }
}

// Input sanitization
function sanitizeInput(input) {
    const div = document.createElement('div');
    div.textContent = input;
    return div.innerHTML;
}

// Numeric input validation
function validateNumericInput(event) {
    const charCode = event.which ? event.which : event.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        event.preventDefault();
        return false;
    }
    return true;
}

// Date input validation - prevent past dates
function validateFutureDate(dateInput) {
    const selectedDate = new Date(dateInput.value);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    if (selectedDate < today) {
        dateInput.value = '';
        showError('Please select a future date');
        return false;
    }
    return true;
}

// Form submission with confirmation
function confirmSubmit(formId, message) {
    const form = document.getElementById(formId);
    form.addEventListener('submit', function(e) {
        if (!confirm(message)) {
            e.preventDefault();
            return false;
        }
    });
}

// Auto-dismiss alerts
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
});

// Loading spinner for forms
function showLoadingSpinner(button) {
    const originalText = button.innerHTML;
    button.disabled = true;
    button.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Loading...';
    
    return function hideLoadingSpinner() {
        button.disabled = false;
        button.innerHTML = originalText;
    };
}

// File size validation (for future use)
function validateFileSize(input, maxSizeMB) {
    if (input.files && input.files[0]) {
        const fileSize = input.files[0].size / 1024 / 1024; // Convert to MB
        if (fileSize > maxSizeMB) {
            showError(`File size must not exceed ${maxSizeMB}MB`);
            input.value = '';
            return false;
        }
    }
    return true;
}

// Copy to clipboard function
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function() {
        showSuccess('Copied to clipboard!');
    }, function() {
        showError('Failed to copy');
    });
}

// Show success message
function showSuccess(message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3';
    alertDiv.style.zIndex = '9999';
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        alertDiv.remove();
    }, 3000);
}
