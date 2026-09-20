package com.jobtracker.servlet;

import com.jobtracker.dao.AnalyticsDAO;
import com.jobtracker.dao.ApplicationDAO;
import com.jobtracker.model.Application;
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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


public class AnalyticsServlet extends HttpServlet {

    private final AnalyticsDAO analyticsDAO = new AnalyticsDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        try {
            Map<String, Integer> applicationsPerMonth = analyticsDAO.getApplicationsPerMonth(user.getId(), 12);
            Map<String, Integer> statusDistribution = analyticsDAO.getStatusDistribution(user.getId());
            Map<String, Integer> topCompanies = analyticsDAO.getTopCompanies(user.getId(), 5);
            Map<String, Integer> skillMatchBuckets = analyticsDAO.getSkillMatchBuckets(user.getId());
            List<Application> applications = applicationDAO.getAllApplicationsByUser(user.getId());
            int placementScore = PlacementScoreEngine.calculateScore(user, applications);

            request.setAttribute("applicationsPerMonth", applicationsPerMonth);
            request.setAttribute("statusDistribution", statusDistribution);
            request.setAttribute("topCompanies", topCompanies);
            request.setAttribute("skillMatchBuckets", skillMatchBuckets);
            request.setAttribute("placementReadinessTrend", buildPlacementReadinessTrend(placementScore));
            request.setAttribute("interviewOfferFunnel", buildInterviewOfferFunnel(applications));
            request.setAttribute("applicationWeekdayHeatmap", buildWeekdayHeatmap(applications));
            request.setAttribute("offerRatioTrend", buildOfferRatioTrend(applications));
            request.getRequestDispatcher("/WEB-INF/jsp/analytics.jsp").forward(request, response);
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

    private Map<String, Integer> buildPlacementReadinessTrend(int placementScore) {
        Map<String, Integer> trend = new LinkedHashMap<>();
        trend.put("Baseline", Math.max(placementScore - 18, 0));
        trend.put("Preparation", Math.max(placementScore - 10, 0));
        trend.put("Interviews", Math.max(placementScore - 5, 0));
        trend.put("Current", placementScore);
        return trend;
    }

    private Map<String, Integer> buildInterviewOfferFunnel(List<Application> applications) {
        int applied = 0;
        int interviews = 0;
        int offers = 0;
        int joined = 0;

        for (Application application : applications) {
            applied++;
            if ("Interview".equalsIgnoreCase(application.getStatus())) {
                interviews++;
            }
            if ("Offer".equalsIgnoreCase(application.getStatus())) {
                offers++;
            }
            if ("Joined".equalsIgnoreCase(application.getStatus())) {
                joined++;
            }
        }

        Map<String, Integer> funnel = new LinkedHashMap<>();
        funnel.put("Applied", applied);
        funnel.put("Interview", interviews);
        funnel.put("Offer", offers);
        funnel.put("Joined", joined);
        return funnel;
    }

    private Map<String, Integer> buildWeekdayHeatmap(List<Application> applications) {
        Map<String, Integer> heatmap = new LinkedHashMap<>();
        heatmap.put("Monday", 0);
        heatmap.put("Tuesday", 0);
        heatmap.put("Wednesday", 0);
        heatmap.put("Thursday", 0);
        heatmap.put("Friday", 0);
        heatmap.put("Saturday", 0);
        heatmap.put("Sunday", 0);

        for (Application application : applications) {
            if (application.getApplicationDate() != null) {
                String day = application.getApplicationDate().toLocalDate().getDayOfWeek().name();
                String label = day.substring(0, 1) + day.substring(1).toLowerCase();
                heatmap.put(label, heatmap.getOrDefault(label, 0) + 1);
            }
        }
        return heatmap;
    }

    private Map<String, Double> buildOfferRatioTrend(List<Application> applications) {
        int total = applications.size();
        int offers = 0;
        int joined = 0;

        for (Application application : applications) {
            if ("Offer".equalsIgnoreCase(application.getStatus())) {
                offers++;
            }
            if ("Joined".equalsIgnoreCase(application.getStatus())) {
                joined++;
            }
        }

        double offerRatio = total == 0 ? 0.0 : (offers * 100.0) / total;
        double joinRatio = total == 0 ? 0.0 : (joined * 100.0) / total;

        Map<String, Double> ratios = new LinkedHashMap<>();
        ratios.put("Offers", offerRatio);
        ratios.put("Joined", joinRatio);
        return ratios;
    }
}
