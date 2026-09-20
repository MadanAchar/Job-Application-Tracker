package com.jobtracker.servlet;

import com.jobtracker.dao.ApplicationDAO;
import com.jobtracker.dao.UserDAO;
import com.jobtracker.model.Application;
import com.jobtracker.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

public class ExportServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String type = request.getParameter("type");

        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter writer = response.getWriter()) {
            if ("users".equalsIgnoreCase(type) && "admin".equalsIgnoreCase(loggedInUser.getRole())) {
                response.setHeader("Content-Disposition", "attachment; filename=\"users.csv\"");
                writeUsersCsv(writer, userDAO.getAllUsers());
                return;
            }

            if ("applications".equalsIgnoreCase(type) && "admin".equalsIgnoreCase(loggedInUser.getRole())) {
                response.setHeader("Content-Disposition", "attachment; filename=\"applications.csv\"");
                writeApplicationsCsv(writer, applicationDAO.getAllApplications());
                return;
            }

            response.setHeader("Content-Disposition", "attachment; filename=\"my_applications.csv\"");
            writeApplicationsCsv(writer, applicationDAO.getAllApplicationsByUser(loggedInUser.getId()));
        } catch (SQLException exception) {
            response.reset();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/plain");
            response.getWriter().write("Unable to export data right now.");
        }
    }

    private void writeUsersCsv(PrintWriter writer, List<User> users) {
        writer.println("ID,Name,Email,Role,CGPA,Branch,Skills,Experience,Projects,GitHub,LinkedIn,Created At");
        for (User user : users) {
            writer.println(
                    user.getId() + ","
                            + escape(user.getName()) + ","
                            + escape(user.getEmail()) + ","
                            + escape(user.getRole()) + ","
                            + (user.getCgpa() == null ? "" : user.getCgpa()) + ","
                            + escape(user.getBranch()) + ","
                            + escape(user.getSkills()) + ","
                            + escape(user.getExperience()) + ","
                            + escape(user.getProjects()) + ","
                            + escape(user.getGithubUrl()) + ","
                            + escape(user.getLinkedinUrl()) + ","
                            + escape(String.valueOf(user.getCreatedAt()))
            );
        }
    }

    private void writeApplicationsCsv(PrintWriter writer, List<Application> applications) {
        writer.println("ID,User ID,Company,Role,Location,Application Date,Deadline,Status,Notes,Resume,Job Skills,Skill Match %,Created At");
        for (Application application : applications) {
            writer.println(
                    application.getId() + ","
                            + application.getUserId() + ","
                            + escape(application.getCompanyName()) + ","
                            + escape(application.getJobRole()) + ","
                            + escape(application.getLocation()) + ","
                            + escape(String.valueOf(application.getApplicationDate())) + ","
                            + escape(String.valueOf(application.getDeadline())) + ","
                            + escape(application.getStatus()) + ","
                            + escape(application.getNotes()) + ","
                            + escape(application.getResumeFilename()) + ","
                            + escape(application.getJobSkills()) + ","
                            + application.getSkillMatchPercent() + ","
                            + escape(String.valueOf(application.getCreatedAt()))
            );
        }
    }

    private String escape(String value) {
        if (value == null) {
            return "\"\"";
        }
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }
}
