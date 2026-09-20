package com.jobtracker.dao;

import com.jobtracker.model.Activity;
import com.jobtracker.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ActivityDAO {

    public boolean logActivity(int userId, String action, String entityType, Integer entityId) throws SQLException {
        String sql = "INSERT INTO activity_logs (user_id, action, entity_type, entity_id) VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, action);
            preparedStatement.setString(3, entityType);
            if (entityId == null) {
                preparedStatement.setNull(4, java.sql.Types.INTEGER);
            } else {
                preparedStatement.setInt(4, entityId);
            }
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public List<Activity> getRecentActivitiesByUser(int userId, int limit) throws SQLException {
        String sql = "SELECT id, user_id, action, entity_type, entity_id, performed_at "
                + "FROM activity_logs WHERE user_id = ? ORDER BY performed_at DESC LIMIT ?";
        List<Activity> activities = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, limit);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    activities.add(mapRow(resultSet));
                }
            }
        }
        return activities;
    }

    public List<Activity> getAllActivities(int limit) throws SQLException {
        String sql = "SELECT id, user_id, action, entity_type, entity_id, performed_at "
                + "FROM activity_logs ORDER BY performed_at DESC LIMIT ?";
        List<Activity> activities = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, limit);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    activities.add(mapRow(resultSet));
                }
            }
        }
        return activities;
    }

    public int countActivities() throws SQLException {
        String sql = "SELECT COUNT(*) FROM activity_logs";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        }
        return 0;
    }

    private Activity mapRow(ResultSet resultSet) throws SQLException {
        Activity activity = new Activity();
        activity.setId(resultSet.getInt("id"));
        activity.setUserId(resultSet.getInt("user_id"));
        activity.setAction(resultSet.getString("action"));
        activity.setEntityType(resultSet.getString("entity_type"));
        int entityId = resultSet.getInt("entity_id");
        if (resultSet.wasNull()) {
            activity.setEntityId(null);
        } else {
            activity.setEntityId(entityId);
        }
        Timestamp performedAt = resultSet.getTimestamp("performed_at");
        activity.setPerformedAt(performedAt);
        return activity;
    }
}
