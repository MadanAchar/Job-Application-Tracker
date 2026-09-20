package com.jobtracker.dao;

import com.jobtracker.model.Application;
import com.jobtracker.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public List<Application> getApplicationsByUser(int userId, String status, String search, String sortBy, int offset, int limit)
            throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT id, user_id, company_name, job_role, location, application_date, deadline, status, notes, "
                        + "resume_filename, job_skills, skill_match_percent, created_at "
                        + "FROM applications WHERE user_id = ?"
        );
        List<Object> parameters = new ArrayList<>();
        parameters.add(userId);

        if (status != null && !status.isBlank()) {
            sql.append(" AND status = ?");
            parameters.add(status);
        }

        if (search != null && !search.isBlank()) {
            sql.append(" AND (company_name LIKE ? OR job_role LIKE ? OR location LIKE ?)");
            String likeValue = "%" + search.trim() + "%";
            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
        }

        sql.append(" ORDER BY ");
        if ("company".equalsIgnoreCase(sortBy)) {
            sql.append("company_name ASC");
        } else if ("deadline".equalsIgnoreCase(sortBy)) {
            sql.append("deadline ASC");
        } else if ("status".equalsIgnoreCase(sortBy)) {
            sql.append("status ASC");
        } else {
            sql.append("application_date DESC");
        }
        sql.append(" LIMIT ? OFFSET ?");
        parameters.add(limit);
        parameters.add(offset);

        List<Application> applications = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            setParameters(preparedStatement, parameters);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    applications.add(mapRow(resultSet));
                }
            }
        }
        return applications;
    }

    public int countApplicationsByUser(int userId, String status, String search) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM applications WHERE user_id = ?");
        List<Object> parameters = new ArrayList<>();
        parameters.add(userId);

        if (status != null && !status.isBlank()) {
            sql.append(" AND status = ?");
            parameters.add(status);
        }

        if (search != null && !search.isBlank()) {
            sql.append(" AND (company_name LIKE ? OR job_role LIKE ? OR location LIKE ?)");
            String likeValue = "%" + search.trim() + "%";
            parameters.add(likeValue);
            parameters.add(likeValue);
            parameters.add(likeValue);
        }

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            setParameters(preparedStatement, parameters);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        }
        return 0;
    }

   public Application getApplicationById(int applicationId) throws SQLException {

    String sql = "SELECT id, user_id, company_name, job_role, location, application_date, deadline, status, notes, "
            + "resume_filename, job_skills, skill_match_percent, created_at "
            + "FROM applications WHERE id = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

        preparedStatement.setInt(1, applicationId);

        try (ResultSet resultSet = preparedStatement.executeQuery()) {

            if (resultSet.next()) {
                return mapRow(resultSet);
            }

        }
    }

    return null;
}

    public boolean addApplication(Application application) throws SQLException {
        String sql = "INSERT INTO applications (user_id, company_name, job_role, location, application_date, deadline, status, "
                + "notes, resume_filename, job_skills, skill_match_percent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, application.getUserId());
            preparedStatement.setString(2, application.getCompanyName());
            preparedStatement.setString(3, application.getJobRole());
            preparedStatement.setString(4, application.getLocation());
            preparedStatement.setDate(5, application.getApplicationDate());
            preparedStatement.setDate(6, application.getDeadline());
            preparedStatement.setString(7, application.getStatus());
            preparedStatement.setString(8, application.getNotes());
            preparedStatement.setString(9, application.getResumeFilename());
            preparedStatement.setString(10, application.getJobSkills());
            preparedStatement.setInt(11, application.getSkillMatchPercent());
            return preparedStatement.executeUpdate() > 0;
        }
    }

    public boolean updateApplication(Application application) throws SQLException {
        String sql = "UPDATE applications SET company_name = ?, job_role = ?, location = ?, application_date = ?, deadline = ?, "
                + "status = ?, notes = ?, resume_filename = ?, job_skills = ?, skill_match_percent = ? "
                + "WHERE id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, application.getCompanyName());
            preparedStatement.setString(2, application.getJobRole());
            preparedStatement.setString(3, application.getLocation());
            preparedStatement.setDate(4, application.getApplicationDate());
            preparedStatement.setDate(5, application.getDeadline());
            preparedStatement.setString(6, application.getStatus());
            preparedStatement.setString(7, application.getNotes());
            preparedStatement.setString(8, application.getResumeFilename());
            preparedStatement.setString(9, application.getJobSkills());
            preparedStatement.setInt(10, application.getSkillMatchPercent());
            preparedStatement.setInt(11, application.getId());
            preparedStatement.setInt(12, application.getUserId());
            return preparedStatement.executeUpdate() > 0;
        }
    }

   public boolean deleteApplication(int applicationId, int userId) throws SQLException {

    String sql = "DELETE FROM applications WHERE id=? AND user_id=?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

        preparedStatement.setInt(1, applicationId);
        preparedStatement.setInt(2, userId);

        return preparedStatement.executeUpdate() > 0;
    }
}

    public List<Application> getAllApplicationsByUser(int userId) throws SQLException {
        String sql = "SELECT id, user_id, company_name, job_role, location, application_date, deadline, status, notes, "
                + "resume_filename, job_skills, skill_match_percent, created_at "
                + "FROM applications WHERE user_id = ? ORDER BY application_date DESC";
        List<Application> applications = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    applications.add(mapRow(resultSet));
                }
            }
        }
        return applications;
    }

    public List<Application> getAllApplications() throws SQLException {
        String sql = "SELECT id, user_id, company_name, job_role, location, application_date, deadline, status, notes, "
                + "resume_filename, job_skills, skill_match_percent, created_at "
                + "FROM applications ORDER BY created_at DESC";
        List<Application> applications = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            while (resultSet.next()) {
                applications.add(mapRow(resultSet));
            }
        }
        return applications;
    }

    public int countByStatus(int userId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications WHERE user_id = ? AND status = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, status);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        }
        return 0;
    }

    public int countTotalByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications WHERE user_id = ?";

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

    public List<String> getRecentMonthsWithCounts(int userId, int monthCount) throws SQLException {
        String sql = "SELECT DATE_FORMAT(application_date, '%b %Y') AS month_label, COUNT(*) AS total "
                + "FROM applications WHERE user_id = ? "
                + "GROUP BY YEAR(application_date), MONTH(application_date), DATE_FORMAT(application_date, '%b %Y') "
                + "ORDER BY YEAR(application_date) DESC, MONTH(application_date) DESC LIMIT ?";
        List<String> monthlyCounts = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, monthCount);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    monthlyCounts.add(resultSet.getString("month_label") + ":" + resultSet.getInt("total"));
                }
            }
        }
        return monthlyCounts;
    }

    public boolean hasApplied(int userId, String companyName, String jobRole) throws SQLException {

    String sql = "SELECT COUNT(*) FROM applications WHERE user_id=? AND company_name=? AND job_role=?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

        preparedStatement.setInt(1, userId);
        preparedStatement.setString(2, companyName);
        preparedStatement.setString(3, jobRole);

        try (ResultSet resultSet = preparedStatement.executeQuery()) {

            if(resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }

        }

    }

    return false;
}
public List<Integer> getAppliedOpportunityIds(int userId)
        throws SQLException {

    String sql = """
            SELECT o.id
            FROM opportunities o
            INNER JOIN applications a
                ON o.company = a.company_name
               AND o.role = a.job_role
            WHERE a.user_id = ?
            """;

    List<Integer> ids = new ArrayList<>();

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement =
                 connection.prepareStatement(sql)) {

        preparedStatement.setInt(1, userId);

        try (ResultSet resultSet =
                     preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                ids.add(resultSet.getInt("id"));
            }

        }
    }

    return ids;
}

