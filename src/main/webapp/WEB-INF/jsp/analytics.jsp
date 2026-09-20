<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Analytics | JobTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/analytics.css">
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
                <a class="nav-link" href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-briefcase"></i><span class="nav-link-label">Applications</span></a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/analytics"><i class="fa-solid fa-chart-pie"></i><span class="nav-link-label">Analytics</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/reminders"><i class="fa-regular fa-bell"></i><span class="nav-link-label">Reminders</span></a>
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
        <div class="topbar-title">Analytics</div>
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
    </header>

    <main class="content-area">
        <div class="content-inner">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Placement Analytics</h1>
                    <p class="page-subtitle">A deeper look at volume, conversion, skill alignment, and application rhythm.</p>
                </div>
            </div>

            <div class="analytics-grid">
                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <div class="analytics-title">Applications Per Month</div>
                            <div class="analytics-subtitle">Last 12 months</div>
                        </div>
                        <div class="analytics-actions">
                            <select class="form-select analytics-filter"><option>2026</option></select>
                            <button class="analytics-download"><i class="fa-solid fa-download"></i></button>
                        </div>
                    </div>
                    <div class="analytics-canvas">
                        <canvas data-chart="bar" data-title="Applications Per Month"
                                data-labels='[<c:forEach var="entry" items="${applicationsPerMonth}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${applicationsPerMonth}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'></canvas>
                    </div>
                </div>

                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <div class="analytics-title">Status Distribution</div>
                            <div class="analytics-subtitle">Current outcome mix</div>
                        </div>
                        <div class="analytics-actions">
                            <select class="form-select analytics-filter"><option>Current</option></select>
                            <button class="analytics-download"><i class="fa-solid fa-download"></i></button>
                        </div>
                    </div>
                    <div class="analytics-canvas">
                        <canvas data-chart="doughnut" data-title="Status Distribution"
                                data-labels='[<c:forEach var="entry" items="${statusDistribution}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${statusDistribution}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'></canvas>
                    </div>
                </div>

                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <div class="analytics-title">Top 5 Companies</div>
                            <div class="analytics-subtitle">Most frequently targeted companies</div>
                        </div>
                        <div class="analytics-actions">
                            <select class="form-select analytics-filter"><option>All Time</option></select>
                            <button class="analytics-download"><i class="fa-solid fa-download"></i></button>
                        </div>
                    </div>
                    <div class="analytics-canvas">
                        <canvas data-chart="horizontalBar" data-title="Top Companies"
                                data-labels='[<c:forEach var="entry" items="${topCompanies}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${topCompanies}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'></canvas>
                    </div>
                </div>

                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <div class="analytics-title">Skill Match Distribution</div>
                            <div class="analytics-subtitle">Histogram of fit scores</div>
                        </div>
                        <div class="analytics-actions">
                            <select class="form-select analytics-filter"><option>Current</option></select>
                            <button class="analytics-download"><i class="fa-solid fa-download"></i></button>
                        </div>
                    </div>
                    <div class="analytics-canvas">
                        <canvas data-chart="bar" data-title="Skill Match Distribution"
                                data-labels='[<c:forEach var="entry" items="${skillMatchBuckets}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${skillMatchBuckets}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'></canvas>
                    </div>
                </div>

                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <div class="analytics-title">Placement Readiness Trend</div>
                            <div class="analytics-subtitle">Progression across milestones</div>
                        </div>
                        <div class="analytics-actions">
                            <select class="form-select analytics-filter"><option>2026</option></select>
                            <button class="analytics-download"><i class="fa-solid fa-download"></i></button>
                        </div>
                    </div>
                    <div class="analytics-canvas">
                        <canvas data-chart="line" data-title="Placement Readiness Trend"
                                data-labels='[<c:forEach var="entry" items="${placementReadinessTrend}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${placementReadinessTrend}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'></canvas>
                    </div>
                </div>

                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <div class="analytics-title">Interview to Offer Funnel</div>
                            <div class="analytics-subtitle">Stage-wise conversion view</div>
                        </div>
                        <div class="analytics-actions">
                            <select class="form-select analytics-filter"><option>Current</option></select>
                            <button class="analytics-download"><i class="fa-solid fa-download"></i></button>
                        </div>
                    </div>
                    <div class="analytics-canvas">
                        <canvas data-chart="bar" data-title="Interview to Offer Funnel"
                                data-labels='[<c:forEach var="entry" items="${interviewOfferFunnel}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${interviewOfferFunnel}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'></canvas>
                    </div>
                </div>

                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <div class="analytics-title">Application Heatmap By Weekday</div>
                            <div class="analytics-subtitle">HTML heat table view</div>
                        </div>
                        <div class="analytics-actions">
                            <select class="form-select analytics-filter"><option>This Year</option></select>
                            <button class="analytics-download"><i class="fa-solid fa-download"></i></button>
                        </div>
                    </div>
                    <table class="heatmap-table">
                        <thead>
                        <tr>
                            <th>Monday</th>
                            <th>Tuesday</th>
                            <th>Wednesday</th>
                            <th>Thursday</th>
                            <th>Friday</th>
                            <th>Saturday</th>
                            <th>Sunday</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <c:forEach var="entry" items="${applicationWeekdayHeatmap}">
                                <td class="${entry.value lt 2 ? 'heat-low' : entry.value lt 4 ? 'heat-medium' : 'heat-high'}">${entry.value}</td>
                            </c:forEach>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <div class="analytics-title">Offer Ratio Over Time</div>
                            <div class="analytics-subtitle">Offer and joining conversion rate</div>
                        </div>
                        <div class="analytics-actions">
                            <select class="form-select analytics-filter"><option>Current</option></select>
                            <button class="analytics-download"><i class="fa-solid fa-download"></i></button>
                        </div>
                    </div>
                    <div class="analytics-canvas">
                        <canvas data-chart="line" data-title="Offer Ratio Over Time"
                                data-labels='[<c:forEach var="entry" items="${offerRatioTrend}" varStatus="status">"${entry.key}"<c:if test="${not status.last}">,</c:if></c:forEach>]'
                                data-values='[<c:forEach var="entry" items="${offerRatioTrend}" varStatus="status">${entry.value}<c:if test="${not status.last}">,</c:if></c:forEach>]'></canvas>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/charts.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
</body>
</html>
