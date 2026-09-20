<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Admin Dashboard | JobTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard"><i class="fa-solid fa-chart-line"></i><span class="nav-link-label">Dashboard</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-briefcase"></i><span class="nav-link-label">Applications</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/analytics"><i class="fa-solid fa-chart-pie"></i><span class="nav-link-label">Analytics</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/reminders"><i class="fa-regular fa-bell"></i><span class="nav-link-label">Reminders</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/opportunities"><i class="fa-solid fa-sparkles"></i><span class="nav-link-label">Opportunities</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/profile"><i class="fa-regular fa-user"></i><span class="nav-link-label">Profile</span></a>
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
        <div class="topbar-title">Admin Dashboard</div>
        <div class="topbar-actions">
            <div class="search-pill">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" value="" name="globalSearch" aria-label="Search">
            </div>
            <div style="position: relative;">
                <button type="button" class="icon-button" data-dropdown-trigger="notifications">
                    <i class="fa-regular fa-bell"></i>
                </button>
                <div class="dropdown-panel" data-dropdown-panel="notifications">
                    <div class="dropdown-title">Latest Reminders</div>
                    <div data-notification-count="${fn:length(reminders)}">
                        <c:forEach var="reminder" items="${reminders}">
                            <div class="dropdown-item">
                                <span>${reminder.title}</span>
                                <span class="badge badge-${reminder.urgency}">${reminder.urgency}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <button type="button" class="icon-button" data-theme-toggle>
                <i class="fa-regular fa-moon"></i>
            </button>
            <div style="position: relative;">
                <button type="button"
        class="avatar-button"
        data-dropdown-trigger="profileMenu"
        style="padding:0;overflow:hidden;">

    <c:choose>

        <c:when test="${not empty sessionScope.loggedInUser.profilePicture}">

            <img
                    src="${pageContext.request.contextPath}/profilePictures/${sessionScope.loggedInUser.profilePicture}"
                    style="
                        width:42px;
                        height:42px;
                        border-radius:50%;
                        object-fit:cover;">

        </c:when>

        <c:otherwise>

            ${fn:substring(sessionScope.loggedInUser.name,0,1)}

        </c:otherwise>

    </c:choose>

