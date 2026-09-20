<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1280">
    <title>Opportunities | JobTrack</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/opportunities"><i class="fa-solid fa-sparkles"></i><span class="nav-link-label">Opportunities</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-briefcase"></i><span class="nav-link-label">Applications</span></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/analytics"><i class="fa-solid fa-chart-pie"></i><span class="nav-link-label">Analytics</span></a>
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
        <div class="topbar-title">Opportunities</div>
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
        <h1 class="page-title">Open Opportunities</h1>
        <p class="page-subtitle">
            A curated view of placement openings with quick visibility into deadlines, salary, and eligibility.
        </p>
    </div>

    <c:if test="${sessionScope.loggedInUser.role eq 'admin'}">
        <button type="button"
                class="button button-primary"
                onclick="document.getElementById('addOpportunityModal').style.display='flex'">
            <i class="fa-solid fa-plus"></i> Add Opportunity
        </button>
    </c:if>

</div>

            <div style="display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 24px;">
                <c:forEach var="opportunity" items="${opportunities}">
                    <article class="opportunity-card">
                        <div class="opportunity-title">${opportunity.company}</div>
                        <div class="opportunity-meta">${opportunity.role} • ${opportunity.location}</div>
                        <div class="opportunity-description">${opportunity.description}</div>
                        <div class="opportunity-tags">
                            <c:forEach var="skill" items="${fn:split(opportunity.skillsRequired, ',')}">
                                <span class="opportunity-tag">${fn:trim(skill)}</span>
                            </c:forEach>
                        </div>
                        <div style="display: grid; gap: 6px; color: var(--text-secondary); margin-bottom: 18px;">
                            <div>Deadline: <span style="color: ${fn:length(opportunity.deadline.toString()) gt 0 ? 'var(--danger)' : 'var(--text-primary)'};">${opportunity.deadline}</span></div>
                            <div>Salary: ${opportunity.salary}</div>
                            <div>Eligibility: ${opportunity.eligibility}</div>
                        </div>
                        <div class="opportunity-footer">

    <c:if test="${sessionScope.loggedInUser.role ne 'admin'}">

    <c:choose>

        <c:when test="${appliedOpportunityIds.contains(opportunity.id)}">

            <button class="button button-secondary"
                    disabled>

                ✓ Applied

            </button>

        </c:when>

        <c:otherwise>

            <form method="post"
                  action="${pageContext.request.contextPath}/applications"
                  style="margin:0;">

                <input type="hidden"
                       name="action"
                       value="apply">

                <input type="hidden"
                       name="opportunityId"
                       value="${opportunity.id}">

                <button type="submit"
                        class="button button-primary">

                    Apply

                </button>

            </form>

        </c:otherwise>

    </c:choose>

</c:if>
    <c:if test="${sessionScope.loggedInUser.role eq 'admin'}">
        <div class="table-actions">
            <button
    type="button"
    class="action-button edit"

    data-id="${opportunity.id}"
    data-company="${opportunity.company}"
    data-role="${opportunity.role}"
    data-location="${opportunity.location}"
    data-description="${opportunity.description}"
    data-skills="${opportunity.skillsRequired}"
    data-deadline="${opportunity.deadline}"
    data-eligibility="${opportunity.eligibility}"
    data-salary="${opportunity.salary}"

    onclick="openEditModal(this)">

    <i class="fa-regular fa-pen-to-square"></i>

</button>

            <form method="post"
      action="${pageContext.request.contextPath}/opportunities"
      style="display:inline;">

    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="id" value="${opportunity.id}">

    <button type="submit"
            class="action-button delete"
            onclick="return confirm('Delete this opportunity?');">

        <i class="fa-regular fa-trash-can"></i>

    </button>

</form>
        </div>
    </c:if>

</div>
                    </article>
                </c:forEach>
            </div>
        </div>
    </main>
</div>

<c:if test="${sessionScope.loggedInUser.role eq 'admin'}">

