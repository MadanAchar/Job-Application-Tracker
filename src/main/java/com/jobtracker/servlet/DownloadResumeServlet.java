package com.jobtracker.servlet;

import com.jobtracker.dao.UserDAO;
import com.jobtracker.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.SQLException;

@WebServlet("/resume")
public class DownloadResumeServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));

            User user = userDAO.findById(userId);

            if (user == null || user.getResumeFilename() == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String uploadPath = "E:\\javaproject\\uploads\\resumes";
            File file = new File(uploadPath, user.getResumeFilename());

            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            response.setContentType(getServletContext().getMimeType(file.getName()));
            response.setHeader(
                    "Content-Disposition",
                    "inline; filename=\"" + file.getName() + "\""
            );

            try (
                    FileInputStream inputStream = new FileInputStream(file);
                    OutputStream outputStream = response.getOutputStream()
            ) {

                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }

        } catch (SQLException | NumberFormatException exception) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}