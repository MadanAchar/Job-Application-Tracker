package com.jobtracker.util;

import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

public final class FileUploadUtil {

    private FileUploadUtil() {
    }

    public static String saveFile(Part filePart, String uploadDir) throws IOException {
        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extension = "";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex >= 0) {
            extension = originalFileName.substring(dotIndex);
        }

        String savedFileName = UUID.randomUUID() + extension.toLowerCase();
        File directory = new File(uploadDir);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        filePart.write(new File(directory, savedFileName).getAbsolutePath());
        return savedFileName;
    }

    public static boolean isPDF(Part filePart) {
        String submittedFileName = filePart.getSubmittedFileName();
        String contentType = filePart.getContentType();
        return submittedFileName != null
                && submittedFileName.toLowerCase().endsWith(".pdf")
                && contentType != null
                && (contentType.equalsIgnoreCase("application/pdf")
                || contentType.equalsIgnoreCase("application/x-pdf"));
    }

    public static boolean isUnderSizeLimit(Part filePart, long maxBytes) {
        return filePart != null && filePart.getSize() <= maxBytes;
    }
}
