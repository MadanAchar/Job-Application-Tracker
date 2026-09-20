package com.jobtracker.servlet;

import com.jobtracker.dao.ActivityDAO;
import com.jobtracker.dao.ApplicationDAO;
import com.jobtracker.dao.OpportunityDAO;
import com.jobtracker.dao.UserDAO;
import com.jobtracker.model.Activity;
import com.jobtracker.model.Application;
import com.jobtracker.model.Opportunity;
import com.jobtracker.model.User;
import com.jobtracker.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final OpportunityDAO opportunityDAO = new OpportunityDAO();
    private final ActivityDAO activityDAO = new ActivityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tab = ValidationUtil.sanitize(request.getParameter("tab"));
        if (!ValidationUtil.isNotEmpty(tab)) {
            tab = "users";
        }

        try {
            List<User> users = userDAO.getAllUsers();
            List<Application> applications = applicationDAO.getAllApplications();
            List<Opportunity> opportunities = opportunityDAO.getAllOpportunities();
            List<Activity> activities = activityDAO.getAllActivities(50);

            request.setAttribute("activeTab", tab);
            request.setAttribute("users", users);
            request.setAttribute("applications", applications);
            request.setAttribute("opportunities", opportunities);
            request.setAttribute("activities", activities);
            request.getRequestDispatcher("/WEB-INF/jsp/admin.jsp").forward(request, response);
        } catch (SQLException exception) {
            request.setAttribute("errorMessage", "Unable to load admin data right now. Please try again.");
            request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User adminUser = (User) session.getAttribute("loggedInUser");
        String action = ValidationUtil.sanitize(request.getParameter("action"));
        String tab = ValidationUtil.sanitize(request.getParameter("tab"));

        try {
            if ("deleteUser".equalsIgnoreCase(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                if (userDAO.deleteUser(userId)) {
                    activityDAO.logActivity(adminUser.getId(), "Deleted user account #" + userId, "user", userId);
                }
            } else if ("toggleAdminRole".equalsIgnoreCase(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String currentRole = ValidationUtil.sanitize(request.getParameter("currentRole"));
                String updatedRole = "admin".equalsIgnoreCase(currentRole) ? "student" : "admin";
                if (userDAO.updateUserRole(userId, updatedRole)) {
                    activityDAO.logActivity(adminUser.getId(), "Changed role for user #" + userId + " to " + updatedRole, "user", userId);
                }
            } else if ("deleteOpportunity".equalsIgnoreCase(action)) {
                int opportunityId = Integer.parseInt(request.getParameter("opportunityId"));
                if (opportunityDAO.deleteOpportunity(opportunityId)) {
                    activityDAO.logActivity(adminUser.getId(), "Deleted opportunity #" + opportunityId, "opportunity", opportunityId);
                }
            }

            if (!ValidationUtil.isNotEmpty(tab)) {
                tab = "users";
            }
            response.sendRedirect(request.getContextPath() + "/admin?tab=" + tab);
        } catch (SQLException | NumberFormatException exception) {
            request.setAttribute("errorMessage", "Unable to process the admin request right now. Please try again.");
            request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp").forward(request, response);
        }
    }
}