public boolean quickApply(Application application) throws SQLException {
    

    String sql = """
            INSERT INTO applications
            (
                user_id,
                company_name,
                job_role,
                location,
                application_date,
                deadline,
                status,
                notes,
                resume_filename,
                job_skills,
                skill_match_percent
            )
            VALUES(?,?,?,?,?,?,?,?,?,?,?)
            """;

    try(Connection connection=DBConnection.getConnection();
        PreparedStatement preparedStatement=connection.prepareStatement(sql)){

        preparedStatement.setInt(1,application.getUserId());
        preparedStatement.setString(2,application.getCompanyName());
        preparedStatement.setString(3,application.getJobRole());
        preparedStatement.setString(4,application.getLocation());
        preparedStatement.setDate(5,application.getApplicationDate());
        preparedStatement.setDate(6,application.getDeadline());
        preparedStatement.setString(7,"Pending");
        preparedStatement.setString(8,"");
        preparedStatement.setString(9,application.getResumeFilename());
        preparedStatement.setString(10,application.getJobSkills());
        preparedStatement.setInt(11,0);

        return preparedStatement.executeUpdate()>0;

    }

}

public boolean updateReview(int applicationId,
                            String status,
                            String notes,
                            int skillMatchPercent) throws SQLException {

    String sql = """
            UPDATE applications
            SET status=?,
                notes=?,
                skill_match_percent=?
            WHERE id=?
            """;

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement =
                 connection.prepareStatement(sql)) {

        preparedStatement.setString(1, status);
        preparedStatement.setString(2, notes);
        preparedStatement.setInt(3, skillMatchPercent);
        preparedStatement.setInt(4, applicationId);

        return preparedStatement.executeUpdate() > 0;
    }
}


