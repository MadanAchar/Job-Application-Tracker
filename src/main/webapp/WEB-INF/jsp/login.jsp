<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Login | JobTrack</title>
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
                <h1 class="auth-title">Track every application with the clarity of a premium operating system.</h1>
                <p class="auth-subtitle">
                    A focused workspace for placement preparation, application pipelines, and career momentum.
                </p>
            </div>
        </div>

        <svg width="360" height="240" viewBox="0 0 360 240" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="20" y="24" width="120" height="120" rx="24" stroke="rgba(255,255,255,0.18)" stroke-width="2"/>
            <rect x="104" y="84" width="180" height="110" rx="28" fill="rgba(255,255,255,0.06)"/>
            <circle cx="262" cy="62" r="32" fill="rgba(37,99,235,0.92)"/>
            <path d="M58 168H184" stroke="rgba(255,255,255,0.24)" stroke-width="2" stroke-linecap="round"/>
            <path d="M58 188H238" stroke="rgba(255,255,255,0.18)" stroke-width="2" stroke-linecap="round"/>
            <path d="M208 108L238 138L316 60" stroke="rgba(255,255,255,0.92)" stroke-width="10" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    </section>

    <section class="auth-form-panel">
        <div class="auth-form-wrap slide-up">
            <div class="auth-form-header">
                <h2 class="auth-form-title">Welcome back</h2>
                <p class="auth-form-subtitle">Sign in to manage your applications, reminders, and placement progress.</p>
            </div>

            <c:if test="${param.success eq '1'}">
                <div class="form-card" style="margin-bottom: 20px; border-color: rgba(16,185,129,0.25); background: #ECFDF5; color: #065F46;">
                    Account created successfully. You can sign in now.
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="form-card" style="margin-bottom: 20px; border-color: rgba(239,68,68,0.2); background: #FEF2F2; color: #991B1B;">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" class="form-card">
                <div class="form-group" style="margin-bottom: 20px;">
                    <label class="form-label" for="email">Email Address</label>
                    <input class="form-input" type="email" id="email" name="email" required>
                </div>

                <div class="form-group" style="margin-bottom: 20px;">
                    <label class="form-label" for="password">Password</label>
                    <input class="form-input" type="password" id="password" name="password" required>
                </div>

                <div class="checkbox-row">
                    <label class="checkbox-label" for="rememberMe">
                        <input type="checkbox" id="rememberMe" name="rememberMe">
                        <span>Remember me</span>
                    </label>
                    <a href="${pageContext.request.contextPath}/register" style="color: var(--accent); font-weight: 600;">Need an account?</a>
                </div>

                <div class="form-actions" style="justify-content: stretch; margin-top: 24px;">
                    <button type="submit" class="button button-primary" style="width: 100%;">Sign In</button>
                </div>

                <p class="auth-footer-link">
                    New to JobTrack?
                    <a href="${pageContext.request.contextPath}/register">Create your account</a>
                </p>
            </form>
        </div>
    </section>
</div>
</body>
</html>
