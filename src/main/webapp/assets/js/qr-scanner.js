// QR Code Scanner Implementation using html5-qrcode library

let html5QrCodeScanner = null;

// Initialize QR Scanner
function initQRScanner(elementId, onScanSuccess, onScanFailure) {
    const config = {
        fps: 10,
        qrbox: { width: 250, height: 250 },
        aspectRatio: 1.0,
        disableFlip: false
    };
    
    html5QrCodeScanner = new Html5QrcodeScanner(
        elementId,
        config,
        false
    );
    
    html5QrCodeScanner.render(onScanSuccess, onScanFailure);
}

// Default scan success handler
function onScanSuccess(decodedText, decodedResult) {
    console.log(`QR Code decoded: ${decodedText}`);
    
    // Send to server for verification
    fetch(contextPath + '/scanQR', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'qrData=' + encodeURIComponent(decodedText)
    })
    .then(response => response.json())
    .then(data => {
        displayScanResult(data);
        
        // Pause scanner after successful scan
        if (data.status === 'success') {
            html5QrCodeScanner.pause();
            
            // Resume after 3 seconds
            setTimeout(() => {
                html5QrCodeScanner.resume();
            }, 3000);
        }
    })
    .catch(error => {
        console.error('Scan error:', error);
        displayScanResult({
            status: 'error',
            message: 'Failed to verify QR code'
        });
    });
}

// Default scan failure handler
function onScanFailure(error) {
    // Silent handling - this fires frequently during scanning
    // console.warn(`QR scan error: ${error}`);
}

// Display scan result
function displayScanResult(data) {
    const resultDiv = document.getElementById('scanResult');
    if (!resultDiv) return;
    
    let alertClass = 'alert-';
    let icon = '';
    
    switch(data.status) {
        case 'success':
            alertClass += 'success';
            icon = '<i class="fas fa-check-circle"></i>';
            break;
        case 'warning':
            alertClass += 'warning';
            icon = '<i class="fas fa-exclamation-triangle"></i>';
            break;
        case 'error':
            alertClass += 'danger';
            icon = '<i class="fas fa-times-circle"></i>';
            break;
        default:
            alertClass += 'info';
            icon = '<i class="fas fa-info-circle"></i>';
    }
    
    let detailsHTML = '';
    if (data.name) {
        detailsHTML += `<p class="mb-1"><strong>Name:</strong> ${data.name}</p>`;
    }
    if (data.event) {
        detailsHTML += `<p class="mb-0"><strong>Event:</strong> ${data.event}</p>`;
    }
    
    resultDiv.innerHTML = `
        <div class="alert ${alertClass} alert-dismissible fade show">
            ${icon}
            <strong> ${data.message}</strong>
            ${detailsHTML}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    
    // Play sound based on result
    playFeedbackSound(data.status);
}

// Audio feedback for scan results
function playFeedbackSound(status) {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    const oscillator = audioContext.createOscillator();
    const gainNode = audioContext.createGain();
    
    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);
    
    if (status === 'success') {
        oscillator.frequency.value = 800;
        gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.3);
    } else {
        oscillator.frequency.value = 200;
        gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);
    }
    
    oscillator.start(audioContext.currentTime);
    oscillator.stop(audioContext.currentTime + 0.3);
}

// Stop QR Scanner
function stopQRScanner() {
    if (html5QrCodeScanner) {
        html5QrCodeScanner.clear();
    }
}

// Switch camera (front/back)
function switchCamera() {
    if (html5QrCodeScanner) {
        html5QrCodeScanner.clear().then(() => {
            // Re-initialize with different camera
            initQRScanner('reader', onScanSuccess, onScanFailure);
        });
    }
}

// Manual QR code input
function processManualQRInput() {
    const input = document.getElementById('manualQRInput');
    if (input && input.value.trim()) {
        onScanSuccess(input.value.trim(), null);
        input.value = '';
    }
}