<div id="addOpportunityModal"
     style="display:none;
            position:fixed;
            top:0;
            left:0;
            width:100%;
            height:100%;
            background:rgba(0,0,0,0.55);
            justify-content:center;
            align-items:center;
            z-index:9999;">

    <div style="background:#fff;
                width:700px;
                max-width:90%;
                padding:30px;
                border-radius:12px;
                box-shadow:0 10px 30px rgba(0,0,0,.2);">

        <h2 style="margin-bottom:20px;">Add Opportunity</h2>

        <form action="${pageContext.request.contextPath}/opportunities"
              method="post">

            <input type="hidden" name="action" value="add">

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:15px;">

                <div>
                    <label>Company</label>
                    <input class="form-control" type="text" name="company" required>
                </div>

                <div>
                    <label>Role</label>
                    <input class="form-control" type="text" name="role" required>
                </div>

                <div>
                    <label>Location</label>
                    <input class="form-control" type="text" name="location">
                </div>

                <div>
                    <label>Deadline</label>
                    <input class="form-control" type="date" name="deadline" required>
                </div>

                <div>
                    <label>Salary</label>
                    <input class="form-control" type="text" name="salary">
                </div>

                <div>
                    <label>Eligibility</label>
                    <input class="form-control" type="text" name="eligibility">
                </div>

            </div>

            <div style="margin-top:15px;">

                <label>Skills Required</label>

                <input class="form-control"
                       type="text"
                       name="skillsRequired">

            </div>

            <div style="margin-top:15px;">

                <label>Description</label>

                <textarea class="form-control"
                          name="description"
                          rows="5"></textarea>

            </div>

            <div style="margin-top:25px;
                        display:flex;
                        justify-content:flex-end;
                        gap:10px;">

                <button type="button"
                        class="button"
                        onclick="document.getElementById('addOpportunityModal').style.display='none'">
                    Cancel
                </button>

                <button type="submit"
                        class="button button-primary">
                    Add Opportunity
                </button>

            </div>

        </form>

    </div>

</div>

</c:if>

<c:if test="${sessionScope.loggedInUser.role eq 'admin'}">

<div id="editOpportunityModal"
     style="display:none;
            position:fixed;
            inset:0;
            background:rgba(0,0,0,.55);
            justify-content:center;
            align-items:center;
            z-index:9999;">

    <div style="background:#fff;
                width:700px;
                padding:30px;
                border-radius:12px;">

        <h2>Edit Opportunity</h2>

        <form method="post"
              action="${pageContext.request.contextPath}/opportunities">

            <input type="hidden" name="action" value="edit">

            <input type="hidden"
                   id="editId"
                   name="id">

            <input id="editCompany"
                   type="text"
                   name="company"
                   required>

            <br><br>

            <input id="editRole"
                   type="text"
                   name="role"
                   required>

            <br><br>

            <input id="editLocation"
                   type="text"
                   name="location">

            <br><br>

            <textarea id="editDescription"
                      name="description"
                      rows="5"></textarea>

            <br><br>

            <input id="editSkills"
                   type="text"
                   name="skillsRequired">

            <br><br>

            <input id="editDeadline"
                   type="date"
                   name="deadline"
                   required>

            <br><br>

            <input id="editEligibility"
                   type="text"
                   name="eligibility">

            <br><br>

            <input id="editSalary"
                   type="text"
                   name="salary">

            <br><br>

            <button type="button"
                    onclick="document.getElementById('editOpportunityModal').style.display='none'">
                Cancel
            </button>

            <button type="submit">
                Save Changes
            </button>

        </form>

    </div>

</div>

</c:if>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/animations.js"></script>
<script>

function openEditModal(button){

    document.getElementById("editId").value=button.dataset.id;
    document.getElementById("editCompany").value=button.dataset.company;
    document.getElementById("editRole").value=button.dataset.role;
    document.getElementById("editLocation").value=button.dataset.location;
    document.getElementById("editDescription").value=button.dataset.description;
    document.getElementById("editSkills").value=button.dataset.skills;
    document.getElementById("editDeadline").value=button.dataset.deadline;
    document.getElementById("editEligibility").value=button.dataset.eligibility;
    document.getElementById("editSalary").value=button.dataset.salary;

    document.getElementById("editOpportunityModal").style.display="flex";

}

</script>
</body>
</html>
