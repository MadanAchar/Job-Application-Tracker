<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Applications | JobTrack</title>
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-briefcase"></i><span class="nav-link-label">Applications</span></a>
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
        <div class="topbar-title">Applications</div>
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
    <c:choose>
    <c:when test="${isAdmin}">
        <h1 class="page-title">All Student Applications</h1>
    </c:when>
    <c:otherwise>
        <h1 class="page-title">Application Pipeline</h1>
    </c:otherwise>
</c:choose>
                   <c:choose>
    <c:when test="${isAdmin}">
        <p class="page-subtitle">
            View all student applications submitted through the portal.
        </p>
    </c:when>
    <c:otherwise>
        <p class="page-subtitle">
            Track every company, deadline, status change, and resume version in one place.
        </p>
    </c:otherwise>
</c:choose>
                </div>
            </div>

            <section class="card">

<form action="${pageContext.request.contextPath}/applications"
      method="get"
      class="filter-bar">                    <div class="filter-group">
                        <select class="form-select" name="status">
                            <option value="">All Statuses</option>
                            <option value="Applied" ${selectedStatus eq 'Applied' ? 'selected' : ''}>Applied</option>
                            <option value="Interview" ${selectedStatus eq 'Interview' ? 'selected' : ''}>Interview</option>
                            <option value="Rejected" ${selectedStatus eq 'Rejected' ? 'selected' : ''}>Rejected</option>
                            <option value="Selected" ${selectedStatus eq 'Selected' ? 'selected' : ''}>Selected</option>
                            <option value="Offer" ${selectedStatus eq 'Offer' ? 'selected' : ''}>Offer</option>
                            <option value="Joined" ${selectedStatus eq 'Joined' ? 'selected' : ''}>Joined</option>
                        </select>
                    </div>

                    <div class="filter-group filter-search">
                        <input class="form-input" type="text" name="search" value="${searchTerm}" placeholder="">
                    </div>

                    <div class="filter-group">
                        <select class="form-select" name="sort">
                            <option value="">Latest</option>
                            <option value="company" ${selectedSort eq 'company' ? 'selected' : ''}>Company</option>
                            <option value="deadline" ${selectedSort eq 'deadline' ? 'selected' : ''}>Deadline</option>
                            <option value="status" ${selectedSort eq 'status' ? 'selected' : ''}>Status</option>
                        </select>
                    </div>

                    <div class="filter-spacer"></div>
         <button type="submit" class="button button-secondary">
    Apply Filters
</button>

<c:if test="${isAdmin}">
    <a href="${pageContext.request.contextPath}/applications?action=add"
       class="button button-primary">
        Add Application
    </a>
</c:if>

</form>

                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Company</th>
                            <th>Role</th>
                            <th>Location</th>
                            <th>Applied</th>
                            <th>Deadline</th>
                            <th>Status</th>
                            <th>Skill Match</th>
                            <th>Resume</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody data-skeleton-table>
                        <tr class="skeleton-row hidden">
                            <td colspan="9"><div class="skeleton" style="height: 56px;"></div></td>
                        </tr>
                        <c:forEach var="application" items="${applications}">
                            <tr>
                                <td>${application.companyName}</td>
                                <td>${application.jobRole}</td>
                                <td>${application.location}</td>
                                <td>${application.applicationDate}</td>
                                <td>${application.deadline}</td>
                                <td><span class="badge badge-${application.status.toLowerCase()}">${application.status}</span></td>
                                <td>${application.skillMatchPercent}%</td>
                                <td>${application.resumeFilename}</td>
                                <td>
                                    <div class="table-actions">

<c:choose>

<c:when test="${isAdmin}">

<a class="action-button edit"
   href="${pageContext.request.contextPath}/applications?id=${application.id}"
   title="Review">

<i class="fa-solid fa-user-check"></i>

</a>

</c:when>

<c:otherwise>

<button
type="button"
class="action-button delete"
title="Delete"
data-modal-open="deleteApplication"
data-delete-id="${application.id}"
data-delete-name="${application.companyName}">

<i class="fa-regular fa-trash-can"></i>

</button>

</c:otherwise>

</c:choose>

</div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="pagination">
                    <div class="pagination-summary">
                        Showing ${(currentPage - 1) * pageSize + 1}-${((currentPage - 1) * pageSize) + applications.size()} of ${totalRecords}
                    </div>
                    <div class="pagination-controls">
                        <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                            <a
                                class="page-button ${pageNumber eq currentPage ? 'active' : ''}"
                                href="${pageContext.request.contextPath}/applications?page=${pageNumber}&status=${selectedStatus}&search=${searchTerm}&sort=${selectedSort}"
                            >
                                ${pageNumber}
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>

<div class="modal-backdrop" data-modal="deleteApplication">
    <div class="modal-box">
        <h2 class="modal-title">Delete application</h2>
        <p class="modal-text">You are about to remove <strong data-delete-label>this record</strong> from your tracker.</p>
        <form action="${pageContext.request.contextPath}/applications" method="post">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" value="" data-delete-target>
            <div class="modal-actions">
                <button type="button" class="button button-secondary" data-modal-close>Cancel</button>
                <button type="submit" class="button button-primary">Delete</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
</body>
</html>
