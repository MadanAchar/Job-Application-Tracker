<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard | JobTrack</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
        rel="stylesheet" />

    <!-- Font Awesome -->
    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animations.css" />
</head>

<body>
    <div class="app-shell">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div>
                <div class="sidebar-brand">
                    <span class="sidebar-brand-mark"></span>
                    <span class="sidebar-brand-text">JobTrack</span>
                </div>

                <!-- Navigation -->
                <nav class="sidebar-nav">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
                        <i class="fa-solid fa-chart-line"></i>
                        <span class="nav-link-label">Dashboard</span>
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/applications">
                        <i class="fa-solid fa-briefcase"></i>
                        <span class="nav-link-label">Applications</span>
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/opportunities">
                        <i class="fa-solid fa-sparkles"></i>
                        <span class="nav-link-label">Opportunities</span>
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/analytics">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span class="nav-link-label">Analytics</span>
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                        <i class="fa-regular fa-user"></i>
                        <span class="nav-link-label">Profile</span>
                    </a>
                </nav>
            </div>
            <!-- Sidebar Footer -->
            <div class="sidebar-footer">
                <button class="collapse-button" data-sidebar-toggle>
                    <i class="fa-solid fa-panel-left"></i>
                    <span class="collapse-button-label">Collapse</span>
                </button>
            </div>
        </aside>

        <!-- Topbar -->
        <header class="topbar">
            <div class="topbar-title">Admin Dashboard</div>
            <div class="topbar-actions">
                <button type="button" class="icon-button" data-theme-toggle>
                    <i class="fa-regular fa-moon"></i>
                </button>

                <!-- User Profile -->
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser.profilePicture}">
                        <img src="${pageContext.request.contextPath}/profilePictures/${sessionScope.loggedInUser.profilePicture}"
                            class="avatar-button"
                            style="width:42px; height:42px; border-radius:50%; object-fit:cover; cursor:pointer;"
                            onclick="window.location='${pageContext.request.contextPath}/profile'" />
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/profile" class="avatar-button"
                            style="display:flex; align-items:center; justify-content:center;">
                            ${fn:substring(sessionScope.loggedInUser.name, 0, 1)}
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <!-- Main Content -->
        <main class="content-area">
            <div class="content-inner">
                <!-- Page Header -->
                <div class="page-header">
                    <div>
                        <h1 class="page-title">Welcome, ${sessionScope.loggedInUser.name}</h1>
                        <p class="page-subtitle">Manage students, applications, opportunities and placement activities from one place.</p>
                    </div>
                </div>

                <!-- Stats Grid -->
                <section class="stats-grid">
                    <!-- Applications Count -->
                    <div class="stat-card">
                        <div class="stat-card-top">
                            <div class="stat-card-icon"><i class="fa-solid fa-file-lines"></i></div>
                        </div>
                        <div class="stat-card-value">${totalApplications}</div>
                        <div class="stat-card-label">Applications</div>
                    </div>
                    <!-- Opportunities Count -->
                    <div class="stat-card">
                        <div class="stat-card-top">
                            <div class="stat-card-icon"><i class="fa-solid fa-briefcase"></i></div>
                        </div>
                        <div class="stat-card-value">${totalOpportunities}</div>
                        <div class="stat-card-label">Opportunities</div>
                    </div>
                    <!-- Pending Reviews -->
                    <div class="stat-card">
                        <div class="stat-card-top">
                            <div class="stat-card-icon"><i class="fa-solid fa-hourglass-half"></i></div>
                        </div>
                        <div class="stat-card-value">${pendingCount}</div>
                        <div class="stat-card-label">Pending Reviews</div>
                    </div>
                    <!-- Selected Count -->
                    <div class="stat-card">
                        <div class="stat-card-top">
                            <div class="stat-card-icon"><i class="fa-solid fa-award"></i></div>
                        </div>
                        <div class="stat-card-value">${selectedCount}</div>
                        <div class="stat-card-label">Selected</div>
                    </div>
                    <!-- Rejected Count -->
                    <div class="stat-card">
                        <div class="stat-card-top">
                            <div class="stat-card-icon"><i class="fa-solid fa-circle-xmark"></i></div>
                        </div>
                        <div class="stat-card-value">${rejectedCount}</div>
                        <div class="stat-card-label">Rejected</div>
                    </div>
                </section>

                <!-- Dashboard Charts -->
                <div class="dashboard-layout">
                    <section class="dashboard-row-two">
                        <!-- Monthly Applications Chart -->
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="card-title">Monthly Applications</div>
                                    <div class="card-subtitle">Overall applications submitted every month.</div>
                                </div>
                            </div>
                            <div class="chart-canvas-wrap">
                                <canvas
                                    data-chart="line"
                                    data-title="Applications"
                                    data-labels='[
                                        <c:forEach var="entry" items="${applicationsPerMonth}" varStatus="status">
                                            "${entry.key}"<c:if test="${!status.last}">,</c:if>
                                        </c:forEach>
                                    ]'
                                    data-values='[
                                        <c:forEach var="entry" items="${applicationsPerMonth}" varStatus="status">
                                            ${entry.value}<c:if test="${!status.last}">,</c:if>
                                        </c:forEach>
                                    ]'
                                ></canvas>
                            </div>
                        </div>

                        <!-- Placement Status Chart -->
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="card-title">Placement Status</div>
                                    <div class="card-subtitle">Distribution of all applications.</div>
                                </div>
                            </div>
                            <div class="chart-canvas-wrap">
                                <canvas
                                    data-chart="doughnut"
                                    data-title="Status"
                                    data-labels='[
                                        <c:forEach var="entry" items="${statusDistribution}" varStatus="status">
                                            "${entry.key}"<c:if test="${!status.last}">,</c:if>
                                        </c:forEach>
                                    ]'
                                    data-values='[
                                        <c:forEach var="entry" items="${statusDistribution}" varStatus="status">
                                            ${entry.value}<c:if test="${!status.last}">,</c:if>
                                        </c:forEach>
                                    ]'
                                ></canvas>
                            </div>
                        </div>
                    </section>

                    <!-- Recent Applications -->
                    <section class="dashboard-row-two">
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="card-title">Recent Applications</div>
                                    <div class="card-subtitle">Latest student applications.</div>
                                </div>
                            </div>
                            <div class="activity-timeline">
                                <c:forEach var="application" items="${recentApplications}">
                                    <div class="activity-item">
                                        <div class="activity-icon"><i class="fa-solid fa-file-lines"></i></div>
                                        <div class="activity-content">
                                            <div class="activity-text">
                                                ${application.companyName} - ${application.jobRole}
                                            </div>
                                            <div class="activity-meta">${application.status}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </section>

                    <!-- Recent Activities -->
                    <section class="dashboard-row-two">
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="card-title">Recent Activities</div>
                                    <div class="card-subtitle">Placement cell activity log.</div>
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
                    </section>
                </div>
            </div>
        </main>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/charts.js"></script>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script src="${pageContext.request.contextPath}/js/notifications.js"></script>
    <script src="${pageContext.request.contextPath}/js/animations.js"></script>
</body>

</html>