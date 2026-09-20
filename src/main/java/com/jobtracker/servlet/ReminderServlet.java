package com.jobtracker.servlet;

import com.jobtracker.dao.ActivityDAO;
import com.jobtracker.dao.ReminderDAO;
import com.jobtracker.model.Reminder;
import com.jobtracker.model.User;
import com.jobtracker.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;


public class ReminderServlet extends HttpServlet {

    private final ReminderDAO reminderDAO = new ReminderDAO();
    private final ActivityDAO activityDAO = new ActivityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        try {
            List<Reminder> reminders = reminderDAO.getAllRemindersByUser(user.getId());
            request.setAttribute("reminders", reminders);
            request.getRequestDispatcher("/WEB-INF/jsp/reminders.jsp").forward(request, response);
        }catch (SQLException exception) {

    exception.printStackTrace();

    request.setAttribute(
            "errorMessage",
            exception.getMessage()
    );

    request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp")
            .forward(request, response);
}
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");
        String action = ValidationUtil.sanitize(request.getParameter("action"));

        try {
            if ("add".equalsIgnoreCase(action)) {
                Reminder reminder = buildReminderFromRequest(request, user.getId());
                if (reminderDAO.addReminder(reminder)) {
                    activityDAO.logActivity(user.getId(), "Created reminder: " + reminder.getTitle(), "reminder", null);
                }
            } else if ("markRead".equalsIgnoreCase(action)) {
                int reminderId = Integer.parseInt(request.getParameter("id"));
                boolean isRead = Boolean.parseBoolean(request.getParameter("isRead"));
                if (reminderDAO.markAsRead(reminderId, user.getId(), isRead)) {
                    activityDAO.logActivity(user.getId(), "Updated reminder read status", "reminder", reminderId);
                }
            } else if ("delete".equalsIgnoreCase(action)) {
                int reminderId = Integer.parseInt(request.getParameter("id"));
                if (reminderDAO.deleteReminder(reminderId, user.getId())) {
                    activityDAO.logActivity(user.getId(), "Deleted a reminder", "reminder", reminderId);
                }
            }

            response.sendRedirect(request.getContextPath() + "/reminders");
        } catch (SQLException | IllegalArgumentException exception) {
            request.setAttribute("errorMessage", "Unable to process the reminder request right now. Please try again.");
            request.getRequestDispatcher("/WEB-INF/jsp/error500.jsp").forward(request, response);
        }
    }

    private Reminder buildReminderFromRequest(HttpServletRequest request, int userId) {
        String title = ValidationUtil.sanitize(request.getParameter("title"));
        String message = ValidationUtil.sanitize(request.getParameter("message"));
        String remindAtValue = ValidationUtil.sanitize(request.getParameter("remindAt"));
        String urgency = ValidationUtil.sanitize(request.getParameter("urgency"));

        if (!ValidationUtil.isNotEmpty(title) || !ValidationUtil.isNotEmpty(remindAtValue) || !ValidationUtil.isNotEmpty(urgency)) {
            throw new IllegalArgumentException("Required reminder fields are missing.");
        }

        Reminder reminder = new Reminder();
        reminder.setUserId(userId);
        reminder.setTitle(title);
        reminder.setMessage(message);
        reminder.setRemindAt(Timestamp.valueOf(remindAtValue.replace("T", " ") + ":00"));
        reminder.setUrgency(urgency);
        reminder.setRead(false);
        return reminder;
    }
}
