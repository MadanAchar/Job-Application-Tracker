<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Reminders | JobTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/reminders"><i class="fa-regular fa-bell"></i><span class="nav-link-label">Reminders</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-briefcase"></i><span class="nav-link-label">Applications</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/opportunities"><i class="fa-solid fa-sparkles"></i><span class="nav-link-label">Opportunities</span></a>
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
        <div class="topbar-title">Reminders</div>
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
                    <h1 class="page-title">Reminder Timeline</h1>
                    <p class="page-subtitle">Stay ahead of interviews, deadlines, documents, and follow-ups with precise scheduling.</p>
                </div>
            </div>

            <section class="form-card" style="margin-bottom: 24px;">
                <form action="${pageContext.request.contextPath}/reminders" method="post" class="form-grid">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label class="form-label" for="title">Title</label>
                        <input class="form-input" type="text" id="title" name="title" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="urgency">Urgency</label>
                        <select class="form-select" id="urgency" name="urgency" required>
                            <option value="low">Low</option>
                            <option value="medium">Medium</option>
                            <option value="high">High</option>
                        </select>
                    </div>
                    <div class="form-group full-width">
                        <label class="form-label" for="message">Message</label>
                        <textarea class="form-textarea" id="message" name="message"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="remindAt">Remind At</label>
                        <input class="form-input" type="datetime-local" id="remindAt" name="remindAt" required>
                    </div>
                    <div class="form-actions" style="grid-column: 1 / -1;">
                        <button type="submit" class="button button-primary">Create Reminder</button>
                    </div>
                </form>
            </section>

            <section class="card">
                <div class="reminder-list">
                    <c:forEach var="reminder" items="${reminders}">
                        <div class="reminder-item ${reminder.urgency}">
                            <div style="display: flex; justify-content: space-between; gap: 16px;">
                                <div>
                                    <div class="reminder-title">${reminder.title}</div>
                                    <div class="reminder-meta">${reminder.remindAt}</div>
                                </div>
                                <span class="badge badge-${reminder.urgency}">${reminder.urgency}</span>
                            </div>
                            <div class="reminder-message">${reminder.message}</div>
                            <div style="display: flex; gap: 12px; margin-top: 16px;">
                                <form action="${pageContext.request.contextPath}/reminders" method="post">
                                    <input type="hidden" name="action" value="markRead">
                                    <input type="hidden" name="id" value="${reminder.id}">
                                    <input type="hidden" name="isRead" value="${not reminder.read}">
                                    <button type="submit" class="button button-secondary">${reminder.read ? 'Mark Unread' : 'Mark Read'}</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/reminders" method="post">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${reminder.id}">
                                    <button type="submit" class="button button-secondary">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
</body>
</html>
