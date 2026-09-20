<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Profile | JobTrack</title>
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
                <a class="nav-link" href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-briefcase"></i><span class="nav-link-label">Applications</span></a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/profile"><i class="fa-regular fa-user"></i><span class="nav-link-label">Profile</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/settings"><i class="fa-solid fa-gear"></i><span class="nav-link-label">Settings</span></a>
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
        <div class="topbar-title">Profile</div>
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
                    <h1 class="page-title">Your Profile</h1>
                    <p class="page-subtitle">Maintain a polished placement-ready profile with links, skills, experience, and projects.</p>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 260px minmax(0, 1fr); gap: 24px;">
                <section class="card">
                    <div style="display: flex; flex-direction: column; align-items: center; text-align: center;">
                        <c:choose>

    <c:when test="${not empty profileUser.profilePicture}">

        <img
                src="${pageContext.request.contextPath}/profilePictures/${profileUser.profilePicture}"
                alt="Profile Picture"
                style="
                    width:120px;
                    height:120px;
                    border-radius:50%;
                    object-fit:cover;
                    border:3px solid #2563EB;
                    margin-bottom:20px;">

    </c:when>

    <c:otherwise>

        <div style="
                width:120px;
                height:120px;
                border-radius:50%;
                background:var(--accent-light);
                color:var(--accent);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:42px;
                font-weight:700;
                margin-bottom:20px;">

            ${fn:substring(profileUser.name,0,1)}

        </div>

    </c:otherwise>

</c:choose>
                        <h2 style="font-size: 22px; margin-bottom: 8px;">${profileUser.name}</h2>
                        <p style="color: var(--text-secondary); margin-bottom: 10px;">${profileUser.email}</p>
                        <p style="color: var(--text-secondary); margin-bottom: 6px;">${profileUser.branch}</p>
                        <p style="color: var(--text-secondary); margin-bottom: 20px;">CGPA ${profileUser.cgpa}</p>
                        <a class="button button-secondary" style="width: 100%; margin-bottom: 10px;" href="${profileUser.githubUrl}">GitHub</a>
                        <a class="button button-secondary" style="width: 100%;" href="${profileUser.linkedinUrl}">LinkedIn</a>
                    </div>
                </section>

                <section class="form-card">
                    <form action="${pageContext.request.contextPath}/profile"
      method="post"
      enctype="multipart/form-data"
      class="form-grid">
                        <input type="hidden" name="action" value="updateProfile">

                        <div class="form-group">
                            <label class="form-label" for="name">Full Name</label>
                            <input class="form-input" type="text" id="name" name="name" value="${profileUser.name}" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="email">Email</label>
                            <input class="form-input" type="email" id="email" name="email" value="${profileUser.email}" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="branch">Branch</label>
                            <input class="form-input" type="text" id="branch" name="branch" value="${profileUser.branch}">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="cgpa">CGPA</label>
                            <input class="form-input" type="number" step="0.01" min="0" max="10" id="cgpa" name="cgpa" value="${profileUser.cgpa}">
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label">Skills</label>
                            <div class="tag-input-wrap" data-tag-input data-target="#skillsHidden">
                                <c:forEach var="skill" items="${fn:split(profileUser.skills, ',')}">
                                    <c:if test="${not empty fn:trim(skill)}">
                                        <span class="tag-pill" data-tag-value="${fn:trim(skill)}">${fn:trim(skill)}<button type="button" data-remove-tag>&times;</button></span>
                                    </c:if>
                                </c:forEach>
                                <input type="text" value="">
                            </div>
                            <input type="hidden" id="skillsHidden" name="skills" value="${profileUser.skills}">
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label" for="experience">Experience</label>
                            <textarea class="form-textarea" id="experience" name="experience">${profileUser.experience}</textarea>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label" for="projects">Projects</label>
                            <textarea class="form-textarea" id="projects" name="projects">${profileUser.projects}</textarea>
                        </div>

                        <div class="form-group">
    <label class="form-label" for="githubUrl">GitHub URL</label>
    <input
            class="form-input"
            type="text"
            id="githubUrl"
            name="githubUrl"
            value="${profileUser.githubUrl}">
</div>

<div class="form-group">
    <label class="form-label" for="linkedinUrl">LinkedIn URL</label>
    <input
            class="form-input"
            type="text"
            id="linkedinUrl"
            name="linkedinUrl"
            value="${profileUser.linkedinUrl}">
</div>

<div class="form-group full-width">
    <label class="form-label" for="profileImage">
        Upload Profile Picture
    </label>

    <input
            class="form-input"
            type="file"
            id="profileImage"
            name="profileImage"
            accept=".jpg,.jpeg,.png">

    <c:if test="${not empty profileUser.profilePicture}">
        <div style="margin-top:10px;color:var(--text-secondary);">
            Current Profile Picture:
            <strong>${profileUser.profilePicture}</strong>
        </div>
    </c:if>
</div>

<div class="form-group full-width">
    <label class="form-label" for="resumeFile">
        Upload Resume (PDF/DOC/DOCX)
    </label>

    <input
            class="form-input"
            type="file"
            id="resumeFile"
            name="resumeFile"
            accept=".pdf,.doc,.docx">

    <c:if test="${not empty profileUser.resumeFilename}">
        <div style="margin-top:10px;color:var(--text-secondary);">
            Current Resume:
<strong>${profileUser.resumeFilename}</strong>

<a class="button button-secondary"
   href="${pageContext.request.contextPath}/resume?userId=${profileUser.id}">
    View Resume
</a>
        </div>
    </c:if>
</div>

<div class="form-actions" style="grid-column: 1 / -1;">
    <button type="submit" class="button button-primary">
        Save Profile
    </button>
</div>
                    </form>
                </section>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
</body>
</html>
