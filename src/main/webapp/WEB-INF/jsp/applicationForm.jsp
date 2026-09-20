<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Application Form | JobTrack</title>
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
        <div class="topbar-title">${empty application ? 'Add Application' : 'Edit Application'}</div>
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
                    <h1 class="page-title">${empty application ? 'Create a new application entry' : 'Update your application entry'}</h1>
                    <p class="page-subtitle">Capture every detail that matters, from job skills to deadlines and resume versions.</p>
                </div>
            </div>

            <section class="form-card">
               <form action="${pageContext.request.contextPath}/applications"
    method="post"
    enctype="multipart/form-data"
    class="form-grid">
                    <input type="hidden" name="action" value="${empty application ? 'add' : 'edit'}">
                    <c:if test="${not empty application}">
                        <input type="hidden" name="id" value="${application.id}">
                    </c:if>

                    <div class="form-group">
                        <label class="form-label" for="companyName">Company Name</label>
                        <input class="form-input" type="text" id="companyName" name="companyName" value="${application.companyName}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="jobRole">Job Role</label>
                        <input class="form-input" type="text" id="jobRole" name="jobRole" value="${application.jobRole}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="location">Location</label>
                        <input class="form-input" type="text" id="location" name="location" value="${application.location}">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="status">Status</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="Applied" ${application.status eq 'Applied' ? 'selected' : ''}>Applied</option>
                            <option value="Interview" ${application.status eq 'Interview' ? 'selected' : ''}>Interview</option>
                            <option value="Rejected" ${application.status eq 'Rejected' ? 'selected' : ''}>Rejected</option>
                            <option value="Selected" ${application.status eq 'Selected' ? 'selected' : ''}>Selected</option>
                            <option value="Offer" ${application.status eq 'Offer' ? 'selected' : ''}>Offer</option>
                            <option value="Joined" ${application.status eq 'Joined' ? 'selected' : ''}>Joined</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="applicationDate">Application Date</label>
                        <input class="form-input" type="date" id="applicationDate" name="applicationDate" value="${application.applicationDate}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="deadline">Deadline</label>
                        <input class="form-input" type="date" id="deadline" name="deadline" value="${application.deadline}">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="jobSkills">Job Skills</label>
                        <input class="form-input" type="text" id="jobSkills" name="jobSkills" value="${application.jobSkills}">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="skillMatchPercent">Skill Match Percent</label>
                        <input class="form-input" type="number" id="skillMatchPercent" name="skillMatchPercent" min="0" max="100" value="${application.skillMatchPercent}">
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="notes">Notes</label>
                        <textarea class="form-textarea" id="notes" name="notes">${application.notes}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Resume Upload</label>
                        <div class="upload-zone" data-upload-zone data-input="#resumeFile" data-file-name="#resumeFileName">
                            <div class="upload-zone-icon"><i class="fa-regular fa-file-pdf"></i></div>
                            <div class="upload-zone-text">Drop your PDF resume here or click to browse</div>
                            <div class="upload-zone-help">Only PDF files are accepted, up to 5 MB.</div>
                            <div class="upload-file-name" id="resumeFileName">${application.resumeFilename}</div>
                        </div>
                        <input type="file" id="resumeFile" accept="application/pdf" class="hidden">
                        <input type="hidden" id="resumeFilename" name="resumeFilename" value="${application.resumeFilename}">
                    </div>

                    <div class="form-actions" style="grid-column: 1 / -1;">
                        <a class="button button-secondary" href="${pageContext.request.contextPath}/applications">Back</a>
                        <button type="submit" class="button button-primary">${empty application ? 'Save Application' : 'Update Application'}</button>
                    </div>
                </form>
            </section>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const fileInput = document.getElementById("resumeFile");
    const resumeField = document.getElementById("resumeFilename");
    const fileNameTarget = document.getElementById("resumeFileName");

    if (!fileInput || !resumeField || !fileNameTarget) {
        return;
    }

    fileInput.addEventListener("change", function () {
        if (!fileInput.files || fileInput.files.length === 0) {
            return;
        }

        const formData = new FormData();
        formData.append("resume", fileInput.files[0]);

        fetch("${pageContext.request.contextPath}/upload", {
            method: "POST",
            body: formData
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Upload failed");
                }
                return response.text();
            })
            .then(function (filename) {
                resumeField.value = filename;
                fileNameTarget.textContent = filename;
            })
            .catch(function () {
                fileNameTarget.textContent = "Upload failed. Please try again.";
            });
    });
});
</script>
</body>
</html>
