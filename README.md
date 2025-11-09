# 📲 QR-Based Event Registration System

A comprehensive **web-based event management and registration platform** built using **Java (Servlets & JSP)** that automates university event registrations, attendance tracking, payment verification, and participant management using **secure QR code technology**.

---

## 📋 Table of Contents
- Overview  
- Features  
- Tech Stack  
- System Architecture  
- Installation  
- Database Setup  
- Usage  
- Project Structure  
- Screenshots  
- Future Enhancements  
- Contributing  
- License  
- Author  
- Acknowledgments  

---

# 🎯 Overview  
Universities conduct multiple academic, cultural, and technical events, yet traditional registration and attendance verification methods are slow, error‑prone, and paper-based.  

✅ This system eliminates manual work by providing **secure OTP-based authentication**, **QR-based attendance**, and **automated payment verification**, ensuring a smooth event experience.

---

# ✨ Features

## 🔐 Authentication & Authorization
- Email OTP-based Login / Registration  
- Role-Based Access Control (**Admin**, **Organizer**, **Participant**)  
- Secure Session Management  
- Email-based Password Reset  

---

## 👥 User Roles & Capabilities

### 🛠️ Admin
- Create / Update / Delete events  
- Manage users & roles  
- Approve or reject registrations  
- Verify payments  
- Generate reports and analytics  
- Export attendance and registration data  

### 🎓 Organizer / Volunteer
- Scan QR codes for attendance  
- Manage participant lists  
- View live attendance  
- Generate event reports  

### 🙋 Participant / User
- Browse & register for events  
- Receive unique QR ticket  
- Track past and upcoming events  
- Download registration proof  
- Submit event feedback  

---

## 📅 Event Management
- Detailed event creation (name, venue, date, category, capacity, poster)  
- Categories: Academic, Cultural, Technical, Sports, Extracurricular  
- Auto seat tracking  
- Search & Filter events  
- Event status tracking (Active / Completed / Cancelled)  

---

## 💳 Payment Processing

### Supports both **Free** and **Paid** events:

✅ **Free Events:** Instant approval  
✅ **Paid Events:**  
- User uploads payment proof  
- Admin verifies  
- QR code emailed automatically after approval  

✅ Optional Integration: **Razorpay** for automated payments  

---

## 📱 QR Code System

- Unique QR generation using **ZXing**  
- Instant QR delivery via Email  
- Web-based QR scanner for organizers  
- Real-time attendance marking  
- Duplicate scan prevention  
- Attendance timestamp + location  

---

## 📧 Email Notifications
- OTP for login  
- Registration confirmation + QR  
- Payment verification updates  
- Event reminders  
- Attendance confirmation  

---

## 📊 Reports & Analytics
- Registration reports  
- Attendance analytics  
- Payment verification reports  
- Event popularity metrics  
- Export as **Excel/PDF**  

---

# 🛠️ Tech Stack  

## Backend  
- Java EE (Servlets & JSP)  
- JDBC  
- JavaMail API  
- Apache Tomcat 9+  

## Frontend  
- HTML5, CSS3  
- Bootstrap 5  
- JavaScript, jQuery  
- AJAX  

## Database  
- MySQL 8+  
- JDBC Connection Pooling  

## Libraries  
- ZXing (QR generation)  
- JavaMail API  
- Apache Commons FileUpload  
- iText / PDFBox (optional PDF generation)  

---

# 🏗️ System Architecture  

```
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │
       ▼
┌────────────────────────┐
│   Apache Tomcat        │
│  ┌───────────────────┐ │
│  │   Servlets        │ │
│  └────────┬──────────┘ │
│           │             │
│  ┌────────▼──────────┐ │
│  │   DAO Layer       │ │
│  └────────┬──────────┘ │
└───────────┼────────────┘
            │
 ┌──────────┼────────────┐
 ▼          ▼             ▼
MySQL DB  JavaMail      ZXing (QR)
```

---

# 📦 Installation  

## ✅ Prerequisites  
- JDK 11+  
- Apache Tomcat 9+  
- MySQL Server 8+  
- IDE (IntelliJ / Eclipse)  

---

## ✅ Step 1: Clone Repository  
```
git clone https://github.com/yourusername/qr-event-registration.git
cd qr-event-registration
```

---

## ✅ Step 2: Configure Database  
After creating the DB:

```
CREATE DATABASE event_registration_db;
```

Import schema:

```
mysql -u root -p event_registration_db < database/schema.sql
```

Update DB credentials in:  
`src/main/java/com/event/util/DBConnection.java`

---

## ✅ Step 3: Configure Email (JavaMail API)
Set your SMTP credentials in `EmailUtil.java`.

---

## ✅ Step 4: Add Required Libraries  
Place these JARs in `WEB-INF/lib/`:

- MySQL Connector  
- JavaMail API  
- ZXing core + javase  
- commons-fileupload  
- commons-io  

---

## ✅ Step 5: Deploy to Tomcat  
### Option A: Eclipse  
Export → WAR → Deploy  

### Option B: Manual  
```
mvn clean package
cp target/EventRegistrationSystem.war /tomcat/webapps/
```

---

# 🚀 Usage Guide  

## 👤 Participants  
1. Register with OTP  
2. Browse events  
3. Register (free/paid)  
4. Receive QR code  
5. Attend event using QR  

---

## 🎓 Organizers  
- Login → Scan QR  
- View participants  
- Mark attendance  

---

## 🛠️ Admin  
- Create/manage events  
- Verify payments  
- Approve registrations  
- Generate reports  

---

# 📁 Project Structure  

```
EventRegistrationSystem/
├── src/main/java/com/event/
│   ├── controller/
│   ├── dao/
│   ├── model/
│   ├── filter/
│   └── util/
└── webapp/
    ├── WEB-INF/
    ├── css/
    ├── js/
    ├── images/
    ├── admin/
    └── organizer/
```

---

# 📸 Screenshots  
Add your screenshots here:  
```
screenshots/homepage.png  
screenshots/registration.png  
screenshots/qr-code.png  
screenshots/admin-dashboard.png  
screenshots/scan-qr.png  
```

---

# 🚀 Future Enhancements  
✅ Mobile App (Android/iOS)  
✅ Razorpay/Stripe integration  
✅ WebSocket-based live updates  
✅ LMS / ERP integration  
✅ Certificate generation  
✅ Waitlist management  
✅ Multi-language support  

---

# 🤝 Contributing  
1. Fork the repo  
2. Create feature branch  
3. Commit changes  
4. Push  
5. Open Pull Request  

---

# 📄 License  
MIT License  

---

# 👨‍💻 Author  
**Gundumogula Dhana Sai**  
GitHub: https://github.com/dhanasai2  
Email: saigundumogula5@gmail.com  
LinkedIn: https://linkedin.com  

---

# 🙏 Acknowledgments  
- Apache Tomcat  
- ZXing Library  
- Bootstrap Team  
- JavaMail API Team  
- MySQL  

---

**Made with ❤️ for modern, efficient event management.**