</button>
                <div class="dropdown-panel avatar-menu" data-dropdown-panel="profileMenu">
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/settings">Settings</a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a>
                </div>
            </div>
        </div>
    </header>

    <main class="content-area">
        <div class="content-inner">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Welcome, ${sessionScope.loggedInUser.name}</h1>
                    <p class="page-subtitle">A precise view of your application momentum, upcoming actions, and readiness score.</p>
                </div>
            </div>

            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-card-top">
                        <div class="stat-card-icon"><i class="fa-solid fa-layer-group"></i></div>
                        <span class="trend-pill up"><i class="fa-solid fa-arrow-up"></i> All</span>
                    </div>
                    <div class="stat-card-value" data-count-up="${counts.total}">${counts.total}</div>
                    <div class="stat-card-label">Total Applications</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-top">
                        <div class="stat-card-icon"><i class="fa-solid fa-hourglass-half"></i></div>
                        <span class="trend-pill up"><i class="fa-solid fa-arrow-up"></i> Active</span>
                    </div>
                    <div class="stat-card-value" data-count-up="${counts.active}">${counts.active}</div>
                    <div class="stat-card-label">Active Pipeline</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-top">
                        <div class="stat-card-icon"><i class="fa-regular fa-comments"></i></div>
                        <span class="trend-pill up"><i class="fa-solid fa-arrow-up"></i> Round</span>
                    </div>
                    <div class="stat-card-value" data-count-up="${counts.interviews}">${counts.interviews}</div>
                    <div class="stat-card-label">Interviews</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-top">
                        <div class="stat-card-icon"><i class="fa-solid fa-gift"></i></div>
                        <span class="trend-pill up"><i class="fa-solid fa-arrow-up"></i> Offers</span>
                    </div>
                    <div class="stat-card-value" data-count-up="${counts.offers}">${counts.offers}</div>
                    <div class="stat-card-label">Offers Received</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-top">
                        <div class="stat-card-icon"><i class="fa-solid fa-circle-xmark"></i></div>
                        <span class="trend-pill down"><i class="fa-solid fa-arrow-down"></i> Review</span>
                    </div>
                    <div class="stat-card-value" data-count-up="${counts.rejections}">${counts.rejections}</div>
                    <div class="stat-card-label">Rejections</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-top">
                        <div class="stat-card-icon"><i class="fa-solid fa-bullseye"></i></div>
                        <span class="trend-pill up"><i class="fa-solid fa-arrow-up"></i> Score</span>
                    </div>
                    <div class="stat-card-value" data-count-up="${placementScore}">${placementScore}</div>
                    <div class="stat-card-label">Placement Score</div>
                </div>
            </section>

            <div class="dashboard-layout">
                <section class="dashboard-row-two">
                    <div class="card chart-panel">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Applications Over Time</div>
                                <div class="card-subtitle">Six-month view of your submission pace.</div>
                            </div>
                        </div>
                        <div class="chart-canvas-wrap">
                            <canvas
                                data-chart="line"
                                data-title="Applications Over Time"
                                data-labels='[<c:forEach var="entry" items="${applicationsPerMonth}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${applicationsPerMonth}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'
                            ></canvas>
                        </div>
                    </div>

                    <div class="card score-card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Readiness Score</div>
                                <div class="card-subtitle">Calculated from profile strength and outcomes.</div>
                            </div>
                        </div>
                        <div class="score-ring-wrap">
                            <div class="score-ring ${placementScore lt 40 ? 'low' : placementScore lt 70 ? 'medium' : 'high'}">
                                <svg viewBox="0 0 220 220">
                                    <circle class="score-ring-track" cx="110" cy="110" r="88"></circle>
                                    <circle
                                        class="score-ring-progress"
                                        cx="110"
                                        cy="110"
                                        r="88"
                                        stroke-dasharray="552"
                                        stroke-dashoffset="${552 - (placementScore * 5.52)}"
                                    ></circle>
                                </svg>
                                <div class="score-ring-center">
                                    <div class="score-ring-value">${placementScore}</div>
                                    <div class="score-ring-label">out of 100</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="dashboard-row-three">
                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Upcoming Reminders</div>
                                <div class="card-subtitle">Your next five high-impact actions.</div>
                            </div>
                        </div>
                        <div class="reminder-list">
                            <c:forEach var="reminder" items="${reminders}">
                                <div class="reminder-item ${reminder.urgency}">
                                    <div class="reminder-title">${reminder.title}</div>
                                    <div class="reminder-meta">${reminder.remindAt}</div>
                                    <div class="reminder-message">${reminder.message}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Fresh Opportunities</div>
                                <div class="card-subtitle">Curated openings to act on quickly.</div>
                            </div>
                        </div>
                        <div class="opportunity-stack">
                            <c:forEach var="opportunity" items="${opportunities}">
                                <div class="opportunity-card">
                                    <div class="opportunity-title">${opportunity.company}</div>
                                    <div class="opportunity-meta">${opportunity.role} • ${opportunity.location}</div>
                                    <div class="opportunity-description">${opportunity.description}</div>
                                    <div class="opportunity-tags">
                                        <c:forEach var="skill" items="${fn:split(opportunity.skillsRequired, ',')}">
                                            <span class="opportunity-tag">${fn:trim(skill)}</span>
                                        </c:forEach>
                                    </div>
                                    <div class="opportunity-footer">
                                        <span class="opportunity-meta">Deadline: ${opportunity.deadline}</span>
                                        <a class="button button-secondary" href="${pageContext.request.contextPath}/opportunities">View</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </section>

                <section class="dashboard-row-two">
                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Activity Timeline</div>
                                <div class="card-subtitle">Recent actions across your placement workspace.</div>
                            </div>
                        </div>
                        <div class="activity-timeline">
                            <c:forEach var="activity" items="${activities}">
                                <div class="activity-item">
                                    <div class="activity-icon"><i class="fa-solid fa-bolt"></i></div>
                                    <div class="activity-content">
                                        <div class="activity-text">${activity.action}</div>
                                        <div class="activity-meta">${activity.performedAt}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div>
                                <div class="card-title">Status Distribution</div>
                                <div class="card-subtitle">Where your current pipeline is concentrated.</div>
                            </div>
                        </div>
                        <div class="chart-canvas-wrap">
                            <canvas
                                data-chart="doughnut"
                                data-title="Status Distribution"
                                data-labels='[<c:forEach var="entry" items="${statusDistribution}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${statusDistribution}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'
                            ></canvas>
                        </div>
                        <div class="suggestion-list" style="margin-top: 20px;">
                            <c:forEach var="tip" items="${placementSuggestions}">
                                <div class="suggestion-item">${tip}</div>
                            </c:forEach>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/charts.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/notifications.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
</body>
</html>
