package com.jobtracker.servlet;

import com.jobtracker.dao.ActivityDAO;
import com.jobtracker.dao.UserDAO;
import com.jobtracker.model.User;
import com.jobtracker.util.PasswordUtil;
import com.jobtracker.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

import java.io.File;

@MultipartConfig
public class ProfileServlet extends HttpServlet {

private final UserDAO userDAO = new UserDAO();
private final ActivityDAO activityDAO = new ActivityDAO();

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    User user = (User) session.getAttribute("loggedInUser");

    try {
        User freshUser = userDAO.findById(user.getId());
        session.setAttribute("loggedInUser", freshUser);

        String servletPath = request.getServletPath();

        if ("/settings".equals(servletPath)) {
            request.getRequestDispatcher("/WEB-INF/jsp/settings.jsp")
                    .forward(request, response);
            return;
        }

        request.setAttribute("profileUser", freshUser);
        request.getRequestDispatcher("/WEB-INF/jsp/profile.jsp")
                .forward(request, response);

    } catch (SQLException exception) {
        request.setAttribute("errorMessage",
                "Unable to load the profile right now. Please try again.");
        request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp")
                .forward(request, response);
    }
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    User loggedInUser = (User) session.getAttribute("loggedInUser");

    String action = request.getParameter("action");

    try {

        if ("updateProfile".equalsIgnoreCase(action)) {

            User updatedUser = userDAO.findById(loggedInUser.getId());

            populateProfileFields(request, updatedUser);

            Part resumePart = request.getPart("resumeFile");

            if (resumePart != null && resumePart.getSize() > 0) {

                String fileName = new File(
                        resumePart.getSubmittedFileName())
                        .getName();

                String uploadPath = "E:\\javaproject\\uploads\\resumes";

                File uploadDir = new File(uploadPath);

                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                resumePart.write(uploadPath + File.separator + fileName);

                updatedUser.setResumeFilename(fileName);
            }

            Part profilePart = request.getPart("profileImage");

if (profilePart != null && profilePart.getSize() > 0) {

    String imageName = new File(
            profilePart.getSubmittedFileName())
            .getName();

    String imageUploadPath = "E:\\javaproject\\uploads\\profilePictures";

    File imageDir = new File(imageUploadPath);

    if (!imageDir.exists()) {
        imageDir.mkdirs();
    }

    profilePart.write(imageUploadPath + File.separator + imageName);

    updatedUser.setProfilePicture(imageName);
}

            if (userDAO.updateUser(updatedUser)) {

                session.setAttribute(
                        "loggedInUser",
                        userDAO.findById(updatedUser.getId())
                );

                activityDAO.logActivity(
                        updatedUser.getId(),
                        "Updated profile details",
                        "user",
                        updatedUser.getId()
                );
            }

            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        if ("changePassword".equalsIgnoreCase(action)) {

            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User freshUser = userDAO.findById(loggedInUser.getId());

            if (!PasswordUtil.verifyPassword(
                    currentPassword,
                    freshUser.getPasswordHash())) {

                request.setAttribute(
                        "error",
                        "Current password is incorrect."
                );

                request.getRequestDispatcher("/WEB-INF/jsp/settings.jsp")
                        .forward(request, response);
                return;
            }

            if (!ValidationUtil.isNotEmpty(newPassword)
                    || !newPassword.equals(confirmPassword)) {

                request.setAttribute(
                        "error",
                        "New password and confirm password must match."
                );

                request.getRequestDispatcher("/WEB-INF/jsp/settings.jsp")
                        .forward(request, response);
                return;
            }

            if (userDAO.updatePassword(
                    freshUser.getId(),
                    PasswordUtil.hashPassword(newPassword))) {

                activityDAO.logActivity(
                        freshUser.getId(),
                        "Changed account password",
                        "user",
                        freshUser.getId()
                );
            }

            response.sendRedirect(request.getContextPath() + "/settings");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/profile");

    } catch (SQLException exception) {

        request.setAttribute(
                "errorMessage",
                "Unable to save profile changes right now. Please try again."
        );

        request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp")
                .forward(request, response);
    }
}

private void populateProfileFields(HttpServletRequest request, User user) {

    user.setName(
            ValidationUtil.sanitize(request.getParameter("name"))
    );

    user.setEmail(
            ValidationUtil.sanitize(request.getParameter("email"))
    );

    user.setBranch(
            ValidationUtil.sanitize(request.getParameter("branch"))
    );

    user.setSkills(
            ValidationUtil.sanitize(request.getParameter("skills"))
    );

    user.setExperience(
            ValidationUtil.sanitize(request.getParameter("experience"))
    );

    user.setProjects(
            ValidationUtil.sanitize(request.getParameter("projects"))
    );

    user.setGithubUrl(
            ValidationUtil.sanitize(request.getParameter("githubUrl"))
    );

    user.setLinkedinUrl(
            ValidationUtil.sanitize(request.getParameter("linkedinUrl"))
    );

    user.setProfilePicture(
            ValidationUtil.sanitize(request.getParameter("profilePicture"))
    );

    String cgpaValue =
            ValidationUtil.sanitize(request.getParameter("cgpa"));

    if (ValidationUtil.isNotEmpty(cgpaValue)) {
        user.setCgpa(Double.parseDouble(cgpaValue));
    } else {
        user.setCgpa(null);
    }
}

}
