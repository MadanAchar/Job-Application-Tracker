<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Register | JobTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animations.css">
</head>
<body>
<div class="auth-layout">
    <section class="auth-panel">
        <div>
            <div class="auth-brand">
                <span class="auth-brand-mark"></span>
                <span>JobTrack</span>
            </div>
            <div class="auth-art">
                <h1 class="auth-title">Build your placement command center before the next opportunity arrives.</h1>
                <p class="auth-subtitle">
                    Capture your profile, organize applications, and turn scattered effort into measurable readiness.
                </p>
            </div>
        </div>

        <svg width="360" height="240" viewBox="0 0 360 240" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="36" y="38" width="116" height="116" rx="26" fill="rgba(255,255,255,0.05)"/>
            <rect x="152" y="60" width="144" height="144" rx="30" stroke="rgba(255,255,255,0.16)" stroke-width="2"/>
            <circle cx="82" cy="190" r="26" fill="rgba(37,99,235,0.92)"/>
            <path d="M88 98H262" stroke="rgba(255,255,255,0.16)" stroke-width="2" stroke-linecap="round"/>
            <path d="M88 124H224" stroke="rgba(255,255,255,0.22)" stroke-width="2" stroke-linecap="round"/>
            <path d="M182 168H290" stroke="rgba(255,255,255,0.2)" stroke-width="12" stroke-linecap="round"/>
            <path d="M182 168L214 200L304 116" stroke="rgba(255,255,255,0.92)" stroke-width="10" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    </section>

    <section class="auth-form-panel">
        <div class="auth-form-wrap slide-up" style="max-width: 520px;">
            <div class="auth-form-header">
                <h2 class="auth-form-title">Create account</h2>
                <p class="auth-form-subtitle">Set up your student profile and start organizing your placement pipeline.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="form-card" style="margin-bottom: 20px; border-color: rgba(239,68,68,0.2); background: #FEF2F2; color: #991B1B;">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="form-card">
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label" for="name">Full Name</label>
                        <input class="form-input" type="text" id="name" name="name" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">Email Address</label>
                        <input class="form-input" type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="branch">Branch</label>
                        <input class="form-input" type="text" id="branch" name="branch" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="cgpa">CGPA</label>
                        <input class="form-input" type="number" step="0.01" min="0" max="10" id="cgpa" name="cgpa" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <input class="form-input" type="password" id="password" name="password" required data-password-strength>
                        <div class="password-strength">
                            <div class="password-strength-bar">
                                <div class="password-strength-fill" data-password-strength-fill></div>
                            </div>
                            <div class="password-strength-text" data-password-strength-text>Choose a strong password</div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm Password</label>
                        <input class="form-input" type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>

                <div class="form-actions">
                    <a class="button button-secondary" href="${pageContext.request.contextPath}/login">Back to Login</a>
                    <button type="submit" class="button button-primary">Create Account</button>
                </div>
            </form>
        </div>
    </section>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
