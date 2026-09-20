package com.jobtracker.servlet;

import com.jobtracker.dao.OpportunityDAO;
import com.jobtracker.model.Opportunity;
import com.jobtracker.dao.ActivityDAO;
import com.jobtracker.dao.ApplicationDAO;
import com.jobtracker.model.Application;
import com.jobtracker.model.User;
import com.jobtracker.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;


public class ApplicationServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final OpportunityDAO opportunityDAO = new OpportunityDAO();
    private final ActivityDAO activityDAO = new ActivityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        String status = ValidationUtil.sanitize(request.getParameter("status"));
        String search = ValidationUtil.sanitize(request.getParameter("search"));
        String sort = ValidationUtil.sanitize(request.getParameter("sort"));
        String formId = ValidationUtil.sanitize(request.getParameter("id"));
        String action = ValidationUtil.sanitize(request.getParameter("action"));

        if ("add".equalsIgnoreCase(action)) {
            request.getRequestDispatcher("/WEB-INF/jsp/applicationForm.jsp")
                .forward(request, response);
            return;
        }
        int page = parsePage(request.getParameter("page"));
        int offset = (page - 1) * PAGE_SIZE;

        try {
           if (ValidationUtil.isNotEmpty(formId)) {

    Application application =
            applicationDAO.getApplicationById(
                    Integer.parseInt(formId));

    request.setAttribute("application", application);

    if ("admin".equalsIgnoreCase(user.getRole())) {

        request.getRequestDispatcher("/WEB-INF/jsp/reviewApplication.jsp")
                .forward(request, response);

    } else {

        response.sendRedirect(
                request.getContextPath() + "/applications");

    }

    return;
}

            List<Application> applications;
int totalRecords;
int totalPages;

if ("admin".equalsIgnoreCase(user.getRole())) {

    applications = applicationDAO.getAllApplications();
    totalRecords = applications.size();
    totalPages = 1;

} else {

    applications = applicationDAO.getApplicationsByUser(
            user.getId(),
            status,
            search,
            sort,
            offset,
            PAGE_SIZE
    );

    totalRecords = applicationDAO.countApplicationsByUser(
            user.getId(),
            status,
            search
    );

    totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
}

            request.setAttribute("applications", applications);
            request.setAttribute("isAdmin", "admin".equalsIgnoreCase(user.getRole()));
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", PAGE_SIZE);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("selectedStatus", status);
            request.setAttribute("searchTerm", search);
            request.setAttribute("selectedSort", sort);
            request.getRequestDispatcher("/WEB-INF/jsp/applications.jsp").forward(request, response);
        } catch(Exception exception) {

    exception.printStackTrace();

    throw new ServletException(exception);

}
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");
        String action = ValidationUtil.sanitize(request.getParameter("action"));

        try {
            if ("apply".equalsIgnoreCase(action)) {

    int opportunityId = Integer.parseInt(request.getParameter("opportunityId"));

    Opportunity opportunity = opportunityDAO.getOpportunityById(opportunityId);

    if (opportunity != null &&
        !applicationDAO.hasApplied(
                user.getId(),
                opportunity.getCompany(),
                opportunity.getRole())) {

        Application application = new Application();

        application.setUserId(user.getId());
        application.setCompanyName(opportunity.getCompany());
        application.setJobRole(opportunity.getRole());
        application.setLocation(opportunity.getLocation());

        application.setApplicationDate(
                new Date(System.currentTimeMillis()));

        application.setDeadline(opportunity.getDeadline());

        application.setStatus("Pending");

        application.setNotes("");

        application.setResumeFilename(
                user.getResumeFilename());

        application.setJobSkills(
                opportunity.getSkillsRequired());

        application.setSkillMatchPercent(0);

        applicationDAO.quickApply(application);

        activityDAO.logActivity(
                user.getId(),
                "Applied for " +
                        opportunity.getCompany() +
                        " - " +
                        opportunity.getRole(),
                "application",
                null
        );

    }

    response.sendRedirect(
            request.getContextPath() +
                    "/opportunities");

    return;

}
     
     if ("review".equalsIgnoreCase(action)) {

    if (!"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/applications");
        return;
    }

    int applicationId =
            Integer.parseInt(request.getParameter("id"));

    String status =
            ValidationUtil.sanitize(request.getParameter("status"));

    String notes =
            ValidationUtil.sanitize(request.getParameter("notes"));

    int skillMatchPercent = 0;

    String skill =
            ValidationUtil.sanitize(request.getParameter("skillMatchPercent"));

    if (ValidationUtil.isNotEmpty(skill)) {
        skillMatchPercent = Integer.parseInt(skill);
    }

    boolean updated = applicationDAO.updateReview(
        applicationId,
        status,
        notes,
        skillMatchPercent);

System.out.println("===== REVIEW UPDATE =====");
System.out.println("Application ID : " + applicationId);
System.out.println("Status         : " + status);
System.out.println("Updated?       : " + updated);

if (updated) {
    activityDAO.logActivity(
            user.getId(),
            "Reviewed application #" + applicationId,
            "application",
            applicationId);
}

    response.sendRedirect(request.getContextPath() + "/applications");
    return;
}

            if ("add".equalsIgnoreCase(action)) {
                Application application = buildApplicationFromRequest(request, user.getId(), 0);
                if (applicationDAO.addApplication(application)) {
                    activityDAO.logActivity(
                            user.getId(),
                            "Added application for " + application.getCompanyName() + " - " + application.getJobRole(),
                            "application",
                            null
                    );
                }
            } else if ("edit".equalsIgnoreCase(action)) {
                int applicationId = Integer.parseInt(request.getParameter("id"));
                Application application = buildApplicationFromRequest(request, user.getId(), applicationId);
                if (applicationDAO.updateApplication(application)) {
                    activityDAO.logActivity(
                            user.getId(),
                            "Updated application for " + application.getCompanyName() + " - " + application.getJobRole(),
                            "application",
                            applicationId
                    );
                }
            } else if ("delete".equalsIgnoreCase(action)) {
                int applicationId = Integer.parseInt(request.getParameter("id"));
                if (applicationDAO.deleteApplication(applicationId, user.getId())) {
                    activityDAO.logActivity(
                            user.getId(),
                            "Deleted an application entry",
                            "application",
                            applicationId
                    );
                }
            }

            response.sendRedirect(request.getContextPath() + "/applications");
        } catch (SQLException exception) {

    exception.printStackTrace();

    request.setAttribute(
            "errorMessage",
            exception.getMessage()
    );

    request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp")
            .forward(request, response);
}
    }

    private Application buildApplicationFromRequest(HttpServletRequest request, int userId, int applicationId) {
        String companyName = ValidationUtil.sanitize(request.getParameter("companyName"));
        String jobRole = ValidationUtil.sanitize(request.getParameter("jobRole"));
        String location = ValidationUtil.sanitize(request.getParameter("location"));
        String applicationDateValue = ValidationUtil.sanitize(request.getParameter("applicationDate"));
        String deadlineValue = ValidationUtil.sanitize(request.getParameter("deadline"));
        String status = ValidationUtil.sanitize(request.getParameter("status"));
        String notes = ValidationUtil.sanitize(request.getParameter("notes"));
        String resumeFilename = ValidationUtil.sanitize(request.getParameter("resumeFilename"));
        String jobSkills = ValidationUtil.sanitize(request.getParameter("jobSkills"));
        String skillMatchPercentValue = ValidationUtil.sanitize(request.getParameter("skillMatchPercent"));

        if (!ValidationUtil.isNotEmpty(companyName)
                || !ValidationUtil.isNotEmpty(jobRole)
                || !ValidationUtil.isNotEmpty(applicationDateValue)
                || !ValidationUtil.isNotEmpty(status)) {
            throw new IllegalArgumentException("Required application fields are missing.");
        }

        Application application = new Application();
        application.setId(applicationId);
        application.setUserId(userId);
        application.setCompanyName(companyName);
        application.setJobRole(jobRole);
        application.setLocation(location);
        application.setApplicationDate(Date.valueOf(applicationDateValue));
        application.setDeadline(ValidationUtil.isNotEmpty(deadlineValue) ? Date.valueOf(deadlineValue) : null);
        application.setStatus(status);
        application.setNotes(notes);
        application.setResumeFilename(resumeFilename);
        application.setJobSkills(jobSkills);
        application.setSkillMatchPercent(parseInteger(skillMatchPercentValue));
        return application;
    }

    private int parsePage(String pageValue) {
        try {
            int page = Integer.parseInt(pageValue);
            return Math.max(page, 1);
        } catch (NumberFormatException exception) {
            return 1;
        }
    }

    private int parseInteger(String value) {
        if (!ValidationUtil.isNotEmpty(value)) {
            return 0;
        }
        return Integer.parseInt(value);
    }
}
