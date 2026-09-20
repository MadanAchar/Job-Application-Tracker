package com.jobtracker.servlet;

import com.jobtracker.util.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class UploadServlet extends HttpServlet {

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("resume");
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        if (filePart == null || filePart.getSize() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("No file uploaded.");
            return;
        }

        if (!FileUploadUtil.isPDF(filePart)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Only PDF files are allowed.");
            return;
        }

        if (!FileUploadUtil.isUnderSizeLimit(filePart, MAX_FILE_SIZE)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("File exceeds the 5 MB size limit.");
            return;
        }

        try {
            String uploadDirectory = request.getServletContext().getRealPath("/uploads");
            String savedFileName = FileUploadUtil.saveFile(filePart, uploadDirectory);
            response.getWriter().write(savedFileName);
        } catch (IOException exception) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Unable to upload file right now.");
        }
    }
}
