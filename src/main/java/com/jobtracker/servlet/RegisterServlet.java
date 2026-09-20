package com.jobtracker.servlet;

import com.jobtracker.dao.UserDAO;
import com.jobtracker.model.User;
import com.jobtracker.util.PasswordUtil;
import com.jobtracker.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = ValidationUtil.sanitize(request.getParameter("name"));
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String branch = ValidationUtil.sanitize(request.getParameter("branch"));
        String cgpaValue = ValidationUtil.sanitize(request.getParameter("cgpa"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!ValidationUtil.isNotEmpty(name)
                || !ValidationUtil.isValidEmail(email)
                || !ValidationUtil.isNotEmpty(branch)
                || !ValidationUtil.isNotEmpty(password)
                || !ValidationUtil.isNotEmpty(confirmPassword)) {

            request.setAttribute("error",
                    "All required fields must be filled correctly.");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
                    .forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error",
                    "Password and confirm password do not match.");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
                    .forward(request, response);
            return;
        }

        Double cgpa = null;

        if (ValidationUtil.isNotEmpty(cgpaValue)) {
            try {
                cgpa = Double.parseDouble(cgpaValue);
            } catch (NumberFormatException exception) {
                request.setAttribute("error",
                        "CGPA must be a valid numeric value.");
                request.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
                        .forward(request, response);
                return;
            }

            if (!ValidationUtil.isValidCGPA(cgpa)) {
                request.setAttribute("error",
                        "CGPA must be between 0.0 and 10.0.");
                request.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
                        .forward(request, response);
                return;
            }
        }

        try {

            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error",
                        "An account with this email already exists.");
                request.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
                        .forward(request, response);
                return;
            }

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setBranch(branch);
            user.setCgpa(cgpa);
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            user.setRole("student");
            user.setSkills("");
            user.setExperience("");
            user.setProjects("");
            user.setGithubUrl("");
            user.setLinkedinUrl("");
            user.setProfilePicture("");

            boolean inserted = userDAO.insertUser(user);

            if (inserted) {
                response.sendRedirect(request.getContextPath() + "/login?success=1");
            } else {
                request.setAttribute("error",
                        "Registration could not be completed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/jsp/register.jsp")
                        .forward(request, response);
            }

        } catch (SQLException exception) {
            exception.printStackTrace();
            throw new ServletException(exception);
        }
    }
}