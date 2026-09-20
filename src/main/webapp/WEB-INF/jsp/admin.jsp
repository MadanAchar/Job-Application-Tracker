<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Admin | JobTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/admin"><i class="fa-solid fa-shield-halved"></i><span class="nav-link-label">Admin</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/analytics"><i class="fa-solid fa-chart-pie"></i><span class="nav-link-label">Analytics</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-briefcase"></i><span class="nav-link-label">Applications</span></a>
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
        <div class="topbar-title">Admin Console</div>
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
                    <h1 class="page-title">Placement Administration</h1>
                    <p class="page-subtitle">Manage users, monitor applications, control opportunities, export data, and review system activity.</p>
                </div>
            </div>

            <div class="admin-shell">
                <nav class="admin-tabs">
                    <a class="admin-tab ${activeTab eq 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?tab=users">Users</a>
                    <a class="admin-tab ${activeTab eq 'applications' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?tab=applications">All Applications</a>
                    <a class="admin-tab ${activeTab eq 'opportunities' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?tab=opportunities">Opportunities</a>
                    <a class="admin-tab ${activeTab eq 'analytics' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?tab=analytics">Analytics</a>
                    <a class="admin-tab ${activeTab eq 'export' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?tab=export">Export</a>
                    <a class="admin-tab ${activeTab eq 'activity' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?tab=activity">Activity Logs</a>
                </nav>

                <c:if test="${activeTab eq 'users'}">
                    <section class="admin-panel">
                        <div class="admin-panel-header">
                            <div>
                                <div class="admin-panel-title">Users</div>
                                <div class="admin-panel-subtitle">Review student and admin accounts, and control access roles.</div>
                            </div>
                        </div>
                        <div class="table-wrap admin-table">
                            <table class="data-table">
                                <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Branch</th>
                                    <th>CGPA</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>${user.name}</td>
                                        <td>${user.email}</td>
                                        <td><span class="role-pill ${user.role}">${user.role}</span></td>
                                        <td>${user.branch}</td>
                                        <td>${user.cgpa}</td>
                                        <td>
                                            <div class="admin-actions-inline">
                                                <form action="${pageContext.request.contextPath}/admin" method="post">
                                                    <input type="hidden" name="action" value="toggleAdminRole">
                                                    <input type="hidden" name="tab" value="users">
                                                    <input type="hidden" name="userId" value="${user.id}">
                                                    <input type="hidden" name="currentRole" value="${user.role}">
                                                    <button type="submit" class="button button-secondary">Toggle Role</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin" method="post">
                                                    <input type="hidden" name="action" value="deleteUser">
                                                    <input type="hidden" name="tab" value="users">
                                                    <input type="hidden" name="userId" value="${user.id}">
                                                    <button type="submit" class="button button-secondary">Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </c:if>

                <c:if test="${activeTab eq 'applications'}">
                    <section class="admin-panel">
                        <div class="admin-panel-header">
                            <div>
                                <div class="admin-panel-title">All Applications</div>
                                <div class="admin-panel-subtitle">A platform-wide overview of student application records.</div>
                            </div>
                        </div>
                        <div class="table-wrap admin-table">
                            <table class="data-table">
                                <thead>
                                <tr>
                                    <th>User ID</th>
                                    <th>Company</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Applied On</th>
                                    <th>Deadline</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="application" items="${applications}">
                                    <tr>
                                        <td>${application.userId}</td>
                                        <td>${application.companyName}</td>
                                        <td>${application.jobRole}</td>
                                        <td><span class="badge badge-${application.status.toLowerCase()}">${application.status}</span></td>
                                        <td>${application.applicationDate}</td>
                                        <td>${application.deadline}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </c:if>

                <c:if test="${activeTab eq 'opportunities'}">
                    <section class="admin-panel">
                        <div class="admin-panel-header">
                            <div>
                                <div class="admin-panel-title">Opportunities</div>
                                <div class="admin-panel-subtitle">Maintain the opportunity board used by students across the portal.</div>
                            </div>
                        </div>
                        <div class="table-wrap admin-table">
                            <table class="data-table">
                                <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Role</th>
                                    <th>Location</th>
                                    <th>Deadline</th>
                                    <th>Salary</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="opportunity" items="${opportunities}">
                                    <tr>
                                        <td>${opportunity.company}</td>
                                        <td>${opportunity.role}</td>
                                        <td>${opportunity.location}</td>
                                        <td>${opportunity.deadline}</td>
                                        <td>${opportunity.salary}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin" method="post">
                                                <input type="hidden" name="action" value="deleteOpportunity">
                                                <input type="hidden" name="tab" value="opportunities">
                                                <input type="hidden" name="opportunityId" value="${opportunity.id}">
                                                <button type="submit" class="button button-secondary">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </c:if>

                <c:if test="${activeTab eq 'analytics'}">
                    <section class="admin-panel">
                        <div class="admin-panel-header">
                            <div>
                                <div class="admin-panel-title">Admin Analytics Snapshot</div>
                                <div class="admin-panel-subtitle">Quick totals across users, applications, opportunities, and activity logs.</div>
                            </div>
                        </div>
                        <div class="admin-stat-row">
                            <div class="admin-stat-card">
                                <div class="admin-stat-label">Users</div>
                                <div class="admin-stat-value">${users.size()}</div>
                            </div>
                            <div class="admin-stat-card">
                                <div class="admin-stat-label">Applications</div>
                                <div class="admin-stat-value">${applications.size()}</div>
                            </div>
                            <div class="admin-stat-card">
                                <div class="admin-stat-label">Opportunities</div>
                                <div class="admin-stat-value">${opportunities.size()}</div>
                            </div>
                            <div class="admin-stat-card">
                                <div class="admin-stat-label">Activity Logs</div>
                                <div class="admin-stat-value">${activities.size()}</div>
                            </div>
                        </div>
                    </section>
                </c:if>

                <c:if test="${activeTab eq 'export'}">
                    <section class="admin-panel">
                        <div class="admin-panel-header">
                            <div>
                                <div class="admin-panel-title">Export Center</div>
                                <div class="admin-panel-subtitle">Download structured CSV exports for audits, reporting, and committee reviews.</div>
                            </div>
                        </div>
                        <div class="export-grid">
                            <div class="export-card">
                                <div class="export-card-title">Applications Export</div>
                                <div class="export-card-text">Download the complete applications dataset across all users.</div>
                                <a class="button button-primary" href="${pageContext.request.contextPath}/export?type=applications">Download CSV</a>
                            </div>
                            <div class="export-card">
                                <div class="export-card-title">Users Export</div>
                                <div class="export-card-text">Download profile and role information for the full user base.</div>
                                <a class="button button-primary" href="${pageContext.request.contextPath}/export?type=users">Download CSV</a>
                            </div>
                            <div class="export-card">
                                <div class="export-card-title">My Applications</div>
                                <div class="export-card-text">Quick personal export using the same download endpoint.</div>
                                <a class="button button-primary" href="${pageContext.request.contextPath}/export">Download CSV</a>
                            </div>
                        </div>
                    </section>
                </c:if>

                <c:if test="${activeTab eq 'activity'}">
                    <section class="admin-panel">
                        <div class="admin-panel-header">
                            <div>
                                <div class="admin-panel-title">Activity Logs</div>
                                <div class="admin-panel-subtitle">Recent system actions captured from user and admin workflows.</div>
                            </div>
                        </div>
                        <div class="activity-log-list">
                            <c:forEach var="activity" items="${activities}">
                                <div class="activity-log-item">
                                    <div class="activity-log-entity">${activity.entityType}</div>
                                    <div class="activity-log-text">${activity.action}</div>
                                    <div class="activity-log-time">${activity.performedAt}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </c:if>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
</body>
</html>