public List<Application> getRecentApplications(int limit)
        throws SQLException {

    String sql = """
            SELECT *
            FROM applications
            ORDER BY created_at DESC
            LIMIT ?
            """;

    List<Application> applications = new ArrayList<>();

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement =
                 connection.prepareStatement(sql)) {

        preparedStatement.setInt(1, limit);

        try (ResultSet resultSet =
                     preparedStatement.executeQuery()) {

            while (resultSet.next()) {

                applications.add(mapRow(resultSet));

            }

        }

    }

    return applications;
}

    private Application mapRow(ResultSet resultSet) throws SQLException {
        Application application = new Application();
        application.setId(resultSet.getInt("id"));
        application.setUserId(resultSet.getInt("user_id"));
        application.setCompanyName(resultSet.getString("company_name"));
        application.setJobRole(resultSet.getString("job_role"));
        application.setLocation(resultSet.getString("location"));
        application.setApplicationDate(resultSet.getDate("application_date"));
        application.setDeadline(resultSet.getDate("deadline"));
        application.setStatus(resultSet.getString("status"));
        application.setNotes(resultSet.getString("notes"));
        application.setResumeFilename(resultSet.getString("resume_filename"));
        application.setJobSkills(resultSet.getString("job_skills"));
        application.setSkillMatchPercent(resultSet.getInt("skill_match_percent"));
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        application.setCreatedAt(createdAt);
        return application;
    }

    private void setParameters(PreparedStatement preparedStatement, List<Object> parameters) throws SQLException {
        for (int index = 0; index < parameters.size(); index++) {
            Object value = parameters.get(index);
            int parameterIndex = index + 1;
            if (value instanceof Integer integerValue) {
                preparedStatement.setInt(parameterIndex, integerValue);
            } else if (value instanceof String stringValue) {
                preparedStatement.setString(parameterIndex, stringValue);
            } else if (value instanceof Date dateValue) {
                preparedStatement.setDate(parameterIndex, dateValue);
            } else {
                preparedStatement.setObject(parameterIndex, value);
            }
        }
    }

    public int countAllApplications() throws SQLException {

    String sql = "SELECT COUNT(*) FROM applications";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql);
         ResultSet resultSet = preparedStatement.executeQuery()) {

        if (resultSet.next()) {
            return resultSet.getInt(1);
        }
    }

    return 0;
}

public int countByStatus(String status) throws SQLException {

    String sql = "SELECT COUNT(*) FROM applications WHERE status=?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

        preparedStatement.setString(1, status);

        try (ResultSet resultSet = preparedStatement.executeQuery()) {

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }

        }

    }

    return 0;
}

}

