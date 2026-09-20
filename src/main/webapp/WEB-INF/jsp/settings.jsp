<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Settings | JobTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animations.css">
</head>
<body>
<div class="app-shell">
    <aside class="sidebar">
        <div>
            <div class="sidebar-brand">
                <span class="sidebar-brand-mark"></span>
                <span class="sidebar-brand-text">JobTrack</span>
            </div>
            <nav class="sidebar-nav">
                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard"><i class="fa-solid fa-chart-line"></i><span class="nav-link-label">Dashboard</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/profile"><i class="fa-regular fa-user"></i><span class="nav-link-label">Profile</span></a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/settings"><i class="fa-solid fa-gear"></i><span class="nav-link-label">Settings</span></a>
            </nav>
        </div>
        <div class="sidebar-footer">
            <button type="button" class="collapse-button" data-sidebar-toggle>
                <i class="fa-solid fa-panel-left"></i>
                <span class="collapse-button-label">Collapse</span>
            </button>
        </div>
    </aside>

    <header class="topbar">
        <div class="topbar-title">Settings</div>
        <div class="topbar-actions">
            <button type="button" class="icon-button" data-theme-toggle><i class="fa-regular fa-moon"></i></button>
           <c:choose>

    <c:when test="${not empty sessionScope.loggedInUser.profilePicture}">

        <img
                src="${pageContext.request.contextPath}/profilePictures/${sessionScope.loggedInUser.profilePicture}"
                class="avatar-button"
                style="
                    width:42px;
                    height:42px;
                    border-radius:50%;
                    object-fit:cover;
                    cursor:pointer;"
                onclick="window.location='${pageContext.request.contextPath}/profile'">

    </c:when>

    <c:otherwise>

        <a href="${pageContext.request.contextPath}/profile"
           class="avatar-button"
           style="display:flex;align-items:center;justify-content:center;">
            ${fn:substring(sessionScope.loggedInUser.name,0,1)}
        </a>

    </c:otherwise>

</c:choose>
        </div>
    </header>

    <main class="content-area">
        <div class="content-inner">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Account Settings</h1>
                    <p class="page-subtitle">Control account security and the interface feel of your workspace.</p>
                </div>
            </div>

            <div style="display: grid; gap: 24px;">
                <section class="form-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Change Password</div>
                            <div class="card-subtitle">Update your password to keep your account secure.</div>
                        </div>
                    </div>
                    <c:if test="${not empty error}">
                        <div class="form-card" style="margin-bottom: 20px; border-color: rgba(239,68,68,0.2); background: #FEF2F2; color: #991B1B;">
                            ${error}
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/settings" method="post" class="form-grid">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="form-group">
                            <label class="form-label" for="currentPassword">Current Password</label>
                            <input class="form-input" type="password" id="currentPassword" name="currentPassword" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="newPassword">New Password</label>
                            <input class="form-input" type="password" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="confirmPassword">Confirm Password</label>
                            <input class="form-input" type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <div class="form-actions" style="grid-column: 1 / -1;">
                            <button type="submit" class="button button-primary">Update Password</button>
                        </div>
                    </form>
                </section>

                <section class="form-card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Appearance</div>
                            <div class="card-subtitle">Adjust visual density and color mode for long working sessions.</div>
                        </div>
                    </div>
                    <div style="display: grid; gap: 20px;">
                        <div style="display: flex; align-items: center; justify-content: space-between; padding: 18px 20px; border: 1px solid var(--border-subtle); border-radius: var(--radius-md);">
                            <div>
                                <div style="font-weight: 600; margin-bottom: 4px;">Dark Mode</div>
                                <div style="color: var(--text-secondary);">Switch the interface into a focused dark canvas.</div>
                            </div>
                            <button type="button" class="button button-secondary" data-theme-toggle>Toggle</button>
                        </div>
                        <div style="display: flex; align-items: center; justify-content: space-between; padding: 18px 20px; border: 1px solid var(--border-subtle); border-radius: var(--radius-md);">
                            <div>
                                <div style="font-weight: 600; margin-bottom: 4px;">Compact Mode</div>
                                <div style="color: var(--text-secondary);">Reduce page spacing for denser information views.</div>
                            </div>
                            <button type="button" class="button button-secondary" id="compactModeToggle">Toggle</button>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const toggle = document.getElementById("compactModeToggle");
    if (!toggle) {
        return;
    }
    toggle.addEventListener("click", function () {
        document.body.classList.toggle("compact-mode");
    });
});
</script>
</body>
</html>
