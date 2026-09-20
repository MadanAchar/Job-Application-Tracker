package com.jobtracker.servlet;

import com.jobtracker.dao.ActivityDAO;
import com.jobtracker.dao.OpportunityDAO;
import com.jobtracker.model.Opportunity;
import com.jobtracker.model.User;
import com.jobtracker.util.ValidationUtil;
import com.jobtracker.dao.ApplicationDAO;

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


public class OpportunityServlet extends HttpServlet {

    private final OpportunityDAO opportunityDAO = new OpportunityDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final ActivityDAO activityDAO = new ActivityDAO();

   @Override
protected void doGet(HttpServletRequest request,
                     HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    User user = (User) session.getAttribute("loggedInUser");

    try {

        List<Opportunity> opportunities =
                opportunityDAO.getAllOpportunities();

        request.setAttribute("opportunities", opportunities);

        if (user != null &&
            !"admin".equalsIgnoreCase(user.getRole())) {

            request.setAttribute(
                    "appliedOpportunityIds",
                    applicationDAO.getAppliedOpportunityIds(user.getId()));
        }

        request.getRequestDispatcher("/WEB-INF/jsp/opportunities.jsp")
               .forward(request, response);

    } catch (SQLException exception) {

        request.setAttribute(
                "errorMessage",
                "Unable to load opportunities right now.");

        request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp")
               .forward(request, response);
    }
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");
        String action = ValidationUtil.sanitize(request.getParameter("action"));

        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            if ("add".equalsIgnoreCase(action)) {
                Opportunity opportunity = buildOpportunityFromRequest(request, user.getId(), 0);
                if (opportunityDAO.addOpportunity(opportunity)) {
                    activityDAO.logActivity(user.getId(), "Posted opportunity for " + opportunity.getCompany(), "opportunity", null);
                }
            } else if ("edit".equalsIgnoreCase(action)) {
                int opportunityId = Integer.parseInt(request.getParameter("id"));
                Opportunity opportunity = buildOpportunityFromRequest(request, user.getId(), opportunityId);
                if (opportunityDAO.updateOpportunity(opportunity)) {
                    activityDAO.logActivity(user.getId(), "Updated opportunity for " + opportunity.getCompany(), "opportunity", opportunityId);
                }
            } else if ("delete".equalsIgnoreCase(action)) {
                int opportunityId = Integer.parseInt(request.getParameter("id"));
                if (opportunityDAO.deleteOpportunity(opportunityId)) {
                    activityDAO.logActivity(user.getId(), "Deleted an opportunity entry", "opportunity", opportunityId);
                }
            }

            response.sendRedirect(request.getContextPath() + "/opportunities");
        } catch (SQLException | IllegalArgumentException exception) {
            request.setAttribute("errorMessage", "Unable to process the opportunity request right now. Please try again.");
            request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp").forward(request, response);
        }
    }

    private Opportunity buildOpportunityFromRequest(HttpServletRequest request, int postedBy, int opportunityId) {
        String company = ValidationUtil.sanitize(request.getParameter("company"));
        String role = ValidationUtil.sanitize(request.getParameter("role"));
        String location = ValidationUtil.sanitize(request.getParameter("location"));
        String description = ValidationUtil.sanitize(request.getParameter("description"));
        String skillsRequired = ValidationUtil.sanitize(request.getParameter("skillsRequired"));
        String deadlineValue = ValidationUtil.sanitize(request.getParameter("deadline"));
        String eligibility = ValidationUtil.sanitize(request.getParameter("eligibility"));
        String salary = ValidationUtil.sanitize(request.getParameter("salary"));

        if (!ValidationUtil.isNotEmpty(company) || !ValidationUtil.isNotEmpty(role) || !ValidationUtil.isNotEmpty(deadlineValue)) {
            throw new IllegalArgumentException("Required opportunity fields are missing.");
        }

        Opportunity opportunity = new Opportunity();
        opportunity.setId(opportunityId);
        opportunity.setCompany(company);
        opportunity.setRole(role);
        opportunity.setLocation(location);
        opportunity.setDescription(description);
        opportunity.setSkillsRequired(skillsRequired);
        opportunity.setDeadline(Date.valueOf(deadlineValue));
        opportunity.setEligibility(eligibility);
        opportunity.setSalary(salary);
        opportunity.setPostedBy(postedBy);
        return opportunity;
    }
}
