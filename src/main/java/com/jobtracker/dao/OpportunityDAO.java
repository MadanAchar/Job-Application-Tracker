package com.jobtracker.dao;

import com.jobtracker.model.Opportunity;
import com.jobtracker.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OpportunityDAO {

    public List<Opportunity> getLatestOpportunities(int limit) throws SQLException {
        String sql = "SELECT id, company, role, location, description, skills_required, deadline, eligibility, salary, "
                + "posted_by, created_at FROM opportunities ORDER BY deadline ASC, created_at DESC LIMIT ?";
        List<Opportunity> opportunities = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, limit);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    opportunities.add(mapRow(resultSet));
                }
            }
        }
        return opportunities;
    }

    public List<Opportunity> getAllOpportunities() throws SQLException {
        String sql = "SELECT id, company, role, location, description, skills_required, deadline, eligibility, salary, "
                + "posted_by, created_at FROM opportunities ORDER BY deadline ASC";
        List<Opportunity> opportunities = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                opportunities.add(mapRow(resultSet));
            }
        }
        return opportunities;
    }

    public Opportunity getOpportunityById(int opportunityId) throws SQLException {
        String sql = "SELECT id, company, role, location, description, skills_required, deadline, eligibility, salary, "
                + "posted_by, created_at FROM opportunities WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, opportunityId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapRow(resultSet);
                }
            }
        }
        return null;
    }

    public boolean addOpportunity(Opportunity opportunity) throws SQLException {
        String sql = "INSERT INTO opportunities (company, role, location, description, skills_required, deadline, eligibility, "
                + "salary, posted_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, opportunity.getCompany());
            preparedStatement.setString(2, opportunity.getRole());
            preparedStatement.setString(3, opportunity.getLocation());
            preparedStatement.setString(4, opportunity.getDescription());
            preparedStatement.setString(5, opportunity.getSkillsRequired());
            preparedStatement.setDate(6, opportunity.getDeadline());
            preparedStatement.setString(7, opportunity.getEligibility());
            preparedStatement.setString(8, opportunity.getSalary());
            preparedStatement.setInt(9, opportunity.getPostedBy());
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean updateOpportunity(Opportunity opportunity) throws SQLException {
        String sql = "UPDATE opportunities SET company = ?, role = ?, location = ?, description = ?, skills_required = ?, "
                + "deadline = ?, eligibility = ?, salary = ? WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, opportunity.getCompany());
            preparedStatement.setString(2, opportunity.getRole());
            preparedStatement.setString(3, opportunity.getLocation());
            preparedStatement.setString(4, opportunity.getDescription());
            preparedStatement.setString(5, opportunity.getSkillsRequired());
            preparedStatement.setDate(6, opportunity.getDeadline());
            preparedStatement.setString(7, opportunity.getEligibility());
            preparedStatement.setString(8, opportunity.getSalary());
            preparedStatement.setInt(9, opportunity.getId());
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean deleteOpportunity(int opportunityId) throws SQLException {
        String sql = "DELETE FROM opportunities WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, opportunityId);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public int countOpportunities() throws SQLException {
        String sql = "SELECT COUNT(*) FROM opportunities";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        }
        return 0;
    }

    private Opportunity mapRow(ResultSet resultSet) throws SQLException {
        Opportunity opportunity = new Opportunity();
        opportunity.setId(resultSet.getInt("id"));
        opportunity.setCompany(resultSet.getString("company"));
        opportunity.setRole(resultSet.getString("role"));
        opportunity.setLocation(resultSet.getString("location"));
        opportunity.setDescription(resultSet.getString("description"));
        opportunity.setSkillsRequired(resultSet.getString("skills_required"));
        opportunity.setDeadline(resultSet.getDate("deadline"));
        opportunity.setEligibility(resultSet.getString("eligibility"));
        opportunity.setSalary(resultSet.getString("salary"));
        opportunity.setPostedBy(resultSet.getInt("posted_by"));
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        opportunity.setCreatedAt(createdAt);
        return opportunity;
    }
}
