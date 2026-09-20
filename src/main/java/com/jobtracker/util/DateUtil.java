package com.jobtracker.util;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public final class DateUtil {

    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd MMM yyyy");
    private static final SimpleDateFormat DATE_TIME_FORMAT = new SimpleDateFormat("dd MMM yyyy hh:mm a");

    private DateUtil() {
    }

    public static String formatDate(Date date) {
        if (date == null) {
            return "";
        }
        return DATE_FORMAT.format(date);
    }

    public static String formatDateTime(Timestamp timestamp) {
        if (timestamp == null) {
            return "";
        }
        return DATE_TIME_FORMAT.format(timestamp);
    }

    public static boolean isOverdue(Date date) {
        return date != null && date.toLocalDate().isBefore(LocalDate.now());
    }

    public static long daysUntil(Date date) {
        if (date == null) {
            return 0;
        }
        return ChronoUnit.DAYS.between(LocalDate.now(), date.toLocalDate());
    }
}
