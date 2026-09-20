package com.jobtracker.dao;

import com.jobtracker.model.Reminder;
import com.jobtracker.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ReminderDAO {

    public List<Reminder> getLatestRemindersByUser(int userId, int limit) throws SQLException {
        String sql = "SELECT id, user_id, title, message, remind_at, urgency, is_read, created_at "
                + "FROM reminders WHERE user_id = ? ORDER BY remind_at ASC LIMIT ?";
        List<Reminder> reminders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, limit);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    reminders.add(mapRow(resultSet));
                }
            }
        }
        return reminders;
    }

    public List<Reminder> getAllRemindersByUser(int userId) throws SQLException {
        String sql = "SELECT id, user_id, title, message, remind_at, urgency, is_read, created_at "
                + "FROM reminders WHERE user_id = ? ORDER BY remind_at ASC";
        List<Reminder> reminders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    reminders.add(mapRow(resultSet));
                }
            }
        }
        return reminders;
    }

    public boolean addReminder(Reminder reminder) throws SQLException {
        String sql = "INSERT INTO reminders (user_id, title, message, remind_at, urgency, is_read) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, reminder.getUserId());
            preparedStatement.setString(2, reminder.getTitle());
            preparedStatement.setString(3, reminder.getMessage());
            preparedStatement.setTimestamp(4, reminder.getRemindAt());
            preparedStatement.setString(5, reminder.getUrgency());
            preparedStatement.setBoolean(6, reminder.isRead());
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean markAsRead(int reminderId, int userId, boolean isRead) throws SQLException {
        String sql = "UPDATE reminders SET is_read = ? WHERE id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setBoolean(1, isRead);
            preparedStatement.setInt(2, reminderId);
            preparedStatement.setInt(3, userId);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean deleteReminder(int reminderId, int userId) throws SQLException {
        String sql = "DELETE FROM reminders WHERE id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, reminderId);
            preparedStatement.setInt(2, userId);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public int countUnreadReminders(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reminders WHERE user_id = ? AND is_read = FALSE";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        }
        return 0;
    }

    private Reminder mapRow(ResultSet resultSet) throws SQLException {
        Reminder reminder = new Reminder();
        reminder.setId(resultSet.getInt("id"));
        reminder.setUserId(resultSet.getInt("user_id"));
        reminder.setTitle(resultSet.getString("title"));
        reminder.setMessage(resultSet.getString("message"));
        reminder.setRemindAt(resultSet.getTimestamp("remind_at"));
        reminder.setUrgency(resultSet.getString("urgency"));
        reminder.setRead(resultSet.getBoolean("is_read"));
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        reminder.setCreatedAt(createdAt);
        return reminder;
    }
}
