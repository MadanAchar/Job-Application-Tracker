package com.jobtracker.servlet;

import com.jobtracker.dao.UserDAO;
import com.jobtracker.model.User;
import com.jobtracker.util.PasswordUtil;
import com.jobtracker.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;


public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") instanceof User) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String password = request.getParameter("password");

        if (!ValidationUtil.isValidEmail(email) || !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("error", "Please enter a valid email and password.");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.findByEmail(email);
            if (user != null && PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
                HttpSession session = request.getSession(true);
                session.setAttribute("loggedInUser", user);
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        } catch (SQLException exception) {
            request.setAttribute("errorMessage", "Unable to process login right now. Please try again.");
            request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp").forward(request, response);
        }
    }
}
