package com.jobtracker.dao;

import com.jobtracker.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

public class AnalyticsDAO {

    public Map<String, Integer> getDashboardCounts(int userId) throws SQLException {
        Map<String, Integer> counts = new LinkedHashMap<>();
        counts.put("total", getCountByQuery("SELECT COUNT(*) FROM applications WHERE user_id = ?", userId));
        counts.put("active", getCountByQuery(
                "SELECT COUNT(*) FROM applications WHERE user_id = ? AND status IN ('Applied', 'Interview', 'Selected')",
                userId
        ));
        counts.put("interviews", getCountByQuery(
                "SELECT COUNT(*) FROM applications WHERE user_id = ? AND status = 'Interview'",
                userId
        ));
        counts.put("offers", getCountByQuery(
                "SELECT COUNT(*) FROM applications WHERE user_id = ? AND status = 'Offer'",
                userId
        ));
        counts.put("rejections", getCountByQuery(
                "SELECT COUNT(*) FROM applications WHERE user_id = ? AND status = 'Rejected'",
                userId
        ));
        return counts;
    }

    public Map<String, Integer> getApplicationsPerMonth(int userId, int limit) throws SQLException {
        String sql = "SELECT DATE_FORMAT(application_date, '%b %Y') AS label, COUNT(*) AS total "
                + "FROM applications WHERE user_id = ? "
                + "GROUP BY YEAR(application_date), MONTH(application_date), DATE_FORMAT(application_date, '%b %Y') "
                + "ORDER BY YEAR(application_date) DESC, MONTH(application_date) DESC LIMIT ?";
        Map<String, Integer> result = new LinkedHashMap<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, limit);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    result.put(resultSet.getString("label"), resultSet.getInt("total"));
                }
            }
        }
        return result;
    }

    public Map<String, Integer> getStatusDistribution(int userId) throws SQLException {
        String sql = "SELECT status, COUNT(*) AS total FROM applications WHERE user_id = ? GROUP BY status ORDER BY status";
        Map<String, Integer> result = new LinkedHashMap<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    result.put(resultSet.getString("status"), resultSet.getInt("total"));
                }
            }
        }
        return result;
    }

    public Map<String, Integer> getTopCompanies(int userId, int limit) throws SQLException {
        String sql = "SELECT company_name, COUNT(*) AS total FROM applications WHERE user_id = ? "
                + "GROUP BY company_name ORDER BY total DESC, company_name ASC LIMIT ?";
        Map<String, Integer> result = new LinkedHashMap<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, limit);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    result.put(resultSet.getString("company_name"), resultSet.getInt("total"));
                }
            }
        }
        return result;
    }

    public Map<String, Integer> getSkillMatchBuckets(int userId) throws SQLException {
        String sql = "SELECT "
                + "CASE "
                + "WHEN skill_match_percent BETWEEN 0 AND 20 THEN '0-20' "
                + "WHEN skill_match_percent BETWEEN 21 AND 40 THEN '21-40' "
                + "WHEN skill_match_percent BETWEEN 41 AND 60 THEN '41-60' "
                + "WHEN skill_match_percent BETWEEN 61 AND 80 THEN '61-80' "
                + "ELSE '81-100' END AS bucket, COUNT(*) AS total "
                + "FROM applications WHERE user_id = ? GROUP BY bucket ORDER BY bucket";
        Map<String, Integer> result = new LinkedHashMap<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    result.put(resultSet.getString("bucket"), resultSet.getInt("total"));
                }
            }
        }
        return result;
    }
    
    public Map<String, Integer> getApplicationsPerMonth() throws SQLException {

    String sql =
            """
            SELECT DATE_FORMAT(application_date,'%b %Y') AS label,
                   COUNT(*) AS total
            FROM applications
            GROUP BY YEAR(application_date),
                     MONTH(application_date),
                     DATE_FORMAT(application_date,'%b %Y')
            ORDER BY YEAR(application_date) DESC,
                     MONTH(application_date) DESC
            LIMIT 6
            """;

    Map<String,Integer> result = new LinkedHashMap<>();

    try(Connection connection = DBConnection.getConnection();
        PreparedStatement preparedStatement =
                connection.prepareStatement(sql);
        ResultSet resultSet =
                preparedStatement.executeQuery()){

        while(resultSet.next()){

            result.put(
                    resultSet.getString("label"),
                    resultSet.getInt("total"));

        }

    }

    return result;
}
 

    public Map<String, Integer> getOverallStatusDistribution()
        throws SQLException {

    String sql =
            """
            SELECT status,
                   COUNT(*) AS total
            FROM applications
            GROUP BY status
            ORDER BY status
            """;

    Map<String,Integer> result = new LinkedHashMap<>();

    try(Connection connection = DBConnection.getConnection();
        PreparedStatement preparedStatement =
                connection.prepareStatement(sql);
        ResultSet resultSet =
                preparedStatement.executeQuery()){

        while(resultSet.next()){

            result.put(
                    resultSet.getString("status"),
                    resultSet.getInt("total"));

        }

    }

    return result;
}
   
    private int getCountByQuery(String sql, int userId) throws SQLException {
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
}
