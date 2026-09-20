package com.jobtracker.util;

public final class ValidationUtil {

    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";

    private ValidationUtil() {
    }

    public static boolean isValidEmail(String email) {
        return email != null && email.trim().matches(EMAIL_REGEX);
    }

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static boolean isValidCGPA(double cgpa) {
        return cgpa >= 0.0 && cgpa <= 10.0;
    }

    public static String sanitize(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("<", "").replace(">", "").trim();
    }
}
