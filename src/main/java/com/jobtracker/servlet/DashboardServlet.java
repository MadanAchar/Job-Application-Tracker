package com.jobtracker.servlet;

import com.jobtracker.dao.ActivityDAO;
import com.jobtracker.dao.AnalyticsDAO;
import com.jobtracker.dao.ApplicationDAO;
import com.jobtracker.dao.OpportunityDAO;
import com.jobtracker.dao.ReminderDAO;
import com.jobtracker.model.Activity;
import com.jobtracker.model.Application;
import com.jobtracker.model.Opportunity;
import com.jobtracker.model.Reminder;
import com.jobtracker.model.User;
import com.jobtracker.util.PlacementScoreEngine;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public class DashboardServlet extends HttpServlet {

    private final AnalyticsDAO analyticsDAO = new AnalyticsDAO();
    private final ReminderDAO reminderDAO = new ReminderDAO();
    private final OpportunityDAO opportunityDAO = new OpportunityDAO();
    private final ActivityDAO activityDAO = new ActivityDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
protected void doGet(HttpServletRequest request,
                     HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    User user = (User) session.getAttribute("loggedInUser");

    try {

        if ("admin".equalsIgnoreCase(user.getRole())) {

    request.setAttribute(
            "totalApplications",
            applicationDAO.countAllApplications());

    request.setAttribute(
            "totalOpportunities",
            opportunityDAO.countOpportunities());

    request.setAttribute(
            "pendingCount",
            applicationDAO.countByStatus("Pending"));

    request.setAttribute(
            "shortlistedCount",
            applicationDAO.countByStatus("Shortlisted"));

    request.setAttribute(
            "interviewCount",
            applicationDAO.countByStatus("Interview"));

    request.setAttribute(
            "selectedCount",
            applicationDAO.countByStatus("Selected"));

    request.setAttribute(
            "rejectedCount",
            applicationDAO.countByStatus("Rejected"));

    request.setAttribute(
            "recentApplications",
            applicationDAO.getRecentApplications(8));

    request.setAttribute(
            "activities",
            activityDAO.getAllActivities(8));

    request.setAttribute(
            "applicationsPerMonth",
            analyticsDAO.getApplicationsPerMonth());

    request.setAttribute(
            "statusDistribution",
            analyticsDAO.getOverallStatusDistribution());

    request.getRequestDispatcher(
            "/WEB-INF/jsp/adminDashboard.jsp")
            .forward(request, response);

    return;
}
        Map<String, Integer> counts =
                analyticsDAO.getDashboardCounts(user.getId());

        List<Reminder> reminders =
                reminderDAO.getLatestRemindersByUser(user.getId(), 5);

        List<Opportunity> opportunities =
                opportunityDAO.getLatestOpportunities(3);

        List<Activity> activities =
                activityDAO.getRecentActivitiesByUser(user.getId(), 8);

        List<Application> applications =
                applicationDAO.getAllApplicationsByUser(user.getId());

        int placementScore =
                PlacementScoreEngine.calculateScore(user, applications);

        List<String> placementSuggestions =
                PlacementScoreEngine.getSuggestions(user, applications);

        Map<String, Integer> applicationsPerMonth =
                analyticsDAO.getApplicationsPerMonth(user.getId(), 6);

        Map<String, Integer> statusDistribution =
                analyticsDAO.getStatusDistribution(user.getId());

        request.setAttribute("counts", counts);
        request.setAttribute("reminders", reminders);
        request.setAttribute("opportunities", opportunities);
        request.setAttribute("activities", activities);
        request.setAttribute("placementScore", placementScore);
        request.setAttribute("placementSuggestions", placementSuggestions);
        request.setAttribute("applicationsPerMonth", applicationsPerMonth);
        request.setAttribute("statusDistribution", statusDistribution);

        request.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp")
                .forward(request, response);

    } catch (SQLException exception) {

        request.setAttribute(
                "errorMessage",
                "Unable to load the dashboard right now.");

        request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp")
                .forward(request, response);
    }
}
}
