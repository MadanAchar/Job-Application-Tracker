package com.jobtracker.dao;

import com.jobtracker.model.User;
import com.jobtracker.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

public User findByEmail(String email) throws SQLException {
    String sql = "SELECT id, name, email, password_hash, role, cgpa, branch, skills, experience, projects, "
            + "github_url, linkedin_url, profile_picture, resume_filename, created_at "
            + "FROM users WHERE email = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
        preparedStatement.setString(1, email);
        try (ResultSet resultSet = preparedStatement.executeQuery()) {
            if (resultSet.next()) {
                return mapRow(resultSet);
            }
        }
    }
    return null;
}

public User findById(int id) throws SQLException {
    String sql = "SELECT id, name, email, password_hash, role, cgpa, branch, skills, experience, projects, "
            + "github_url, linkedin_url, profile_picture, resume_filename, created_at "
            + "FROM users WHERE id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
        preparedStatement.setInt(1, id);
        try (ResultSet resultSet = preparedStatement.executeQuery()) {
            if (resultSet.next()) {
                return mapRow(resultSet);
            }
        }
    }
    return null;
}

public boolean isEmailExists(String email) throws SQLException {
    String sql = "SELECT 1 FROM users WHERE email = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
        preparedStatement.setString(1, email);
        try (ResultSet resultSet = preparedStatement.executeQuery()) {
            return resultSet.next();
        }
    }
}

public boolean insertUser(User user) throws SQLException {
    String sql = "INSERT INTO users (name, email, password_hash, role, cgpa, branch, skills, experience, projects, "
            + "github_url, linkedin_url, profile_picture, resume_filename) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

        preparedStatement.setString(1, user.getName());
        preparedStatement.setString(2, user.getEmail());
        preparedStatement.setString(3, user.getPasswordHash());
        preparedStatement.setString(4, user.getRole());
        setNullableDouble(preparedStatement, 5, user.getCgpa());
        preparedStatement.setString(6, user.getBranch());
        preparedStatement.setString(7, user.getSkills());
        preparedStatement.setString(8, user.getExperience());
        preparedStatement.setString(9, user.getProjects());
        preparedStatement.setString(10, user.getGithubUrl());
        preparedStatement.setString(11, user.getLinkedinUrl());
        preparedStatement.setString(12, user.getProfilePicture());
        preparedStatement.setString(13, user.getResumeFilename());

        return preparedStatement.executeUpdate() > 0;
    }
}

public boolean updateUser(User user) throws SQLException {
    String sql = "UPDATE users SET "
            + "name = ?, email = ?, cgpa = ?, branch = ?, skills = ?, experience = ?, "
            + "projects = ?, github_url = ?, linkedin_url = ?, profile_picture = ?, "
            + "resume_filename = ? "
            + "WHERE id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

        preparedStatement.setString(1, user.getName());
        preparedStatement.setString(2, user.getEmail());
        setNullableDouble(preparedStatement, 3, user.getCgpa());
        preparedStatement.setString(4, user.getBranch());
        preparedStatement.setString(5, user.getSkills());
        preparedStatement.setString(6, user.getExperience());
        preparedStatement.setString(7, user.getProjects());
        preparedStatement.setString(8, user.getGithubUrl());
        preparedStatement.setString(9, user.getLinkedinUrl());
        preparedStatement.setString(10, user.getProfilePicture());
        preparedStatement.setString(11, user.getResumeFilename());
        preparedStatement.setInt(12, user.getId());

        return preparedStatement.executeUpdate() > 0;
    }
}

public boolean updatePassword(int userId, String passwordHash) throws SQLException {
    String sql = "UPDATE users SET password_hash = ? WHERE id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
        preparedStatement.setString(1, passwordHash);
        preparedStatement.setInt(2, userId);
        return preparedStatement.executeUpdate() > 0;
    }
}

public List<User> getAllUsers() throws SQLException {
    String sql = "SELECT id, name, email, password_hash, role, cgpa, branch, skills, experience, projects, "
            + "github_url, linkedin_url, profile_picture, resume_filename, created_at "
            + "FROM users ORDER BY created_at DESC";

    List<User> users = new ArrayList<>();

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql);
         ResultSet resultSet = preparedStatement.executeQuery()) {

        while (resultSet.next()) {
            users.add(mapRow(resultSet));
        }
    }

    return users;
}

public boolean deleteUser(int userId) throws SQLException {
    String sql = "DELETE FROM users WHERE id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
        preparedStatement.setInt(1, userId);
        return preparedStatement.executeUpdate() > 0;
    }
}

public boolean updateUserRole(int userId, String role) throws SQLException {
    String sql = "UPDATE users SET role = ? WHERE id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
        preparedStatement.setString(1, role);
        preparedStatement.setInt(2, userId);
        return preparedStatement.executeUpdate() > 0;
    }
}

private User mapRow(ResultSet resultSet) throws SQLException {
    User user = new User();

    user.setId(resultSet.getInt("id"));
    user.setName(resultSet.getString("name"));
    user.setEmail(resultSet.getString("email"));
    user.setPasswordHash(resultSet.getString("password_hash"));
    user.setRole(resultSet.getString("role"));

    double cgpaValue = resultSet.getDouble("cgpa");
    if (resultSet.wasNull()) {
        user.setCgpa(null);
    } else {
        user.setCgpa(cgpaValue);
    }

    user.setBranch(resultSet.getString("branch"));
    user.setSkills(resultSet.getString("skills"));
    user.setExperience(resultSet.getString("experience"));
    user.setProjects(resultSet.getString("projects"));
    user.setGithubUrl(resultSet.getString("github_url"));
    user.setLinkedinUrl(resultSet.getString("linkedin_url"));
    user.setProfilePicture(resultSet.getString("profile_picture"));
    user.setResumeFilename(resultSet.getString("resume_filename"));

    Timestamp createdAt = resultSet.getTimestamp("created_at");
    user.setCreatedAt(createdAt);

    return user;
}

private void setNullableDouble(PreparedStatement preparedStatement, int parameterIndex, Double value) throws SQLException {
    if (value == null) {
        preparedStatement.setNull(parameterIndex, java.sql.Types.DECIMAL);
    } else {
        preparedStatement.setDouble(parameterIndex, value);
    }
}

}
